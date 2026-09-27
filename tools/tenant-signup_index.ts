// Phase C1b, extended Sprint 034 (Customer Onboarding & Billing
// Foundation, 2026-09-14) — new-company signup. Called with the app's
// anon key (a client-facing endpoint; the caller has no session yet,
// since creating the first executive account is the whole point). All
// privileged work runs through a service-role client here — an un-authed
// client can't create these rows directly under RLS, which is correct.
//
// Sprint 034 extends this from "company name + director name + email +
// password" into the full onboarding wizard's first stages in one
// atomic call: Organisation (with legal/billing fields), the first
// executive (GoTrue + public.users, owner_user_id set on the org), the
// first venue (optionally under a named region), and a trialing
// subscription row. Optional venue_type looks up an existing global or
// org venue type by name, or creates an org-scoped one if none matches.
// Best-effort rollback if a later step fails — same pattern as before,
// just with more to roll back.
//
// Sign-up gate REMOVED (2026-09-22, reversing the 2026-09-20 decision) —
// per-branch billing (below) is now the real gate: a stranger signing up
// costs nothing until they actually pay, so there's no need to keep
// sign-up itself invite-only. `public.invite_codes` is repurposed
// (unchanged shape, no migration) into a discount-code table read by
// gocardless-start-mandate instead — see that function's own doc
// comment. No invite/discount code is read or required here at all
// anymore.
//
// Per-branch pricing (2026-09-22, agreed with the user): £39/branch/month
// standard, discounted to £19/branch/month only via a valid code entered
// at Direct Debit setup (gocardless-start-mandate), never at sign-up.
// `branch_count` (the number the customer states they have, INCLUDING
// head office if any) drives `billed_site_count` here: at 4+ branches, a
// head-office unit is automatically added on top, since that's roughly
// where a business starts actually using the Regional/Executive
// oversight features (cross-venue rollups, consolidated billing) this
// app was built to support — not billed below that, since a 1-3 branch
// business is typically still one person wearing every hat.
import "@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"

const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
const DB_URL = Deno.env.get("SUPABASE_URL")!

const admin = createClient(DB_URL, SERVICE_ROLE_KEY)

const DEFAULT_TRIAL_DAYS = 14
const HEAD_OFFICE_THRESHOLD = 4
// Terms of Service acceptance (2026-09-27) — kept as a plain constant here
// rather than a database-driven "current version" row, matching how every
// other versioned-but-rarely-changing piece of content in this project is
// handled (motivational_quotes.dart, help_content.dart). Bump this string
// whenever legal/TERMS_OF_SERVICE.md's own "Version:" line changes, and the
// next signup will record the new version.
const CURRENT_TERMS_VERSION = "2026-09-27"

Deno.serve(async (req: Request) => {
  if (req.headers.get("apikey") !== ANON_KEY) {
    return Response.json({ error: "invalid or missing apikey" }, { status: 401 })
  }
  if (req.method !== "POST") {
    return Response.json({ error: "method not allowed" }, { status: 405 })
  }

  let body: {
    // Step 1 — admin account
    first_name?: string
    last_name?: string
    email?: string
    password?: string
    // Step 2 — company details
    company_name?: string
    legal_name?: string
    country?: string
    registered_address?: string
    vat_number?: string
    billing_email?: string
    primary_color_argb?: number
    // Step 4 — first venue
    venue_name?: string
    venue_address?: string
    venue_country?: string
    venue_region?: string
    venue_type?: string
    venue_timezone?: string
    // Step 5 — branch count for pricing (2026-09-22) -- how many
    // branches the customer says they have today, INCLUDING head office
    // if they have one. Only one real venue is created in this call
    // (the one named below) -- the rest get added one at a time later,
    // same as before this pricing model existed.
    branch_count?: number
    // Step 6 — payment preference (2026-09-14): captured now, not wired
    // to any real payment API yet -- 'stripe' | 'gocardless' | undefined
    // ("decide later").
    payment_provider?: string
    // Terms of Service acceptance (2026-09-27) — required, not optional;
    // signup is rejected outright without it, same "fail closed" spirit as
    // every other required field above.
    terms_accepted?: boolean
  }
  try {
    body = await req.json()
  } catch {
    return Response.json({ error: "invalid JSON body" }, { status: 400 })
  }

  const branchCount = Number.isInteger(body.branch_count) && (body.branch_count as number) >= 1
    ? (body.branch_count as number)
    : 1

  const firstName = (body.first_name ?? "").trim()
  const lastName = (body.last_name ?? "").trim()
  const email = (body.email ?? "").trim().toLowerCase()
  const password = body.password ?? ""
  const companyName = (body.company_name ?? "").trim()
  const country = (body.country ?? "").trim()
  const venueName = (body.venue_name ?? "").trim()

  if (!firstName || !lastName || !email || password.length < 8) {
    return Response.json(
      { error: "first_name, last_name, email and a password (8+ chars) are required" },
      { status: 400 },
    )
  }
  if (!companyName || !country) {
    return Response.json(
      { error: "company_name and country are required" },
      { status: 400 },
    )
  }
  if (!venueName) {
    return Response.json({ error: "venue_name is required" }, { status: 400 })
  }
  if (body.terms_accepted !== true) {
    return Response.json(
      { error: "you must accept the Terms of Service to create an account" },
      { status: 400 },
    )
  }

  const directorName = `${firstName} ${lastName}`.trim()

  // 1. Organisation
  const { data: org, error: orgErr } = await admin
    .from("organisations")
    .insert({
      name: companyName,
      legal_name: body.legal_name?.trim() || companyName,
      country,
      registered_address: body.registered_address?.trim() || null,
      vat_number: body.vat_number?.trim() || null,
      billing_email: body.billing_email?.trim() || email,
      terms_accepted_at: new Date().toISOString(),
      terms_accepted_version: CURRENT_TERMS_VERSION,
    })
    .select("id")
    .single()
  if (orgErr) {
    console.error("org insert", orgErr)
    return Response.json({ error: "could not create organisation" }, { status: 500 })
  }
  const organisationId = org.id as number

  const rollbackOrg = async () => {
    await admin.from("organisations").delete().eq("id", organisationId)
  }

  // 2. GoTrue account for the Director (executive tier)
  const { data: created, error: authErr } = await admin.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
    app_metadata: {
      role_tier: "executive",
      organisation_id: organisationId,
    },
  })
  if (authErr || !created.user) {
    console.error("auth createUser", authErr)
    await rollbackOrg()
    const already = authErr?.message?.toLowerCase().includes("already")
    return Response.json(
      { error: already ? "that email is already registered" : "could not create the account" },
      { status: already ? 409 : 500 },
    )
  }
  const authUserId = created.user.id

  const rollbackAll = async () => {
    await admin.auth.admin.deleteUser(authUserId)
    await rollbackOrg()
  }

  // 3. Matching public.users row (executive), linked
  const { data: localUser, error: userErr } = await admin
    .from("users")
    .insert({
      name: directorName,
      job_title: "Director",
      role_tier: "executive",
      organisation_id: organisationId,
      supabase_user_id: authUserId,
      active: true,
    })
    .select("id")
    .single()
  if (userErr) {
    console.error("users insert", userErr)
    await rollbackAll()
    return Response.json({ error: "could not create the director profile" }, { status: 500 })
  }
  const localUserId = localUser.id as number

  // 4. Set this Director as the org's owner (Sprint 034 decision #1 — a
  // billing/legal distinction, not a new RoleTier).
  const { error: ownerErr } = await admin
    .from("organisations")
    .update({ owner_user_id: localUserId })
    .eq("id", organisationId)
  if (ownerErr) {
    console.error("owner_user_id update (non-fatal)", ownerErr)
  }

  // 5. Optional named region for the first venue.
  let regionId: number | null = null
  const venueRegion = body.venue_region?.trim()
  if (venueRegion) {
    const { data: region, error: regionErr } = await admin
      .from("regions")
      .insert({ organisation_id: organisationId, name: venueRegion })
      .select("id")
      .single()
    if (regionErr) {
      console.error("region insert (non-fatal)", regionErr)
    } else {
      regionId = region.id as number
    }
  }

  // 6. First venue. device_credential (2026-09-21, device pairing) is
  // NOT NULL with no column default -- generate one here the same way
  // the client's own "regenerate code" action does (8 chars, no 0/O/1/I).
  const codeAlphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
  const deviceCredential = Array.from({ length: 8 }, () =>
    codeAlphabet[Math.floor(Math.random() * codeAlphabet.length)]
  ).join("")

  const { data: site, error: siteErr } = await admin
    .from("sites")
    .insert({
      organisation_id: organisationId,
      region_id: regionId,
      name: venueName,
      address: body.venue_address?.trim() || null,
      device_credential: deviceCredential,
    })
    .select("id")
    .single()
  if (siteErr) {
    console.error("site insert", siteErr)
    await rollbackAll()
    return Response.json({ error: "could not create the first venue" }, { status: 500 })
  }
  const siteId = site.id as number

  // 7. Optional venue type — look up an existing global (organisation_id
  // is null) or org-scoped match by name (case-insensitive); create an
  // org-scoped one if nothing matches. Non-fatal on any failure — the
  // venue exists and is usable either way.
  const venueTypeName = body.venue_type?.trim()
  if (venueTypeName) {
    try {
      const { data: existing } = await admin
        .from("venue_types")
        .select("id")
        .ilike("name", venueTypeName)
        .or(`organisation_id.is.null,organisation_id.eq.${organisationId}`)
        .limit(1)
        .maybeSingle()
      let venueTypeId = existing?.id as number | undefined
      if (!venueTypeId) {
        const { data: createdType } = await admin
          .from("venue_types")
          .insert({ name: venueTypeName, organisation_id: organisationId })
          .select("id")
          .single()
        venueTypeId = createdType?.id
      }
      if (venueTypeId) {
        await admin
          .from("site_venue_types")
          .insert({ site_id: siteId, venue_type_id: venueTypeId })
      }
    } catch (e) {
      console.error("venue type linking (non-fatal)", e)
    }
  }

  // 8. Trialing subscription — one row per organisation (Sprint 034
  // decision #3: schema now, real payment-provider wiring later —
  // provider-agnostic, Stripe or GoCardless, added 2026-09-14).
  const trialEndsAt = new Date(Date.now() + DEFAULT_TRIAL_DAYS * 24 * 60 * 60 * 1000)
  const allowedProviders = ["stripe", "gocardless"]
  const paymentProvider = allowedProviders.includes(body.payment_provider ?? "")
    ? body.payment_provider
    : null
  // billed_site_count (2026-09-22): the stated branch count, plus one
  // automatic head-office unit once that count reaches
  // HEAD_OFFICE_THRESHOLD — see this file's own top-of-file doc comment
  // for why 4, not lower. `founding_offer` starts false here always now
  // — it's set later, only via a real discount code entered at Direct
  // Debit setup (gocardless-start-mandate), never at sign-up.
  const billedSiteCount = branchCount + (branchCount >= HEAD_OFFICE_THRESHOLD ? 1 : 0)
  const { error: subErr } = await admin.from("subscriptions").insert({
    organisation_id: organisationId,
    status: "trialing",
    plan_name: "standard",
    billed_site_count: billedSiteCount,
    trial_ends_at: trialEndsAt.toISOString(),
    payment_provider: paymentProvider,
    founding_offer: false,
  })
  if (subErr) {
    console.error("subscription insert (non-fatal)", subErr)
  }

  // 9. Optional initial branding (unchanged from before this sprint).
  if (typeof body.primary_color_argb === "number") {
    const { error: brandErr } = await admin.from("branding_configs").insert({
      config_group_id: 0,
      version_number: 1,
      organisation_id: organisationId,
      company_name: companyName,
      primary_color_argb: body.primary_color_argb,
      set_by_user_id: localUserId,
    })
    if (brandErr) {
      console.error("branding insert (non-fatal)", brandErr)
    } else {
      await admin
        .from("branding_configs")
        .update({ config_group_id: 0 })
        .eq("organisation_id", organisationId)
      const { data: b } = await admin
        .from("branding_configs")
        .select("id")
        .eq("organisation_id", organisationId)
        .single()
      if (b) {
        await admin.from("branding_configs").update({ config_group_id: b.id }).eq("id", b.id)
      }
    }
  }

  return Response.json({
    organisation_id: organisationId,
    local_user_id: localUserId,
    site_id: siteId,
    email,
    trial_ends_at: trialEndsAt.toISOString(),
    billed_site_count: billedSiteCount,
    message: "Company created. Sign in with your email and password.",
  })
})
