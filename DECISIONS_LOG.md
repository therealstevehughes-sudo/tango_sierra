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

## Task library data model (Sprint 007)
- Legal-limit violations are warning-only — a manager can still save a template whose limits fall outside the legal reference range, matching PROJECT_BIBLE's literal wording ("trigger a warning"), not a hard block.
- TaskTemplate keeps an optional EquipmentType link (the category, e.g. "Fridge") — not pushed entirely down to TaskSchedule — so a future tick-box library (Sprint 009) can filter "which templates apply to Fridge-type equipment."
- Custom fields are stored as a JSON blob column (customFieldsJson) rather than a separate child table, since the full range of field types the real 100+ tasks will need isn't known yet.
- If/then logic for v1 is minimal structured fields (isCritical, requiresCorrectiveActionOnFail) rather than a generic rule engine — deferred until a concrete task actually needs more.
- EquipmentType and LegalLimitReference get a handful of seeded example rows (Fridge/Freezer/Hot-hold unit; fridge/freezer/hot-hold legal temps) so the legal-limit check is testable, mirroring how Users got seeded in Sprints 003/006. One example TaskTemplate ("Check Fridge Temperature") is also seeded for the same reason — this is illustrative test data, not the start of loading the real 100+ task library.

## Venue setup wizard (Sprint 008)
- No Site/Organisation/Brand this sprint — the app stays implicitly single-venue; Area and Equipment don't get a siteId yet since Site doesn't exist.
- Equipment.areaId is required in the wizard UI but nullable at the schema level, matching how other optional-but-usually-set FKs have been handled.
- Staff creation lives on the existing UserRepository (new createStaffMember method) rather than a new repository.
- Entry-point icons on ManagerScreen and TopScreen are included in this sprint, not deferred — a wizard nobody can reach isn't useful, and each addition is a single icon button, not a redesign.
- Light suggestion chips (common area names) and auto-numbered equipment names (e.g. "Fridge 3") are in scope for v1 — kept intentionally simple, no recommendation engine.

## Staff onboarding + task assignment (Sprint 009)
- TaskSchedule uses a simple `active` boolean toggle for unassign/reassign, not full append-only versioning like TaskTemplate — full reassignment history is deferred until ReassignmentLog itself gets built.
- Frequency is a small fixed enum (daily/weekly/per-shift/custom) plus a free-text detail field for the custom case — granular scheduling (specific times, shift-phase-aware) is deferred to Sprint 010/011.
- Custom tasks default to `segment: 'custom'`, reusing the existing TaskTemplate field rather than adding a dedicated isCustom flag.
- The assignment screen has its own entry-point icon on ManagerScreen/TopScreen, separate from Sprint 008's venue-setup icon, keeping the two features cleanly split.
- This sprint assigns tasks to named individuals only, not broadcast to a whole role tier — role-wide assignment is a different, deferred model.

## Richer task input UI (Sprint 010)
- TaskSubmission gains traceability columns (taskScheduleId, taskTemplateGroupId, equipmentInstanceId, customFieldValuesJson) — needed for real audit traceability, not optional.
- For tasks with a numeric range, PASS/FAIL is now auto-derived from whether the reading falls inside [minLimit, maxLimit], replacing the old manual PASS/FAIL button press for those tasks specifically. Non-measurable tasks (choice-only, notes-only) keep the manual PASS/FAIL buttons.
- Units: per-user preference (temperature only — Celsius/Fahrenheit), template stays canonical, conversion happens only at the display/input edges. The schema field and conversion logic are built now; the self-service toggle UI itself is deferred to Sprint 016 — everyone is defaulted to the template's native unit until then.
- Legal-limit reference numbers stay a manager-configuration-time concern, not shown to staff during data entry — only the template's own min/max and fixInstructions are surfaced.
- The carousel shows all of a staff member's active schedules every session (matching today's fixed-list simplicity) — due/overdue tracking (TaskInstance) is a separate, later concern.

## Equipment type library expansion (Sprint 011)
- Found "Full check list.docx" (in Documents\AA Tango Sierra) — the real source checklist — was never actually incorporated into PROJECT_BIBLE.md despite being referenced as if it were; extracted it directly for this sprint rather than guessing at equipment coverage.
- Expanded EquipmentType seed list to 18 realistic commercial-kitchen types, derived from the checklist's equipment-related sections (refrigeration, fryer, cooking line, wash-up) plus the user's explicit examples (walk-ins, ice machines, prep stations). Deliberately excluded utility-style items (gas/water supply) and consumable/tool items (knives, chopping boards) — they don't fit the "named instance" model (Fridge 1/Fridge 2) the way durable appliances do.
- Did not also expand LegalLimitReference or add new TaskTemplates for the new types — out of scope for this fix, which is specifically the equipment type library plus the custom-type escape hatch. Loading the real 100+ task library remains a separate, later effort.
- Equipment type seeding is now always-ensured on every app open (idempotent, checked by name) rather than gated on "table empty" — an existing install with only the original 3 types gets backfilled with the rest. No schema version bump needed since this is pure reference data, not a structural change.
- The "Something else..." custom equipment type option follows the identical pattern to Sprint 009's custom task capability: inline creation, immediately usable, no separate screen.

## PROJECT_BIBLE checklist incorporation (docs-only pass)
- Incorporated "Full check list.docx"'s structure (19 operational segments, task method vocabulary, priority levels, frequency vocabulary) into PROJECT_BIBLE.md as a new "Task Library Source Content" section — the taxonomy, not the ~100+ individual task rows, which stay in the source document until a future sprint actually loads them.
- Confirmed the checklist file is unchanged since Sprint 011's extraction (byte-identical), so no new equipment-type gaps found this pass.

## Open / Not yet decided
- Task priority: the checklist uses 3 levels (Critical/High/Standard); TaskTemplate currently only has a binary `isCritical`. Needs a decision before the real task library gets loaded — add a 3-level field, or accept the information loss of mapping down to the boolean.
- Task method vocabulary: the checklist's real methods (Tick, Data+Tick, Tick+Photo, Data+Photo, Note, Note+Photo, Tick+Note, Multi) don't fully match the placeholder `method` strings used in Sprint 007/009's example data. Needs reconciling when the real library loads.
- Task frequency vocabulary: the checklist uses frequencies (3x daily, per batch, per delivery, per use, 2x per service, event-based, as-needed) broader than Sprint 009's 4-value enum. Workable via `custom` + free text for now, but worth a decision on whether to expand the enum later.
