// Roster add-on billing (2026-09-27) — staged here in the repo for review
// before deployment (the real copy lives at
// ~/tango-sierra/supabase/docker/volumes/functions/roster-addon-billing/index.ts
// on the VPS — no local functions/ dev mirror exists in this project, per
// established convention; this file is the staging/review copy only).
//
// Real per-branch pricing, computed from CURRENT active staff counts at
// each site in the organisation (£6/branch/month under 10 staff, £10/month
// at 10+), summed into one flat monthly amount charged as a SEPARATE
// GoCardless subscription against the org's existing mandate — not a
// change to the main plan subscription's amount, since GoCardless
// subscriptions don't support amount changes without cancel+recreate, and
// keeping the two separate avoids proration complexity entirely.
//
// Re-pricing (2026-09-27) — event-driven, not a scheduled job (this
// backend deliberately has none, see BACKEND_INFRA.md's standing note):
// the `reprice_if_needed` action is called from the two real places a
// site's active staff count actually changes for a backend-mode org --
// client-side right after SupabaseUserRepository.setActive, and
// server-side from provision-staff-pin right after it creates a new
// staff row. No-ops instantly if Roster isn't enabled or the price
// hasn't actually changed, so it's always safe/cheap to call. DISCLOSED
// GAP: staff created via the older createStaffMember path (Staff
// Management/organogram/venue wizard's "Add Staff" button, which
// delegates to a local Drift write even in backend mode -- a separate,
// pre-existing architecture question outside this task's scope) does
// NOT trigger a reprice. A manager can always force a correct price by
// toggling Roster off and back on in Settings.
import "@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"
import * as jose from "jsr:@panva/jose@6"

const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
const JWT_SECRET = Deno.env.get("JWT_SECRET")!
const DB_URL = Deno.env.get("SUPABASE_URL")!
const GC_ACCESS_TOKEN = Deno.env.get("GOCARDLESS_ACCESS_TOKEN")!
const GC_ENVIRONMENT = Deno.env.get("GOCARDLESS_ENVIRONMENT") ?? "sandbox"
const ISSUER = "https://api.venurite.com/auth/v1"

const GC_API_BASE = GC_ENVIRONMENT === "live"
  ? "https://api.gocardless.com"
  : "https://api-sandbox.gocardless.com"

const PRICE_UNDER_10_STAFF_PENCE = 600
const PRICE_10_PLUS_STAFF_PENCE = 1000
const STAFF_THRESHOLD = 10

// Only tiers that already manage Roster elsewhere in the app (Roster
// Board, the Settings toggle itself) may enable/disable real billing —
// matches the existing venueManager+ floor on every other Roster
// management screen.
const ALLOWED_TIERS = ["venueManager", "regional", "executive"]

const admin = createClient(DB_URL, SERVICE_ROLE_KEY)

interface Claims {
  organisation_id?: number
  role_tier?: string
}

interface SiteBreakdown {
  siteId: number
  staffCount: number
  pricePence: number
}

async function computeQuote(organisationId: number): Promise<{ totalPence: number; breakdown: SiteBreakdown[] }> {
  const { data: sites, error: sitesError } = await admin
    .from("sites")
    .select("id")
    .eq("organisation_id", organisationId)
  if (sitesError) throw new Error(`sites lookup failed: ${sitesError.message}`)

  const breakdown: SiteBreakdown[] = []
  for (const site of sites ?? []) {
    const { count, error: countError } = await admin
      .from("users")
      .select("id", { count: "exact", head: true })
      .eq("site_id", site.id)
      .eq("active", true)
    if (countError) throw new Error(`staff count failed: ${countError.message}`)
    const staffCount = count ?? 0
    const pricePence = staffCount >= STAFF_THRESHOLD
      ? PRICE_10_PLUS_STAFF_PENCE
      : PRICE_UNDER_10_STAFF_PENCE
    breakdown.push({ siteId: site.id, staffCount, pricePence })
  }

  const totalPence = breakdown.reduce((sum, b) => sum + b.pricePence, 0)
  return { totalPence, breakdown }
}

Deno.serve(async (req: Request) => {
  const apikey = req.headers.get("apikey")
  if (apikey !== ANON_KEY) {
    return Response.json({ outcome: "error", error: "invalid or missing apikey" }, { status: 401 })
  }
  if (req.method !== "POST") {
    return Response.json({ outcome: "error", error: "method not allowed" }, { status: 405 })
  }

  const authHeader = req.headers.get("Authorization") ?? ""
  const callerToken = authHeader.replace(/^Bearer\s+/i, "")
  if (!callerToken) {
    return Response.json({ outcome: "error", error: "sign in first" }, { status: 401 })
  }

  let claims: Claims
  try {
    const secretKey = new TextEncoder().encode(JWT_SECRET)
    const verified = await jose.jwtVerify(callerToken, secretKey, { issuer: ISSUER })
    claims = (verified.payload.app_metadata as Claims) ?? {}
  } catch {
    return Response.json({ outcome: "error", error: "invalid session" }, { status: 401 })
  }

  if (!claims.organisation_id) {
    return Response.json({ outcome: "error", error: "no organisation on this session" }, { status: 403 })
  }
  if (!claims.role_tier || !ALLOWED_TIERS.includes(claims.role_tier)) {
    return Response.json({ outcome: "error", error: "you don't have permission to change billing" }, { status: 403 })
  }
  const organisationId = claims.organisation_id

  let body: { action?: string }
  try {
    body = await req.json()
  } catch {
    return Response.json({ outcome: "error", error: "invalid JSON body" }, { status: 400 })
  }

  try {
    if (body.action === "quote") {
      const quote = await computeQuote(organisationId)
      return Response.json({ outcome: "quote", ...quote })
    }

    if (body.action === "enable") {
      const { data: subscription, error: subErr } = await admin
        .from("subscriptions")
        .select("id, gocardless_mandate_id, mandate_status, roster_addon_gc_subscription_id")
        .eq("organisation_id", organisationId)
        .maybeSingle()
      if (subErr || !subscription) {
        return Response.json({ outcome: "error", error: "no subscription found for this organisation" }, { status: 404 })
      }
      if (subscription.roster_addon_gc_subscription_id) {
        // Already enabled -- idempotent, not an error.
        return Response.json({ outcome: "enabled", alreadyEnabled: true })
      }
      if (!subscription.gocardless_mandate_id || subscription.mandate_status !== "active") {
        return Response.json({
          outcome: "error",
          error: "Direct Debit isn't set up yet for this organisation. Set up billing first.",
        }, { status: 400 })
      }

      const quote = await computeQuote(organisationId)

      const gcResponse = await fetch(`${GC_API_BASE}/subscriptions`, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${GC_ACCESS_TOKEN}`,
          "GoCardless-Version": "2015-07-06",
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          subscriptions: {
            amount: quote.totalPence,
            currency: "GBP",
            name: "VenuRite Roster Add-on",
            interval_unit: "monthly",
            links: { mandate: subscription.gocardless_mandate_id },
          },
        }),
      })
      const gcData = await gcResponse.json()
      if (!gcResponse.ok) {
        console.error("gocardless roster-addon subscription create", gcData)
        return Response.json({ outcome: "error", error: "could not set up billing for this add-on" }, { status: 502 })
      }

      await admin.from("subscriptions").update({
        roster_addon_gc_subscription_id: gcData.subscriptions.id,
        updated_at: new Date().toISOString(),
      }).eq("id", subscription.id)

      await admin.from("organisations").update({
        roster_addon_enabled: true,
      }).eq("id", organisationId)

      return Response.json({ outcome: "enabled", pricePence: quote.totalPence, breakdown: quote.breakdown })
    }

    if (body.action === "disable") {
      const { data: subscription, error: subErr } = await admin
        .from("subscriptions")
        .select("id, roster_addon_gc_subscription_id")
        .eq("organisation_id", organisationId)
        .maybeSingle()
      if (subErr || !subscription) {
        return Response.json({ outcome: "error", error: "no subscription found for this organisation" }, { status: 404 })
      }

      if (subscription.roster_addon_gc_subscription_id) {
        const cancelResponse = await fetch(
          `${GC_API_BASE}/subscriptions/${subscription.roster_addon_gc_subscription_id}/actions/cancel`,
          {
            method: "POST",
            headers: {
              Authorization: `Bearer ${GC_ACCESS_TOKEN}`,
              "GoCardless-Version": "2015-07-06",
              "Content-Type": "application/json",
            },
            body: JSON.stringify({ data: {} }),
          },
        )
        if (!cancelResponse.ok) {
          const cancelData = await cancelResponse.json()
          console.error("gocardless roster-addon subscription cancel", cancelData)
          return Response.json({ outcome: "error", error: "could not cancel billing for this add-on" }, { status: 502 })
        }
      }

      await admin.from("subscriptions").update({
        roster_addon_gc_subscription_id: null,
        updated_at: new Date().toISOString(),
      }).eq("id", subscription.id)

      await admin.from("organisations").update({
        roster_addon_enabled: false,
      }).eq("id", organisationId)

      return Response.json({ outcome: "disabled" })
    }

    if (body.action === "reprice_if_needed") {
      // Deliberately no ALLOWED_TIERS check here -- this only ever aligns
      // the charged amount to current real usage, it can't be used to
      // change what's enabled/disabled, so any authenticated staff member
      // triggering it (indirectly, via a deactivate they were allowed to
      // do) is harmless.
      const { data: org } = await admin
        .from("organisations")
        .select("roster_addon_enabled")
        .eq("id", organisationId)
        .maybeSingle()
      if (!org?.roster_addon_enabled) {
        return Response.json({ outcome: "no_change", reason: "not_enabled" })
      }

      const { data: subscription } = await admin
        .from("subscriptions")
        .select("id, gocardless_mandate_id, roster_addon_gc_subscription_id")
        .eq("organisation_id", organisationId)
        .maybeSingle()
      if (!subscription?.roster_addon_gc_subscription_id) {
        return Response.json({ outcome: "no_change", reason: "not_subscribed" })
      }

      const currentGcResponse = await fetch(
        `${GC_API_BASE}/subscriptions/${subscription.roster_addon_gc_subscription_id}`,
        {
          headers: {
            Authorization: `Bearer ${GC_ACCESS_TOKEN}`,
            "GoCardless-Version": "2015-07-06",
          },
        },
      )
      const currentGcData = await currentGcResponse.json()
      if (!currentGcResponse.ok) {
        console.error("gocardless roster-addon subscription fetch", currentGcData)
        return Response.json({ outcome: "error", error: "could not check current billing" }, { status: 502 })
      }
      const currentAmount = currentGcData.subscriptions.amount as number

      const quote = await computeQuote(organisationId)
      if (quote.totalPence === currentAmount) {
        return Response.json({ outcome: "no_change", reason: "price_unchanged" })
      }

      // Price changed -- cancel the old subscription and create a new one
      // at the correct amount (GoCardless subscriptions can't have their
      // amount changed in place).
      const cancelResponse = await fetch(
        `${GC_API_BASE}/subscriptions/${subscription.roster_addon_gc_subscription_id}/actions/cancel`,
        {
          method: "POST",
          headers: {
            Authorization: `Bearer ${GC_ACCESS_TOKEN}`,
            "GoCardless-Version": "2015-07-06",
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ data: {} }),
        },
      )
      if (!cancelResponse.ok) {
        const cancelData = await cancelResponse.json()
        console.error("gocardless roster-addon reprice cancel", cancelData)
        return Response.json({ outcome: "error", error: "could not update billing for this add-on" }, { status: 502 })
      }

      const gcResponse = await fetch(`${GC_API_BASE}/subscriptions`, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${GC_ACCESS_TOKEN}`,
          "GoCardless-Version": "2015-07-06",
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          subscriptions: {
            amount: quote.totalPence,
            currency: "GBP",
            name: "VenuRite Roster Add-on",
            interval_unit: "monthly",
            links: { mandate: subscription.gocardless_mandate_id },
          },
        }),
      })
      const gcData = await gcResponse.json()
      if (!gcResponse.ok) {
        console.error("gocardless roster-addon reprice create", gcData)
        return Response.json({ outcome: "error", error: "could not update billing for this add-on" }, { status: 502 })
      }

      await admin.from("subscriptions").update({
        roster_addon_gc_subscription_id: gcData.subscriptions.id,
        updated_at: new Date().toISOString(),
      }).eq("id", subscription.id)

      return Response.json({
        outcome: "repriced",
        fromPence: currentAmount,
        toPence: quote.totalPence,
      })
    }

    return Response.json({ outcome: "error", error: "unknown action" }, { status: 400 })
  } catch (e) {
    return Response.json(
      { outcome: "error", error: e instanceof Error ? e.message : String(e) },
      { status: 500 },
    )
  }
})
