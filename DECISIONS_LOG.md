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

## Notifications inbox (Sprint 017) — completes the 016/017 split
- Exact mirror of Sprint 013's `SessionSummaries` banner pattern: a `StreamBuilder` on `TriggerNotificationRepository.watchForUser(currentUser.id)`, rendering a private `_TriggerNotificationsBanner` (all notifications shown, each with an "Acknowledge" button or a green checkmark once acknowledged).
- Notifications banner placed above the Session Summaries banner on `ManagerScreen` (both banners now stack) — a FAIL that just happened is more time-sensitive than an end-of-shift report. Minor UX ordering call, not flagged as needing separate approval since it's within the already-approved scope.
- `_TriggerNotificationsBanner` is duplicated in both `manager_screen.dart` and `top_screen.dart` rather than extracted to a shared widget — matches this project's established pattern of duplicating small per-screen UI elements (icon buttons, banners) rather than abstracting across ManagerScreen/TopScreen.
- `TopScreen`'s body was restructured from a bare `Center` to a `Column` (banner + `Expanded` placeholder) to accommodate the new banner — the first real body content TopScreen has had beyond its placeholder text, needed to fit this sprint's scope, not a redesign.
- Red-tinted banner (`Colors.red.shade50`) instead of Session Summaries' amber, to visually distinguish the two and match this app's existing red-for-FAIL convention (e.g. the FAIL button on the task screen).
- Given the pumpAndSettle hang encountered in Sprint 014's widget test, this sprint verified the underlying repository behavior directly (`watchForUser` streams only the addressed recipient's notifications; `acknowledge` correctly sets `acknowledged`/`acknowledgedAt`) rather than attempting a full widget test. A real Windows run confirmed both restructured screens render without runtime errors. Interactive visual confirmation of the banner's actual appearance was not independently exercised — left the app running on-device for a manual look, same disclosed limitation as Sprint 014's rule screen.

## Per-task quick-setup notifications (Sprint 018) — first of the queued notification refinements
- Task-template-level granularity, not equipment-instance-level — a row per `TaskTemplate`, matching the schema exactly as Sprint 014 built it. Equipment-instance-level scoping (e.g. "Fridge 1" vs "Fridge 2" separately) was flagged as a real alternative reading of "equipment/task fails" but confirmed out of scope for this sprint — it would need a new `equipmentInstanceId` column plus a `TaskController` matching-logic change, materially bigger than a UI addition.
- All current task templates shown, no filtering by `isCritical`/`requiresCorrectiveActionOnFail` — confirmed, consistent with the existing "Add Rule" form's dropdown which also doesn't filter.
- Sits alongside the Sprint 014 "Add Rule" form, not a replacement — the grid can't express "any task fail" or specific-person targeting, so the form stays for those cases. Rules created either way are ordinary `NotificationRule` rows, indistinguishable in the existing rule list.
- No new repository methods or schema — the grid derives checkbox state by scanning the already-loaded current-version rules for a match on `(taskTemplateGroupId, targetRoleTier, targetUserId: null)`, and toggles via the exact same `saveNewVersion`-with-`ruleGroupId` versioning mechanism `_setActive` already uses. Toggling preserves the existing rule's channels/site if one is found, or defaults to the setter's own site with both channels off if creating fresh.
- Given this exact screen has now hit an unresolved `pumpAndSettle()` hang twice before (Sprints 014 and 017), verified the new toggle logic at the repository level instead — a temporary test replicating the toggle function's exact behavior (not the widget) confirmed: first toggle creates a fresh rule; toggling off then on again reuses the same `ruleGroupId` rather than creating a duplicate group, and preserves the original site. A real Windows run confirmed the screen renders without error; interactive visual confirmation of the grid wasn't independently exercised — left the app running on-device for a manual look.

## Third-party maintenance contacts (Sprint 019) — completes the notification refinements backlog
- A new `ThirdPartyContact` entity, not previously named in ARCHITECTURE_LOCK's Core Entities list — added to that list as part of this sprint (name, company, specialty, phone/email, directory-only, distinct from `User`) rather than left undocumented.
- Directory only, not wired into `NotificationRule` — a contact isn't a `User` (no login, no role tier), so it can't be a `targetUserId`. A manager sees a trigger fire, looks the contact up here, and calls/emails them manually. Confirmed with the user before building, not assumed.
- `specialty` is free text (e.g. "Refrigeration", "Electrical"), not a structured link to `EquipmentType` — avoids a join table for a feature not wired into any automated matching.
- Simple `active` toggle, not full append-only versioning — treated like `Area`/`EquipmentInstance`/`TaskSchedule`, not like `NotificationRule`/`TaskTemplate`. A contact's phone number changing isn't audit-sensitive the way rule precedence is.
- `siteId` nullable, same null-means-org-wide pattern as `NotificationRule.siteId` — a contact can be specific to one site or visible everywhere.
- New screen placed under the existing (previously unused, reserved-for-later per Sprint 003) `lib/features/settings/` folder rather than adding a new top-level folder — avoids amending ARCHITECTURE_LOCK's Folder Structure Rule for a single small screen.
- Add-only + active/inactive toggle, no edit form — matches Sprint 008's established v1-scope precedent for Areas/Equipment.
- Verified with a repository-level test: creating a contact with neither phone nor email throws (mirrors `NotificationRule`'s "must have a target" validation); phone-only and email-only both succeed; org-wide (`siteId: null`) vs. site-specific both store correctly; `setActive` toggles correctly. A real Windows run confirmed the v14→v15 migration executes cleanly against the existing dev database.

## Local data backup/export (Sprint 020) — first feature audit priority
- Raw SQLite file copy, not a structured (JSON/CSV) export — deliberately distinct from PROJECT_BIBLE's separate, later "Inspection data export" item, which serves a different audience (inspectors reading a report) rather than disaster recovery (getting the exact data back onto a replacement device). Confirmed with the user before building, not conflated.
- Implemented via SQLite's `VACUUM INTO ?` (a parameterized `customStatement` on `AppDatabase`) — produces a complete, consistent, compacted snapshot safely while the live connection stays open, avoiding WAL-corruption risk from a naive file copy. Verified with a test that opens the resulting file as an independent sqlite database and confirms it contains real data.
- Export only this sprint, not restore — restore is destructive (overwrites whatever's on the target device) and riskier to do safely while the app has the live file open. Treated as a separate future sprint.
- No file-picker dependency added — the backup auto-saves to a `KitchenControlBackups` folder under the user's Documents (via the already-present `path_provider`/`path` dependencies, both now used directly in app code for the first time) with a timestamped filename, and the resulting path is shown to the manager in a confirmation dialog. Actually moving the file to a USB drive/cloud folder stays a manual step.
- No "last backup" staleness reminder this sprint (would need a small persisted timestamp or a new dependency) and no retention/cleanup of old backup files — both flagged as possible future refinements, not built now.
- Per the user's explicit instruction: the confirmation dialog has an optional "Backup name" text field (e.g. "Pre-inspection backup"); when given, it's folded into the filename *alongside* the timestamp, not in place of it — confirmed the filename always sorts chronologically in a file browser regardless of whether a custom name was given.
- No schema change, no migration, no schemaVersion bump — this is new application code over the existing database, not a new table.
- Dialog logic (`_showBackupDialog`) is duplicated as a private top-level function in both `manager_screen.dart` and `top_screen.dart`, matching this project's established pattern of duplicating small per-screen logic rather than sharing it across ManagerScreen/TopScreen.

## Feature audit priorities (from FEATURE_AUDIT.md, added as new sprints)
1. Data backup/export - local drift DB only lives on one device; losing it loses compliance history. Highest priority.
2. Edit/retire for Areas/Equipment - no way to handle equipment replacement (e.g. broken fridge) without losing submission history
3. Notification escalation on non-acknowledgment - a fired trigger with nobody acting on it defeats the purpose
4. Three task-taxonomy gaps (already logged) - blocking real 100+ task library
5. PIN reset + staff deactivation flow - basic day-one operational need
Full detail and lower-priority items in FEATURE_AUDIT.md (now in project root alongside DECISIONS_LOG.md).

## Standing design rule: custom naming
- Every feature that lets a user create a new entry/element (notification rules, backups, venues/sites, areas, tasks, future entities, etc.) should let them enter and save a custom name for it - not just an auto-derived label. Applies going forward to any new creation feature.
- EXPANDED: naming must also be EDITABLE after creation, not just set once at creation time - a manager should be able to rename something later, not just name it on the way in.
- Real gaps already found:
  - NotificationRule has no name field - identified only by task+tier. Needs a nullable name field.
  - Site/Organisation currently auto-seeded with placeholder names ("My Organisation"/"Main Site") with NO UI to rename them at all. Real gap - a venue should be able to set its own name, not live with a placeholder forever.
  - Areas and EquipmentInstances have names set at creation (venue setup wizard) but are add-only - no edit/rename capability yet (also already flagged in FEATURE_AUDIT.md priority #2).
  - TaskTemplates already have a title field and are versioned, so "editing the name" already works via the existing versioning mechanism - no gap here.
- None of this blocks the in-progress backup/export sprint - these are separate, queued gaps to address when each entity is next touched, not urgent enough alone to justify individual sprints yet. Site/Organisation naming is probably the most user-visible one and worth prioritizing relatively soon.

## Parked features (decided, deliberately not built - revisit only when there's real need)
- Regional tier (top->regional->venue mid/base for large multi-branch operators) - schema foundation supports adding this later, but the tier itself isn't built
- Equipment-instance-level notification targeting (per-specific-fridge, not just per task type) - Sprint 018 built the simpler task-level version
- Restore from backup - Sprint 020 built export only, restore deferred to its own future sprint (meaningfully riskier)
- Backup staleness reminder ("haven't backed up in X days") - v1 is a manual button only
- Backup retention/cleanup - no auto-deletion of old backups, manual via Explorer
- Site-switcher UI - not needed until a second real site exists
- Third-party contacts wired into automated notification firing - manual-lookup directory only, not an automated dispatch target
- Brand entity (Organisation -> Brand -> Site) - deferred to whenever real branding work happens
- Task-library site-editing (per-site version of the library vs. one shared library) - real gap against PROJECT_BIBLE wording, accepted as out of scope for the multi-site foundation
- Generic if/then rule engine for tasks - Sprint 007 built minimal structured fields instead, full engine deferred unless a real task needs it
- getAll() siteId-filter parameter on repositories - not needed until there's more than one site to filter by

## Areas/EquipmentInstances rename + retire (Sprint 021a) — first half of closing the add-only gap
- Confirmed directly against ARCHITECTURE_LOCK's Versioning Rule before building: `Area`/`EquipmentInstance` aren't named among the entities requiring append-only versioning (`TaskTemplate`, `LegalLimitReference`, `NotificationRule`, `BrandingConfig`), and aren't task-library configuration in that sense. Rename and retire are both plain mutable `UPDATE`s, consistent with the lock, not a violation — checked, not assumed.
- `EquipmentInstances` had no `active` column at all before this sprint — added (`boolean().withDefault(const Constant(true))()`, a normal `addColumn` with a compile-time default, so existing rows get `true` automatically, no backfill loop needed unlike the earlier nullable-FK `siteId` additions).
- Retiring an equipment instance cascades: it deactivates any `TaskSchedules` currently pointing at that `equipmentInstanceId` (so staff stop being asked to check equipment that no longer exists), while `TaskSubmissions` history is untouched (immutable, never re-validated against current equipment state). Reactivating does **not** restore those schedules — re-assignment is a deliberate, separate manager action via the staff assignment screen. Verified with a repository test covering exactly this asymmetry.
- Retiring shows a confirmation dialog (cascading effect, real consequence); renaming does not (non-destructive). `staff_assignment_screen.dart`'s equipment picker now excludes retired instances from new assignments.
- Retired instances stay visible in the venue setup wizard's Equipment list (greyed, labelled "(retired)") with a Reactivate action, rather than being hidden — matching how inactive rows are already shown elsewhere (`NotificationRulesScreen`, `ThirdPartyContactsScreen`).
- Site/Organisation rename (the second half of the original ask) is deliberately a separate sprint (021b) — different tables, different (currently nonexistent) screen, agreed upfront as a two-sprint split.

## Site/Organisation rename (Sprint 021b) — completes closing the add-only gap
- New `lib/features/settings/venue_details_screen.dart` — the first screen to ever surface Organisation/Site data to a user; previously only read internally via `getDefault()`. Shows the current org/site name each with a rename action — not a list, since only one of each exists in practice today (no multi-site UI yet).
- Same plain-mutable-`UPDATE` `rename()` pattern as Sprint 021a's Areas/EquipmentInstances, for the same reason (checked against ARCHITECTURE_LOCK's Versioning Rule in 021a's planning — neither entity is in the list requiring append-only versioning).
- New "Venue Details" icon added to both `ManagerScreen`/`TopScreen`, placed directly next to the existing "Venue Setup" icon (same logical grouping — venue configuration) rather than at the end of the action list.
- Closes the "Site/Organisation currently auto-seeded with placeholder names... NO UI to rename them at all" gap flagged in the Standing design rule: custom naming section — placeholders can now be renamed to a venue's real name.
- Verified with a repository-level test confirming both the default Organisation and Site rename correctly and the new names persist on re-read. `flutter analyze` clean; no schema change this sprint. A real Windows run confirmed the new screen and icons render without error.

## Notification escalation (Sprint 022) — third feature audit priority
- Fixed global 30-minute threshold, not per-rule configurable — matches this project's repeated "ship the simple version, defer richer config" pattern (Sprint 009's frequency enum, Sprint 020's no-staleness-reminder). Per-rule configurability is a real, separable future refinement, not built now.
- Escalation is both: (a) a brand-new `TriggerNotification` addressed to every top-tier user at the same site, for any unacknowledged notification whose firing rule targeted mid tier or a specific person; and (b) visual re-surfacing (elapsed time + bold/red styling) in the existing banners for any unacknowledged notification past the threshold, regardless of tier.
- Per explicit correction during planning: specific-person-targeted notifications escalate to top tier exactly like mid-tier-targeted ones — a single named recipient not seeing it is exactly the case escalation exists for. Only notifications whose firing rule already targeted top tier get visual-only treatment, since there's nobody further up to escalate to.
- Which category a notification falls into is denormalized onto a new `TriggerNotification.originTargetRoleTier` field at creation time (null for specific-person targets, same as mid-tier) rather than looked up from the rule later — `notificationRuleId` points at the rule version that fired, which may since have a newer version, so this avoids a repository lookup back to a rule the escalation check doesn't otherwise need.
- Mechanism: no backend/background service exists, so escalation is only checked while `ManagerScreen`/`TopScreen` is open in the foreground — a `Timer.periodic` (60s) plus one check on load. Real, disclosed limitation: if nobody has either screen open, nothing escalates. No realistic alternative exists for a purely local app.
- A new `TriggerNotification.escalatedAt` marks a notification once it has triggered an escalation, so the periodic sweep never double-escalates the same one. Pre-existing (pre-Sprint-022) unacknowledged rows migrate with both new columns null, which is treated as escalate-eligible — the conservative default, since a null `originTargetRoleTier` is indistinguishable from (and handled identically to) a specific-person target.
- Escalation fans out to top-tier users at the original notification's own `siteId` (the site where the failure actually happened) — mirrors the existing fan-out site-scoping convention already used when a rule first fires (Sprint 016), rather than introducing a new precedent.

## Task-taxonomy reconciliation (Sprint 023) — fourth feature audit priority
- Priority: added a nullable 3-level `TaskPriority` (`critical`/`high`/`standard`) field alongside the existing `isCritical` boolean, which is left completely untouched — confirmed by grep before building that nothing in the app currently branches on `isCritical` for behavior (corrective-action gating uses the separate `requiresCorrectiveActionOnFail` flag instead), so this reconciliation carried very little risk. Existing rows get `priority: null` on migration (can't be reconstructed from a boolean without guessing High vs. Standard); `TaskTemplate.effectivePriority` falls back to deriving Critical/Standard from `isCritical` for those rows, matching PROJECT_BIBLE's own documented fallback mapping.
- `TaskTemplateRepository.saveNewVersion`'s `required bool isCritical` parameter was replaced with `required TaskPriority priority`, which derives `isCritical: priority == TaskPriority.critical` internally at write time — one source of truth rather than two independently-supplied fields that could desync (the same class of bug caught and fixed in Sprint 015d for `NotificationRule.siteId`). Confirmed as the recommended option before building, not decided unilaterally.
- Method: replaced the custom-task form's 3 placeholder options (`numeric_photo`/`categorical_choice`/`notes_only`) with the checklist's real 8 values (Tick, Data + Tick, Tick + Photo, Data + Photo, Note, Note + Photo, Tick + Note, Multi), stored as the same free-text `method` column — no schema change, since nothing branches on `.method`'s value anywhere in the app (confirmed by grep) and it's only ever set through this one closed dropdown, which already structurally enforces the real vocabulary. Default changed from the old numeric-photo-flavored value to `'tick'`, the simplest real method.
- The one seeded example template ("Check Fridge Temperature") updated to `method: 'data_photo'` (numeric reading + required photo) and `priority: 'critical'` explicitly, matching its existing `isCritical: true`.
- Pre-existing real custom task templates created under the old 3 placeholder `method` strings keep those exact values — no backfill, since nothing displays or branches on them, so there's no visible or behavioral consequence.
- Frequency: expanded `ScheduleFrequency` in place with 7 new values (`threeXDaily`, `perBatch`, `perDelivery`, `perUse`, `twoXPerService`, `eventBased`, `asNeeded`) alongside the existing `daily`/`weekly`/`perShift`/`custom` — no schema change, since the column already stores `.name` as text and existing rows parse identically via `.byName`. Added a `frequencyLabel()` helper so the assignment screen's dropdown shows "3x Daily"/"Per Batch"/etc. instead of raw camelCase (which is what it displayed for the original 4 values too, e.g. "perShift" literally) — applied across all 11 values for consistency.
- Deliberately data-model-only, per the approved plan: `ResolvedTask`/`task_controller.dart`/`task_screen.dart` are unchanged — the new 3-level priority isn't surfaced to staff during task execution this sprint, matching how `isCritical` itself has never been surfaced there. Wiring real behavior on top of priority (e.g. a "CRITICAL" badge, escalation tied to priority) is deferred until something concretely needs it.
- Loading the actual ~100+ task rows from "Full check list.docx" remains a separate, later effort — this sprint only fixes the vocabulary they'll load into.

## PIN reset + staff deactivation (Sprint 024) — fifth feature audit priority, closes out this list
- New `lib/features/settings/staff_management_screen.dart` — fulfils Sprint 003's deferred item ("Real staff CRUD is deferred to a later Settings-feature sprint"). Deliberately separate from `staff_assignment_screen.dart`, whose stated purpose is task assignment, not account administration — matches how Site/Organisation and third-party contacts each got their own `settings/` screen rather than overloading an existing one.
- PIN reset: a manager/top-tier user types a new PIN directly (no old-PIN confirmation), via `UserRepository.resetPin()` — reuses the existing salted-hash machinery from staff creation. Consistent with the existing staff-creation PIN field: no format validation added (staying consistent with what's already there, not scope-creeping into new validation).
- Deactivation: `Users` gains `active` (boolean, default `true`) — confirmed against ARCHITECTURE_LOCK's Versioning Rule first: `User` isn't in the list requiring append-only versioning, so a plain mutable `UPDATE` is correct, same as `Area`/`EquipmentInstance`/`ThirdPartyContact`.
- `Users` also gains `deactivatedAt` and `deactivatedByUserId` (not just a plain boolean) — added per explicit instruction, since staff deactivation is more HR/compliance-sensitive than equipment retirement and is worth having on record. **Confirmed via a direct question rather than assumed:** these two fields are deliberately **preserved on reactivation, not cleared** — "when/who last deactivated this person" stays on record even once they're active again, only overwritten if they're deactivated again later. This is a real behavioral choice, not an obvious default, and differs from how `acknowledgedAt`/`escalatedAt` elsewhere in this app describe only the *current* state.
- Deactivation cascades exactly like Sprint 021a's equipment retire: `UserRepository.setActive()` also deactivates that user's own active `TaskSchedules` (`assignedUserId` match) when deactivating, so a manager doesn't see someone who can't log in as still assigned. Reactivating does **not** restore those schedules — same deliberate asymmetry, same reasoning (re-assignment is a separate manager action).
- Three places needed to actually respect `active`, or this would have real gaps: `staffDirectoryProvider` (login screen's staff list) now filters to active-only; `UserRepository.authenticate()` rejects a correct PIN if the user is inactive (defense in depth, not just a UI-level filter); `staff_assignment_screen.dart`'s staff picker excludes inactive staff from new assignments, mirroring how retired equipment is already excluded there.
- No special handling for a deactivated user who's still the `targetUserId` of a `NotificationRule` or has pending unacknowledged `TriggerNotification`s — confirmed as an accepted, not-fixed-now gap (they simply can no longer log in to see/acknowledge anything addressed to them).
- Verified with a temporary repository-level test (deleted after, not part of this commit): `resetPin` changes the PIN without needing the old one, and the old PIN stops working; deactivating a user blocks login even with the correct PIN, cascades to deactivate their active schedule, and — after reactivating — restores login while the schedule stays deactivated and `deactivatedAt`/`deactivatedByUserId` remain populated (not cleared). `flutter analyze` clean. A real Windows debug run confirmed the schemaVersion 18→19 migration executes cleanly against the existing dev database. Interactive click-through of the new screen's dialogs was not independently exercised — left the app running on-device for a manual look.
- This closes out the full "Feature audit priorities" list (data backup/export, equipment edit/retire, notification escalation, task-taxonomy reconciliation, PIN reset + staff deactivation) — all five are now built. Remaining FEATURE_AUDIT.md items are lower-priority per its own ranking (bulk assignment, due/overdue tracking, multi-site UI, search, admin audit log viewer, etc.), not yet scheduled.

## Create new venue + minimal site context (Sprint 025) — first half of branding/multi-site work, split from Sprint 026 (branding)
- ⚠️ **MULTI-SITE IS NOT FULLY USABLE AFTER THIS SPRINT — READ BEFORE CREATING A SECOND VENUE.** This sprint makes creating a second `Site` *safe* (it no longer silently corrupts the original venue's setup), but does **not** make managing two venues day-to-day *usable*. `Area`/`EquipmentInstance`/`TaskSchedule`/`User` reads (`getAll()`-style queries) remain completely unfiltered by site, exactly as decided in Sprint 015b ("not needed until there's more than one site to filter by") — that condition is now true, and the follow-up work to filter those reads has **not been done yet**. Concretely: once a second venue exists, `staff_assignment_screen.dart`'s staff/equipment pickers, `venue_setup_wizard_screen.dart`'s Area/Equipment lists, and `staff_management_screen.dart`'s staff list will all show **both venues' data mixed together indiscriminately**, with no way to tell which row belongs to which site. Do not create a second real venue expecting day-to-day multi-site operation to work — only do so once the site-filtered-reads follow-up sprint has shipped.
- Found and fixed the specific landmine that made creating a second site actively dangerous rather than just incomplete: `SiteRepository.getDefault()` (and `currentSiteProvider`, which just wraps it) always resolves "the first site by id." `venue_setup_wizard_screen.dart`'s three create call sites (`_addArea`/`_addEquipment`/`_addStaff`) relied on this exclusively — meaning every new area/equipment/staff member created through the wizard would have silently landed on the *original* site forever, no matter which venue a top-tier user thought they were configuring, with zero indication anything was wrong. This was discovered and flagged before building, not worked around silently.
- Minimal fix, not a full site-switcher: new `activeSiteProvider` (`StateProvider<Site?>`, defaults `null`). The wizard's three call sites now resolve `activeSiteProvider ?? currentSiteProvider`'s default — so every existing single-site install behaves byte-for-byte identically (the provider stays null forever unless someone explicitly sets it). Only once a top-tier or mid-tier user explicitly selects a site via `venue_details_screen.dart`'s new "Set as Active" action does new-item attribution follow that selection.
- `venue_details_screen.dart` rebuilt: now lists *all* sites (previously showed only the first/default one), each with rename (available to both tiers, matching Sprint 021b's existing precedent) and a "Set as Active"/"Active" indicator. "Create New Venue" is **top-tier only** — creating a new venue is a company-expansion decision, not a day-to-day mid-tier action; this is the first time this app has scoped a config action to top tier alone rather than mid+top, a deliberate departure confirmed before building (also see Sprint 026's branding screen, which does the same).
- The create-venue dialog itself repeats the "multi-site is partial" warning in-app, at the point of creation — not just in written docs — so a top-tier user can't create a second venue without seeing the limitation first. Reuses `Site`'s existing fields (name, address) — no schema change this sprint.
- `SiteRepository.getDefault()` itself is deliberately left unchanged (still "first by id") — every existing single-site read path continues to work exactly as before; the new `activeSiteProvider` is additive, not a replacement.
- Verified with a temporary repository-level test (deleted after, not part of this commit): creating a second site correctly adds it under the existing Organisation without disturbing the original site, and `getDefault()` still resolves to the original first site afterward (not the new one) — confirming existing single-site call sites are unaffected. `flutter analyze` clean. No schema change, no migration. A real Windows run confirmed the rebuilt Venue Details screen and the wizard's updated call sites render and run without error. Interactive click-through of the create/rename/set-active dialogs was not independently exercised — left the app running on-device for a manual look.
- Deferred to a genuinely separate future sprint: site-filtered reads across `Area`/`EquipmentInstance`/`TaskSchedule`/`User` repositories and their consuming screens — this is what actually makes a second venue usable, not just creatable, and is materially bigger than this sprint (touches most repositories in the app). Branding (Sprint 026) is unrelated to this gap and doesn't depend on it.

## Open / Not yet decided
- All three task-taxonomy gaps (priority, method, frequency) logged here since Sprint 012 are now resolved — see "Task-taxonomy reconciliation (Sprint 023)" above. Loading the real ~100+ task rows from "Full check list.docx" using this now-correct vocabulary remains a separate, later effort.
- Multi-site is only partially usable: creating a second `Site` is safe (Sprint 025), but `Area`/`EquipmentInstance`/`TaskSchedule`/`User` reads are not yet filtered by site, so two venues' data currently displays mixed together in shared lists. Needs its own sprint before real day-to-day multi-site use is viable.
