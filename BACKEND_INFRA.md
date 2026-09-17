# BACKEND_INFRA.md

Non-secret operational record of Tango Sierra's backend infrastructure. Kept
separate from DECISIONS_LOG.md because this tracks *current state* (IPs,
status, what's live) rather than a narrative of decisions made.

**NEVER put secrets in this file** — no passwords, no JWT secrets, no API
keys (anon or service_role), no Studio credentials. Those live only in
Steve's password manager, per the explicit security practice agreed for
this backend phase. This file is safe to read, share, and commit to git.

## Plan revision (2026-08-17): shared VPS, not a dedicated one

Superseded the earlier "maximum separation / new dedicated VPS" decision —
Tango Sierra now shares Bloody Hell's existing VPS to avoid a second IONOS
subscription. Isolation is now at the application/Docker level (own
directory, own database, own secrets, own subdomain) rather than at the
physical-server level. See DECISIONS_LOG.md for the full reasoning.

## RESUMED (2026-08-17): permanent domain secured

App is officially **VenuRite**; permanent domain **www.venurite.com**
purchased. The earlier `db.bloodyhellapp.com` temporary-domain idea is
abandoned entirely — no migration will be needed, this is the real, final
domain. Backend subdomain: **`api.venurite.com`**.

## Where the domain is configured — reference list (kept for future
maintenance, e.g. server migration or cert reissue — no migration currently
planned, since this is the permanent domain)

- [ ] DNS A record → `217.160.174.119` (Steve, in venurite.com's registrar
      DNS panel) — being added now
- [ ] `.env` on the VPS: `SITE_URL`, `API_EXTERNAL_URL`, and any other
      domain-referencing variables
- [ ] nginx server block on the VPS (routes `api.venurite.com` to Envoy's
      internal port)
- [ ] SSL certificate — issued for `api.venurite.com`
- [ ] Flutter app's Supabase connection config — doesn't exist yet (Phase
      3/4, not started) — will need this URL once built

## Servers

| Purpose | VPS name | IP | Plan | OS | Status |
|---|---|---|---|---|---|
| Bloody Hell + Tango Sierra (shared) | My VPS | 217.160.174.119 | VPS 6-8-240 (6 vCore / 8GB / 240GB NVMe) | Ubuntu 24.04 | Live |

## What's already running on this VPS (surveyed 2026-08-17, before any
Tango Sierra changes — nothing here was touched)

- **nginx** — reverse proxy, listening on 80/443 (IPv4 + IPv6). This is
  what Tango Sierra's subdomain will be added to as a new server block —
  no new proxy software needed.
- **PostgreSQL 16** (native systemd service, not Docker) — bound to
  `127.0.0.1:5432` only, not publicly reachable. Belongs to Bloody Hell.
  Won't collide with Supabase's own Postgres, which runs inside Docker and
  is never published to the host's port 5432 either.
- **MariaDB** — bound to `127.0.0.1:3306`. Belongs to Bloody Hell, unrelated.
- **Node/Ghost** — `127.0.0.1:2368`. Belongs to Bloody Hell, unrelated.
- **Next.js** — `*:3000` (bound to all interfaces, not just localhost) —
  belongs to Bloody Hell, unrelated to Tango Sierra's setup; noted here
  only because it's the one existing service not restricted to localhost.
- **IONOS panel-level firewall**: a policy named "My firewall policy" is
  attached to this server — exact rules not yet reviewed; check before
  finishing the firewall step, since a panel-level firewall can override
  anything set inside the server.

## Tango Sierra's Supabase stack — what's done so far

- **Location**: `/root/tango-sierra/supabase/` on the VPS (the self-hosting
  `docker/` subfolder is what actually gets run).
- **Gateway**: this current version of Supabase's self-hosting repo defaults
  to **Envoy** as the API gateway, not Kong (Kong is now an optional
  override — `sh run.sh config add kong`). Plan updated accordingly: nginx
  will route to Envoy's port, not Kong's.
- **Fixed**: `docker-compose.yml` publishes the gateway port
  (`API_GW_HTTP_PORT`) to `0.0.0.0` by default — reachable from the
  internet unless changed. Changed `.env` to `API_GW_HTTP_PORT=127.0.0.1:8000`
  (Compose's port-mapping syntax accepts an `IP:PORT` value), so it's
  Docker/nginx-only, matching the "only 443 public" security requirement.
  Applied and confirmed 2026-08-17, before anything was brought online.
- **Secrets**: generated and written directly into `.env` on the server
  (never printed to chat) — `POSTGRES_PASSWORD`, `JWT_SECRET`,
  `DASHBOARD_PASSWORD`, `SECRET_KEY_BASE`, `VAULT_ENC_KEY`,
  `PG_META_CRYPTO_KEY` are all fresh random values. `ANON_KEY`/
  `SERVICE_ROLE_KEY` were cleared to blank so this version auto-derives
  real ones from the new `JWT_SECRET` at first boot, rather than using the
  public demo tokens `.env.example` ships with by default. Steve has saved
  the Studio dashboard username/password to his password manager.
- **Site/API URLs**: set in `.env` — `SUPABASE_PUBLIC_URL=https://api.venurite.com`,
  `API_EXTERNAL_URL=https://api.venurite.com/auth/v1`,
  `SITE_URL=https://api.venurite.com`. `SITE_URL` is a placeholder for now
  (it's meant to be the app's own redirect-back URL for auth flows — there's
  no such thing yet since Phase 2/the Flutter app's auth integration hasn't
  been built) — revisit when that's built, not before.
- **nginx + SSL**: new site file `/etc/nginx/sites-available/api-venurite`
  (symlinked into `sites-enabled/`), `server_name api.venurite.com`
  specifically (not the existing catch-all `default_server` block that
  serves Bloody Hell) — proxies to `127.0.0.1:8000` (Envoy). Real SSL
  certificate obtained via certbot, valid until 2026-11-29 with auto-renewal
  scheduled; HTTP→HTTPS redirect confirmed working. Verified externally
  (from outside the server, not just localhost): both `http://` and
  `https://api.venurite.com` return `502 Bad Gateway` — the *correct*
  result at this point, since it proves DNS/port/nginx routing/SSL all work
  end-to-end; the only reason it's not a real response is that the Supabase
  stack itself isn't started yet (checklist item further down).

## Access

Direct SSH access is set up for Claude Code to use directly (key-based,
`~/.ssh/tango_sierra_vps` on the local Windows machine — private key never
leaves this machine, only the public half was added to the server).
Password login still works as Steve's own backup access but is no longer
needed for day-to-day setup work, and will be disabled entirely once
hardening is complete.

## Phase 1 checklist status

- [x] 0. Confirmed which VPS Tango Sierra lives on (shared with Bloody Hell)
- [x] 1a. Direct SSH access confirmed working (key-based)
- [x] 1b. Existing server setup surveyed — no collisions found
- [ ] 1c. Root login + password auth disabled (deferred until a non-root
      operational user exists, so we don't lock anyone out)
- [x] 2. Docker + Docker Compose installed (v29.7.2 / Compose v5.4.0)
- [x] 3. Supabase self-hosting files cloned into an isolated directory
- [x] 4. Fresh secrets generated — **stop-and-confirm point #1, done**
- [x] 5. Set `API_GW_HTTP_PORT=127.0.0.1:8000` in `.env` (localhost-only fix, see above)
- [x] 6. DNS A record added for `api.venurite.com` → `217.160.174.119`
      (Squarespace DNS panel — confirmed live in the panel)
- [x] 7. Site/API URLs set in `.env` to `api.venurite.com` (see above)
- [x] 8. nginx server block added, routing to Envoy's internal port (see above)
- [x] 10. SSL/HTTPS live for `api.venurite.com` (done alongside item 8, since
      both only needed port 80 — see above; done ahead of the firewall step
      since it doesn't depend on it)
- [x] **STOP-AND-CONFIRM POINT #2 — reviewed and approved 2026-08-31**
- [x] 9. Firewall reviewed — **no changes needed**. The three internal ports
      (5432, 6543, 8000) are bound to `127.0.0.1` only at the Docker level,
      so they're never published to the public network interface at all —
      `ufw` never even sees them. Existing rules (22, 80/443, 2368, 3000,
      8080) left completely untouched.
- [x] 11. Stack brought up (`sh run.sh start`), all 11 containers healthy —
      confirmed 2026-08-31 (see "Live verification" section below)
- [x] 12. First Studio login confirmed working — 2026-09-01. Note: the
      saved `DASHBOARD_PASSWORD` was stale (regenerated earlier during the
      pooler troubleshooting, but Steve was never told to update his saved
      copy — fixed by re-pulling the current value and updating the saved
      entry).
- [x] 13a. Backups scheduled (daily via cron) + test restore confirmed with
      real sample data — done 2026-09-01, see "Backups" section below
- [ ] 13b. Off-VPS copy of backups — **not done yet, must-fix-before-real-data**.
      Candidate destination (a second Oracle Cloud server, 129.151.189.254)
      investigated 2026-09-01: same server as before (identity confirmed
      unchanged), but unreachable — connection times out (not refused, not
      a key rejection), pointing to either an Oracle-side Security
      List/NSG firewall rule or the free-tier instance being idle-reclaimed.
      Parked — Steve to check the Oracle console when convenient. Do not
      let real shop data go live before this is resolved one way or another.
- [ ] 13c. IONOS snapshot availability checked — needs Steve to look in the
      IONOS panel, not something checkable over SSH
- [x] 14. Final go/no-go review completed 2026-09-01 — **GO for Phase 2**,
      with a short must-fix-before-real-data list carried forward (see
      "Phase 1 close-out" below).

## Phase 1 close-out (2026-09-01)

**Green — done and verified:**
- Server access, isolation from the other 3 sites on the shared VPS
- All internal ports (5432, 6543, 8000) confirmed unreachable from outside
- SSL/domain live at `api.venurite.com`, real Supabase responses confirmed
- Full stack up, all 11 containers healthy
- Real API keys generated and saved
- Nightly backups running + a genuine test restore proven with real data
- Studio dashboard login confirmed working

**Outstanding — tracked, not blocking Phase 2 app-code work, but must be
closed before real shop data goes live:**
- 1c. Root/password SSH login still enabled (waiting on a non-root
  operational user existing first)
- 13b. Off-server backup copy — parked pending the Oracle server
  investigation (Steve checking the Oracle console)
- 13c. IONOS snapshot feature — not yet checked in the panel

**Verdict:** infrastructure is solid enough to start Phase 2 (the Flutter
app's own auth/data integration). The three items above don't block that
work, but none of them should still be open by the time your partner's
team is using this with real data.

## Backups (2026-09-01)

- **Script**: `/root/backups/backup_db.sh` on the VPS — dumps the entire
  Postgres cluster (`pg_dumpall`), compresses it, and deletes anything
  older than 14 days.
- **Schedule**: runs automatically every night at 3am via cron
  (`crontab -l` on the server shows the job).
- **Where backups live right now**: `/root/backups/` — on the same VPS as
  everything else. This is a real gap: if the whole server were lost
  (not just the database, but the physical/virtual machine itself), the
  backups would be lost too. This needs one of: (a) checking whether
  IONOS's snapshot feature is available/enabled for this VPS (item 13c
  above — Steve to check in the panel), or (b) copying backup files
  somewhere else periodically (e.g. a cloud storage bucket, or even just
  downloading them to Steve's own machine on a schedule). Not urgent while
  there's no real shop data yet, but must be resolved before Steve's
  partner's team starts relying on this for real.
- **Test restore, done properly**: created a real test table with sample
  rows in the live database, ran the backup script, restored that backup
  into a completely separate, throwaway Postgres container (not touching
  the live database at all), and confirmed the restored data matched the
  original exactly, row for row. Test table and throwaway container were
  both removed afterward — production was untouched throughout except for
  the temporary test table, which is gone now. A fresh, clean backup was
  taken immediately after cleanup, so a current recovery point exists.
  Note: restoring a full `pg_dumpall` cluster dump into a *brand-new*
  Supabase Postgres container (rather than into the live one) produces
  some expected, harmless errors around Supabase's own internal Auth/
  Realtime scaffolding (duplicate objects, a few not-yet-existing columns)
  — those services self-heal their own schema when they start up normally
  as part of the full stack, so this doesn't affect real data recovery.

## Live verification (2026-08-31) — run from outside the server, not assumed from config

1. **Port scan for 5432, 6543, 8000** — all three come back closed/refused
   from the public internet (tested via raw TCP connect from a machine
   outside the VPS). Confirmed via `ss -tlnp` on the server too: all three
   are bound to `127.0.0.1` only.
2. **The other three sites** — Ghost, Umami (analytics), and the admin hub
   all still return normal `200 OK` responses over nginx, exactly as
   before. Same running processes the whole time (never restarted) —
   nothing about them was touched. Port 3000 (Umami) is still bound to all
   interfaces exactly as it was before this work started, and port 8080
   has nothing listening on it — both pre-existing states, unrelated to
   anything done today.
3. **`api.venurite.com`** — no longer returns `502 Bad Gateway`. It now
   returns real responses from the Supabase stack itself (`401` with no
   key, `403 RBAC: access denied` with the anon key on the bare `/rest/v1/`
   root — both expected at this stage, since no tables/grants exist yet;
   this is Phase 2/3 work, not a Phase 1 problem).
4. **All containers healthy** — confirmed via `docker compose ps`.

## Issues found and fixed while bringing the stack up (2026-08-31)

- The pooler's port-binding override file approach didn't work — Docker
  Compose **appends** `ports:` lists across files rather than replacing
  them, so the original unbound entries stayed active alongside the new
  bound ones. Fixed by editing `docker-compose.yml` directly instead (two
  lines in the `supavisor` service), and removing the now-unnecessary
  override file. **Maintenance note**: because this is a direct edit to
  the vendored file (not an override file), it will need to be re-applied
  after any future `sh run.sh pull`/update — the two lines to restore are
  `supavisor`'s `ports:` entries getting a `127.0.0.1:` prefix.
- Port 5432 was already taken on this shared VPS by Bloody Hell's own
  native Postgres (also bound to `127.0.0.1` only). Fixed by publishing
  Supabase's own Postgres on host port **5433** instead (the container's
  internal port, and `POSTGRES_PORT` itself, both stay `5432` — only the
  host-facing port number changed, so nothing else needed touching).
- `ANON_KEY`/`SERVICE_ROLE_KEY` were left blank to auto-derive at boot, but
  this caused two problems: the `realtime` container's own health check
  failed (it reads the key from `.env` directly, not the live derived
  value), and the API gateway's routing config also had the blank value
  baked in at startup, rejecting all API calls. Fixed by generating real,
  permanent values from `JWT_SECRET` and writing them into `.env` directly
  on the server (values never left the server or appeared in chat) —
  this also means the Flutter app will have real keys ready to use once
  Phase 2 (auth integration) starts, rather than needing this redone later.
  **Steve: please retrieve `ANON_KEY` and `SERVICE_ROLE_KEY` from the
  server's `.env` yourself and save both to the password manager,
  especially `SERVICE_ROLE_KEY` — it bypasses all database security rules,
  so treat it like a master password.**

## Subdomain

`api.venurite.com` — permanent, confirmed 2026-08-17.

## Phase 1 — closed 2026-09-01

Studio login confirmed working, backups running with a proven test
restore, final go/no-go review done (see close-out section above). GO for
Phase 2 issued.

## Phase 2 — real backend auth (built and verified 2026-09-01)

Implements the design approved in DECISIONS_LOG.md's Phase 2 entry: real
Supabase auth behind the existing tap-name+PIN flow for base/supervisor/
venueManager, and real email+password for Leadership Access (regional/
executive), replacing its interim PIN.

**What's live:**
- `staff_pins` table (Postgres) — holds PIN hash/salt server-side, zero
  grants to anon/authenticated. Confirmed unreachable via the public REST
  API directly (401), even with a valid key — the only way in is through
  the function below.
- `verify_staff_pin()` (Postgres function) — the actual PIN check and
  lockout logic, atomic (row-locked) so concurrent guesses can't race past
  the limit. 5 wrong attempts -> 15-minute lockout, per Steve's decision.
  Verified directly: 5 wrong PINs lock the account, and the 6th attempt is
  rejected *even with the correct PIN* — the lockout is a hard gate, not a
  counter the correct PIN can override.
- `pin-login` Edge Function (`~/tango-sierra/supabase/docker/volumes/functions/pin-login/`
  on the VPS) — the app calls this with the anon key; it verifies the PIN
  via the function above and, on success, mints a real signed session
  token (HS256, using the stack's own JWT_SECRET) with the person's role
  tier and site baked into its claims. Verified the minted token is a real
  session, not just a valid-looking string: used it to insert a row into a
  throwaway RLS-protected table, which succeeded and was correctly
  attributed to the right person — while the same insert using only the
  anon key was rejected.
- **Lockout re-verified from outside the app entirely**: called the
  function directly over HTTP (bypassing the app completely, simulating
  someone hitting it directly) — 5 wrong attempts still locks it, exactly
  as when tested via the database function directly. Confirmed
  server-side, not cosmetic, per Steve's explicit requirement.
- Local app changes: `supabaseUserId` column added to the local staff
  table (links a local profile to its Supabase identity, null = not yet
  synced); `UserRepository.authenticate()` now returns a proper outcome
  (success/incorrect/locked/not-found/error) instead of a plain yes/no,
  gated behind `backendAuthEnabledProvider` (off by default — existing
  local-only login is completely unchanged unless explicitly turned on,
  per the "safe add-on" approach Steve asked for); Leadership Access
  screen rebuilt for real email + password sign-in via Supabase's own
  auth, replacing the PIN entirely for that tier.
- **Proven end-to-end**: a real integration test
  (`integration_test/phase2_pin_login_test.dart`) runs the actual
  production code on the real Windows build with real networking (not a
  mock) — tap a name, enter the correct PIN, get back a real signed
  session token from the real server; wrong PIN correctly rejected; with
  the feature flag off, the exact same call falls back to the existing
  local check with no token, proving both paths coexist safely. All
  passed. This is a real, live-backend test — needs internet and the test
  accounts below, so it's kept separate from the regular test suite.

**Test accounts used for this proof** (not real staff): the project's
existing seed users, since their PINs are already known plaintext.
- Steve Hughes (local id 1, base) → linked to a live Supabase identity,
  full PIN round trip proven with this account.
- Alex Rivera (local id 8, executive) → a Supabase identity was created
  directly with a set password for testing the Leadership Access screen's
  sign-in mechanics (bypassing email delivery, see gap below).

**Known gaps, not yet closed:**
- **Email delivery isn't configured** — the self-hosted stack still has
  the example/placeholder SMTP settings, so a real "invite by email" (per
  Steve's decision 5) won't actually reach anyone yet. Needs a real SMTP
  provider (e.g. SendGrid, Postmark, AWS SES) configured in `.env` before
  any real leadership person can be invited. Logged as must-fix-before-
  real-leadership-onboarding.
- **Bulk/lazy sync for real staff isn't built** — this pass manually
  linked two known test accounts. Rolling this out to a venue's real
  staff needs either a one-time migration script (copying each person's
  *existing* PIN hash/salt as-is, since their real plaintext PIN is
  unknown) or a "provision on first login" flow. Not built — future work
  before real onboarding.
- **2FA** — deliberately deferred per Steve's decision 4 (fast-follow
  after email+password, not bundled into this pass).
- **Linking a new Leadership Access account to its local staff profile**
  is currently a manual/scripted step (matching a Supabase identity to a
  local row) — no admin UI for this yet.
- `docker-compose.yml`'s vendored `functions` service environment exposes
  keys under `SUPABASE_ANON_KEY`/`SUPABASE_SERVICE_ROLE_KEY` (not the bare
  `ANON_KEY`/`SERVICE_ROLE_KEY` names used in `.env` directly) — worth
  remembering for any future Edge Function, since it's an easy mismatch to
  trip over (cost real debugging time this session).
- As with the other Edge/API containers earlier in Phase 1: **any
  container that reads secrets from `.env` must be force-recreated (`docker
  compose up -d --force-recreate <service>`), not just restarted**, after
  `.env` changes — `restart` reuses the old baked-in environment. Hit this
  twice this session (`functions` container had stale blank keys baked in
  from before they were generated).

## Phase B1 — claims + RLS foundation + cross-tenant proof (built and PROVEN 2026-09-08)

Implements the design approved in DECISIONS_LOG.md's Phase B1 entry. Backend
state checked directly before building (not assumed): only `staff_pins`
existed server-side; no `organisations`/`regions`/`sites` tables at all.

**Built (all real, permanent — kept, not thrown away after the proof):**
- `public.organisations(id, name, created_at)`, `public.regions(id,
  organisation_id, name, created_at)`, `public.sites(id, organisation_id,
  region_id, name, created_at)`. No grants to anon/authenticated yet —
  these become RLS-governed app-facing tables in a later cluster (B2+).
- `verify_staff_pin()` extended to also return `organisation_id`/
  `region_id`, resolved via a **live join through `sites`** at
  verification time (`select organisation_id, region_id from sites where
  id = rec.site_id`) — never cached on `staff_pins`, so a site's region/
  org reassignment takes effect on the very next login. `pin-login` Edge
  Function carries both into `app_metadata`.
- `custom_access_token_hook(event jsonb)` — this stack's GoTrue is
  v2.189.0, which supports the Custom Access Token Hook, so Leadership
  claims are live too, not just PIN's: enabled via
  `GOTRUE_HOOK_CUSTOM_ACCESS_TOKEN_ENABLED`/`_URI` in `docker-compose.yml`
  (previously-commented lines already vendored, uncommented — see
  `docker-compose.yml.bak-b1` on the server for the pre-change copy), auth
  container force-recreated, confirmed healthy with no errors in logs. The
  hook resolves `organisation_id`/`region_id` from the account's existing
  `site_id` claim on every token mint/refresh — symmetric with PIN's live
  join. `site_id` itself is still set once at provisioning (unchanged);
  only org/region resolution is live.
- `can_access_site(target_site_id int)` — the single reusable tier-aware
  function, `SECURITY DEFINER` with pinned `search_path` (same defensive
  pattern as `verify_staff_pin()`): branch tiers (base/supervisor/
  venueManager) match own `site_id`; regional matches any site sharing the
  caller's `region_id`; executive matches any site sharing the caller's
  `organisation_id`. Any missing/null claim returns `false` (fail closed).
  Reads claims via `current_setting('request.jwt.claims', true)`
  (PostgREST's convention), not a caller-supplied parameter.

**The proof — verbatim, run entirely via direct `curl` against
`https://api.venurite.com/rest/v1/...`, never the app UI.** Throwaway
tenants: Org A (id 1) with Region A1 (id 1: sites A1a=1, A1b=2) and Region
A2 (id 2: site A2a=3); Org B (id 2) with Region B1 (id 3: site B1a=4). A
throwaway table `isolation_proof_rows(id, site_id, note)`, one row per
site.

- **Test 0** — RLS enabled, **zero policies** yet. Branch token, SELECT:
  ```
  []
  HTTP_STATUS:200
  ```
  Proves "enabled, no policy" locks out even a legitimate session —
  fail-closed, not a false positive for "isolation working."

  *(Policy added at this point: `for all using (can_access_site(site_id))
  with check (can_access_site(site_id))`.)*

- **Test 1** — branch token (site A1a) SELECT:
  ```
  [{"id":1,"site_id":1,"note":"row for site A1a"}]
  HTTP_STATUS:200
  ```
- **Test 2** — branch token INSERT at its own site:
  ```
  [{"id":5,"site_id":1,"note":"branch_a1a legit insert"}]
  HTTP_STATUS:201
  ```
- **Test 3** — branch token INSERT claiming `site_id=4` (tenant B):
  ```
  {"code":"42501","details":null,"hint":null,"message":"new row violates row-level security policy for table \"isolation_proof_rows\""}
  HTTP_STATUS:403
  ```
  Admin follow-up query confirmed no hostile row landed (table still
  showed exactly rows 1-5, id 4 untouched).
- **Test 4** — branch token SELECT filtered directly by `site_id=eq.4`:
  ```
  []
  HTTP_STATUS:200
  ```
- **Test 5** — branch token UPDATE targeting site B1a's row (id=4):
  ```
  []
  HTTP_STATUS:200
  ```
  (0 rows affected — PostgREST returns an empty array, not an error, for
  a no-op RLS-filtered update.) Admin follow-up confirmed row 4 unchanged.
- **Test 6** — branch token DELETE targeting site B1a's row (id=4):
  ```
  HTTP_STATUS:204
  ```
  (0 rows affected.) Admin follow-up confirmed row 4 still present.
- **Test 7** — regional token (Region A1) SELECT:
  ```
  [{"id":1,"site_id":1,...}, {"id":2,"site_id":2,...}, {"id":5,"site_id":1,...}]
  HTTP_STATUS:200
  ```
  Exactly Region A1's two sites (1, 2) — not site 3 (Region A2, same org),
  not site 4 (Org B).
- **Test 8** — regional token write attempt at site A2a (id=3, same org,
  sibling region):
  ```
  {"code":"42501",...}
  HTTP_STATUS:403
  ```
- **Test 9** — executive token (Org A) SELECT:
  ```
  [{"id":1,...}, {"id":2,...}, {"id":3,...}, {"id":5,...}]
  HTTP_STATUS:200
  ```
  All three of Org A's sites (1, 2, 3) — not site 4 (Org B).
- **Test 10** — executive token write attempt at site B1a (id=4, different
  org):
  ```
  {"code":"42501",...}
  HTTP_STATUS:403
  ```
- **Test 11 — real production path**, not a hand-crafted token: created a
  genuine throwaway Supabase auth user + `staff_pins` row (site A1a, PIN
  4321), called the actual live `pin-login` function:
  ```
  {"access_token":"...","user":{"id":"...","role_tier":"base","site_id":1,
   "local_user_id":9999,"organisation_id":1,"region_id":1}}
  HTTP_STATUS:200
  ```
  Decoded the real token's `app_metadata`: `organisation_id: 1,
  region_id: 1` — correct, resolved live by `verify_staff_pin()`. Using
  that real token against the proof table reproduced Test 1 exactly
  (rows 1 and 5 only). Wrong PIN correctly rejected:
  `{"error":"incorrect pin"}` / `HTTP_STATUS:401`.
- **Test 12 — negative control**, anon key only, no token:
  ```
  []
  HTTP_STATUS:200
  ```
  No regression from today's pre-B1 baseline (already-documented 403/401
  behavior on bare REST access).
- **Trap tests — missing-claim fail-closed** (the null-claim trap):
  a regional token with `region_id` claim omitted, and an executive token
  with `organisation_id` claim omitted, both returned:
  ```
  []
  HTTP_STATUS:200
  ```
  for both. Confirms `can_access_site()` treats a missing claim as no
  access, never an accidental match.
- **Test 13 — concurrency**: Org A's and Org B's branch tokens fired at
  the same instant via backgrounded curl calls —
  ```
  branch_a1a: [{"id":1,...},{"id":5,...}]
  branch_b1a: [{"id":4,"site_id":4,"note":"row for site B1a"}]
  ```
  Each saw only its own tenant's row, no cross-contamination through the
  Supavisor connection pooler.

**Cleanup, verified not assumed**: throwaway auth user deleted via the
admin API (its `staff_pins` row disappeared automatically via the
existing `ON DELETE CASCADE` — confirmed as a bonus, the cascade actually
works); `isolation_proof_rows` dropped; all throwaway sites/regions/
organisations deleted. Re-queried immediately after: 0 organisations, 0
regions, 0 sites, `\dt public.*` shows only the real (now empty)
`organisations`/`regions`/`sites` plus `staff_pins` — no residue.

**Known gap carried forward**: the human security review of this RLS
design (the gate logged in DECISIONS_LOG.md's "Phase B approved" entry)
is still outstanding — required before any real second company's data
goes live, separate from and in addition to this technical proof.

## Phase B2 — Foundation cluster (built and PROVEN 2026-09-08)

Organisations, Regions, Sites, VenueTypes, Departments, Areas, EquipmentTypes
moved onto the backend with RLS. Real schema checked before building (not
assumed): `venue_types`/`equipment_types` had `create()` methods but no
org/site linkage at all — fixed with a nullable `organisation_id` before
any policy was written.

**Schema added:**
```sql
alter table public.sites add column address text;

create table public.venue_types (
  id serial primary key, name text not null,
  organisation_id integer references public.organisations(id)
); -- null organisation_id = shared baseline; non-null = a tenant's own addition

create table public.equipment_types (
  id serial primary key, name text not null,
  organisation_id integer references public.organisations(id)
);

create table public.site_venue_types (
  id serial primary key,
  site_id integer not null references public.sites(id),
  venue_type_id integer not null references public.venue_types(id)
);

create table public.departments (
  id serial primary key, name text not null,
  site_id integer references public.sites(id),
  active boolean not null default true, created_at timestamptz not null default now()
);

create table public.areas (
  id serial primary key, name text not null,
  site_id integer references public.sites(id)
);
```

**`can_access_region(target_region_id)`** — parallel to B1's
`can_access_site()`: branch tier matches the region of its *own* site
(live lookup through `sites`, since a branch token doesn't carry
`region_id` directly); regional matches its own `region_id`; executive
matches any region in its org.

**RLS — enabled + policied on all 7 tables BEFORE any grant was added**
(closing B1's own "grant before policy" trap for real):
- `organisations`: `using (id = claim.organisation_id)`.
- `regions`: `using (can_access_region(id))`.
- `sites`: `using (can_access_site(id))` — reused directly, B1's function.
- `venue_types` / `equipment_types`: `using (organisation_id is null or
  organisation_id = claim.organisation_id) with check (organisation_id =
  claim.organisation_id)` — shared baseline plus own tenant's additions;
  a session can never write a null-org ("global") row.
- `site_venue_types` / `departments` / `areas`: `using
  (can_access_site(site_id))` — same function/shape as `sites`.

**The proof — verbatim, direct curl, never the app UI.** Throwaway
tenants (fresh ids, B1's were already cleaned up): Org A (id 3) — Region
A1 (id 4: sites A1a=5, A1b=6), Region A2 (id 5: site A2a=7); Org B (id 4)
— Region B1 (id 6: site B1a=8).

- **Sites (full matrix, 7 tests)**:
  - branch (site 5) SELECT: `[{"id":5,"name":"B2-PROOF-SITE-A1a"}]`
  - branch INSERT claiming `organisation_id:4` (tenant B): `403`,
    `"new row violates row-level security policy for table \"sites\""`
  - branch UPDATE site 8 (tenant B): `[]` / `200` (0 rows affected)
  - regional (region 4) SELECT: sites 5, 6 only — not 7 (sibling region,
    same org), not 8
  - regional (region 5) SELECT: site 7 only
  - executive (org 3) SELECT: sites 5, 6, 7 — not 8 (Org B)
  - executive write attempt at site 8: `[]` / `200` (0 rows affected)
- **Organisations (3 tests)**: branch SELECT → only org 3; branch SELECT
  org 4 by id → `[]`; executive UPDATE org 4 → `[]` (0 rows affected).
- **Regions (4 tests)**: branch SELECT → only region 4 (own site's
  region); regional (region 4) SELECT → only region 4, not region 5;
  executive SELECT → regions 4 and 5 (both in org 3), not region 6;
  regional write attempt at region 5 (sibling region, same org) → `[]`
  (0 rows affected).
- **VenueTypes / EquipmentTypes (the null-org logic)**: seeded one
  shared-baseline row (`organisation_id: null`) and one Org-A-private row
  per table. branch_a1a SELECT → both rows (shared + its own private);
  branch_b1a SELECT → shared row only, **not** Org A's private row;
  branch_a1a attempting to INSERT a null-org ("global") row → `403`,
  `"new row violates row-level security policy for table \"venue_types\""`.
- **Departments / Areas / SiteVenueTypes (lighter confirmation, reusing
  B1's proven `can_access_site()` shape)**: branch_a1a own-site read
  returns its own row; read filtered to tenant B's site → `[]`; write
  attempt at tenant B's site → `403` RLS rejection, on all three tables.

**Cleanup verified**: all throwaway rows across all 8 tables (7 Foundation
tables + the proof's seeded rows) deleted; re-queried immediately after —
0 rows in every one. Only the real, empty schema remains.

**App-layer wiring** (new this cluster, not just SQL):
- `backendDataEnabledProvider` (`lib/shared/providers/auth_providers.dart`)
  — off by default, mirrors `backendAuthEnabledProvider`'s shape exactly.
  Only produces results once `backendAuthEnabledProvider` is also on for
  that session (RLS needs real claims).
- `currentBackendAccessTokenProvider` — unifies PIN sessions' own token
  (`currentSessionTokenProvider`, never touches `supabase_flutter`'s auth
  state) and Leadership's real GoTrue session token, so every
  `Supabase*Repository` sends the right one regardless of login path.
- `BackendRestClient` (`lib/core/network/backend_rest_client.dart`) — a
  small raw-REST helper (the `http` package) against `/rest/v1/<table>`,
  since `supabase_flutter`'s own `SupabaseClient.from(table)` reads only
  its ambient auth session, which PIN sessions never populate.
- Seven `Supabase*Repository` classes (`lib/shared/repositories/supabase_*.dart`),
  each implementing the *same existing interface* as its Drift
  counterpart — no call-site changes needed anywhere, since RLS scopes
  results silently server-side. Provider files
  (`site_providers.dart`, `department_providers.dart`,
  `venue_type_providers.dart`, `venue_setup_providers.dart`) branch on
  `backendDataEnabledProvider` to pick Drift vs. Supabase.
- `EquipmentRepository` mixes in-scope (types) and out-of-scope
  (instances, tagging) methods in one interface — `SupabaseEquipmentRepository`
  implements only the types methods and delegates the rest to a wrapped
  `DriftEquipmentRepository`, so nothing else regresses.
- **Real Dart-layer integration test**
  (`integration_test/phase_b2_backend_repositories_test.dart`), run
  against the live backend with a hand-crafted throwaway-tenant token (the
  app itself can never mint one — no `JWT_SECRET` access): confirmed
  `organisationRepositoryProvider`/`siteRepositoryProvider`/
  `departmentRepositoryProvider` all correctly tenant-scoped, and that a
  cross-tenant `SiteRepository.create()` call throws a real
  `BackendRequestException` with `isRlsRejection == true`. All 4 passed.
  Fixture tenant deleted and verified gone afterward.
- Flag-off path re-confirmed separately: a normal (non-integration-test)
  Windows debug build launched and ran normally with
  `backendDataEnabledProvider` at its default `false` — the working local
  app is unaffected by any of this.

**Known gap carried forward, unchanged**: the human security review gate
(logged in DECISIONS_LOG.md's "Phase B approved" entry) is still
outstanding — required before any real second company's data goes live.

## Phase B3 — People cluster (built and PROVEN 2026-09-09)

Users and TrainingRecords moved onto the backend with RLS. The trickiest
interaction so far (Users is the table auth itself depends on) — resolved
by construction, confirmed by the proof.

**Why auth can't break**: `verify_staff_pin()` reads only `staff_pins` and
`sites` (its `SECURITY DEFINER` privilege, owned by the superuser
`postgres`, already bypasses RLS entirely for those — the exact mechanism
that let it join `sites` transparently since B1). It never queries
`public.users` at all, before or after this cluster. RLS on `users`
governs the app's normal profile-data calls only — a completely separate
code path from login.

**Schema added** (PIN credentials deliberately excluded — those stay only
in `staff_pins`, per Phase 2's separation):
```sql
create table public.users (
  id serial primary key, name text not null, job_title text not null,
  role_tier text not null, job_role text,
  preferred_temperature_unit text not null default 'celsius',
  site_id integer references public.sites(id),
  active boolean not null default true,
  deactivated_at timestamptz, deactivated_by_user_id integer references public.users(id),
  department_id integer references public.departments(id),
  region_id integer references public.regions(id),
  supabase_user_id uuid
);

create table public.training_records (
  id serial primary key, user_id integer not null references public.users(id),
  site_id integer references public.sites(id),
  item_type text not null, custom_item_title text,
  completed_at timestamptz not null, expires_at timestamptz,
  signed_off_by_user_id integer not null references public.users(id),
  certificate_reference text, created_at timestamptz not null default now()
);
```

**Real finding #1**: adding a plain FK from `staff_pins.local_user_id` to
`public.users(id)` failed immediately —
```
ERROR: insert or update on table "staff_pins" violates foreign key
constraint "staff_pins_local_user_id_fkey"
DETAIL: Key (local_user_id)=(1) is not present in table "users".
```
The pre-existing Phase 2 test row (Steve Hughes) predates `public.users`
entirely. Added as `NOT VALID` instead:
```sql
alter table public.staff_pins add constraint staff_pins_local_user_id_fkey
  foreign key (local_user_id) references public.users(id) not valid;
```
Enforced for every future write, doesn't require backfilling that real
row now (which would mean migrating real data prematurely). **Design
note for whenever real data sync happens**: `public.users` rows must be
inserted with an explicit `id` matching the local Drift id, not the
`SERIAL` default, or `staff_pins.local_user_id` stops meaning anything.

**RLS** — reuses `can_access_site(site_id)` directly on both tables, no
new function, enabled + policied before any grant (same discipline as B2):
```sql
create policy tenant_isolation on public.users for all
  using (can_access_site(site_id)) with check (can_access_site(site_id));
create policy tenant_isolation on public.training_records for all
  using (can_access_site(site_id)) with check (can_access_site(site_id));
```

**The proof — verbatim, direct curl.** Throwaway Org A (id 7, Region A1
id 7: sites A1a=13/A1b=14, Region A2 id 8: site A2a=15) / Org B (id 8,
Region B1 id 9: site B1a=16). Seeded one active user + one **deactivated**
user at site 13, one user at site 16.

- `users` own-site read (branch, site 13) — **both** the active and
  deactivated colleague come back: `[{"id":1,...,"active":true},
  {"id":2,...,"active":false}]` / `200`. Isolation is the tenant boundary,
  not the active/inactive one.
- branch read filtered to site 16 (tenant B) → `[]` / `200`.
- branch write attempt at tenant B's user → `[]` / `200` (0 rows affected).
- regional (region 7) SELECT → both site-13 users, not site 15/16.
- executive (org 7) SELECT → all of Org A's users, not Org B's.
- branch UPDATE on its **own deactivated** colleague (id 2) →
  **succeeds**, full row returned — confirms isolation never blocked an
  in-tenant action based on `active` status.
- `training_records`: own read returns its row; read filtered to
  tenant B's site → `[]`; write attempt at tenant B's site → `403`,
  `"new row violates row-level security policy for table
  \"training_records\""`.

**Real finding #2, during cleanup**: the throwaway proof user landed on
`id=1` (fresh table, `SERIAL` starts at 1) — colliding with
`staff_pins.local_user_id=1`'s FK. Deleting it failed:
```
ERROR: update or delete on table "users" violates foreign key
constraint "staff_pins_local_user_id_fkey" on table "staff_pins"
```
Couldn't be deleted (the FK requires some row at `id=1`); neutralized
instead:
```sql
update public.users set name = 'RESERVED (staff_pins FK placeholder, not real data)',
  job_title = 'n/a', site_id = null, active = false where id = 1;
```
This row now exists permanently until real onboarding populates `id=1`
properly — documented here so it's never mistaken for real data. Users 2
and 3 (no FK references) deleted normally; all other throwaway rows
(sites, regions, organisations, training_records) deleted and verified
empty.

**App-layer wiring**:
- `SupabaseUserRepository` implements only the profile-data methods
  (`getAll`, `findBySupabaseUserId`, `setActive`, `changeRoleTier`,
  `changeDepartment`, `assignRegion`, `setPreferredTemperatureUnit`)
  against the backend; `authenticate()`/`resetPin()`/`createStaffMember()`
  all delegate unchanged to a wrapped `DriftUserRepository` — same split
  pattern as B2's `SupabaseEquipmentRepository` (types vs. instances).
- `SupabaseTrainingRecordRepository` implements the full interface
  directly — no split needed, no auth entanglement.
- **Dart-layer integration test**
  (`integration_test/phase_b3_backend_repositories_test.dart`), live
  backend, hand-crafted throwaway token: `SupabaseUserRepository.getAll()`
  correctly tenant-scoped; `setActive()` on another tenant's user
  completes with **no exception** and leaves that user untouched — this
  corrected an initially-wrong test expectation (an UPDATE matching zero
  RLS-visible rows returns `200`/empty, not a `403`; only an INSERT
  violating `WITH CHECK` throws — exactly the B1/B2-proven distinction,
  re-confirmed here at the Dart layer, not assumed); and — the specific
  thing asked to be shown — `authenticate()` called through
  `userRepositoryProvider` with `backendDataEnabledProvider` **on** still
  returns `PinAuthNotFound` for a nonexistent user, proving it reached the
  real, unchanged Drift path rather than the network. All 3 passed live,
  no mocks, no dependency on any real seed account.

**Known gap logged, not closed**: `verify_staff_pin()` does not check
`users.active` — a deactivated account could theoretically still obtain a
backend token via the PIN path today. Deliberately not bundled into this
cluster (an auth-behaviour change deserves its own explicit decision).
Follow-up, not yet scheduled.

**Known gap carried forward, unchanged**: the human security review gate
is still outstanding — required before any real second company's data
goes live.

## Phase B4 — Operational config cluster (built and PROVEN 2026-09-09)

TaskTemplates, TaskSchedules, NotificationRules, BrandingConfigs moved onto
the backend with RLS — the biggest cluster so far, and the one with the
most genuinely new scoping shapes (not clean reuses of a prior pattern).

**Real finding during build**: `primary_color_argb` as Postgres `integer`
(32-bit signed) overflowed on the first real ARGB value (alpha=0xFF,
e.g. `4278190080`) — `ERROR: integer out of range`. Fixed immediately:
```sql
alter table public.branding_configs alter column primary_color_argb type bigint;
```

**Schema** (four tables; PIN credentials n/a here):
```sql
create table public.task_templates (
  id serial primary key, template_group_id integer not null,
  version_number integer not null,
  previous_version_id integer references public.task_templates(id),
  title text not null, segment text not null,
  applicable_role_tiers text not null, method text not null,
  requires_photo boolean not null default false,
  requires_notes boolean not null default false,
  custom_fields_json text, min_limit real, max_limit real, unit text,
  legal_limit_category text, is_critical boolean not null default false,
  requires_corrective_action_on_fail boolean not null default false,
  fix_instructions text,
  equipment_type_id integer references public.equipment_types(id),
  created_at timestamptz not null default now(),
  created_by_user_id integer references public.users(id),
  priority text, job_role text, guidance_text text,
  requires_supplier_selection boolean not null default false,
  -- null = shared baseline library (~150 tasks), non-null = a tenant's
  -- own private template or fork.
  organisation_id integer references public.organisations(id)
);

create table public.task_schedules (
  id serial primary key,
  task_template_group_id integer not null,  -- soft ref, matches local design
  assigned_user_id integer not null references public.users(id),
  equipment_instance_id integer,  -- soft ref, NO FK -- equipment_instances
                                   -- isn't backend-hosted yet (later cluster)
  frequency text not null, custom_frequency_detail text,
  assigned_by_user_id integer not null references public.users(id),
  assigned_at timestamptz not null, active boolean not null default true,
  site_id integer references public.sites(id),
  window_start_minutes integer, window_end_minutes_exclusive integer
);

create table public.notification_rules (
  id serial primary key, rule_group_id integer not null,
  version_number integer not null,
  previous_version_id integer references public.notification_rules(id),
  task_template_group_id integer,  -- soft ref, matches local design
  target_role_tier text, target_user_id integer references public.users(id),
  channel_push boolean not null default false,
  channel_email boolean not null default false,
  set_by_user_id integer not null references public.users(id),
  set_by_tier text not null, active boolean not null default true,
  created_at timestamptz not null default now(),
  site_id integer references public.sites(id),
  -- NEW, backend-only, not in the local model. null site_id = "org-wide"
  -- (meaningful locally, cross-tenant-ambiguous without this on a shared
  -- backend). Always set, resolved from the creating session's own org.
  organisation_id integer not null references public.organisations(id)
);

create table public.branding_configs (
  id serial primary key, config_group_id integer not null,
  version_number integer not null,
  previous_version_id integer references public.branding_configs(id),
  organisation_id integer not null references public.organisations(id),
  company_name text,
  primary_color_argb bigint not null,  -- see the finding above
  contact_phone text, contact_email text,
  set_by_user_id integer not null references public.users(id),
  created_at timestamptz not null default now(),
  logo_path text  -- known limitation: local file path, non-functional
                   -- across devices/server, unchanged from the original
                   -- branding decision
);
```

**`can_access_organisation(target_org_id)`** — simpler than
`can_access_region()`: every tier's own `organisation_id` claim IS the
scope, no tier branching:
```sql
select target_org_id is not null
  and (claims ->> 'organisation_id') is not null
  and target_org_id = (claims ->> 'organisation_id')::integer;
```

**RLS**, enabled + policied before any grant (same discipline as B2/B3):
- `task_templates`: `using (organisation_id is null or
  can_access_organisation(organisation_id)) with check
  (can_access_organisation(organisation_id))`.
- `task_schedules`: `using (can_access_site(site_id))` — direct reuse.
- `notification_rules`: `using ((site_id is not null and
  can_access_site(site_id)) or (site_id is null and
  can_access_organisation(organisation_id)))`.
- `branding_configs`: `using (can_access_organisation(organisation_id))`.

**THE FORK-ON-WRITE RULE** (`SupabaseTaskTemplateRepository.saveNewVersion`,
app-layer, not RLS): editing an existing `templateGroupId` chain checks
whether the chain's current head belongs to the caller's own org. If it
doesn't (shared baseline, or — unreachable under RLS anyway, but checked
explicitly — a different tenant's), the write forks: starts a brand-new
`templateGroupId` under the caller's own `organisation_id`, exactly like
a fresh create, leaving the original chain completely untouched. Without
this, extending a shared chain would silently retag the ENTIRE chain
(every earlier shared version included) as one tenant's private property.

**The proof — verbatim, direct curl.** Throwaway Org A (id 11, site
A1=19) / Org B (id 12, site B1=20).

- `task_templates`: branch_a sees shared (id1) + its own private (id2);
  branch_b sees shared only; branch_a INSERT of a null-org row → `403`.
  **Fork-on-write**: branch_a inserts a new version on the shared
  `template_group_id=1`, tagged `organisation_id: 11` →
  `HTTP_STATUS:201`. Re-read: branch_b's view of group 1 is **still
  exactly one row, version 1, unchanged** — 
  `[{"id":1,"title":"B4-PROOF-SHARED-TASK","organisation_id":null,"version_number":1}]`.
  branch_a now sees the original (id1) + its private task (id2) + its
  new fork (id4, `organisation_id: 11`, `version_number: 2`).
- `notification_rules`: branch_a (site 19) sees its site-specific rule
  AND its org-wide rule (2 rows); branch_b sees only its own org-wide
  rule (1 row); branch_a's attempt to insert an org-wide rule claiming
  `organisation_id: 12` (Org B) → `403`.
- `branding_configs`: branch_a and executive_a both see only Org A's
  config (confirms org-scoped, not site-scoped — executive isn't
  "more" scoped, same org boundary either way); branch_a's write attempt
  at Org B's config → `[]` (0 rows affected).
- `task_schedules`: own read; cross-tenant read → `[]`; cross-tenant
  write attempt → `403`.

**App-layer wiring**:
- `SupabaseTaskTemplateRepository` implements the fork-on-write rule
  above; `getVenueTypeIds`/`setVenueTypeIds` throw `UnimplementedError`
  (matches the local app's own "schema-ready, not yet wired into any UI"
  state — not a new gap this cluster introduces).
- `SupabaseTaskScheduleRepository`, `SupabaseNotificationRuleRepository`,
  `SupabaseBrandingConfigRepository` implement their full interfaces
  directly against the backend.
- `SupabaseBrandingConfigRepository.watchCurrent()` has no server push
  available without Supabase Realtime (out of this cluster's scope) —
  implemented as a real 30-second poll instead (values emitted only on
  change, not every tick), a working trade-off for "mostly online"
  branding rather than a broken stand-in.
- **Dart-layer integration test**
  (`integration_test/phase_b4_backend_repositories_test.dart`), live
  backend, hand-crafted throwaway tokens (Org G / Org H): proved the
  fork-on-write rule at the actual application-code layer — calling
  `SupabaseTaskTemplateRepository.saveNewVersion()` on a shared task
  from Org G's session produces a new `templateGroupId` under Org G,
  Org H's view of the original chain is confirmed unchanged afterward,
  and Org H never sees Org G's fork; plus `task_schedules` tenant
  scoping. Both passed live, no mocks. (One test-fixture bug of my own —
  used a JWT claim value instead of a real `users.id` for a required FK
  — caught immediately by the resulting `403`/FK error and fixed before
  being mistaken for a code defect.)

**Named, not fixed**: Postgres FK constraints validate that the
referenced row's primary key exists — they don't go through RLS. A
session could set `previousVersionId` to an id from a tenant it can't
read; the FK accepts it (no content leak, since RLS still blocks reading
that row — only pollutes the writer's own chain metadata with a dangling
pointer). Confined impact, isolation itself unaffected — documented and
accepted rather than engineered around.

**Known gap carried forward, unchanged**: the human security review gate
is still outstanding.

## Phase B5 — Live/transactional cluster (built and PROVEN 2026-09-10) — MULTI-TENANT FOUNDATION COMPLETE

TaskSubmissions, TriggerNotifications, SessionSummaries, ShiftHandoverNotes,
ProblemStatusEvents, and EquipmentInstances (the B2 deferral) all moved
onto the backend with RLS. Every one reuses `can_access_site(site_id)` —
no new function needed this cluster.

**Schema** (six tables + two FK upgrades):
```sql
create table public.equipment_instances (
  id serial primary key, name text not null,
  equipment_type_id integer not null references public.equipment_types(id),
  area_id integer references public.areas(id),
  site_id integer references public.sites(id),
  active boolean not null default true
);

create table public.task_submissions (
  id serial primary key, task_title text not null, status text not null,
  completed_by text not null, completed_at timestamptz not null,
  numeric_value text, photo_attached boolean not null default false,
  photo_path text, notes text,
  task_schedule_id integer,        -- soft ref, no FK even locally
  task_template_group_id integer,  -- soft ref, no FK even locally
  equipment_instance_id integer references public.equipment_instances(id),
  custom_field_values_json text,
  completed_by_user_id integer references public.users(id),
  site_id integer references public.sites(id),
  corrective_action_outcome text, corrective_action_note text,
  supplier_id integer,  -- soft ref, NO FK -- Suppliers not backend-hosted yet
  problem_status text, equipment_instance_name text
);

create table public.trigger_notifications (
  id serial primary key,
  notification_rule_id integer references public.notification_rules(id),
  task_submission_id integer not null references public.task_submissions(id),
  recipient_user_id integer not null references public.users(id),
  message text not null,
  site_id integer not null references public.sites(id),
  created_at timestamptz not null default now(),
  acknowledged boolean not null default false, acknowledged_at timestamptz,
  origin_target_role_tier text, escalated_at timestamptz,
  equipment_instance_name text
);

create table public.session_summaries (
  id serial primary key,
  staff_user_id integer not null references public.users(id),
  staff_name text not null,
  sent_to_manager_id integer not null references public.users(id),
  pass_count integer not null, fail_count integer not null,
  failed_task_titles_json text not null, note text,
  sent_at timestamptz not null,
  acknowledged boolean not null default false, acknowledged_at timestamptz,
  site_id integer references public.sites(id)
);

create table public.shift_handover_notes (
  id serial primary key,
  author_user_id integer not null references public.users(id),
  note text not null, created_at timestamptz not null,
  site_id integer references public.sites(id)
);

create table public.problem_status_events (
  id serial primary key,
  task_submission_id integer not null references public.task_submissions(id),
  status text not null,
  changed_by_user_id integer not null references public.users(id),
  changed_at timestamptz not null, note text,
  -- B5: NEW, backend-only. Locally the app joins through
  -- task_submission_id for site scoping; every other child table
  -- denormalises site_id directly, so this matches that convention.
  -- Populated from the parent submission at write time.
  site_id integer references public.sites(id)
);

-- FK upgrades: both tables were empty on the backend, so plain validated
-- constraints (no NOT VALID needed).
alter table public.task_schedules add constraint
  task_schedules_equipment_instance_id_fkey
  foreign key (equipment_instance_id) references public.equipment_instances(id);
-- (task_submissions.equipment_instance_id got its FK inline above.)
```

**RLS**, enabled + policied before any grant on all six:
`for all using (can_access_site(site_id)) with check (can_access_site(site_id))`.

**The proof — verbatim, direct curl.** Throwaway Org A (id 15, site
A1=23) / Org B (id 16, site B1=24), seeded a submission per tenant with
denormalised fields (`completed_by`, `equipment_instance_name`,
`problem_status`), plus a child row per tenant in each of the other five
tables.

- `task_submissions`:
  - branch_a SELECT → its own row only, denormalised fields intact:
    `[{"id":1,"site_id":23,"completed_by":"B5-PROOF-USER-A (denormalised)","equipment_instance_name":"B5-PROOF-FRIDGE-A (denormalised)","problem_status":"open"}]`
  - branch_a read tenant B's submission by id → `[]` (no denormalised
    field leak)
  - branch_a INSERT claiming tenant B's site → `403`
  - branch_a UPDATE tenant B's submission's `problem_status` → `[]`
    (0 rows); admin follow-up: tenant B's row still `problem_status = open`
  - branch_a append a NEW submission at its own site → `HTTP_STATUS:201`
    (append-only audit write works)
  - branch_b SELECT → only tenant B's row, never tenant A's
- `problem_status_events`:
  - branch_a SELECT → its own event only (new denormalised site_id working)
  - branch_a read tenant B's event → `[]`
  - branch_a INSERT a status-change event carrying `site_id: 24` (tenant
    B) → `403`
  - branch_a INSERT a legitimate status-change at its own site →
    `HTTP_STATUS:201`
- `equipment_instances`: own read; cross-tenant read → `[]`;
  cross-tenant write → `403`.
- **FK upgrade check**: a `task_schedules` insert referencing
  `equipment_instance_id: 99999` (nonexistent) →
  `{"code":"23503","details":"Key is not present in table
  \"equipment_instances\".","message":"...violates foreign key constraint
  \"task_schedules_equipment_instance_id_fkey\""}` / `HTTP_STATUS:409` —
  confirms the FK is live and validated, not `NOT VALID`.
- `trigger_notifications`, `session_summaries`, `shift_handover_notes`:
  each — own read returns its row; cross-tenant read → `[]`;
  cross-tenant write → `403`.

**Cleanup verified**: all six B5 tables + adjacent (organisations, sites,
users, equipment_types) re-queried immediately after — 0 rows everywhere
except the one permanent `users.id=1` placeholder documented in the B3
section.

**App-layer wiring**:
- Six new `Supabase*Repository` classes; `SupabaseEquipmentRepository`
  (from B2) upgraded so instance methods (`getAll`/`create`/`rename`/
  `setActive`) now go to the backend too, keeping only the venue-type
  tagging join delegated to Drift. The same-site duplicate-name check is
  replicated against the RLS-scoped instance list.
- `backend_polling_stream.dart` — the interim stand-in for a push feed.
  Backend-path `watch*` methods (`TaskSubmissionRepository.watchAll`/
  `watchDefaultView`/`watchFiltered`, `TriggerNotificationRepository.
  watchForUser`, `SessionSummaryRepository.watchForManager`,
  `ProblemRegisterRepository.watchForSite`) fetch on listen then poll
  every 20s, emitting only on change. This is the accepted PULL guarantee
  — correct data at most one interval late — not a true push.
- `TaskSubmissionRepository`'s DISTINCT-lookup methods fetch the
  RLS-scoped rows and dedupe in Dart (PostgREST has no bare SELECT
  DISTINCT).
- **Dart-layer integration test**
  (`integration_test/phase_b5_backend_repositories_test.dart`), live
  backend, hand-crafted throwaway token: `SupabaseTaskSubmissionRepository`
  appends a record, reads it back, and never sees the other tenant's —
  including its denormalised `completed_by`/`equipment_instance_name`;
  the upgraded `SupabaseEquipmentRepository` creates an instance at its
  own site and is rejected creating one at another tenant's. Both passed
  live, no mocks.

**Minor known limitations, none security-relevant, all documented:**
- Backend-path `watch*` streams poll, don't push — the Realtime follow-on.
- `SupabaseProblemRegisterRepository._recordStatusChange` is two REST
  calls, not a transaction (PostgREST has no multi-statement transaction
  without an RPC). The `problem_status_events` row is the source of
  truth; `task_submissions.problem_status` is a read-optimisation mirror
  — if the mirror write failed, `getHistory` would still be correct.
- `SupabaseEquipmentRepository.setActive(false)` doesn't yet
  cascade-deactivate dependent TaskSchedules on the backend path (the
  local path does) — belongs with the "retire equipment" flow retrofit.
- BrandingConfig `logo_path` still a non-portable local file path,
  unchanged from the original branding decision.

## Multi-tenant isolation foundation (B0–B5) — status

| Cluster | Tables | Function(s) added | Proven |
|---|---|---|---|
| B0 | Region (local schema) | — | migration verified against real DB |
| B1 | organisations, regions, sites (skeleton) | `can_access_site`, live claims join, GoTrue hook | 14-test curl matrix + real pin-login token |
| B2 | + venue_types, equipment_types, site_venue_types, departments, areas | — (nullable-org pattern) | full/moderate/light curl matrix + Dart test |
| B3 | + users, training_records | — (reuse) | curl matrix (incl. deactivated-user) + Dart test (auth untouched) |
| B4 | + task_templates, task_schedules, notification_rules, branding_configs | `can_access_organisation` | curl matrix + fork-on-write proven twice |
| B5 | + equipment_instances, task_submissions, trigger_notifications, session_summaries, shift_handover_notes, problem_status_events | — (reuse) | curl matrix + Dart test |

Every table with a tenant boundary now has RLS enabled + forced + a
`tenant_isolation` policy, added before any grant. Three reusable
functions cover every shape: `can_access_site(site_id)`,
`can_access_region(region_id)`, `can_access_organisation(org_id)`.

**The one gate still open before real multi-tenant data**: a human
security review of this RLS design by someone backend-experienced — in
addition to the technical cross-tenant proof above, and alongside the
existing "dedicated server before real data" rule.

## Phase C1 — tenant signup + cascading onboarding (in progress, 2026-09-10)

Built on the completed B0–B5 foundation. Backend surface for C1 is three
new service-role Edge Functions (each the same shape as `pin-login`),
added across sub-parts:
- `tenant-signup` — C1b — creates an Organisation + its first executive
  (GoTrue account + `public.users` row + optional `branding_configs`) in
  one transaction. Open endpoint for now; an invite-code/approval gate is
  a logged pre-real-public-launch gate.
- `invite-senior` — C1c — creates a regional/executive GoTrue account
  with `raw_app_meta_data` claims set at invite time, returns a copyable
  one-time setup link (real email delivery is the later SMTP-dependent
  upgrade).
- `provision-staff-pin` — C1d — writes a `staff_pins` row for a
  base/supervisor user a branch manager just created (there's no
  client-reachable path to `staff_pins` today — it's service-role only).

**C1a (demo-seed gating)** — no backend change. Local-only: the
`SEED_DEMO_DATA` compile-time flag gates the fake company/venue/staff so a
real build (`--dart-define=SEED_DEMO_DATA=false`) opens empty. Recorded
here so the sub-part is accounted for; detail in DECISIONS_LOG.md.

### C1b (tenant signup) — built and PROVEN 2026-09-10

**`tenant-signup` Edge Function** deployed
(`~/tango-sierra/supabase/docker/volumes/functions/tenant-signup/index.ts`,
service-role, `apikey` = anon check like `pin-login`). Body:
`{company_name, director_name, email, password, primary_color_argb?}`.
Creates, with best-effort rollback: `organisations` row → GoTrue account
(`app_metadata: {role_tier: 'executive', organisation_id}` → stored as
`raw_app_meta_data`, so claims resolve on first sign-in; a Director has no
site so the B1 hook leaves this explicit value alone) → `public.users`
row (executive, `organisation_id` set, `supabase_user_id` linked) →
optional `branding_configs` row. Returns `{organisation_id, local_user_id,
email}`. Open endpoint (abuse gate is a logged pre-real-public-launch
item).

**Schema change — `public.users` gained `organisation_id`** (integer, FK
to organisations). B3's `users` had no org column, so a site-less
executive couldn't be RLS-scoped at all. The `tenant_isolation` policy is
now tier-aware:
```sql
using (
  (site_id is not null and can_access_site(site_id))
  or (site_id is null and can_access_organisation(organisation_id))
)
-- with check identical
```
B3's proven branch/regional behaviour is unchanged (their rows all carry a
`site_id`); only the site-less executive path is new. Going forward every
`public.users` insert (from any of the C1 Edge Functions) sets
`organisation_id`.

**Proof (direct curl, 6 tests):** fresh signup → org+Director+branding all
created and linked (`role_tier=executive`, `organisation_id` set,
`supabase_user_id` linked); GoTrue password sign-in resolves claims
(`{organisation_id, role_tier: executive}`); the Director's session sees
ONLY its own org (`[{"id":20,"name":"C1B-PROOF-COMPANY"}]`); the new
tenant starts empty (`sites: []`, `users: [Director only]`,
`task_submissions: []`); duplicate email → `409` with rollback verified
(no orphan org). Plus a Dart integration test
(`phase_c1b_tenant_signup_test.dart`) exercising the real client path
(`SupabaseTenantProvisioningRepository` → sign-in → `findBySupabaseUserId`
→ isolation checks). All throwaway companies + GoTrue accounts deleted
afterward, verified.

### C1c (invite-senior + Region/Branch management) — built and PROVEN 2026-09-11

**`invite-senior` Edge Function** deployed
(`~/tango-sierra/supabase/docker/volumes/functions/invite-senior/index.ts`).
Unlike `tenant-signup`, this is **not** open: the caller's own bearer
token is verified via `admin.auth.getUser(callerToken)`, and the request
is rejected (`403`) unless `caller.app_metadata.role_tier === 'executive'`
and `organisation_id` matches the target. Body:
`{email, name, role_tier: 'regional'|'executive', organisation_id, region_id?}`.
Creates the invitee's GoTrue account (`app_metadata` claims baked in —
`region_id` too for regional) and the linked `public.users` row. SMTP
still isn't configured, so this returns `{email, temporary_password,
local_user_id}` for the inviting Director to pass on, not a real emailed
invite (logged upgrade).

**Real finding — a genuine RLS bug, not a config typo.** `sites`/`regions`'
B2 policies used `can_access_site(id)`/`can_access_region(id)` for both
`USING` and `WITH CHECK`. Those functions' executive branch (and, for
`sites`, the regional branch too) resolve the target row's org/region by
**querying the same table the policy protects** — self-referential RLS.
`INSERT ... RETURNING` re-checks the new row against `USING` (PostgREST
always requests `Prefer: return=representation`), and that self-lookup
fails to see the just-inserted row even though `WITH CHECK` alone passed.
Confirmed by direct isolation, in a transaction, role `authenticated`,
identical claims:
```
insert into regions (...) values (...) returning id;              -- ERROR: RLS violation
insert into regions (...) values (...);                            -- INSERT 0 1 (succeeds)
```
Every prior B1/B2 proof of `sites`/`regions` created its throwaway rows
via direct superuser SQL and only ever exercised an *authenticated*
INSERT for the cross-tenant **rejection** case — a legitimate authenticated
create was never actually proven working until C1c's real
Director-creates-a-region step hit it.

**Fix** — rewrote both tables' own policies to use their row's own
columns directly, no table self-lookup, for the branches that were
self-referential:
```sql
-- sites
using (
  case (claims->>'role_tier')
    when 'executive' then organisation_id = claim.organisation_id
    when 'regional'  then region_id = claim.region_id
    else id = claim.site_id
  end
)
-- with check identical, plus organisation_id match on the regional branch

-- regions
using (
  case (claims->>'role_tier')
    when 'executive' then organisation_id = claim.organisation_id
    when 'regional'  then id = claim.region_id
    else exists (select 1 from sites s where s.id = claim.site_id and s.region_id = regions.id)
  end
)
with check (organisation_id = claim.organisation_id)
```
The branch-tier case in `regions` still looks up `sites` — a *different*
table, not itself, so it's safe. Every other table that merely has a
`site_id`/`region_id` **column** (`task_submissions`, `departments`,
`users`, ...) is unaffected — those call `can_access_site()`/
`can_access_region()` to look up `sites`/`regions`, never their own table.

**Re-proof after the fix** — the full original B1/B2 `sites`/`regions`
matrix (14 tests: branch/regional/executive read scoping, cross-tenant
and sibling-region write rejection) re-run in full against fresh
throwaway data: **all 14 passed unchanged**. Plus the two newly-fixed
cases, both now succeeding with `RETURNING`:
```
executive creates a site with RETURNING  -> 201, row returned
regional creates a site in own region    -> 201, row returned
regional creates a site in sibling region -> still 403 (unaffected)
executive creates a region with RETURNING -> 201, row returned
```

**App-layer**: `SiteRepository.create()` gained an optional `regionId`
parameter (default `null`, every existing call site unchanged) — needed
because a regional's own `WITH CHECK` requires `region_id` to already
match their claim *at insert time*; a follow-up `setRegion()` call would
be a second write and risks the same self-reference class of issue.
`RegionManagementScreen` (executive) and `BranchManagementScreen`
(regional) — both read/write through the existing RLS-scoped
repositories, no new client-side scoping logic.

**Proof (direct curl, 9 tests, full chain):** Director creates a region
→ invites a regional manager → the regional's token carries
`organisation_id`+`region_id` → Director creates one in-region site and
one org-wide site → the regional sees only the in-region site and only
its own region, and its linked profile resolves; a non-executive cannot
invite (`403`); a Director cannot invite into another org (`403`). Plus
a Dart integration test (`phase_c1c_region_branch_test.dart`) exercising
the real client path end to end (`signUpCompany` → `RegionRepository
.create()` → `inviteSenior()` → `SiteRepository.create()` ×2 → sign in as
the regional → confirm exactly one visible site and one visible region
via the real repositories). All passed live, no mocks. All throwaway
companies, regions, sites, and accounts deleted and verified gone
afterward.

### C1d (provision-staff-pin + staff onboarding + checklist) — built and PROVEN 2026-09-11

**`provision-staff-pin` Edge Function** deployed
(`~/tango-sierra/supabase/docker/volumes/functions/provision-staff-pin/index.ts`).
Not open: the caller's own bearer token — PIN or GoTrue, both HS256
signed with the same `JWT_SECRET` — is verified directly via
`jose.jwtVerify(token, secretKey, {issuer})` rather than
`admin.auth.getUser()` (which only recognises real GoTrue sessions and
would reject a legitimate PIN-tier caller, e.g. a venueManager creating a
supervisor). Authorization: `TIER_RANK[targetTier] + 1 <=
TIER_RANK[callerTier]` (a target can only be created by someone at least
one full tier above), plus an explicit check that the target `site_id` is
actually in the caller's reach (executive: same org; regional: same
region; branch: their own site) — a clean error on top of the RLS
backstop. Creates a synthetic-email `auth.users` row (PIN accounts have
no real email — the address is never delivered to, only exists to
satisfy `staff_pins`' FK), the linked `public.users` row, and a
`staff_pins` row with a fresh random 4-digit PIN, hashed with the exact
same `sha256(salt:pin)` scheme `verify_staff_pin()` expects. Returns
`{local_user_id, name, role_tier, site_id, pin}` for the creating manager
to pass on.

**Three more real findings, in a chain** — the first two only surfaced
because C1d's Dart-layer test actually tried to log a purely
backend-provisioned person in, not because curl alone would have caught
them:

1. **`SupabaseUserRepository.authenticate()` delegated to Drift, unconditionally.** A real (backend-first) tenant's staff have no local row to delegate to — `PinAuthNotFound`, always, for every account this whole cluster exists to create. Fixed: `authenticate()` now calls the already-proven `pin-login` Edge Function directly (Phase 2's verification logic, byte-for-byte unchanged) instead of the local path.
2. **That fix's first draft tried to resolve `supabase_user_id` via a plain client-side REST read on `users`** — RLS-gated, and at login time there is no session yet to satisfy it. The same chicken-and-egg problem `pin-login` already solves for the PIN hash check itself. Fixed by extending `pin-login` to accept `local_user_id` (int) as an alternative to `user_id` (uuid), resolved server-side, service-role, before calling `verify_staff_pin()`:
   ```ts
   // pin-login/index.ts — additive, existing user_id callers untouched
   let user_id = body.user_id
   if (!user_id && body.local_user_id) {
     const { data: userRow } = await supabaseAdmin
       .from("users").select("supabase_user_id")
       .eq("id", body.local_user_id).eq("active", true).single()
     if (!userRow?.supabase_user_id) return Response.json({ error: "incorrect pin" }, { status: 401 })
     user_id = userRow.supabase_user_id
   }
   ```
3. **A real isolation gap**, found by the Dart test's own isolation assertion (branch manager saw 4 users, not 2): the C1b `users` policy's site-less branch (`site_id is null and can_access_organisation(organisation_id)`) checks only "same org" — `can_access_organisation()` doesn't look at the caller's own tier, so ANY tier with a matching `organisation_id` claim (even base) could read every executive/regional row in the company. Fixed:
   ```sql
   -- users tenant_isolation policy, site-less branch, corrected
   or (
     site_id is null
     and can_access_organisation(organisation_id)
     and (claims ->> 'site_id') is null   -- NEW: caller must also be site-less
   )
   ```
   Branch tiers always carry a `site_id` claim, so this excludes them cleanly. Re-verified: branch manager now sees exactly its own 2 site-scoped users; executive and regional (both site-less) still correctly see each other and their reachable site-scoped staff — nothing legitimate lost.

**Known, deliberately unsolved gap**: the walk-up "Who are you?" staff list (`staffDirectoryProvider`) is itself RLS-gated once `backendDataEnabledProvider` is on, and a shared kitchen tablet has no session before anyone taps a name. Every test in this cluster already had a session by the time it read a roster, so this didn't block C1d's own proof — but a real shared tablet's walk-up screen needs its own pre-auth scoping mechanism (a device/kiosk-scoped credential established at branch setup is the likely shape) before it can use the backend flags for real. Logged as a required follow-on, not solved here.

**App-layer**: `TenantProvisioningRepository.provisionStaffPin()`; new `StaffProvisioningScreen` (venueManager) and "Add branch manager" on `BranchManagementScreen` (regional); new `SetupChecklistCard` on `TierHomeScreen` — per-tier, derived live from the same RLS-scoped repositories, guide-don't-block.

**Proof (direct curl, 8 tests, full chain):** regional provisions a
venueManager for a branch → that branch manager's real `pin-login` call
returns correct claims → provisions a base staff member → that person's
real `pin-login` also works → (pre-fix) branch manager incorrectly saw
4 users company-wide, (post-fix) exactly its own 2 → a base session
cannot provision anyone (`403`) → a branch manager cannot create another
venueManager (`403`) → a branch manager cannot provision staff at a site
that isn't its own (`403`). Plus a Dart integration test
(`phase_c1d_staff_provisioning_test.dart`) running the entire chain
through real repository code end to end — signup → region → invite
regional → branch → provision branch manager → **real PIN login via
`userRepositoryProvider.authenticate()`** (the fixed path) → wrong PIN
still rejected → provision base staff → their real PIN login too →
isolation confirmed. All passed live, no mocks. All throwaway data
deleted and verified gone (except the permanent B3 placeholder row and
the unrelated pre-existing Phase 2 test row, both confirmed untouched).

## Phase B3 follow-on — server-side `users.active` enforcement in `verify_staff_pin()` (built and PROVEN 2026-09-13)

Closes the B3 follow-on ("a deactivated account could theoretically still
get a backend token today"). The gap was confined to the **uuid path**:
`pin-login` already filtered `.eq("active", true)` on its `local_user_id`
resolution, but a caller sending a real `user_id` (the path local Drift
installs use) reached `verify_staff_pin()` directly, and the function
never checked `users.active` — so a deactivated Drift-backed account
could still mint a session with a correct PIN.

**Fix** (function-body only, no schema/Edge/app change): `verify_staff_pin()`
now reads `users.active` via `staff_pins.local_user_id` immediately after
loading the `staff_pins` row, and returns the same "not found" row shape
(all nulls, `success=false`) for a missing or inactive linked user. Runs
**before** the failure-counter/lockout logic, so deactivated accounts
consume no guess-surface. The `RESERVED` placeholder (whose FK is
`NOT VALID`, no linked active row) is correctly rejected by the same
branch. Live function source in Postgres (`pg_get_functiondef`) has the
`-- Server-side active enforcement (Phase B3 follow-on)` block in place.

**Proof** (live, real GoTrue + real `staff_pins` row, throwaway account
created via the actual admin API and deleted afterward — verified empty):
active account → `200` + real signed session token via **both** the uuid
and `local_user_id` paths; deactivated (`users.active=false`) → `401
incorrect pin` via both paths even with the correct PIN; wrong PIN on the
deactivated account → plain `401`, no lockout state. The pre-existing
inactive `RESERVED` placeholder also confirms `401` on both paths.
Cleanup verified: 1 users row (the placeholder), 1 `staff_pins` row, 2
legit `auth.users` rows — exactly the pre-proof state.

## `reset-senior-password` Edge Function (built and PROVEN 2026-09-14)

Found while checking on a user-reported gap: there was no way at all for a
Director/Regional (GoTrue email+password, "Leadership Access") account to
recover a forgotten password. The natural first choice — an emailed
6-digit reset code — was checked against the actual VPS config first:
`SMTP_HOST=supabase-mail` in `.env` points at the default docker-compose
template's fake dev mail catcher, and **that container isn't even running**
(`docker ps -a` on the VPS shows no mail service at all). So GoTrue cannot
send a single real email today — not a reset code, not anything. This is
the same SMTP gap already logged on `invite-senior`'s temp-password
approach, now confirmed to block a real self-service reset flow too.
Decision (user's explicit call, given real SMTP setup is a separate
infra task needing a provider choice + API key): ship an admin-mediated
reset now, mirroring `invite-senior`'s exact pattern, and revisit
self-service email-code reset once real SMTP exists.

**`reset-senior-password` Edge Function** deployed
(`~/tango-sierra/supabase/docker/volumes/functions/reset-senior-password/index.ts`).
Caller must present their own bearer token and be `role_tier=executive`
(same gate as `invite-senior`). Body: `{ target_local_user_id }`. Looks up
the target's `public.users` row service-role, rejects if
`organisation_id` doesn't match the caller's own org (cross-tenant
isolation, same as every other C1 endpoint), rejects if the target isn't
`regional`/`executive` or has no `supabase_user_id` (a PIN-tier account
has no GoTrue identity to reset). Generates a new temp password via
`admin.auth.admin.updateUserById`, returns it plus the target's email for
the calling Director to pass along out-of-band — same UX as
`invite-senior`.

**Known limitation, logged not glossed over**: this only works when
ANOTHER executive of the same org can perform the reset. If the only
Director in a tenant forgets their own password, nobody else in the app
can reset it — would need direct DB/server access. Acceptable for now
per the user's explicit choice; the real fix is the deferred self-service
email-code flow once SMTP is real.

**Proof** (live, throwaway tenant via `tenant-signup` + `invite-senior`,
deleted afterward, verified empty): invited account's original temp
password signs in successfully; Director calls `reset-senior-password`
targeting that account; the OLD password now gets `401 invalid
login credentials`; the NEW password signs in successfully; a Director
from a SECOND, unrelated tenant calling the same endpoint against the
same target gets `403 you can only reset accounts in your own
organisation` (cross-tenant isolation holds). Client wiring:
`TenantProvisioningRepository.resetSeniorPassword()`, a new
`UserRepository.getForOrganisation()` (Drift: single-tenant assumption,
filters by tier only; Supabase: `organisation_id` + tier filter) so
`RegionManagementScreen` can list Directors/Regional Managers and offer
"Reset password" per account.

## Camera evidence capture: Windows + Android (built 2026-09-14)

`image_picker`'s own camera option is Android/iOS/Web only —
`image_picker_windows` explicitly throws `UnsupportedError` for
`ImageSource.camera`, so Windows tablets had no live-camera option, only
a file-browser fallback (and a real bug meant even that fallback wasn't
reliably reached — see DECISIONS_LOG.md's `EvidenceStore` fix). Added the
`camera` federated plugin for real live-preview capture. **Non-obvious
pub.dev gotcha**: `camera`'s own `pubspec.yaml` platform map only lists
`android`/`ios`/`web` as defaults — `camera_windows` exists and
self-declares `implements: camera` for the `windows` platform, but is
NOT auto-pulled in by depending on `camera` alone. Had to add
`camera_windows` as an explicit direct dependency for Flutter's plugin
resolution to register it (confirmed via `.flutter-plugins-dependencies`
before/after, and a full `flutter clean` + rebuild was required —
`generated_plugin_registrant.cc` is only regenerated by a real
build/run, not by `flutter pub get` alone). New `CameraCaptureScreen`
defaults to the back-facing camera (falls back to whichever camera exists
if there's no back camera) and offers a switch-camera button when more
than one camera is present. Android also needs the `CAMERA` permission
declared explicitly in `AndroidManifest.xml` (unlike `image_picker`'s
intent-based capture, which doesn't). iOS was explicitly deferred (user's
choice) — `camera_avfoundation` resolves transitively but hasn't been
added/tested for this app.

## Sprint 034 — Customer Onboarding & Billing Foundation (built and PROVEN 2026-09-14)

**Schema** (local Drift schemaVersion 38→39 + matching backend Postgres migration, both applied):
- `organisations` gains `legal_name`, `country`, `registered_address`, `vat_number`, `billing_email` (all nullable), and `owner_user_id` (references `users`, nullable) — set to the founding executive by `tenant-signup`.
- New `subscriptions` table: one row per organisation, `status` (trialing/active/past_due/canceled, default trialing), `plan_name`, `billed_site_count`, `trial_ends_at`, `current_period_end`, `stripe_customer_id`/`stripe_subscription_id` (unused columns until real Stripe integration — a later, credential-gated stage). RLS: executive-tier only, scoped via `can_access_organisation` — billing is an Owner/Admin concern, tighter than the generic reuse.
- New `organisation_invites` table: `organisation_id`, `role_tier`, `region_id`/`site_id`, `token` (unique, real random single-use), `email`, `created_by_user_id`, `expires_at`, `redeemed_at`/`redeemed_by_user_id`. RLS scoped via `can_access_organisation` for an admin listing their own invites; creation/redemption both go through service-role Edge Functions, same as every other C1-onward privileged operation.

**`tenant-signup` Edge Function, extended**: now collects `first_name`/`last_name` (replacing `director_name`), `country` (required), and creates the first venue (`venue_name` required, optional `venue_address`/`venue_region` — auto-creates a named Region if given/`venue_type` — looks up or creates an org-scoped `venue_types` row) plus a trialing `subscriptions` row (14-day default) in the same atomic, rollback-safe call. Proven live: legal fields, owner_user_id, region auto-create, venue-type linking, and the subscription row all verified via a throwaway tenant covering every field.

**`create-invite` Edge Function** (new): caller's session (PIN or GoTrue — verified via `jose.jwtVerify` like `provision-staff-pin`, since callers here can be any tier) must pass the existing cascade rule (`TIER_RANK[target] + 1 <= TIER_RANK[caller]`) and own the target scope (site reachable, or region/organisation for senior tiers). Generates a token (`crypto.randomUUID()` x2, concatenated — real random, not a guessable code), 7-day expiry, inserts into `organisation_invites`.

**`redeem-invite` Edge Function** (new): no caller session at all (the invitee has none yet — same shape `tenant-signup` already solves). Looks up the invite by token, rejects if missing/redeemed/expired, creates a real GoTrue account with the invite's `role_tier`/`organisation_id`/`region_id`/`site_id` baked into `app_metadata`, creates the matching `public.users` row, marks the invite redeemed.

**Proof** (live, throwaway tenant, all cleaned up and verified empty afterward):
- Full signup with every new field (legal name, country, address, VAT, billing email, venue, region, venue type, plan) — all verified saved correctly via direct REST reads.
- Invite created for a venueManager at the new venue → redeemed with no session → new account signs in successfully with correct claims.
- Reusing the same invite token → `409 already used`. A bogus token → `404 not valid`.
- Cascade check: the new venueManager cannot invite an executive (`403`), but CAN invite a supervisor at their own site (`200`).

**Deliberately deferred, logged not glossed over**: real Stripe API calls (schema is Stripe-shaped, but no live integration without a real Stripe account + API keys — Sprint 034 decision #3); real email delivery of invite tokens (SMTP still isn't configured on this VPS — same gap already logged against `invite-senior`; today the admin shares the code/QR manually, same relay-by-hand pattern as every other C1-onward invite).

## Issues & Incidents: schema + data layer (built 2026-09-15)

Freestanding problem capture, requested by the user from their own dashboard
notes — deliberately a separate data model from `problem_status_events`
(that one is task-fail-triggered; this is for anything raised independent
of a scheduled task: complaints, accidents, incidents, supply problems,
venue problems, other). Same Details → Process → Outcome event-sourced
pattern as the Fails & Problems Register, generalised from 2 phases to 3.

**Schema** (local Drift schemaVersion 40→41 + matching backend Postgres migration, both applied):
- New `issues` table: `site_id`, `type` (complaint/accident/incident/supplyProblem/venueProblem/other), `subtype` (nullable — e.g. dish/employee/customer/equipment/other, empty for types with no sub-category), `details`, `raised_by_user_id`, `raised_at`, `status` (open/resolved/escalated, denormalised current state), plus supply-problem-only fields: `supplier_id` (nullable, **no FK** — see gap below), `delivery_problem_type`, `received_by_user_id` (a staff picker, not free text — confirmed requirement). RLS: `tenant_isolation` via `can_access_site(site_id)`, same as every other table.
- New `issue_events` table: `issue_id`, `phase` (details/process/outcome), `note`, `changed_by_user_id`, `changed_at`, `resulting_status`. No `site_id` of its own — RLS scoped via a join to the parent issue's `site_id`, mirroring `shift_handover_acknowledgements`' policy exactly.
- Both deployed live via SSH: `BEGIN`/`CREATE TABLE` x2/`ALTER TABLE` x4/`CREATE POLICY` x2/`GRANT` x4/`COMMIT`, all succeeded.

**Known gap, logged not fixed here**: `public.suppliers` does not exist on the backend at all — confirmed via `\dt public.*` — Suppliers was apparently never migrated to the backend in any B-phase cluster (local Drift only). `issues.supplier_id` is a plain `integer` with no foreign key as a result. Fixing that is Suppliers' own backend migration, out of scope for this feature — not silently worked around by expanding scope.

**Governing anti-gaming rule, confirmed with the user and baked into the model/repository layer** (this is the one that must never be bypassed anywhere UI is built on top of this data):
1. Aggregate/leadership-level red-flag visibility (branch/region/section/month/day/shift counts, resolution rates, colour severity at those aggregate levels) is legitimate and wanted — it points leadership at a problem *area*, punishing no individual.
2. "Employee" is a filter/lookup only, never a graded severity score or ranking for that person. An individual's task completion colour/status must never worsen because they honestly logged an issue — same rule as "a logged FAIL scores identically to a PASS". Any issue tag on a personal view is neutral, never a penalty.
3. Any future "management score" measures management's *response* (resolved-without-escalation rate, time-to-resolve, % with a completed Outcome) — never issue volume. "Fewer issues raised = better score" must never exist at any level.
4. Director/Region/Branch score *dashboards* themselves are explicitly deferred to a later, separate piece — this build only captures the underlying data correctly so those can later be built on honest foundations.

**Data layer** (Drift + backend, both proven to compile clean, not yet exercised against the live backend with a throwaway tenant): `lib/shared/models/issue.dart`, `lib/shared/repositories/issue_repository.dart` (abstract `IssueRepository` + `DriftIssueRepository`, transactional dual-write mirroring `DriftProblemRegisterRepository._recordStatusChange`), `lib/shared/repositories/supabase_issue_repository.dart` (two-write pattern mirroring `SupabaseProblemRegisterRepository`, but simpler — no denormalised `site_id` lookup needed on `issue_events` since RLS there joins through the parent), `lib/shared/providers/issue_providers.dart`.

**Still to come**: raise/resolve/escalate UI, Issues & Incidents register tab (filter by date/shift/type/employee/status/branch), the pre-carousel branch hub ("My scheduled tasks" vs "Log something that just happened"), and the live-backend throwaway-tenant proof.

## Chain of command: reports-to + free-choice escalation (built 2026-09-15)

Follow-on to Issues & Incidents, requested once the user tried the flow live: "who does this escalate to" needed a real answer, and it varies by branch — a fixed role rule ("Kitchen Porters report to Head Chef") doesn't hold everywhere, so it has to be a per-individual assignment.

**Schema** (local Drift schemaVersion 41→42 + matching backend Postgres migration, both applied):
- `users.reports_to_user_id` (nullable, FK to `users`) — a specific named manager, not a tier/job-role rule. Set via Staff Management's new "Reports To" action, same shape as the existing "Change Department" action.
- `issues.escalated_to_user_id` (nullable, FK to `users`) — denormalised "who this currently sits with," mirrors the `status` column's role.
- `issue_events.target_user_id` (nullable, FK to `users`) — the same target recorded per-event, so history shows who it went to each time if escalated more than once.
- Deployed live via SSH: `BEGIN`/`ALTER TABLE` x3/`COMMIT`, all succeeded.

**Escalation is a free choice, not automatic** — explicit user requirement: the issue may be about the raiser's own direct manager, so `IssueRepository.escalate()` takes a required `escalateToUserId` rather than walking `reportsToUserId` automatically. `IssueDetailScreen`'s escalate picker pre-selects the raiser's manager as a sensible default but lets the caller pick anyone active at the site.

**New `BranchOrgChartScreen`** (drawer, supervisor+): a branch-scoped organogram built from `reportsToUserId` edges, deliberately separate from the executive/regional-scoped Head Office/Region/Venue tree (Phase C3) — that one stops at a venue's manager, this one goes inside a single venue to show its own staff. Anyone with no manager set (or a stale/cross-site pointer) renders as their own root — expected and shown honestly until a manager fills it in via Staff Management, not backfilled or hidden.

## Detailed delivery-by-supplier records (roadmap v1 item #1, built 2026-09-15)

Replaces a delivery task's plain pass/fail with real detail, per the strategy-session roadmap: temperature on arrival, short delivery, damaged stock, late delivery, quality problems, accept/reject/partial outcome. Gated behind the existing `requiresSupplierSelection` marker on a task template — the same flag that already shows the supplier picker on the completion form.

**Schema** (local Drift schemaVersion 42→43 + matching backend Postgres migration, both applied): six new columns on `task_submissions` — `delivery_temperature_c` (nullable real), `delivery_short_delivery`/`delivery_damaged_stock`/`delivery_late_delivery`/`delivery_quality_problem` (bool, default false), `delivery_outcome` (nullable text: accepted/rejected/partial). Deployed live via SSH: `BEGIN`/`ALTER TABLE`/`COMMIT`, succeeded.

**Worker flow stays fast** (explicit roadmap requirement: "one tap if all fine, expand only to record a problem") — `TaskScreen` shows one unticked checkbox ("Report a problem with this delivery") when `requiresSupplierSelection` is true; leaving it unticked writes `deliveryOutcome: 'accepted'` and nothing else. Ticking it reveals the temperature field, four problem `FilterChip`s, and the outcome dropdown.

Plumbed straight through the existing pipeline: `TaskSubmission` model → `TaskController.logTaskSubmission` → `DriftTaskSubmissionRepository`/`SupabaseTaskSubmissionRepository`.submit() → same six columns. `ProblemRegisterRepository`'s own `TaskSubmission` mapping updated too, so a delivery task that FAILs still carries its delivery detail into the Fails & Problems Register.

**Deliberately not linked to Issues & Incidents** — a rejected/problem delivery is captured here as task detail, not auto-escalated as an Issue. A worker who wants managers notified still uses the separate "Log something that just happened" flow. Not entangling the two keeps each system's semantics clean (task completion status vs. an ad-hoc raised issue).

## Leadership dashboard overview (built 2026-09-15) — from Visual idea.pdf

No schema changes — pure read model over data that already exists (`TaskSubmission`, the Issues table). New `LeadershipDashboardService` (`lib/features/dashboard/leadership_dashboard_service.dart`) computes two aggregate breakdowns:

- **`TaskOverviewBreakdown`**: 5-way split (on-time/off-window × issues-logged/no-issues, plus Not done) over a site's submissions in a date range, optionally filtered to one Section (Area) via the `equipmentInstanceId → Equipment.areaId` chain — submissions with no linked equipment can't be attributed to a section and are excluded from that filter, a logged gap for non-equipment tasks, not a silent miscount. "On time" reuses `ReliabilitySummary`'s own convention: a schedule with no window counts as on-time by default. "Issues logged" = `status == 'FAIL'` or any delivery-problem flag/non-accepted outcome from the delivery-detail build above.
- **`IncidentsBreakdown`**: Resolved/Unresolved/Escalated counts from the Issues table for a site + date range. The mockup's fourth "Urgent" category is NOT modelled — `IssueStatus` has no such state and there's no existing signal that would honestly mean "urgent" without inventing one; left as an open product question rather than mapped onto something arbitrary.

**Anti-gaming boundary, enforced structurally, not just by convention**: `LeadershipDashboardScreen`'s Employee filter does not reuse either breakdown class. Selecting a named person switches the screen to a plain list of their own task completions and raised issues (unstyled, ungraded) instead of computing a colour bar for that individual — the two computation classes above are aggregate-only by construction, and the doc comment on both warns against ever adding a per-user variant without revisiting the guideline logged in DECISIONS_LOG.md first.

Drawer-gated `venueManager` and above (`ManagementDrawer`, "Dashboard Overview") — one floor above the existing plain `DashboardScreen`, which supervisor already shares, per the user's explicit scoping ("branch Management, regional management, and director level users").

## Document Centre (built 2026-09-15) — roadmap v1.1

Policies, certs, procedures, EHO reports, plus an expiry dashboard.

**Schema** (local Drift schemaVersion 43→44 + matching backend Postgres migration, both applied): new `documents` table — `site_id`, `title`, `category` (policy/certificate/procedure/ehoReport/other), `file_path`, `expiry_date` (nullable — most policies/procedures never expire), `uploaded_by_user_id`, `uploaded_at`, `active`. RLS via `can_access_site(site_id)`, same as every other site-scoped table. Editable/soft-delete shape (mirrors Suppliers/Departments), not TaskTemplate's append-only versioning — a document being retired or re-titled is live operational data.

**File storage**: new `DocumentStore` (`lib/core/services/document_store.dart`) — `file_picker` (already a dependency, previously only used for the branding logo) picks any file, copies it into `<app documents>/documents/`, same "never reference the original pick location" reasoning as `EvidenceStore` and the logo picker (the source could be a USB drive, a network share, a Downloads folder that gets cleared).

**Expiry dashboard**: `documentExpiryStatus()` in `lib/shared/models/document.dart` — Valid / Expiring soon (within a 30-day warning window, a plain constant, not a legal threshold) / Expired, computed live from each document's own `expiryDate`. Shown as a three-number strip at the top of `DocumentCentreScreen`.

Drawer-gated `venueManager`+, same floor as Supplier Management / Maintenance Contacts.

## Two-factor authentication for senior accounts (built 2026-09-15) — roadmap v1.1

No schema changes — uses Supabase's own native TOTP MFA (`auth.mfa.*` on the GoTrue client), already available on this backend without any extra configuration. Only ever applies to real GoTrue sessions (regional/executive with `backendAuthEnabledProvider` true) — PIN-tier accounts and demo-mode senior accounts never touch GoTrue's own auth state at all (per `currentSessionTokenProvider`'s existing doc comment), so 2FA is architecturally out of scope for them, not just hidden.

**Enrollment** (`TwoFactorSettingsScreen`): `auth.mfa.enroll(factorType: FactorType.totp)` returns an unverified factor id plus a `TOTPEnrollment` (secret + `otpauth://` uri). The uri is rendered as a scannable QR via `qr_flutter` (already a dependency, previously only used for invite codes) rather than GoTrue's own SVG QR code, which would need an SVG renderer this app doesn't otherwise depend on. Confirming with a 6-digit code calls `auth.mfa.challengeAndVerify(factorId, code)`, which promotes the session to `aal2` and is the point the factor becomes `verified`.

**Login-time challenge** (`senior_login_screen.dart`): after `signInWithPassword` succeeds, `auth.mfa.getAuthenticatorAssuranceLevel()` is checked — if `nextLevel` (aal2, because a verified factor exists) differs from `currentLevel` (still aal1, this specific session hasn't cleared MFA yet), the sign-in pauses on a new "enter your 6-digit code" step before finishing. An account with no verified factor has `nextLevel == currentLevel` and skips straight through, byte-for-byte the same flow as before this feature existed.

## Realtime push to a manager's phone — Firebase wiring started (2026-09-16)

Roadmap v1.1 item, the one thing on the "Queued, no blocker" list that actually had a real blocker (an external Firebase/FCM project). User created one (project id `venurite-a6f64`, Spark/free plan — confirmed no cost for FCM at this scale) and registered an Android app under package `com.venurite.app`.

**Found and fixed along the way**: the Android app was still shipping under the Flutter scaffold's default package name (`com.example.flutter_application_1`), never renamed since the project was created. Renamed to `com.venurite.app` across `android/app/build.gradle.kts` (namespace + applicationId) and the `MainActivity.kt` package/folder, before registering with Firebase (so the registration didn't have to be redone against a mismatched package).

**Wired so far** (config-only, no send logic yet):
- `android/app/google-services.json` — the real config downloaded from the Firebase console, verified to carry `com.venurite.app` before being placed.
- `com.google.gms.google-services` Gradle plugin declared in `android/settings.gradle.kts` and applied in `android/app/build.gradle.kts`.
- `firebase_core` + `firebase_messaging` added to `pubspec.yaml`.
- `Firebase.initializeApp()` added to `main.dart`, gated to Android only — Windows (this app's primary desktop target) has no Firebase app registered at all yet, so it's skipped outright rather than calling init and catching the guaranteed failure (same "don't block startup" shape as the existing Supabase try/catch).

**Build proof (2026-09-16)**: `flutter build apk --debug` succeeded after the corrupted NDK cache was cleared and re-downloaded (a machine-state issue unrelated to Firebase — the NDK is actually required by `sqlite3_flutter_libs`, a transitive `drift` dependency, not by this feature; any Android build of this app needs it once). Produced a real ~178MB `app-debug.apk`. Only warnings, both pre-existing and unrelated to Firebase (a future-Flutter Kotlin-Gradle-Plugin deprecation notice from `camera_android_camerax`). `flutter analyze` stayed clean across the whole app.

**Not yet done, deliberately** — this was config wiring only, not the feature:
- Device token registration (saving each manager's FCM token somewhere queryable, e.g. a column on `users`).
- The actual server-side "who gets pushed for which event" sending logic — needs a Firebase service account key (a real secret, unlike `google-services.json`) used from a backend Edge Function, and a design decision on which events fire a push (new Issue raised? escalated? a FAIL?) before that gets built.
- iOS/Web Firebase app registration — Android only for now, matching "manager's phone."

## Realtime push: device-token registration + a Windows build regression fixed (2026-09-16)

**Schema** (local Drift schemaVersion 44→45 + matching backend Postgres migration, both applied): `users.fcm_token` (nullable text) — "last device wins," not a device list; overwritten on every registration and token refresh.

**Client wiring**: new `PushTokenService` (`lib/core/services/push_token_service.dart`). `app.dart` uses `ref.listen(currentUserProvider, ...)` as a single choke point catching every login path (PIN, senior email+password, senior demo-PIN) rather than wiring registration into each one — fires once per sign-in (previous null → next non-null), calls `FirebaseMessaging.requestPermission()` + `getToken()`, saves via `UserRepository.setFcmToken()`, and subscribes to `onTokenRefresh`. Android-only, fire-and-forget (wrapped in try/catch) — a push failure must never block or interrupt sign-in.

**Real regression found and fixed via a full build proof on both platforms**: adding `firebase_core`/`firebase_messaging` broke `flutter build windows` outright, even though this app never calls `Firebase.initializeApp()` on Windows. Their vendored Firebase C++ SDK ships a `CMakeLists.txt` whose `cmake_minimum_required()` predates CMake 3.5 — CMake 4+ (installed on this machine) refuses that outright, and Flutter's Windows build configures every plugin's native target regardless of what the Dart code actually calls at runtime. Fixed at the root `windows/CMakeLists.txt` with `set(CMAKE_POLICY_VERSION_MINIMUM 3.5)`, placed before the Firebase subdirectory is ever added — confirmed with a real `flutter build windows --debug` producing a working `.exe` again (only harmless `LNK4099` "PDB not found" warnings, missing debug symbols on Firebase's precompiled static libs) alongside a real `flutter build apk --debug` proving the Android side still works too.

**Also found and fixed along the way (2026-09-16, same session as the Firebase project setup)**: the Android app was still shipping under the Flutter scaffold's default package (`com.example.flutter_application_1`), never renamed since the project was created — fixed to `com.venurite.app` (namespace + applicationId in `android/app/build.gradle.kts`, `MainActivity.kt` moved to match) before registering with Firebase, so the registration didn't have to be redone against a mismatched package. The equivalent gap on Windows (`windows/CMakeLists.txt`'s project name and `BINARY_NAME` are still `flutter_application_1`) was noticed but deliberately NOT fixed in the same pass — renaming the Windows executable touches more files (the runner project, resource files) and deserves its own careful pass, not a rushed bundle-in alongside a build-break fix.

**Server-side send logic — DONE and PROVEN LIVE (2026-09-17)**:

- **Secret storage**: user generated a Firebase Admin SDK service account key (Firebase console → Project Settings → Service Accounts → Generate new private key) and handed it to the agent via the IDE, which grabbed the file directly from disk (never printed the key's contents in chat). Base64-encoded and appended to the server's `/root/tango-sierra/supabase/docker/.env` as `FIREBASE_SERVICE_ACCOUNT_JSON_B64` — base64 specifically to sidestep `.env` quoting/newline issues with the PEM private key. **Non-obvious gotcha, cost real debugging time**: adding a variable to `.env` alone does nothing for a service whose `docker-compose.yml` block explicitly lists which env vars it receives (this stack's `functions` service does, e.g. `SUPABASE_ANON_KEY: ${ANON_KEY}`) — it had to be added there too (`FIREBASE_SERVICE_ACCOUNT_JSON_B64: ${FIREBASE_SERVICE_ACCOUNT_JSON_B64}`), AND `docker compose restart functions` does NOT reload new `.env` values into an existing container — only `docker compose up -d --force-recreate functions` does. Verified via `docker exec ... printenv NAME | wc -c` (byte count only, never the value) at each step until it matched the expected length.
- **New `send-push` Edge Function** (`volumes/functions/send-push/index.ts`): verifies the caller's own session first (PIN or GoTrue, same HS256/JWT_SECRET check as `provision-staff-pin`) and that the target `user_id` is at the caller's own `site_id` — the anon key is public, so without this any caller could push to any user; added after noticing the gap mid-build, not part of the original design. Then signs a Google OAuth2 JWT-bearer assertion (RS256, via the service account's private key) to get a scoped access token, and calls `https://fcm.googleapis.com/v1/projects/venurite-a6f64/messages:send` directly — no Firebase Admin npm SDK, just `jose` (already used by other functions) plus `fetch`.
- **Proof, live, real calls** (no mocks): wrong apikey → `401`; no session → `sign in first`; a user with no `fcm_token` → clean `{"sent": false, "reason": "no registered device"}`; a throwaway token set on a real row → the call round-tripped all the way to Google's own FCM API and got back a genuine `INVALID_ARGUMENT: The registration token is not a valid FCM registration token` — proving RS256 signing, the OAuth2 exchange, and the authenticated FCM call all work; only actual delivery to a real phone is untestable without one. Throwaway token cleared afterward.
- **Client wiring**: `SupabaseIssueRepository.raise()` pushes to every active supervisor+ at the site when the type is Accident/Incident or a damaged-stock Supply Problem; `.escalate()` pushes to the specific chosen target. New `BackendRestClient.invokeFunction()` reuses the client's existing header/token logic. Both call sites are fire-and-forget (try/catch) — a push failure never blocks raising or escalating an issue.
- **End-of-shift summary — BUILT (2026-09-17)**: new `EndOfShiftDigestService` (`lib/features/tasks/end_of_shift_digest_service.dart`) sends one push per site manager when a worker's session ends (natural completion or early exit), summarising fail count / not-completed count / routine (non-urgent) issues raised since the session started — the exact inverse of the immediate-push "urgent" set, so nothing is double-reported. Sends nothing when there's genuinely nothing to report. No new schema — reuses `IssueRepository.getRaisedByUser()` and the same `send-push` function/`invokeFunction()` plumbing as the immediate-push path.

### Urgency colour-coding — `issues.manual_urgent` — CLOSED (2026-09-17)

Client-side urgency colour-grading (green/amber/red by age, escalated/manual-flag/Not-Completed always red — see DECISIONS_LOG.md for the full design) added a new column, `Issue.manualUrgent`, set by a "Mark as urgent" checkbox on Report Issue. Local Drift: fully migrated (`schemaVersion` 45→46, `addColumn(issues, issues.manualUrgent)`, `boolean` default `false`). Both `DriftIssueRepository` and `SupabaseIssueRepository` are coded and analyzed against a `manual_urgent` column.

The initial migration attempt was blocked by the Claude Code auto-mode classifier as a "Production Deploy" action (direct SSH `ALTER TABLE` against the live VPS). The user ran it themselves, verbatim:
```sql
docker exec supabase-db psql -U postgres -d postgres -c "ALTER TABLE public.issues ADD COLUMN IF NOT EXISTS manual_urgent boolean NOT NULL DEFAULT false;"
```
Result: `ALTER TABLE`. Verified present via `\d public.issues`:
```
 manual_urgent         | boolean                  |           | not null | false
```
Local and backend schemas now match. Not yet re-tested live end-to-end via the Report Issue screen against the real backend — the column existing is confirmed, a live `raise()` round-trip with `manualUrgent: true` is not.

### Supplier/Delivery Scorecard (Sprint 038, 2026-09-17) — no schema change, no new backend surface

Pure client-side read/aggregation over two already-proven, already-backend-hosted tables: `task_submissions` (its `delivery_*` columns, added in the 2026-09-15 delivery-detail migration) and `issues` (`supplier_id`, `delivery_problem_type`, filtered to `type = 'supplyProblem'`). No new table, column, RLS policy, or write path — both tables' `tenant_isolation` RLS was already proven to the full curl+integration-test standard in earlier work, so no new live-backend proof was run for this feature; there is nothing new here that proof methodology would validate.

**Re-confirms the existing `Suppliers`-not-backend-hosted gap** (see line ~1552 above) rather than introducing a new one: the scorecard reads `Supplier` names/categories via the local-Drift-only `SupplierRepository.getForSite()`, since `public.suppliers` still does not exist on the VPS. On a site with more than one device, supplier records could differ or be stale between devices — a pre-existing limitation every supplier-touching feature in this app already has. Flagged to the user rather than silently worked around; revisit if/when Suppliers gets its own backend migration cluster.

## Notes

- Update this file's checklist and server table as each step completes.
