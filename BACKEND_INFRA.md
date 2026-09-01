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

## Notes

- Update this file's checklist and server table as each step completes.
