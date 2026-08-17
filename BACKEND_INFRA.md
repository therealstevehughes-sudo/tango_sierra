# BACKEND_INFRA.md

Non-secret operational record of Tango Sierra's backend infrastructure. Kept
separate from DECISIONS_LOG.md because this tracks *current state* (IPs,
status, what's live) rather than a narrative of decisions made.

**NEVER put secrets in this file** — no passwords, no JWT secrets, no API
keys (anon or service_role), no Studio credentials. Those live only in
Steve's password manager, per the explicit security practice agreed for
this backend phase. This file is safe to read, share, and commit to git.

## Servers

| Purpose | VPS name | IP | Plan | OS | Data centre | Status |
|---|---|---|---|---|---|---|
| Bloody Hell (existing, unrelated app) | My VPS | 217.160.174.119 | VPS 6-8-240 | Ubuntu 24.04 | (per IONOS panel) | Live, pre-existing — not touched by Tango Sierra's setup |
| Tango Sierra Supabase | *(not yet created)* | *(pending)* | *(pending — Linux L+)* | *(pending)* | *(pending)* | Provisioning in progress |

Tango Sierra's VPS is a fully separate server — same IONOS account, no
shared files/volumes/secrets/domains with Bloody Hell's box (confirmed
2026-08-17).

## Phase 1 checklist status (see DECISIONS_LOG.md "BACKEND - approach
decided" / "Sequencing decision" for the full plan)

- [ ] 0. New VPS provisioned, IP noted above; DNS A record added for the
      Tango Sierra subdomain
- [ ] 1. First-time hardening: SSH key auth set up, non-root sudo user
      created, root login + password auth disabled, OS updated, ufw +
      Docker + Docker Compose installed
- [ ] 2. Supabase self-hosting files cloned into an isolated directory
- [ ] 3. Fresh secrets generated (Postgres password, JWT secret, anon/
      service_role keys, Studio credentials) — **stop-and-confirm point #1**
- [ ] 4. Site/API URLs set to the Tango Sierra subdomain
- [ ] 5. Reverse proxy (Caddy) routing the subdomain to Kong's internal
      port — **stop-and-confirm point #2**, before opening the firewall
- [ ] 6. Firewall locked down (443/80 only, Postgres denied)
- [ ] 7. SSL/HTTPS live via the reverse proxy
- [ ] 8. Stack brought up (`docker compose up -d`), all containers healthy
- [ ] 9. First Studio login + test query confirmed
- [ ] 10. Backups scheduled (pg_dump via cron, off-VPS) + test restore
      confirmed; IONOS snapshot availability checked
- [ ] 11. Final 7-point verification checklist — **go/no-go gate before any
      app code (Phase 2)**

## Subdomain

*(pending — to be filled in once the DNS record is created)*

## Notes

- Update this file's checklist and server table as each step completes —
  ask to have it updated, or note progress and it'll be kept current.
