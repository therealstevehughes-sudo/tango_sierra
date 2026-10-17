// Mid-shift notifications (2026-10-17, founder-approved plan 3). Run every
// 5 minutes by cron (x-cron-secret, same secret as cert-expiry). The
// database picks who to remind, at most once per task per day
// (claim_due_task_reminders, tools/task_reminders_migration.sql); this
// only sends the pushes. People without the Android app registered simply
// get nothing here — the in-app list and the tablet badge still show it.

import "@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"
import * as jose from "jsr:@panva/jose@6"

const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
const DB_URL = Deno.env.get("SUPABASE_URL")!
const CRON_SECRET = Deno.env.get("CERT_EXPIRY_CRON_SECRET")!
const SERVICE_ACCOUNT_B64 = Deno.env.get("FIREBASE_SERVICE_ACCOUNT_JSON_B64")!

const supabaseAdmin = createClient(DB_URL, SERVICE_ROLE_KEY)

const WORDS: Record<string, { due: string; overdue: string }> = {
  en: { due: "Due now", overdue: "Overdue" },
  ar: { due: "مستحق الآن", overdue: "متأخر" },
  de: { due: "Jetzt fällig", overdue: "Überfällig" },
  es: { due: "Toca ahora", overdue: "Atrasado" },
  hi: { due: "अभी करना है", overdue: "देर हो गई" },
  hr: { due: "Sada na redu", overdue: "Zakašnjelo" },
  pl: { due: "Do zrobienia teraz", overdue: "Zaległe" },
  ro: { due: "De făcut acum", overdue: "Întârziat" },
  ur: { due: "ابھی کرنا ہے", overdue: "تاخیر ہو گئی" },
  zh: { due: "现在到期", overdue: "已逾期" },
}

type ServiceAccount = { project_id: string; client_email: string; private_key: string }
let account: ServiceAccount | null = null
let cachedToken: { token: string; expiresAt: number } | null = null

async function accessToken(): Promise<string> {
  const now = Math.floor(Date.now() / 1000)
  if (cachedToken && cachedToken.expiresAt > now + 60) return cachedToken.token
  account ??= JSON.parse(atob(SERVICE_ACCOUNT_B64))
  const key = await jose.importPKCS8(account!.private_key, "RS256")
  const assertion = await new jose.SignJWT({ scope: "https://www.googleapis.com/auth/firebase.messaging" })
    .setProtectedHeader({ alg: "RS256" })
    .setIssuer(account!.client_email)
    .setAudience("https://oauth2.googleapis.com/token")
    .setIssuedAt(now)
    .setExpirationTime(now + 3600)
    .sign(key)
  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({ grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer", assertion }),
  })
  if (!res.ok) throw new Error(`token exchange failed: ${await res.text()}`)
  const data = await res.json()
  cachedToken = { token: data.access_token, expiresAt: now + data.expires_in }
  return cachedToken.token
}

Deno.serve(async (req: Request) => {
  if (req.headers.get("apikey") !== ANON_KEY || req.headers.get("x-cron-secret") !== CRON_SECRET) {
    return Response.json({ error: "not allowed" }, { status: 401 })
  }
  const { data, error } = await supabaseAdmin.rpc("claim_due_task_reminders")
  if (error) return Response.json({ error: error.message }, { status: 500 })
  const rows = (data ?? []) as { user_id: number; fcm_token: string; locale: string; kind: string; task_title: string }[]

  let sent = 0
  const failures: string[] = []
  for (const r of rows) {
    const words = WORDS[r.locale] ?? WORDS.en
    const label = r.kind === "overdue" ? words.overdue : words.due
    try {
      const token = await accessToken()
      const res = await fetch(`https://fcm.googleapis.com/v1/projects/${account!.project_id}/messages:send`, {
        method: "POST",
        headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" },
        body: JSON.stringify({
          message: { token: r.fcm_token, notification: { title: `${label}: ${r.task_title}`, body: "VenuRite" } },
        }),
      })
      if (res.ok) sent++
      else failures.push(`${r.user_id}: ${res.status}`)
    } catch (e) {
      failures.push(`${r.user_id}: ${e instanceof Error ? e.message : String(e)}`)
    }
  }
  return Response.json({ claimed: rows.length, sent, failures })
})
