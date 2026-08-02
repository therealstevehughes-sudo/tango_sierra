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

## Standing process rule (effective immediately, all future sprints)
If Claude believes something in an approved plan should change during a build, it must STOP and ask before implementing it — not implement the change and report it afterward, even if the change seems more correct or more consistent with locked architecture. Flag it, wait for a decision, then proceed.
This applies retroactively to nothing already built — Sprint 014's versioning correction (built as an on-the-spot fix to match ARCHITECTURE_LOCK's Versioning Rule, then disclosed) stands as-is and was a reasonable call under the rules in force at the time. This rule governs how deviations from an approved plan are handled from Sprint 015 onward.

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

## Shift handover + end-of-session summary (Sprint 013)
- TaskSubmission gains completedByUserId — needed for reliable session-boundary queries (session = submissions by this user since the carousel loaded), replacing reliance on the formatted completedBy display string.
- "Trigger" and "FAIL" are treated as the same signal for this sprint's summary — no separate trigger-fired flag exists yet.
- Handover notes are per-venue (one running note, shown to everyone at session start) — matches the app's continued single-venue scope; per-area is a future refinement once tasks/staff are area-aware.
- "Send to manager" is a real lightweight in-app inbox (new SessionSummaries table with sentTo/acknowledged), not a no-op — gives staff a distinct, explicit "flag this for a specific manager" action beyond the general submission log a manager can already browse.
- No new Shift/session entity — session boundary is a client-side timestamp captured when the carousel loads; Open/Mid/Close shift-phase tracking remains unbuilt (PROJECT_BIBLE concept only, not yet in the schema).
- Kept as one sprint (~13 files) rather than split, since both features share the same UI moment (start/end of session).

## Notification rules (Sprint 014)
- `NotificationRule` follows the append-only/versioned pattern (`ruleGroupId`/`versionNumber`/`previousVersionId`), matching `TaskTemplate`, not the simple `active` toggle `TaskSchedule` uses — required by ARCHITECTURE_LOCK's Versioning Rule, which explicitly lists `NotificationRule` as a configurable setup entity. "Deactivating" a rule means saving a new version with `active: false`, never mutating the existing row.
- Trigger scope: `taskTemplateGroupId` nullable — null means "any task fail," non-null scopes to one task template (soft reference, same approach as `TaskSchedule.taskTemplateGroupId`). No segment- or equipment-type-level scoping yet.
- A rule must target either a role tier or a specific user (validated in the repository, throws if neither is set). Who can receive a rule isn't restricted to mid/top — the schema allows any target; who can *set* a rule is enforced by which screens expose the entry point (both ManagerScreen and TopScreen, per PROJECT_BIBLE's "configurable by top and/or mid tier").
- Split the original 5-point proposal into two sprints: this sprint builds the schema, repository, and rule-management UI only — unwired. Firing a notification on FAIL and an in-app notifications inbox are deferred to a follow-up sprint, matching this project's established build-then-wire pattern (001→002, 003→004, 007→010).
- Channel (push/email) is captured as configuration intent only on the rule — no real dispatch exists (no backend, Phase 6 territory). The rule-creation form shows an explicit note that delivery isn't connected yet, rather than hiding the toggles.
- Top-tier override of mid-tier rules (per PROJECT_BIBLE) is intended to resolve at query time — the higher tier's active rule wins for a matching trigger scope, nothing gets marked "overridden." `setByTier` is stored to support this, but the actual precedence resolution isn't implemented until the firing-logic follow-up sprint.
- A widget-level automated test for the new screen was attempted but dropped after an unresolved `pumpAndSettle()` hang (compounded by a mid-session disk-space exhaustion that also caused unrelated test/build failures). Verified instead via a repository-level versioning test (passed) plus a real Windows debug run against the existing dev database confirming the schemaVersion 8→9 migration executes cleanly. Interactive click-through of the new screen was not independently exercised this sprint.

## Multi-site foundation (inserted before notifications-firing/branding)
- Decision: build the Organisation -> Site schema foundation NOW, not deferred to the end. Reasoning: branding is explicitly per-branch (already next in sequence), and retrofitting a "which site" link onto everything already built (Users, Areas, Equipment, TaskSchedules, NotificationRules) gets more expensive the longer it's deferred.
- Scope split: build the SCHEMA foundation now (Organisation, Site entities; existing entities gain siteId). Defer the full regional-tier permissions/UI (e.g. "100 branches, regional managers between top and mid") until there's real need - that layer is additive on top of a properly-scoped foundation, not urgent today.
- This pauses the in-progress "wire notifications to fire" follow-up sprint until the foundation exists, so that sprint doesn't have to be redone site-aware later.

## Multi-site foundation schema (Sprint 015a)
- No `Brand` entity this sprint, despite ARCHITECTURE_LOCK listing Organisation/Brand/Site as three separate entities — `Site.organisationId` points straight at Organisation for now. Brand is deferred to Sprint 015's branding work; adding a `brandId` FK later is cheap and non-disruptive.
- `TaskTemplates`, `EquipmentTypes`, `LegalLimitReferences` stay organisation-wide/unscoped (no `siteId`/`organisationId`) — accepted as a known gap against PROJECT_BIBLE's "site-editable" task library wording. Real per-site task library customization is materially bigger work (independent copies vs. site-level override versions via the existing `previousVersionId` chain) and is deferred to a future sprint, not conflated with this schema foundation.
- Default Organisation/Site are auto-seeded (no setup step) with placeholder names "My Organisation" / "Main Site" — matches this project's established auto-seed-don't-block pattern. Renaming them is a later sprint's UI.
- Site-scoped tables get a `siteId` column that's nullable at the SQL level (a SQLite/drift constraint — `ALTER TABLE ADD COLUMN` can't retroactively enforce NOT NULL against existing rows) but is treated as required by application code, validated at the repository layer — same approach already used for `NotificationRule`'s "must have a target" check.
- `NotificationRules.siteId` is nullable *by design*, not just migration necessity — null means "applies org-wide across every site," same pattern as that table's existing `taskTemplateGroupId`.
- Sprint split confirmed: 015a (this sprint) builds Organisation/Site schema, models, repositories, providers, and default-site seeding only — no existing table gets a `siteId` yet. Follow-up sprints add `siteId` to the 7 site-scoped tables in clusters: (Users, Areas, EquipmentInstances), then (TaskSchedules, TaskSubmissions), then (ShiftHandoverNotes, SessionSummaries, NotificationRules) — each wiring its own UI call sites to a new `currentSiteProvider`.

## Multi-site foundation: Users/Areas/EquipmentInstances (Sprint 015b)
- `beforeOpen` reordered: `_ensureDefaultOrganisationAndSite()` now runs first (previously last), since user seeding needs a real site id to seed into. A real change to Sprint 015a's code, not purely additive — flagged and confirmed before building, not decided unilaterally.
- Domain model `siteId` is non-nullable (`int`, not `int?`) on `User`, `Area`, `Equipment`, even though the underlying DB column is nullable (SQLite/drift migration constraint) — repositories assert non-null when mapping rows, since `beforeOpen`'s backfill guarantees every row has a real value by the time application code reads it.
- `getAll()` reads are not filtered by site — no `siteId` parameter added to any read method. Only one site exists and no site-switcher UI exists yet; a filter parameter would be unused code built for a hypothetical.
- `staff_assignment_screen.dart` needed no changes — it only reads Users/EquipmentInstances (for pickers) and creates `TaskSchedules`/`TaskTemplates`, neither in this cluster's scope. Confirmed before building, not assumed.
- Only one real call site existed for all three tables' create methods: `venue_setup_wizard_screen.dart`'s `_addArea`/`_addEquipment`/`_addStaff`. All three now resolve `currentSiteProvider` and pass its id through.

## Multi-site foundation: TaskSchedules/TaskSubmissions (Sprint 015c)
- Neither real call site needed `currentSiteProvider` — both already held a site-bearing `User` in hand. `TaskSchedules.assign()` (called once, from `staff_assignment_screen.dart`) now derives `siteId` from the assigned staff member's own `siteId`; `TaskSubmissions.submit()` (via `TaskController.logTaskSubmission`) derives it from `_currentUser.siteId`, a field the controller already holds. Confirmed by reading the actual call sites before building, not assumed from the 015a plan's shorthand.
- `_backfillSiteIds()` extended to cover these two tables rather than adding a second near-duplicate function — one idempotent routine, growing per cluster.
- Backfill of pre-existing rows still uses the default site id (same as 015b) — the "derive from the acting user" approach only applies to new creates going forward; historical rows have no acting-user context to derive from.

## Multi-site foundation: ShiftHandoverNotes/SessionSummaries/NotificationRules (Sprint 015d) — closes the 015a/b/c/d split
- `ShiftHandoverNotes`/`SessionSummaries` got the standard treatment (required `siteId`, backfilled to the default site, non-nullable domain model) — both describe something that happened at one specific venue.
- `NotificationRules.siteId` is nullable in both the DB column and the domain model, and — unlike every other table in this effort — pre-existing rows were deliberately **excluded** from `_backfillSiteIds()` rather than backfilled to the default site. Sprint 014-era rules meant "applies everywhere" before Site existed; backfilling them to one specific site would have silently narrowed their scope. Leaving them `NULL` preserves that original org-wide meaning.
- New rules created via `notification_rules_screen.dart`'s form default to the creator's own site (`setBy.siteId`), not org-wide — no UI toggle for "applies to all sites" was built this sprint; that's deferred alongside the already-queued Notification refinements work.
- Caught and fixed a real bug during this sprint's own build, before verification: `_setActive`'s first draft passed `siteId: rule.siteId ?? setBy.siteId`, which would have silently converted an org-wide rule to site-specific the moment anyone deactivated/reactivated it. Fixed to `siteId: rule.siteId` (preserve whatever the rule already had, null included) — now covered by a repository test.
- All three call sites (`end_of_session_summary_screen.dart`'s `_finish`/`_sendToManager`, `notification_rules_screen.dart`'s `_saveRule`/`_setActive`) already held a site-bearing `User`, same as 015c — `currentSiteProvider` still hasn't been needed by any cluster after 015b's wizard.

## Notification firing (Sprint 016) — resumes the sprint paused for the multi-site foundation
- No `Notification`/`TriggerNotification` entity existed before this sprint — Sprint 014 built only `NotificationRule` (the configuration). Confirmed this by reading the schema fresh before planning, not assuming from the task description's framing. Built the full stack from scratch: `TriggerNotifications` table, model, repository (`create`/`watchForUser`/`acknowledge` all built now even though the read/acknowledge sides sit unused until the inbox sprint).
- `TaskSubmissionRepository.submit()` changed from `Future<void>` to `Future<int>` (surfacing the already-computed inserted row id) — needed so a `TriggerNotification` can link back to the submission that caused it. This touched a file outside the originally-approved list; flagged and confirmed before building rather than added unilaterally.
- Matching: active `NotificationRules` where `taskTemplateGroupId` is null or matches the failed task, AND `siteId` is null (org-wide) or matches the submission's site.
- Precedence: matching rules are grouped by their exact `taskTemplateGroupId` (null/"any" is its own group). Within a group, an active top-tier rule suppresses mid-tier rules in that same group — this is the concrete algorithm chosen to implement PROJECT_BIBLE's "top tier can override mid-tier notification settings," confirmed with the user since no exact algorithm was ever specified.
- Fan-out: a rule targeting a specific user creates one `TriggerNotification`; a rule targeting a role tier fans out to every user in that tier — scoped to the submission's site if the rule is site-specific, or across all sites if the rule is org-wide (null `siteId`).
- `notificationRuleId` on `TriggerNotification` references the specific rule *version* active when it fired, not the `ruleGroupId` — preserves exactly what config caused the notification even if the rule is edited later, matching this project's immutable-audit-trail philosophy.
- `channelPush`/`channelEmail` still do nothing — no backend exists. Carrying forward Sprint 014's "configuration intent only" decision unchanged now that real firing exists.
- `TaskController` gained three new constructor dependencies (`NotificationRuleRepository`, `TriggerNotificationRepository`, `UserRepository`) via the same explicit-DI pattern already used throughout — `task_screen.dart`'s `initState` is the only construction site and was updated accordingly.
- Verified with a repository/controller-level test covering: no rules → no notifications; a site-matching rule fires; a rule scoped to a different site does not fire; a top-tier rule suppresses a mid-tier rule in the same trigger scope; PASS submissions never fire anything; specific-person targeting works independently of tier fan-out. All passed. Also ran a real Windows debug build against the existing dev database confirming the schemaVersion 13→14 migration (new table, no backfill needed) executes cleanly.
- No in-app inbox UI yet — deferred to the next sprint (017), per the agreed two-sprint split. Notifications are being created but nothing surfaces them to a manager/top-tier user yet.

## Notification refinements (queued after multi-site foundation + notification firing)
- Per-equipment/task-specific fail notifications: a "specific fail notifications" section where a manager picks which equipment/task fails trigger which tier, via two checkboxes per rule (left = notify top tier, right = notify mid tier). Refines Sprint 014's deliberately-simple "specific template or global any" scoping.
- Third-party contacts: a section where top/mid tier can add external/internal maintenance and repair contacts, who can also be notified (or have details on file) in an emergency.

## Open / Not yet decided
- Task priority: the checklist uses 3 levels (Critical/High/Standard); TaskTemplate currently only has a binary `isCritical`. Needs a decision before the real task library gets loaded — add a 3-level field, or accept the information loss of mapping down to the boolean.
- Task method vocabulary: the checklist's real methods (Tick, Data+Tick, Tick+Photo, Data+Photo, Note, Note+Photo, Tick+Note, Multi) don't fully match the placeholder `method` strings used in Sprint 007/009's example data. Needs reconciling when the real library loads.
- Task frequency vocabulary: the checklist uses frequencies (3x daily, per batch, per delivery, per use, 2x per service, event-based, as-needed) broader than Sprint 009's 4-value enum. Workable via `custom` + free text for now, but worth a decision on whether to expand the enum later.
