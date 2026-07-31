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

## Session lifetime (Sprint 004)
- Not a persistent login. The session auto-resets to the login screen once all tasks for that session are complete (device hand-off point for the next staff member), rather than requiring manual logout.

## Full product vision (confirmed, expands original scope)
- Three role tiers: top (C-suite, company-wide + stakeholder data), mid (managers/supervisors - assign tasks, manage staff, notified on triggers), base (workers - task execution)
- Task library: grouped by operation segment/role, site-editable, with trigger events (outside min/max), fix instructions, if/then logic
- Each task has a configurable method (e.g. thermometer+photo, filter type choices) and custom fields - not just pass/fail/temperature
- Multiple named instances per equipment type (Fridge 1, Fridge 2, etc.), set up by manager/top tier per venue
- Venue setup wizard: equipment, operational points, staff + roles - guided, intuitive
- Company/branch branding controlled by top tier (colors, logo, contact info)
- Onboarding: manager selects staff, assigns tasks + frequency via tick-box library, can add custom tasks
- End-of-session summary: pass/fail + triggers, sendable to a selected manager
- Trigger notifications: configurable by top/mid tier (push and/or email), top tier can override mid-tier settings
- Shift handover: carry-over notes between shifts
- Multilingual: each staff member selects their own language
- Audit trail: append-only, versioned - nothing overwritten; manager changes to task setup (limits, frequency) create a new version, old version stays visible
- Legal limit checking: task limits checked against a legal-minimum reference table (e.g. fridge/freezer/hot-hold temps); attempts to set outside legal allowance trigger a warning
- Offline: each device queues entries locally with timestamp, syncs when reconnected - no merging/overwrite, all entries additive; manager dashboard shows a "not yet synced" indicator
- Units: support both metric/imperial and Celsius/Fahrenheit
- Inspection data export: management/top tier only

## Sprint sequence (post Sprint 005)
006 three-tier roles | 007 task library data model (method/limits/triggers/if-then/custom fields) | 008 venue setup wizard | 009 staff onboarding + task assignment | 010 richer task input UI | 011 shift handover + summary/report | 012 notifications | 013 audit trail versioning | 014 offline queue + sync indicator | 015 branding | 016 multilingual | 017 inspection export | 018 visual/UX redesign

## Three-tier roles (Sprint 006)
- Confirmed title → tier mapping: Base = Kitchen Porter, Prep Cook/Commis, Line Cook/Chef de Partie, Sous Chef/Shift Lead. Mid = Head Chef/Kitchen Manager, General Manager. Top = Area Manager, Operations Manager, Group Executive Chef, Director/MD.
- Area Manager placed at Top, not Mid — multi-site scope fits PROJECT_BIBLE's "top tier" definition (company-wide oversight) better than day-to-day single-venue management.
- Top tier gets a bare placeholder screen this sprint (logout only, no dashboard content) rather than sharing the manager log with Mid — cheap now, avoids having to unwind a "top==mid for now" shortcut later when Sprint 017 builds the real dashboard.
- Manager-view icon on the task screen is visible to both Mid and Top (both are oversight roles), not Mid only.
- RoleTier is a rename (staff/manager → top/mid/base), not additive — existing seeded users and any real on-disk data get migrated via a real schema migration (schemaVersion bump + remap step), consistent with how every prior schema change in this project has been handled, not a wipe-and-reseed shortcut.

## Open / Not yet decided
- (nothing logged yet)
