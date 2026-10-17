// Device pairing (2026-09-20) — lets a shared kitchen tablet see its own
// venue's staff list BEFORE anyone has signed in. Called with the app's
// anon key and no session (there is none yet) — the caller proves it
// belongs to a venue by supplying that venue's device_credential (shown
// to a manager in Venue Details, entered once per tablet). Service-role
// throughout, same shape as pin-login/tenant-signup: an unauthenticated
// client can't read `sites`/`users` directly under RLS, which is correct.
//
// Section picker (2026-09-23) — now also returns each staff member's
// department_id and the site's own active departments, so the login
// screen can offer a department-first picker for multi-department
// venues (see auth_providers.dart's staffDirectoryProvider doc comment).
// Backwards compatible: department_id is simply null/omitted-from-
// grouping for any staff row not yet assigned one, exactly like local
// installs already behave.
import "@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"

const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
const DB_URL = Deno.env.get("SUPABASE_URL")!

const admin = createClient(DB_URL, SERVICE_ROLE_KEY)

Deno.serve(async (req: Request) => {
  if (req.headers.get("apikey") !== ANON_KEY) {
    return Response.json({ error: "invalid or missing apikey" }, { status: 401 })
  }
  if (req.method !== "POST") {
    return Response.json({ error: "method not allowed" }, { status: 405 })
  }

  let body: { device_credential?: string }
  try {
    body = await req.json()
  } catch {
    return Response.json({ error: "invalid JSON body" }, { status: 400 })
  }

  const credential = (body.device_credential ?? "").trim()
  if (!credential) {
    return Response.json({ error: "device_credential is required" }, { status: 400 })
  }

  const { data: site, error: siteErr } = await admin
    .from("sites")
    .select("id")
    .eq("device_credential", credential)
    .maybeSingle()

  if (siteErr) {
    console.error("site lookup", siteErr)
    return Response.json({ error: "could not verify code" }, { status: 500 })
  }
  if (!site) {
    return Response.json({ error: "invalid setup code" }, { status: 401 })
  }

  const { data: staff, error: staffErr } = await admin
    .from("users")
    .select("id, name, job_title, role_tier, department_id")
    .eq("site_id", site.id)
    .eq("active", true)
    .in("role_tier", ["base", "supervisor", "venueManager"])

  if (staffErr) {
    console.error("staff lookup", staffErr)
    return Response.json({ error: "could not load staff" }, { status: 500 })
  }

  const { data: departments, error: deptErr } = await admin
    .from("departments")
    .select("id, name")
    .eq("site_id", site.id)
    .eq("active", true)
    .order("name", { ascending: true })

  if (deptErr) {
    console.error("department lookup", deptErr)
    return Response.json({ error: "could not load departments" }, { status: 500 })
  }

  // Mid-shift notifications (2026-10-17): "due now" counts for the shared
  // tablet's name list. Best effort — never fails the login.
  const dueNow: Record<string, number> = {}
  const { data: dueRows } = await admin.rpc("site_due_now_counts_for_device", { p_site_id: site.id })
  for (const r of (dueRows ?? []) as { user_id: number; due_count: number }[]) {
    dueNow[String(r.user_id)] = r.due_count
  }

  return Response.json({
    site_id: site.id,
    staff: staff ?? [],
    departments: departments ?? [],
    due_now: dueNow,
  })
})
