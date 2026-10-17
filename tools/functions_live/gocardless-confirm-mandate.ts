// GoCardless billing (2026-09-21) -- the browser lands here after the
// customer authorizes Direct Debit on GoCardless's own hosted page (this
// URL is what gocardless-start-mandate registered as success_redirect_url,
// carrying our own `org` and `st` (session_token) query params -- no
// server-side session storage needed, this function is fully stateless).
// GET, not POST: a plain browser redirect, no Authorization header
// available -- security here rests on GoCardless's own completion call
// rejecting a session_token that doesn't match what it issued for this
// redirect_flow_id, not on anything we check ourselves.
//
// Completes the mandate, then immediately creates the real recurring
// GoCardless Subscription against it (deferred to start at the
// organisation's own trial_ends_at date, per the agreed "billing starts
// after the 14-day trial" decision -- not immediately on mandate setup).
import "@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"

const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
const DB_URL = Deno.env.get("SUPABASE_URL")!
const GC_ACCESS_TOKEN = Deno.env.get("GOCARDLESS_ACCESS_TOKEN")!
const GC_ENVIRONMENT = Deno.env.get("GOCARDLESS_ENVIRONMENT") ?? "sandbox"

const GC_API_BASE = GC_ENVIRONMENT === "live"
  ? "https://api.gocardless.com"
  : "https://api-sandbox.gocardless.com"

const admin = createClient(DB_URL, SERVICE_ROLE_KEY)

// Per-branch pricing (2026-09-22, replaces the old flat per-plan prices)
// -- £39/branch/month standard, £19/branch/month only once a valid
// discount code has been applied (gocardless-start-mandate sets
// subscriptions.founding_offer, never set here). billed_site_count
// already includes the automatic head-office unit at 4+ branches --
// see tenant-signup's own doc comment for that threshold's reasoning.
// Billing v2 (2026-10-17): superseded — the price now comes from the
// server's own org_billing_quote() (staff-size band per branch + head
// office from 4 branches), less any discount_percent, ×11 for yearly
// billing (1 month free). See tools/billing_v2_migration.sql.

function htmlPage(title: string, message: string): Response {
  return new Response(
    `<!doctype html><html><head><meta charset="utf-8"><title>${title}</title>
    <style>body{font-family:sans-serif;max-width:480px;margin:80px auto;text-align:center;color:#222}</style>
    </head><body><h2>${title}</h2><p>${message}</p></body></html>`,
    { headers: { "Content-Type": "text/html; charset=utf-8" } },
  )
}

Deno.serve(async (req: Request) => {
  const url = new URL(req.url)
  const organisationId = url.searchParams.get("org")
  const sessionToken = url.searchParams.get("st")
  const redirectFlowId = url.searchParams.get("redirect_flow_id")

  if (!organisationId || !sessionToken || !redirectFlowId) {
    return htmlPage("Something went wrong", "This link is missing information and can't be completed. Please try setting up Direct Debit again from VenuRite.")
  }

  // 1. Complete the redirect flow -- GoCardless itself rejects this if
  // session_token doesn't match what it issued for this redirect_flow_id.
  const completeResponse = await fetch(
    `${GC_API_BASE}/redirect_flows/${redirectFlowId}/actions/complete`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${GC_ACCESS_TOKEN}`,
        "GoCardless-Version": "2015-07-06",
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ data: { session_token: sessionToken } }),
    },
  )
  const completeData = await completeResponse.json()
  if (!completeResponse.ok) {
    console.error("gocardless redirect_flows complete", completeData)
    return htmlPage("Could not complete setup", "GoCardless could not confirm this Direct Debit. Please try again from VenuRite, or contact support if this keeps happening.")
  }

  const mandateId = completeData.redirect_flows.links.mandate as string
  const customerId = completeData.redirect_flows.links.customer as string

  // 2. Look up the organisation's billed branch count and trial end date.
  const { data: subscription, error: subErr } = await admin
    .from("subscriptions")
    .select("id, trial_ends_at, discount_percent, billing_interval, free_access_granted")
    .eq("organisation_id", Number(organisationId))
    .maybeSingle()
  if (subErr || !subscription) {
    console.error("subscription lookup", subErr)
    return htmlPage("Something went wrong", "Your Direct Debit was set up, but VenuRite couldn't find your subscription record. Please contact support.")
  }

  const { data: quoteRows, error: quoteErr } = await admin
    .rpc("org_billing_quote", { p_org: Number(organisationId) })
  const quote = quoteRows?.[0]
  if (quoteErr || !quote) {
    console.error("org_billing_quote", quoteErr)
    return htmlPage("Direct Debit authorized, but setup isn't finished", "Please contact support to complete your subscription setup.")
  }
  const branches = quote.branches as number
  const yearly = subscription.billing_interval === "yearly"
  const discount = (subscription.discount_percent ?? 0) as number
  const monthlyPence = Math.round((quote.monthly_pence as number) * (100 - discount) / 100)
  const pricePence = yearly ? monthlyPence * 11 : monthlyPence

  // 3. Create the real recurring subscription, deferred to start when the
  // trial actually ends (not immediately) -- GoCardless takes a plain
  // YYYY-MM-DD date, no time component.
  // Fix (2026-10-17): a trial that already ended gave GoCardless a start
  // date in the past, which it rejects - so setup failed at the last step.
  // Only send a start date that's comfortably after the mandate's earliest
  // possible charge (GoCardless needs a few working days); otherwise let
  // GoCardless start at the earliest date it can.
  const earliest = Date.now() + 7 * 24 * 60 * 60 * 1000
  const trialEnd = subscription.trial_ends_at ? new Date(subscription.trial_ends_at).getTime() : 0
  const startDate = trialEnd > earliest
    ? new Date(trialEnd).toISOString().slice(0, 10)
    : undefined

  const gcSubResponse = await fetch(`${GC_API_BASE}/subscriptions`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${GC_ACCESS_TOKEN}`,
      "GoCardless-Version": "2015-07-06",
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      subscriptions: {
        amount: pricePence,
        currency: "GBP",
        name: `VenuRite - ${branches} branch${branches === 1 ? "" : "es"}${yearly ? " (yearly)" : ""}`,
        interval_unit: yearly ? "yearly" : "monthly",
        ...(startDate ? { start_date: startDate } : {}),
        links: { mandate: mandateId },
      },
    }),
  })
  const gcSubData = await gcSubResponse.json()
  if (!gcSubResponse.ok) {
    console.error("gocardless subscriptions create", gcSubData)
    return htmlPage("Direct Debit authorized, but setup isn't finished", "Please contact support to complete your subscription setup.")
  }

  // 4. Record everything on our side.
  const { error: updateErr } = await admin
    .from("subscriptions")
    .update({
      payment_provider: "gocardless",
      provider_customer_id: customerId,
      provider_subscription_id: gcSubData.subscriptions.id,
      gocardless_mandate_id: mandateId,
      mandate_status: "active",
      current_price_pence: pricePence,
      updated_at: new Date().toISOString(),
    })
    .eq("id", subscription.id)
  if (updateErr) {
    console.error("subscription update (non-fatal to the user)", updateErr)
  }

  return htmlPage(
    "You're all set!",
    "Your Direct Debit has been set up. You can close this window and return to VenuRite.",
  )
})
