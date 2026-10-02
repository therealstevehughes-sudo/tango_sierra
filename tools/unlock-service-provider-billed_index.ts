// Service provider unlock, with real billing (2026-10-02) — closes the
// "recorded as intent only" gap from the original directory build
// (service_provider_directory_migration.sql's own fee_pence/billed doc
// comment): unlocking a contact now attempts a real one-off GoCardless
// Payment against the org's EXISTING mandate (the same one its main
// subscription already uses — no new mandate flow needed) at the moment
// of unlock, rather than waiting for a cron this backend deliberately
// doesn't have (see BACKEND_INFRA.md's standing note on that).
//
// Billing failure never blocks the unlock itself — an org with no
// mandate set up yet (trial, or declined Direct Debit) still gets to see
// the contact; `billed` just stays false on that row, same "impulse-buy,
// forgotten by next invoice, but never a feature-blocker" spirit as the
// original design. A superadmin can also always correct a row by hand via
// admin_set_unlock_billed if a charge silently failed and was later
// resolved another way.
//
// Replaces the plain `unlock_service_provider` RPC as the client's entry
// point (that RPC's own insert logic is duplicated here against the
// service-role client, since a Postgres function can't make an outbound
// HTTP call to GoCardless in this self-hosted stack without a pg_net-style
// extension this project doesn't use elsewhere).
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

const DEFAULT_FEE_PENCE = 79

const admin = createClient(DB_URL, SERVICE_ROLE_KEY)

interface Claims {
  organisation_id?: number
  local_user_id?: number
}

Deno.serve(async (req: Request) => {
  if (req.headers.get("apikey") !== ANON_KEY) {
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
  const organisationId = claims.organisation_id

  let body: { provider_id?: number }
  try {
    body = await req.json()
  } catch {
    return Response.json({ outcome: "error", error: "invalid JSON body" }, { status: 400 })
  }
  const providerId = body.provider_id
  if (!providerId) {
    return Response.json({ outcome: "error", error: "provider_id required" }, { status: 400 })
  }

  try {
    const { data: provider } = await admin
      .from("service_providers")
      .select("id, shared")
      .eq("id", providerId)
      .maybeSingle()
    if (!provider || !provider.shared) {
      return Response.json({ outcome: "error", error: "provider not found or not shared" }, { status: 404 })
    }

    // Idempotent, same as the original RPC — an already-unlocked provider
    // just returns the existing row, never a second charge.
    const { data: existing } = await admin
      .from("service_provider_unlocks")
      .select("id, billed")
      .eq("service_provider_id", providerId)
      .eq("unlocking_organisation_id", organisationId)
      .maybeSingle()
    if (existing) {
      return Response.json({ outcome: "already_unlocked", billed: existing.billed })
    }

    const { data: inserted, error: insertError } = await admin
      .from("service_provider_unlocks")
      .insert({
        service_provider_id: providerId,
        unlocking_organisation_id: organisationId,
        unlocked_by_user_id: claims.local_user_id ?? null,
        fee_pence: DEFAULT_FEE_PENCE,
      })
      .select("id, fee_pence")
      .single()
    if (insertError || !inserted) {
      throw new Error(`unlock insert failed: ${insertError?.message}`)
    }

    // Attempt real billing — never throws past this point, a failure here
    // just leaves `billed` false on the row that already exists.
    try {
      const { data: subscription } = await admin
        .from("subscriptions")
        .select("gocardless_mandate_id, mandate_status")
        .eq("organisation_id", organisationId)
        .maybeSingle()

      if (subscription?.gocardless_mandate_id && subscription.mandate_status === "active") {
        const gcResponse = await fetch(`${GC_API_BASE}/payments`, {
          method: "POST",
          headers: {
            Authorization: `Bearer ${GC_ACCESS_TOKEN}`,
            "GoCardless-Version": "2015-07-06",
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            payments: {
              amount: inserted.fee_pence,
              currency: "GBP",
              description: "VenuRite - service provider contact unlock",
              links: { mandate: subscription.gocardless_mandate_id },
            },
          }),
        })
        const gcData = await gcResponse.json()
        if (gcResponse.ok) {
          await admin
            .from("service_provider_unlocks")
            .update({ billed: true, gocardless_payment_id: gcData.payments.id })
            .eq("id", inserted.id)
          return Response.json({ outcome: "unlocked", billed: true })
        }
        console.error("gocardless unlock payment create", gcData)
      }
    } catch (billingError) {
      console.error("unlock billing attempt failed", billingError)
    }

    return Response.json({ outcome: "unlocked", billed: false })
  } catch (e) {
    return Response.json(
      { outcome: "error", error: e instanceof Error ? e.message : String(e) },
      { status: 500 },
    )
  }
})
