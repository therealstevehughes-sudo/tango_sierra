// Certification expiry warnings (Phase 2, 2026-09-30) — the first
// cron-triggered Edge Function in this backend (every other function so
// far is called by the app itself). No host-level pg_cron extension is
// installed on this server, so this is invoked by a plain host crontab
// entry running `curl` once a day (see BACKEND_INFRA.md's matching entry
// for the exact crontab line) — same "host cron for scheduled work"
// pattern already used for the nightly pg_dumpall backup.
//
// Fires exactly once per record, 30 days before its expires_at: matches
// on expires_at falling exactly 30 days from today (date-only comparison,
// so it's a single-day window, not "any time in the next 30 days" which
// would re-notify every day for a month). Only the LATEST record per
// (user_id, item_type) is considered — mirrors training_record.dart's
// latestPerItem() reduction — so a renewed certification's superseded old
// record can never trigger a stale warning.
//
// English-only for this first pass (known limitation, not an oversight —
// unlike client-side push in send-push.ts, there is no per-recipient
// AppLocalizations available in a Deno Edge Function without duplicating
// the whole .arb catalogue here; flagged in PHASE_2_ROADMAP.md as a
// follow-up rather than silently shipping unlocalized text unremarked).

import "@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"
import * as jose from "jsr:@panva/jose@6"

const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
const DB_URL = Deno.env.get("SUPABASE_URL")!
const SERVICE_ACCOUNT_B64 = Deno.env.get("FIREBASE_SERVICE_ACCOUNT_JSON_B64")!
// Shared secret for the host cron to authenticate with — separate from
// the anon/service-role keys so this endpoint's own exposure is limited
// to whatever holds this one value (only the server's own crontab).
const CRON_SECRET = Deno.env.get("CERT_EXPIRY_CRON_SECRET")!

const supabaseAdmin = createClient(DB_URL, SERVICE_ROLE_KEY)

const ITEM_TYPE_LABELS: Record<string, string> = {
  level2FoodHygiene: "Level 2 Food Hygiene & Safety",
  allergenAwareness: "Allergen Awareness",
  coshh: "COSHH (Control of Substances Hazardous to Health)",
  fireSafety: "Fire Safety",
  manualHandling: "Manual Handling",
  firstAid: "First Aid at Work",
  induction: "Induction Completed",
  other: "Training",
}

interface ServiceAccount {
  project_id: string
  client_email: string
  private_key: string
}

let cachedServiceAccount: ServiceAccount | null = null
function getServiceAccount(): ServiceAccount {
  if (!cachedServiceAccount) {
    cachedServiceAccount = JSON.parse(atob(SERVICE_ACCOUNT_B64))
  }
  return cachedServiceAccount!
}

let cachedAccessToken: { token: string; expiresAt: number } | null = null
async function getAccessToken(): Promise<string> {
  const now = Math.floor(Date.now() / 1000)
  if (cachedAccessToken && cachedAccessToken.expiresAt > now + 60) {
    return cachedAccessToken.token
  }
  const account = getServiceAccount()
  const privateKey = await jose.importPKCS8(account.private_key, "RS256")
  const assertion = await new jose.SignJWT({
    scope: "https://www.googleapis.com/auth/firebase.messaging",
  })
    .setProtectedHeader({ alg: "RS256" })
    .setIssuer(account.client_email)
    .setAudience("https://oauth2.googleapis.com/token")
    .setIssuedAt(now)
    .setExpirationTime(now + 3600)
    .sign(privateKey)

  const tokenResponse = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion,
    }),
  })
  if (!tokenResponse.ok) {
    throw new Error(`token exchange failed: ${await tokenResponse.text()}`)
  }
  const tokenData = await tokenResponse.json()
  cachedAccessToken = { token: tokenData.access_token, expiresAt: now + tokenData.expires_in }
  return cachedAccessToken.token
}

async function sendPush(fcmToken: string, title: string, body: string): Promise<boolean> {
  try {
    const accessToken = await getAccessToken()
    const account = getServiceAccount()
    const res = await fetch(
      `https://fcm.googleapis.com/v1/projects/${account.project_id}/messages:send`,
      {
        method: "POST",
        headers: { Authorization: `Bearer ${accessToken}`, "Content-Type": "application/json" },
        body: JSON.stringify({ message: { token: fcmToken, notification: { title, body } } }),
      },
    )
    return res.ok
  } catch {
    return false
  }
}

Deno.serve(async (req: Request) => {
  const providedSecret = req.headers.get("x-cron-secret")
  if (!CRON_SECRET || providedSecret !== CRON_SECRET) {
    return Response.json({ error: "unauthorized" }, { status: 401 })
  }

  // Every record whose expiry is exactly 30 days from today, date-only.
  const targetDate = new Date()
  targetDate.setUTCDate(targetDate.getUTCDate() + 30)
  const targetDateStr = targetDate.toISOString().slice(0, 10)

  const { data: expiring, error: expiringErr } = await supabaseAdmin
    .from("training_records")
    .select("id, user_id, item_type, custom_item_title, expires_at, completed_at")
    .gte("expires_at", `${targetDateStr}T00:00:00Z`)
    .lt("expires_at", `${targetDateStr}T23:59:59.999Z`)

  if (expiringErr) {
    return Response.json({ error: expiringErr.message }, { status: 500 })
  }
  if (!expiring || expiring.length === 0) {
    return Response.json({ notified: 0, checked: 0 })
  }

  let notifiedCount = 0
  const results: Array<{ recordId: number; skipped?: string; employeeSent?: boolean; managerSent?: boolean }> = []

  for (const record of expiring) {
    // Confirm this is still the LATEST record for this user+item — a
    // renewal since this record was created means it's superseded, and
    // that renewal (with its own, later expiry) is what should notify
    // instead, not this one.
    const { data: latest } = await supabaseAdmin
      .from("training_records")
      .select("id, completed_at")
      .eq("user_id", record.user_id)
      .eq("item_type", record.item_type)
      .order("completed_at", { ascending: false })
      .limit(1)
      .maybeSingle()

    if (!latest || latest.id !== record.id) {
      results.push({ recordId: record.id, skipped: "superseded by a renewal" })
      continue
    }

    const { data: user } = await supabaseAdmin
      .from("users")
      .select("id, name, fcm_token, reports_to_user_id")
      .eq("id", record.user_id)
      .maybeSingle()

    if (!user) {
      results.push({ recordId: record.id, skipped: "user not found" })
      continue
    }

    const itemLabel = record.item_type === "other"
      ? (record.custom_item_title ?? "Training")
      : (ITEM_TYPE_LABELS[record.item_type] ?? record.item_type)
    const expiryDate = new Date(record.expires_at).toLocaleDateString("en-GB")

    let employeeSent = false
    let managerSent = false

    if (user.fcm_token) {
      employeeSent = await sendPush(
        user.fcm_token,
        "Certification expiring soon",
        `Your ${itemLabel} certification expires on ${expiryDate}. Renew it soon to stay eligible for shifts that require it.`,
      )
    }

    if (user.reports_to_user_id) {
      const { data: manager } = await supabaseAdmin
        .from("users")
        .select("fcm_token")
        .eq("id", user.reports_to_user_id)
        .maybeSingle()
      if (manager?.fcm_token) {
        managerSent = await sendPush(
          manager.fcm_token,
          "Staff certification expiring soon",
          `${user.name}'s ${itemLabel} certification expires on ${expiryDate}.`,
        )
      }
    }

    notifiedCount += 1
    results.push({ recordId: record.id, employeeSent, managerSent })
  }

  return Response.json({ checked: expiring.length, notified: notifiedCount, results })
})
