# VenuRite security review: scope of work

*Prepared October 2026 for an independent security reviewer.*

## About VenuRite

VenuRite is a food-safety and compliance app for UK hospitality venues: restaurants, pubs, hotels and contract caterers. Staff use it to:
- record daily checks (temperatures, cleaning, deliveries), including photos;
- clock in and out;
- book shifts;
- complete training.

Managers see reports and an audit export for food-safety inspectors.

**Customers are businesses**, often with several branches. The system holds:
- staff names, roles, work PINs and push-notification tokens;
- work photos;
- clock-in records, including a computed on-site or off-site result (raw coordinates are not stored);
- billing mandates, held via GoCardless;
- each business's compliance records.

We are about to take our first paying customers. We need an independent check that **one customer can never see or change another customer's data**, and that staff can't raise their own privileges.

## The system

| Part | Technology |
|---|---|
| Apps | Flutter: Android app, web app (`venurite.com/app`), admin web tool (`admin.venurite.com`) |
| Backend | **Self-hosted Supabase** in Docker on one Linux VPS: PostgreSQL 15, PostgREST, GoTrue, Storage, Edge Functions (Deno), Kong |
| API | `https://api.venurite.com` behind nginx |
| Database | About 64 tables in `public`, all with row-level security. About 58 `SECURITY DEFINER` functions. |
| Edge Functions | About 24, including PIN login, device login, staff provisioning, invites, push notifications, AI assistant (OpenAI), quiz drafting, GoCardless billing and webhook, and cron jobs. |
| Payments | GoCardless (direct debit; currently in sandbox) |
| Push | Firebase Cloud Messaging (server-side service account) |

### How login works (please test this closely)
- **Staff:** a 4-digit PIN at a shared venue tablet or their own phone. The `pin-login` Edge Function:
  1. checks the PIN, with lockout after failed attempts;
  2. mints our own **HS256 JWT**, carrying `app_metadata` claims: `role_tier`, `site_id`, `organisation_id`, `region_id`, `local_user_id`, and device claims.
- **Managers and directors:** email and password through GoTrue, plus optional TOTP 2FA.
- **Access rules:** RLS policies and functions rely on those JWT claims. The main helpers are `can_access_site(site_id)` and `can_access_organisation(org_id)`.
- **Role tiers:** `base` < `supervisor` < `venueManager` < `regional` < `executive`.
- **Shared tablets:** a tablet is paired to a venue with a setup code (`device-login`). A tablet can also register as a **branch device** with an Ed25519 key, and `pin-login` verifies its signature.

## What we want tested

### 1. Tenant isolation (highest priority)
- Can a user of business A read, insert, update or delete any row belonging to business B, through PostgREST, RPCs, Storage or Edge Functions?
- Can a user at one branch reach another branch of the same business beyond what their role allows?
- Review every RLS policy and every `SECURITY DEFINER` function for missing checks, `search_path` issues, or trusting client-supplied ids.

### 2. Privilege escalation
- Can staff change their own `role_tier`, `site_id`, `billing_access` or `books_shifts`?
  - **Known concern:** the `users` table has a broad update policy, with column guards added by trigger. Please check this thoroughly.
- Can staff mark their own work as verified, sign off their own training, or read quiz answers? Quiz answers are meant to be server-only.
- Can a manager act on staff in another business?

### 3. Authentication and tokens
- `pin-login`:
  - PIN brute force and lockout bypass;
  - user enumeration;
  - token lifetime;
  - claim injection;
  - device-signature replay.
- JWT handling across all Edge Functions. Each verifies HS256 with a shared secret and issuer, so check for algorithm confusion and for missing verification.
- GoTrue configuration: sign-up controls, password rules, 2FA, and email change.
- Setup-code and invite-code flows: guessability, reuse and expiry.

### 4. Edge Functions
- Input validation, authorisation, and any server-side request forgery.
- Abuse of functions that spend money or send things: AI assistant and quiz drafting (OpenAI cost), push notifications, invites.
- The GoCardless webhook: signature verification, replay, and mandate tampering.
- Cron endpoints guarded by a shared secret header.

### 5. Storage
- Photo buckets (task evidence, clock-in photos): bucket policies, cross-tenant access, and how far signed URLs can be guessed or shared.

### 6. Infrastructure
- nginx and Kong configuration, TLS, headers, exposed ports, Docker network exposure, and whether Supabase Studio or Postgres are reachable from the internet.
- SSH and server hardening basics.
- Secrets handling in `.env` and Edge Function environment.
- Backups: currently nightly on the same server; off-site copies are being added.

### 7. Client apps (lighter touch)
- Secrets shipped in the apps. Only the public anon key should be present.
- Local storage of tokens, PINs and the branch-device key.
- The admin tool (`admin.venurite.com`): who can reach it and what it can do.

## Out of scope
- Social engineering or phishing of our staff or customers.
- Denial-of-service or load testing against the live server. Rate-limit design review is welcome.
- Third-party platforms themselves (GoCardless, Firebase, OpenAI).
- Code quality not related to security.

## What we'll provide
- **Test accounts:**
  - two separate test businesses, each with several branches;
  - users at every role tier;
  - a paired test tablet setup code.
- **Access:**
  - read access to the source code (Flutter app, SQL migrations, Edge Function source);
  - a database schema dump.
- **Testing window:** the live server can be used, on agreed dates. Live customer data is minimal at this stage. A staging copy can be provided if preferred.
- A named contact for questions during testing.

## What we'd like back
1. **A written report.** Each finding with:
   - severity (CVSS or Critical/High/Medium/Low);
   - steps to reproduce;
   - affected component;
   - a recommended fix.
2. **An executive summary** in plain English for non-technical owners.
3. **A short retest** of fixed Critical and High findings, within 30 days.

## Who we're looking for
- Proven experience with **Supabase / PostgreSQL row-level security** and JWT-based auth.
- **API penetration testing** (OWASP API Top 10).
- Linux, Docker and nginx hardening.
- OSCP, CREST or equivalent certification is preferred. Please share examples of similar reviews.
- UK-based, or familiar with UK GDPR. An NDA is required before code access.

**Expected effort:** about 2–5 days. Please quote a fixed price and propose dates.
