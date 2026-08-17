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

## PAUSED (2026-08-17): waiting on a domain name

Everything below is set up and ready; the next steps (site/API URLs, DNS,
nginx routing, SSL) all need a real domain name, which Steve doesn't have
yet. Steve is arranging one today. Resume once a domain exists — see "Next
step" at the bottom.

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
- [ ] **← PAUSED HERE — needs a domain name to continue**
- [ ] 6. Site/API URLs set to the Tango Sierra subdomain
- [ ] 7. DNS A record added for the Tango Sierra subdomain (Steve, IONOS panel)
- [ ] 8. nginx server block added for the subdomain, routing to Envoy's
      internal port — **stop-and-confirm point #2**, before firewall changes
- [ ] 9. Firewall locked down for the new stack's internal ports (443/80
      already open for nginx; new internal ports must stay unpublished)
- [ ] 10. SSL/HTTPS live for the new subdomain
- [ ] 11. Stack brought up (`sh run.sh start`), all containers healthy
- [ ] 12. First Studio login + test query confirmed
- [ ] 13. Backups scheduled (pg_dump via cron, off-VPS) + test restore
      confirmed; IONOS snapshot availability checked
- [ ] 14. Final 7-point verification checklist — **go/no-go gate before any
      app code (Phase 2)**

## Subdomain

*(pending — Steve is arranging a domain today)*

## Next step

Once Steve has a domain: tell Claude Code the domain and preferred
subdomain word (e.g. `db`, `supabase`, `backend`), and Phase 1 resumes at
checklist item 5.

## Notes

- Update this file's checklist and server table as each step completes.
