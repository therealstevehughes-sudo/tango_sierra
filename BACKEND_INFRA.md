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

## Notes

- Update this file's checklist and server table as each step completes.
