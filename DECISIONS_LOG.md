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

## Open / Not yet decided
- (nothing logged yet)
