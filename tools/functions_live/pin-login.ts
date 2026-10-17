// Phase 2: server-side PIN verification for base/supervisor/venueManager.
// Called with the app's anon key (a client-facing endpoint, not a
// server-to-server one) — the caller has no session yet, since obtaining
// one is the whole point of this function.
//
// All the security-relevant logic (hash comparison, failed-attempt
// counting, 5-attempt/15-minute lockout) lives in the database function
// verify_staff_pin(), not here — this function cannot be bypassed by
// calling the database directly, since staff_pins has zero grants to
// anon/authenticated and the function itself is revoked from both too.
// Only this function's service-role client can reach either. The apikey
// check below is a basic consistency/defense-in-depth check matching every
// other endpoint on this gateway — it is not the security boundary.

import "@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"
import * as jose from "jsr:@panva/jose@6"

const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
const JWT_SECRET = Deno.env.get("JWT_SECRET")!
const DB_URL = Deno.env.get("SUPABASE_URL")!
const ISSUER = "https://api.venurite.com/auth/v1"
const SESSION_LENGTH_SECONDS = 12 * 60 * 60 // one shift

const supabaseAdmin = createClient(DB_URL, SERVICE_ROLE_KEY)

Deno.serve(async (req: Request) => {
  const apikey = req.headers.get("apikey")
  if (apikey !== ANON_KEY) {
    return Response.json({ error: "invalid or missing apikey" }, { status: 401 })
  }

  if (req.method !== "POST") {
    return Response.json({ error: "method not allowed" }, { status: 405 })
  }

  let body: { user_id?: string; local_user_id?: number; pin?: string }
  try {
    body = await req.json()
  } catch {
    return Response.json({ error: "invalid JSON body" }, { status: 400 })
  }

  const { pin } = body
  if (!pin || !/^\d{4}$/.test(pin)) {
    return Response.json({ error: "a 4-digit pin is required" }, { status: 400 })
  }

  // Phase C1d — a real (backend-first) tenant's staff have no local Drift
  // row to already know their supabase_user_id from. The walk-up UI knows
  // only the backend public.users.id in that case, so it's resolved here,
  // service-role (same privilege staff_pins/verify_staff_pin already
  // require) — never via a client-side read, which would need a session
  // that doesn't exist yet at login time. Existing callers that already
  // know the real uuid (the local Drift path) keep sending user_id
  // unchanged.
  let user_id = body.user_id
  if (!user_id && body.local_user_id) {
    const { data: userRow, error: userLookupErr } = await supabaseAdmin
      .from("users")
      .select("supabase_user_id")
      .eq("id", body.local_user_id)
      .eq("active", true)
      .single()
    if (userLookupErr || !userRow?.supabase_user_id) {
      return Response.json({ error: "incorrect pin" }, { status: 401 })
    }
    user_id = userRow.supabase_user_id
  }
  if (!user_id) {
    return Response.json(
      { error: "user_id or local_user_id, and a 4-digit pin, are required" },
      { status: 400 },
    )
  }

  const { data, error } = await supabaseAdmin
    .rpc("verify_staff_pin", { p_user_id: user_id, p_pin: pin })
    .single()

  if (error) {
    console.error("verify_staff_pin RPC error", error)
    return Response.json({ error: "internal error" }, { status: 500 })
  }

  if (data.locked) {
    return Response.json(
      { error: "locked", locked_until: data.locked_until },
      { status: 423 },
    )
  }

  if (!data.success) {
    return Response.json({ error: "incorrect pin" }, { status: 401 })
  }

  // Billing v2 (2026-10-17): branch prices are banded by staff who
  // actually used VenuRite that month, so record this login against the
  // branch — here, server-side, where the app can't skip it. Best-effort:
  // a failed write must never stop someone logging in.
  if (data.site_id && data.local_user_id) {
    const month = new Date().toISOString().slice(0, 7) + "-01"
    const { error: activityErr } = await supabaseAdmin
      .from("site_monthly_activity")
      .upsert(
        { site_id: data.site_id, user_id: data.local_user_id, month },
        { onConflict: "site_id,user_id,month", ignoreDuplicates: true },
      )
    if (activityErr) console.error("site_monthly_activity upsert", activityErr)
  }

  const now = Math.floor(Date.now() / 1000)
  const secretKey = new TextEncoder().encode(JWT_SECRET)

  const accessToken = await new jose.SignJWT({
    role: "authenticated",
    aud: "authenticated",
    app_metadata: {
      provider: "pin",
      role_tier: data.role_tier,
      site_id: data.site_id,
      local_user_id: data.local_user_id,
      // Phase B1 — resolved via a live join through sites inside
      // verify_staff_pin() itself, not cached here or on staff_pins, so a
      // site's region/org reassignment is picked up on the very next login.
      organisation_id: data.organisation_id,
      region_id: data.region_id,
    },
  })
    .setProtectedHeader({ alg: "HS256" })
    .setIssuer(ISSUER)
    .setSubject(user_id)
    .setIssuedAt(now)
    .setExpirationTime(now + SESSION_LENGTH_SECONDS)
    .sign(secretKey)

  return Response.json({
    access_token: accessToken,
    token_type: "bearer",
    expires_in: SESSION_LENGTH_SECONDS,
    user: {
      id: user_id,
      role_tier: data.role_tier,
      site_id: data.site_id,
      local_user_id: data.local_user_id,
      organisation_id: data.organisation_id,
      region_id: data.region_id,
    },
  })
})
