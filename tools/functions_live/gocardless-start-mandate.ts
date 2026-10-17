// GoCardless billing (2026-09-21) -- starts the Direct Debit setup flow
// for the caller's own organisation. Caller must be a signed-in executive
// (same session-verification pattern as create-invite/provision-staff-pin
// -- HS256, this stack's own JWT_SECRET). Stateless by design: no
// server-side session storage needed -- the organisation id and
// GoCardless's own session_token both travel in the success_redirect_url
// we register with GoCardless, and gocardless-confirm-mandate reads them
// straight back out of the query string when the browser lands there.
//
// Discount code (2026-09-22) -- "Friends" pricing (£19/branch/month
// instead of £39) is now applied HERE, not at sign-up: an optional
// `discount_code`, checked against `public.invite_codes` (unchanged
// table, repurposed -- it no longer gates sign-up at all, see
// tenant-signup's own doc comment). A valid, unused code is marked used
// and flips this organisation's `subscriptions.founding_offer` to true
// immediately, so gocardless-confirm-mandate (which actually creates the
// priced recurring subscription) reads the discount correctly. An
// invalid/already-used code is a soft failure -- reported back, but
// doesn't stop Direct Debit setup at full price.
//
// Billing v2 (2026-10-17): three single-use code types (invite_codes
// .code_type) — half_life (50% for life), half_year (50% for 12 months),
// free_life (owners: whole tool free for life — sets free_access_granted
// and needs no Direct Debit at all, so this returns without a redirect).
// Also takes `billing_interval` ("monthly" | "yearly"; yearly = 11 months'
// price, 1 month free), stored for gocardless-confirm-mandate.
import "@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"
import * as jose from "jsr:@panva/jose@6"

const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
const JWT_SECRET = Deno.env.get("JWT_SECRET")!
const DB_URL = Deno.env.get("SUPABASE_URL")!
const SUPABASE_PUBLIC_URL = Deno.env.get("SUPABASE_PUBLIC_URL")!
const GC_ACCESS_TOKEN = Deno.env.get("GOCARDLESS_ACCESS_TOKEN")!
const GC_ENVIRONMENT = Deno.env.get("GOCARDLESS_ENVIRONMENT") ?? "sandbox"
const ISSUER = "https://api.venurite.com/auth/v1"

const GC_API_BASE = GC_ENVIRONMENT === "live"
  ? "https://api.gocardless.com"
  : "https://api-sandbox.gocardless.com"

const admin = createClient(DB_URL, SERVICE_ROLE_KEY)

Deno.serve(async (req: Request) => {
  if (req.headers.get("apikey") !== ANON_KEY) {
    return Response.json({ error: "invalid or missing apikey" }, { status: 401 })
  }
  if (req.method !== "POST") {
    return Response.json({ error: "method not allowed" }, { status: 405 })
  }

  const authHeader = req.headers.get("Authorization") ?? ""
  const callerToken = authHeader.replace(/^Bearer\s+/i, "")
  if (!callerToken) {
    return Response.json({ error: "sign in first" }, { status: 401 })
  }

  let organisationId: number | undefined
  try {
    const secretKey = new TextEncoder().encode(JWT_SECRET)
    const verified = await jose.jwtVerify(callerToken, secretKey, { issuer: ISSUER })
    const claims = (verified.payload.app_metadata as { role_tier?: string; organisation_id?: number }) ?? {}
    if (claims.role_tier !== "executive") {
      return Response.json({ error: "only a Director can set up billing" }, { status: 403 })
    }
    organisationId = claims.organisation_id
  } catch {
    return Response.json({ error: "invalid session" }, { status: 401 })
  }
  if (!organisationId) {
    return Response.json({ error: "no organisation on this session" }, { status: 400 })
  }

  let body: { discount_code?: string; billing_interval?: string } = {}
  try {
    body = await req.json()
  } catch {
    // No body at all is fine -- discount_code is optional.
  }

  const { data: subscription, error: subErr } = await admin
    .from("subscriptions")
    .select("id, plan_name, gocardless_mandate_id, mandate_status, founding_offer, discount_percent, free_access_granted")
    .eq("organisation_id", organisationId)
    .maybeSingle()
  if (subErr || !subscription) {
    return Response.json({ error: "no subscription found for this organisation" }, { status: 404 })
  }
  if (subscription.gocardless_mandate_id && subscription.mandate_status === "active") {
    return Response.json({ error: "Direct Debit is already set up for this organisation" }, { status: 409 })
  }
  if (!subscription.plan_name) {
    return Response.json({ error: "choose a plan before setting up billing" }, { status: 400 })
  }

  const billingInterval = body.billing_interval === "yearly" ? "yearly" : "monthly"

  let discountApplied = (subscription.discount_percent ?? 0) > 0 || subscription.founding_offer === true
  let discountError: string | null = null
  let discountType: string | null = null
  const discountCode = (body.discount_code ?? "").trim().toUpperCase()
  if (discountCode && !discountApplied) {
    const { data: code, error: codeErr } = await admin
      .from("invite_codes")
      .select("code, used_at, code_type")
      .ilike("code", discountCode)
      .maybeSingle()
    if (codeErr) {
      console.error("discount code lookup", codeErr)
      discountError = "could not verify that discount code"
    } else if (!code || code.used_at) {
      discountError = "that discount code isn't valid or has already been used"
    } else {
      // Claim it atomically: only succeeds if still unused, so the same
      // code can't be redeemed twice by two companies at once.
      const { data: claimed } = await admin
        .from("invite_codes")
        .update({ used_at: new Date().toISOString(), used_by_org_id: organisationId })
        .eq("code", code.code)
        .is("used_at", null)
        .select("code")
      if (!claimed || claimed.length === 0) {
        discountError = "that discount code isn't valid or has already been used"
      } else {
        discountType = code.code_type ?? "half_life"
        const update: Record<string, unknown> = { updated_at: new Date().toISOString() }
        if (discountType === "free_life") {
          update.free_access_granted = true
        } else {
          update.discount_percent = 50
          update.founding_offer = true
          if (discountType === "half_year") {
            const ends = new Date()
            ends.setMonth(ends.getMonth() + 12)
            update.discount_ends_at = ends.toISOString()
          }
        }
        await admin.from("subscriptions").update(update).eq("id", subscription.id)
        discountApplied = true
      }
    }
  }

  // Owner code (or access granted by VenuRite admin): nothing to pay, so
  // no Direct Debit is needed.
  if (discountType === "free_life" || subscription.free_access_granted) {
    return Response.json({
      redirect_url: null,
      free_access: true,
      discount_applied: true,
      discount_type: "free_life",
      discount_error: null,
    })
  }

  await admin
    .from("subscriptions")
    .update({ billing_interval: billingInterval })
    .eq("id", subscription.id)

  const sessionToken = crypto.randomUUID()
  const successUrl = new URL(`${SUPABASE_PUBLIC_URL}/functions/v1/gocardless-confirm-mandate`)
  successUrl.searchParams.set("org", String(organisationId))
  successUrl.searchParams.set("st", sessionToken)

  const gcResponse = await fetch(`${GC_API_BASE}/redirect_flows`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${GC_ACCESS_TOKEN}`,
      "GoCardless-Version": "2015-07-06",
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      redirect_flows: {
        description: "VenuRite subscription",
        session_token: sessionToken,
        success_redirect_url: successUrl.toString(),
      },
    }),
  })
  const gcData = await gcResponse.json()
  if (!gcResponse.ok) {
    console.error("gocardless redirect_flows create", gcData)
    return Response.json({ error: "could not start Direct Debit setup" }, { status: 502 })
  }

  return Response.json({
    redirect_url: gcData.redirect_flows.redirect_url,
    discount_applied: discountApplied,
    discount_type: discountType,
    discount_error: discountError,
    billing_interval: billingInterval,
  })
})
