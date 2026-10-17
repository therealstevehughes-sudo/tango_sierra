// GoCardless billing (2026-09-21) -- receives real-time events from
// GoCardless (payment confirmed/failed, mandate cancelled/failed) and
// updates public.subscriptions accordingly. This is what actually drives
// the agreed grace-period model: trialing -> active -> past_due (grace,
// still full access) -> restricted (read-only), computed CLIENT-SIDE from
// `status`/`last_payment_failed_at` at read time (see
// lib/shared/services/billing_service.dart's effectiveBillingState()) --
// this function only ever records the raw facts, never decides "is this
// account restricted right now," matching the same computed-on-read
// pattern DueStatusService already uses for overdue tasks (no cron job
// needed either way).
//
// No caller session at all -- GoCardless calls this directly, proven
// authentic via HMAC-SHA256 over the raw request body using the webhook
// secret configured in the GoCardless dashboard, not the apikey/JWT
// pattern every other function here uses.
import "@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"

const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
const DB_URL = Deno.env.get("SUPABASE_URL")!
const WEBHOOK_SECRET = Deno.env.get("GOCARDLESS_WEBHOOK_SECRET")!

const admin = createClient(DB_URL, SERVICE_ROLE_KEY)

async function verifySignature(rawBody: string, signatureHeader: string | null): Promise<boolean> {
  if (!signatureHeader) return false
  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(WEBHOOK_SECRET),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  )
  const signatureBytes = await crypto.subtle.sign("HMAC", key, new TextEncoder().encode(rawBody))
  const computedHex = Array.from(new Uint8Array(signatureBytes))
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("")
  // Constant-time-ish compare -- lengths are fixed (both hex-encoded
  // SHA-256), so a straightforward loop is enough here.
  if (computedHex.length !== signatureHeader.length) return false
  let diff = 0
  for (let i = 0; i < computedHex.length; i++) {
    diff |= computedHex.charCodeAt(i) ^ signatureHeader.charCodeAt(i)
  }
  return diff === 0
}

interface GcEvent {
  resource_type: string
  action: string
  links: { subscription?: string; mandate?: string; payment?: string }
}

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") {
    return Response.json({ error: "method not allowed" }, { status: 405 })
  }

  const rawBody = await req.text()
  const signature = req.headers.get("Webhook-Signature")
  if (!(await verifySignature(rawBody, signature))) {
    return Response.json({ error: "invalid signature" }, { status: 401 })
  }

  let body: { events?: GcEvent[] }
  try {
    body = JSON.parse(rawBody)
  } catch {
    return Response.json({ error: "invalid JSON body" }, { status: 400 })
  }

  for (const event of body.events ?? []) {
    try {
      if (event.resource_type === "payments" && event.links.subscription) {
        if (event.action === "confirmed") {
          await admin
            .from("subscriptions")
            .update({
              status: "active",
              last_payment_failed_at: null,
              restricted_at: null,
              updated_at: new Date().toISOString(),
            })
            .eq("provider_subscription_id", event.links.subscription)
        } else if (event.action === "failed" || event.action === "charged_back") {
          // Only set last_payment_failed_at if it isn't already set, so a
          // second failed retry doesn't restart the grace-period clock --
          // it should count from the FIRST failure, not the latest one.
          const { data: existing } = await admin
            .from("subscriptions")
            .select("id, last_payment_failed_at")
            .eq("provider_subscription_id", event.links.subscription)
            .maybeSingle()
          if (existing) {
            await admin
              .from("subscriptions")
              .update({
                status: "past_due",
                last_payment_failed_at: existing.last_payment_failed_at ?? new Date().toISOString(),
                updated_at: new Date().toISOString(),
              })
              .eq("id", existing.id)
          }
        }
      } else if (event.resource_type === "mandates" && event.links.mandate) {
        if (["cancelled", "failed", "expired"].includes(event.action)) {
          // A deliberately pulled/failed mandate is treated as an
          // immediate restriction, not a grace period -- per the agreed
          // design, this is a deliberate stop, not a billing blip.
          await admin
            .from("subscriptions")
            .update({
              status: "cancelled",
              mandate_status: event.action,
              restricted_at: new Date().toISOString(),
              updated_at: new Date().toISOString(),
            })
            .eq("gocardless_mandate_id", event.links.mandate)
        } else if (event.action === "active") {
          await admin
            .from("subscriptions")
            .update({ mandate_status: "active", updated_at: new Date().toISOString() })
            .eq("gocardless_mandate_id", event.links.mandate)
        }
      }
    } catch (e) {
      // One malformed/unexpected event must never block the rest of the
      // batch -- GoCardless sends events in batches and expects a single
      // 200 for the whole request.
      console.error("gocardless webhook event handling", event, e)
    }
  }

  return Response.json({ received: true })
})
