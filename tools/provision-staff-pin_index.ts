// Phase C1d — creates a PIN-tier staff account (venueManager, supervisor,
// or base) the way the walk-up tap-name+PIN flow expects: a real
// auth.users identity (synthetic email — PIN accounts have no real one),
// a linked public.users profile, and a staff_pins row with a freshly
// generated PIN. Not an open endpoint: the caller's own session token
// (PIN or GoTrue — both are HS256, signed with the same JWT_SECRET, so
// verified the same way here rather than via admin.auth.getUser, which
// only recognises real GoTrue sessions) is verified and checked against
// the cascade rule: a regional/executive can create a venueManager; a
// venueManager (or above) can create a supervisor/base.
import "@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"
import * as jose from "jsr:@panva/jose@6"

const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
const JWT_SECRET = Deno.env.get("JWT_SECRET")!
const DB_URL = Deno.env.get("SUPABASE_URL")!
const ISSUER = "https://api.venurite.com/auth/v1"

const admin = createClient(DB_URL, SERVICE_ROLE_KEY)

function randomPin(): string {
  return String(Math.floor(1000 + Math.random() * 9000))
}

async function hashPin(pin: string, salt: string): Promise<string> {
  const data = new TextEncoder().encode(salt + ":" + pin)
  const digest = await crypto.subtle.digest("SHA-256", data)
  return Array.from(new Uint8Array(digest)).map((b) => b.toString(16).padStart(2, "0")).join("")
}

function randomSalt(): string {
  const bytes = crypto.getRandomValues(new Uint8Array(16))
  return Array.from(bytes).map((b) => b.toString(16).padStart(2, "0")).join("")
}

const TIER_RANK: Record<string, number> = {
  base: 0,
  supervisor: 1,
  venueManager: 2,
  regional: 3,
  executive: 4,
}

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

  let callerClaims: { role_tier?: string; site_id?: number; organisation_id?: number; region_id?: number }
  try {
    const secretKey = new TextEncoder().encode(JWT_SECRET)
    const verified = await jose.jwtVerify(callerToken, secretKey, { issuer: ISSUER })
    callerClaims = (verified.payload.app_metadata as typeof callerClaims) ?? {}
  } catch {
    return Response.json({ error: "invalid session" }, { status: 401 })
  }
  const callerTier = callerClaims.role_tier ?? ""

  let body: {
    name?: string
    job_title?: string
    role_tier?: string
    job_role?: string | null
    site_id?: number
  }
  try {
    body = await req.json()
  } catch {
    return Response.json({ error: "invalid JSON body" }, { status: 400 })
  }

  const name = (body.name ?? "").trim()
  const jobTitle = (body.job_title ?? "").trim()
  const targetTier = body.role_tier ?? ""
  const siteId = body.site_id

  if (!name || !jobTitle || !siteId) {
    return Response.json({ error: "name, job_title and site_id are required" }, { status: 400 })
  }
  if (!["venueManager", "supervisor", "base"].includes(targetTier)) {
    return Response.json(
      { error: "role_tier must be 'venueManager', 'supervisor' or 'base'" },
      { status: 400 },
    )
  }

  const requiredCallerRank = TIER_RANK[targetTier] + 1
  if ((TIER_RANK[callerTier] ?? -1) < requiredCallerRank) {
    return Response.json(
      { error: "your account can't create a " + targetTier + " account" },
      { status: 403 },
    )
  }

  const { data: site } = await admin
    .from("sites")
    .select("organisation_id, region_id")
    .eq("id", siteId)
    .single()
  if (!site) {
    return Response.json({ error: "that site does not exist" }, { status: 400 })
  }
  const siteReachable =
    callerTier === "executive"
      ? site.organisation_id === callerClaims.organisation_id
      : callerTier === "regional"
        ? site.region_id === callerClaims.region_id
        : callerClaims.site_id === siteId
  if (!siteReachable) {
    return Response.json({ error: "that site isn't in your scope" }, { status: 403 })
  }

  const syntheticEmail = "pin-" + crypto.randomUUID() + "@staff.venurite.invalid"
  const { data: created, error: authErr } = await admin.auth.admin.createUser({
    email: syntheticEmail,
    password: crypto.randomUUID() + "Aa1!",
    email_confirm: true,
  })
  if (authErr || !created.user) {
    console.error("auth createUser", authErr)
    return Response.json({ error: "could not create the account" }, { status: 500 })
  }
  const authUserId = created.user.id

  const { data: localUser, error: userErr } = await admin
    .from("users")
    .insert({
      name,
      job_title: jobTitle,
      role_tier: targetTier,
      job_role: body.job_role ?? null,
      site_id: siteId,
      organisation_id: site.organisation_id,
      supabase_user_id: authUserId,
      active: true,
    })
    .select("id")
    .single()
  if (userErr) {
    await admin.auth.admin.deleteUser(authUserId)
    console.error("users insert", userErr)
    return Response.json({ error: "could not create the staff profile" }, { status: 500 })
  }

  const pin = randomPin()
  const salt = randomSalt()
  const pinHash = await hashPin(pin, salt)
  const { error: pinErr } = await admin.from("staff_pins").insert({
    user_id: authUserId,
    pin_hash: pinHash,
    pin_salt: salt,
    role_tier: targetTier,
    site_id: siteId,
    local_user_id: localUser.id,
  })
  if (pinErr) {
    await admin.from("users").delete().eq("id", localUser.id)
    await admin.auth.admin.deleteUser(authUserId)
    console.error("staff_pins insert", pinErr)
    return Response.json({ error: "could not set the PIN" }, { status: 500 })
  }

  // Roster add-on re-pricing (2026-09-27) -- fire-and-forget: a new active
  // staff member can change which price bracket a site falls into.
  // Reuses the CALLER's own token (already verified above, carries the
  // organisation_id claim reprice_if_needed needs) via a plain HTTP call
  // to the sibling roster-addon-billing function, rather than duplicating
  // its GoCardless logic here or adding GoCardless secrets to this
  // function. No-ops instantly if Roster isn't enabled for this org, and
  // must never fail or delay the actual account-creation response above.
  fetch(`${DB_URL}/functions/v1/roster-addon-billing`, {
    method: "POST",
    headers: {
      apikey: ANON_KEY,
      Authorization: `Bearer ${callerToken}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ action: "reprice_if_needed" }),
  }).catch((e) => console.error("roster-addon reprice trigger (non-fatal)", e))

  return Response.json({
    local_user_id: localUser.id,
    name: name,
    role_tier: targetTier,
    site_id: siteId,
    pin: pin,
    message: "Account created. Give this person their name (to tap on the login screen) and this PIN.",
  })
})
