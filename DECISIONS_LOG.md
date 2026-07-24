# DECISIONS_LOG.md

Every agreed decision goes here as a short bullet. This file is the source of truth — paste it into any new Claude Code sprint or Claude chat before starting work. Nothing here changes without discussing it first.

## Product
- Kitchen compliance enforcement app (UK), not a checklist app
- Tasks require proof (tick/data/photo/note) — can't be faked or skipped
- Critical/high-risk failures require a corrective action before continuing

## Process
- Restarting the build was rejected — reconcile the existing prototype, don't rewrite from scratch
- Every sprint must be committed to git as a save point
- Claude keeps answers short and simple for the user
- Claude pushes back on ideas that don't fit the ICP or app, and suggests improvements

## Data storage (Sprint 001)
- Use drift for local persistence (relational, matches ARCHITECTURE_LOCK's entity list, type-safe, works with Riverpod streams)
- Keep the flat TaskLogEntry shape for now, renamed/moved to shared/models/ as TaskSubmission — no TaskTemplate/TaskInstance split yet
- Add a nullable photoPath column now to avoid a later migration
- No sync-state fields yet, no site/area/user linkage yet (Phase 2 auth/roles isn't real yet)
- Repository is append-only: submit / getAll / getByStaff / getByDateRange / watchAll — no update or delete
- Repository interface and implementation both live in shared/repositories/

## Auth and roles (Sprint 003)
- Real auth is local-only: PIN per staff member, checked against the drift DB. No server/cloud identity yet.
- Only two role tiers implemented now: staff and manager. Director tier deferred — no dashboard exists yet for it to land on.
- Login UX: tap your name/job-title tile from a list, then enter a 4-digit PIN (not a bare PIN pad with no name list).
- PINs are hashed (salted) before storage, even though everything is local-only.
- No staff-management screen yet — this sprint seeds a fixed demo staff list (reusing the existing mock names) with placeholder PINs. Real staff CRUD is deferred to a later Settings-feature sprint.
- Sprint 003 builds the auth foundation + real login screen only (schema, model, repository, providers, login UI). Wiring the logged-in session into TaskController (real completedBy) and role-based screen gating is Sprint 004, following the same build-then-wire pattern as Sprints 001/002.

## Open / Not yet decided
- Session lifetime: does login persist until manual logout, or reset automatically once a shift's tasks are all submitted (device hand-off point)? To be settled before Sprint 004.
