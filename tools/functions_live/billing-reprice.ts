// Billing v2 (2026-10-17) — monthly price check, run by cron on the 1st.
// For every organisation with an active Direct Debit:
//  1. Recount each branch's active staff (people who logged in there) for
//     the last two full months and update its band — UP only after 2
//     consecutive months over the current band's limit, DOWN as soon as
//     last month was under it. A first month over sets a billing_notice
//     warning instead.
//  2. End any 12-month discount that has run out.
//  3. Recalculate the price (server's org_billing_quote, less discount).
//     Monthly billing: if it changed, replace the GoCardless subscription,
//     starting on the old one's next charge date so nobody is charged
//     twice. Yearly billing: never changed mid-year — the new price is
//     shown as a notice and applied at renewal.
// Auth: x-cron-secret (reuses CERT_EXPIRY_CRON_SECRET, already passed to
// the functions container). Also accepts {"dry_run": true} to report what
// it would do without changing anything.
import "@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"

const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
const DB_URL = Deno.env.get("SUPABASE_URL")!
const CRON_SECRET = Deno.env.get("CERT_EXPIRY_CRON_SECRET")!
const GC_ACCESS_TOKEN = Deno.env.get("GOCARDLESS_ACCESS_TOKEN")!
const GC_ENVIRONMENT = Deno.env.get("GOCARDLESS_ENVIRONMENT") ?? "sandbox"
const GC_API_BASE = GC_ENVIRONMENT === "live"
  ? "https://api.gocardless.com"
  : "https://api-sandbox.gocardless.com"
const GC_HEADERS = {
  Authorization: `Bearer ${GC_ACCESS_TOKEN}`,
  "GoCardless-Version": "2015-07-06",
  "Content-Type": "application/json",
}

const admin = createClient(DB_URL, SERVICE_ROLE_KEY)

const BANDS = [
  { band: "bistro", max: 15, name: "Bistro" },
  { band: "brasserie", max: 50, name: "Brasserie" },
  { band: "banquet", max: 150, name: "Banquet" },
  { band: "grand", max: 300, name: "Grand" },
  { band: "empire", max: Infinity, name: "Empire" },
]
const rank = (band: string) => BANDS.findIndex((b) => b.band === band)
const bandFor = (staff: number) => BANDS.find((b) => staff <= b.max)!.band
const nameOf = (band: string) => BANDS[rank(band)].name

function monthStart(offset: number, now = new Date()): string {
  const d = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() + offset, 1))
  return d.toISOString().slice(0, 10)
}

async function activeCount(siteId: number, month: string): Promise<number> {
  const { count } = await admin
    .from("site_monthly_activity")
    .select("user_id", { count: "exact", head: true })
    .eq("site_id", siteId)
    .eq("month", month)
  return count ?? 0
}

Deno.serve(async (req: Request) => {
  if (!CRON_SECRET || req.headers.get("x-cron-secret") !== CRON_SECRET) {
    return Response.json({ error: "unauthorized" }, { status: 401 })
  }
  let dryRun = false
  try {
    dryRun = (await req.json())?.dry_run === true
  } catch { /* no body */ }

  const lastMonth = monthStart(-1)
  const monthBefore = monthStart(-2)
  const report: unknown[] = []

  const { data: subs, error } = await admin
    .from("subscriptions")
    .select("id, organisation_id, provider_subscription_id, gocardless_mandate_id, mandate_status, discount_percent, discount_ends_at, billing_interval, current_price_pence, free_access_granted")
  if (error) return Response.json({ error: error.message }, { status: 500 })

  for (const sub of subs ?? []) {
    const notices: string[] = []
    const orgReport: Record<string, unknown> = { organisation_id: sub.organisation_id, changes: [] }

    // 1. Bands per branch.
    const { data: sites } = await admin.from("sites").select("id, name").eq("organisation_id", sub.organisation_id)
    for (const site of sites ?? []) {
      const { data: state } = await admin.from("site_billing_bands").select("band, months_over").eq("site_id", site.id).maybeSingle()
      const current = state?.band ?? "bistro"
      const a1 = await activeCount(site.id, lastMonth)
      const a2 = await activeCount(site.id, monthBefore)
      const t1 = bandFor(a1)
      let next = current
      let monthsOver = 0
      if (rank(t1) > rank(current)) {
        monthsOver = rank(bandFor(a2)) > rank(current) ? 2 : 1
        if (monthsOver >= 2) {
          // Up to the lower of the two months' bands — sustained, not a spike.
          next = rank(bandFor(a2)) < rank(t1) ? bandFor(a2) : t1
          notices.push(`${site.name} has moved to ${nameOf(next)} (${a1} staff used VenuRite last month).`)
        } else {
          notices.push(`${site.name} had ${a1} staff last month — over the ${nameOf(current)} limit. If that happens again next month it moves to ${nameOf(t1)}.`)
        }
      } else if (rank(t1) < rank(current)) {
        next = t1
        notices.push(`${site.name} has moved down to ${nameOf(next)}.`)
      }
      ;(orgReport.changes as unknown[]).push({ site_id: site.id, from: current, to: next, active_last_month: a1, active_month_before: a2 })
      if (!dryRun) {
        await admin.from("site_billing_bands").upsert({
          site_id: site.id, band: next, months_over: monthsOver, last_active_count: a1, updated_at: new Date().toISOString(),
        })
      }
    }

    // 2. Expired 12-month discount.
    let discount = sub.discount_percent ?? 0
    if (discount > 0 && sub.discount_ends_at && new Date(sub.discount_ends_at) <= new Date()) {
      discount = 0
      notices.push("Your 12-month 50% discount has ended — full price applies from now.")
      if (!dryRun) {
        await admin.from("subscriptions").update({ discount_percent: 0, founding_offer: false }).eq("id", sub.id)
      }
    }

    // 3. Price.
    if (sub.free_access_granted || !sub.provider_subscription_id || sub.mandate_status !== "active") {
      orgReport.price = "not billed (free access or no active Direct Debit)"
      if (!dryRun) await admin.from("subscriptions").update({ billing_notice: notices.join("\n") || null }).eq("id", sub.id)
      report.push(orgReport)
      continue
    }
    const { data: quoteRows } = dryRun
      ? { data: null }
      : await admin.rpc("org_billing_quote", { p_org: sub.organisation_id })
    const quote = quoteRows?.[0]
    if (!quote) {
      orgReport.price = dryRun ? "dry run: not recalculated" : "quote failed"
      report.push(orgReport)
      continue
    }
    const monthly = Math.round(quote.monthly_pence * (100 - discount) / 100)
    const yearly = sub.billing_interval === "yearly"
    const newPrice = yearly ? monthly * 11 : monthly
    orgReport.price = { old: sub.current_price_pence, new: newPrice, yearly }

    if (newPrice !== sub.current_price_pence) {
      if (yearly) {
        notices.push(`Your yearly price will be £${(newPrice / 100).toFixed(2)} at your next renewal.`)
      } else {
        // Replace the GoCardless subscription from its next charge date.
        const oldRes = await fetch(`${GC_API_BASE}/subscriptions/${sub.provider_subscription_id}`, { headers: GC_HEADERS })
        const oldSub = (await oldRes.json()).subscriptions
        const nextChargeDate = oldSub?.upcoming_payments?.[0]?.charge_date
        const cancelRes = await fetch(`${GC_API_BASE}/subscriptions/${sub.provider_subscription_id}/actions/cancel`, { method: "POST", headers: GC_HEADERS })
        if (!cancelRes.ok) {
          console.error("billing-reprice cancel", await cancelRes.json())
          orgReport.error = "could not cancel old subscription"
          report.push(orgReport)
          continue
        }
        const createRes = await fetch(`${GC_API_BASE}/subscriptions`, {
          method: "POST",
          headers: GC_HEADERS,
          body: JSON.stringify({
            subscriptions: {
              amount: newPrice,
              currency: "GBP",
              name: `VenuRite - ${quote.branches} branch${quote.branches === 1 ? "" : "es"}`,
              interval_unit: "monthly",
              ...(nextChargeDate ? { start_date: nextChargeDate } : {}),
              links: { mandate: sub.gocardless_mandate_id },
            },
          }),
        })
        const created = await createRes.json()
        if (!createRes.ok) {
          console.error("billing-reprice create", created)
          orgReport.error = "old subscription cancelled but new one failed — fix by hand"
          report.push(orgReport)
          continue
        }
        await admin.from("subscriptions").update({
          provider_subscription_id: created.subscriptions.id,
          current_price_pence: newPrice,
          updated_at: new Date().toISOString(),
        }).eq("id", sub.id)
        notices.push(`Your monthly price is now £${(newPrice / 100).toFixed(2)}.`)
      }
    }
    if (!dryRun) await admin.from("subscriptions").update({ billing_notice: notices.join("\n") || null }).eq("id", sub.id)
    orgReport.notices = notices
    report.push(orgReport)
  }

  return Response.json({ ok: true, dry_run: dryRun, last_month: lastMonth, month_before: monthBefore, organisations: report })
})
