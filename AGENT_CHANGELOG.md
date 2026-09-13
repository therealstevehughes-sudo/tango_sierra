# Agent Change Log

## Purpose

This file records work completed by assisting coding agents so future agents can understand what changed, why, and what remains open.

## Session: 2026-09-13 (sixth)

### Photo evidence P0 — real capture, on-disk persistence, PDF embed (`2696b12`)

Sprint 032 P0 (build order item 1, per `PHOTO_EVIDENCE_PLAN.md`): the
anti-fraud promise is now real — `TaskSubmission.photoPath` is actually
written by a real camera capture, not a boolean toggle.

- **`pubspec.yaml`** — `image_picker: ^1.1.2` (the ONLY new dependency
  this sprint; the earlier session's draft had it listed twice — deduped).
- **`lib/core/services/evidence_store.dart`** (new) — `EvidenceStore`:
  camera-first capture with explicit gallery fallback, copies JPEG bytes
  into `<app documents>/evidence/`, returns a stable path; `readPhotoBytes`
  is best-effort (null on missing/unreadable, never throws). Provider
  `evidenceStoreProvider`. Files on disk, never BLOBs in Drift.
- **`lib/features/tasks/task_screen.dart`** — "Add Photo" now runs a real
  capture; disabled once taken; `photoPath` flows through
  `logTaskSubmission`; reset between tasks.
- **`lib/features/tasks/task_controller.dart`** — `logTaskSubmission`
  accepts + forwards `photoPath`.
- **`lib/features/export/eho_export_service.dart`** — preloads photo bytes
  in `generate()` (async I/O kept out of the synchronous layout pass); the
  full detailed log embeds the actual image (96px, BoxFit.cover) with the
  task title as caption. Corrupt/missing bytes degrade to the
  `[Photo attached]` marker — never breaks the export. Limitations notice
  updated to state photos are now embedded when the full log is included.
- **`ios/Runner/Info.plist`** — `NSCameraUsageDescription` +
  `NSPhotoLibraryUsageDescription` keys (required by image_picker on iOS).

No Drift migration needed (`photoPath` column already existed). Validation:
`flutter analyze` clean; all 14/14 tests passing; committed + pushed.

**Open / deferred (by design):** photo "Back up now → free space" prune
manager is P1, deliberately not built this sprint.

## Session: 2026-09-13 (fifth)

### VenuRite branding — logo assets, branded entry screens, native splash

Wired the VenuRite logo set (square, favicon, long transparent, long
white-bg — user-supplied, `assets/logos/`) into the app and platforms:

- **Assets + web branding** — `assets/logos/` registered in `pubspec.yaml`; `web/index.html` now VenuRite-titled with the VenueRite favicon; `web/manifest.json` VenuRite-branded (teal `#0E6B6C`, favicon icon).
- **App title** — `lib/app/app.dart` `MaterialApp.title` `'Kitchen Control'` → `'VenuRite'`; Windows runner window title `'flutter_application_1'` → `'VenuRite'`.
- **Shared `BrandHeader`** (`lib/core/widgets/brand_header.dart`, new) — agreed layout (user review, 2026-09-13): the **VR square mark top-left (72px, full opacity)** as a "built with" signature; the **client branding centred as the dominant element** — client company logo (64px, sizing confirmed via a temporary brain-logo stand-in) + company name + branch name. Used by:
  - `lib/features/auth/login_screen.dart` — branded header above the staff list / fresh-install entry (pre-auth: default org branding only, no branch name yet).
  - `lib/features/home/tier_home_screen.dart` — replaced inline `Image.file(logoPath)` + branch-name block with the shared widget (post-auth: org branding + current branch name).
- **Native splash (square VR logo)**:
  - Android — teal `values/colors.xml` (`venuerite_splash_bg` #0E6B6C), `drawable-nodpi/venuerite_splash.png`, both `launch_background.xml` (drawable + drawable-v21) centered on teal, and Android 12+ `values-v31/styles.xml` SplashScreen API (teal bg + VR square icon).
  - iOS — `LaunchImage` 1x/2x/3x regenerated from `VR_square.png` (320/640/960, bilinear-resized transparent), `LaunchScreen.storyboard` background → brand teal so the transparent logo sits cleanly.
  - Windows — window title only (no native splash image on Windows Flutter runner; blank-window phase kept).
- Pure presentation/asset changes: **no** logic, permissions, auth, repositories, migrations, or backend behavior touched.

Validation: `flutter analyze` clean; all 14/14 widget/unit tests passing; `flutter build windows --debug` succeeded (574s, first full rebuild post `flutter clean`) and the app launches to the branded login screen.

### Disk cleanup (continued)

- Deleted Android emulator AVD (`Pixel7_API36`), both system images
  (android-35/36.1), and the NDK — **~11.1 GB**; Android SDK now ~2.5 GB.
  Earlier: `flutter clean` (~2.2 GB), stale Gradle dists (~1 GB), %TEMP%
  (~0.6 GB). Total **~14.9 GB** freed this session.

## Session: 2026-09-12 (fourth)

### Visual-consistency pass — shared alert banner + drill-down + theme-token sweep

Picked up and completed the in-progress Guided Cards visual-consistency pass
found uncommitted in the working tree (the previous session ended mid-pass
without committing; `HANDOFF_NEXT_CHAT.md` predates this work). Committed as
`5b51367`:

- `lib/core/widgets/trigger_notifications_banner.dart` (new) — the
  duplicated `_TriggerNotificationsBanner` from `manager_screen.dart` +
  `top_screen.dart` extracted into one shared widget. Two screens use it
  with deliberately different row behavior via an optional `onRowTap`:
  the manager screen wires the alert→task drill-down; the top-tier screen
  leaves rows plain. The chrome (count, unacknowledged count, OVERDUE
  treatment, escalation note, acknowledge action) is identical.
- `lib/features/manager/manager_screen.dart` — alert rows are now tappable
  (InkWell → `_showAlertDetail`): "There's an alert" becomes "which task,
  which equipment, who, is it handled" in one tap. Resolves the failed
  submission from the already-watched list; falls back to a lightweight
  detail dialog for old FAILs filtered out of the default view.
- `lib/features/dashboard/top_screen.dart` — now uses the shared banner
  (rows remain non-tappable there).
- **Theme-token sweep** across 9 screens — hardcoded `fontSize` /
  `Colors.red` / `Colors.grey` replaced with `Theme.of(context).textTheme`
  + `AppColors` (`critical`, `muted`, `tealInk`, `pass`): senior login,
  dashboard low-logging chip, manager screen, overdue summary card,
  problems register, training records, reorder tasks, task screen.
  Translation-safe sizing; no logic/permissions/repo/backend changes.
- `test/trigger_notifications_banner_test.dart` (new) — 5 widget tests:
  tally + unacknowledged count; instance-name prominence lead; ack action;
  OVERDUE past escalation threshold; row-tap only when `onRowTap` wired.

Validation: `flutter analyze` clean; all 14/14 tests passing (5 guided
header + 4 isolation + 5 banner); committed scoped files format-clean.

### Note

This completes the second Guided Cards visual piece (the alert banner +
manager drill-down). The alert banner duplicate that previously lived in
`manager_screen.dart`/`top_screen.dart` is now one widget with a tested
behavioral contract.

## Session: 2026-09-12 (third)

### Guided Cards — worker task header (first guided component)

Built the first Guided Cards component on top of the existing shared
foundation (theme tokens, AppCard, StatusBadge, AppBanner, SectionHeader):

- `lib/core/widgets/guided_task_header.dart` (new) — the guided card header,
  replacing the private `_TaskTitleHeader` in the worker task screen. Adds
  two strictly-informational, anti-skip elements:
  - **Progress line** ("Task 2 of 6") — reads the controller's own
    `currentIndex`/`tasks.length`, so it can never disagree with the
    carousel. Hidden for a single task ("Task 1 of 1" never prints).
  - **Section pill** (segment — "Kitchen", "Dry store") — orients the
    worker to the work area; reuses the neutral teal informational tone
    (never a status colour). Blank segments (custom tasks) hide the pill.
  - Instance-name line + title render exactly as before — the
    compliance-critical "which physical unit" text is untouched.
- `lib/features/tasks/task_screen.dart` — both the active-task card and the
  locked-task card now use `GuidedTaskHeader`. Removed the private
  `_TaskTitleHeader` (~18 net lines). No task logic, permissions, repos,
  or backend behavior changed.
- `test/guided_task_header_test.dart` (new) — 5 widget tests pinning:
  progress/section/instance/title rendering; instance-leads-above-title;
  no overflow on a 360px phone with a long title; identical rendering on
  tablet (600) and desktop (1200) widths; blank-segment custom tasks show
  no pill and no "Task 1 of 1".

### Validation

- `flutter analyze`: No issues found.
- All unit/widget tests: 9/9 passing (5 guided header + 4 isolation).
- `dart format`: clean (2 files auto-formatted).

### Note

This is the first Guided Cards piece, not the whole design: it upgrades the
worker task card's header. The changelog's fuller "screen-by-screen visual
consistency pass" remains — future passes should keep preserving logic,
permissions, repositories, and backend behavior, and validate phone/
tablet/desktop (the header test now pins the phone/tablet/desktop widths).

## Session: 2026-09-12 (second)

### Multi-site isolation — audit and proof

Audited every remaining `getAll()` call site that appeared to risk mixing venues:

- `eho_export_service.dart` — **fixed** (the only genuine single-venue leak): resolve the export's one venue via `getById(siteId)` instead of scanning all sites, and load the venue's staff via `getForSite(siteId)` instead of the whole roster.
- `task_controller.dart` (FAIL notification fan-out), `escalation_service.dart`, `setup_checklist_card.dart` (executive/regional branch counts), `venue_details_screen.dart`, `branch_management_screen.dart`, `staffDirectoryProvider` — **deliberately left unchanged**, each verified as intended cross-site/org-scoped behavior:
  - Org-wide notification rules (siteId null) document *"fan out across every site"* — scoping that read to one site would be a regression.
  - Escalation's person-targeted recipients can legitimately sit at a different site than the notification's own siteId.
  - Executive/regional setup-checklist counts are org-level signals; the backend `getAll()` is already RLS-scoped to permitted sites.
  - Venue Details / Branch Management are org/regional admin screens where seeing all permitted venues is the point.
  - The walk-up "Who are you?" roster remains the logged, deliberate design question (kiosk credential), not a quick fix.

### New: multi-site isolation proof test

- `test/multi_site_isolation_test.dart` — headless, in-memory Drift (`AppDatabase.forTesting`, `NativeDatabase.memory()`), no device, no live backend. Four tests pin the Sprint-1 site-scoping guarantees for Users, Areas, Equipment, and TaskSchedules: two venues are seeded with overlapping names, and `getForSite` must return exactly its own rows. A regression to `getAll()` would fail these loudly.
  Run: `flutter test test/multi_site_isolation_test.dart` (passing).

### Validation

- `flutter analyze`: No issues found.
- Isolation test: 4/4 passing.

## Session: 2026-09-11

### Project context reviewed

- Read the project control documents before recommendations or code changes.
- Read the current `DECISIONS_LOG.md` and `BACKEND_INFRA.md` as the latest project-state references.
- Reviewed the supplied `VENURITE_HANDOFF.md`.
- Confirmed older sprint documents can lag the actual implementation.

### Decisions and recommendations

- Recommended Guided Cards as the strongest visual direction for VenuRite, provided cards are used for meaningful work units rather than every repeated row.
- Recommended keeping distinct presentation patterns:
  - Guided task cards for staff execution.
  - Dense lists for operational logs.
  - Tables for comparisons.
  - Dashboards for leadership signals.
- Recommended completing the visual pass before multi-site usability work.
- Confirmed the next implementation sequence as Guided Cards completion followed by multi-site usability.

### Code changes made

1. `lib/features/onboarding/setup_checklist_card.dart`
   - Replaced raw `Colors.green` with `AppColors.pass`.
   - Replaced raw `Colors.grey` with `AppColors.muted`.
   - This keeps setup status aligned with the shared design system.

2. `lib/features/settings/venue_details_screen.dart`
   - Replaced a hardcoded helper-text font size with the shared theme `bodySmall` style.
   - This keeps warning text consistent with the design system and translation-safe sizing.

3. `lib/features/task_library/preset_management_screen.dart`
   - Replaced a hardcoded verification-banner font size with the shared theme `bodySmall` style.
   - This keeps task-library warning text consistent with the design system.

4. `lib/core/network/supabase_client.dart`
   - Moved the deprecation suppression to the exact `anonKey` argument.
   - Preserved the legacy `anonKey` configuration because the current self-hosted Supabase stack uses the legacy JWT key.
   - No authentication behaviour was changed.

### Validation completed

- Focused analysis of the three visual files: passed.
- File diagnostics for the three visual files: no errors.
- Full `flutter analyze`: passed with no issues after the Supabase suppression fix.
- `git diff --check`: passed before the final Supabase edit.
- A Windows build was attempted but stalled without returning a result and was stopped. No build failure was reported.

### Sprint 1 progress: site-scoped staff and venue setup reads

Added explicit `getForSite(siteId)` reads to the local Drift and backend repository paths for:

- Users.
- Areas.
- Equipment instances.

Updated these screens to use the active site, falling back to the default site:

- Staff Management.
- Venue Setup.
- Assign Tasks.
- Supplier Management.
- Maintenance Contacts.
- Notification Rules target-user picker.
- Setup checklist counts.
- Overdue summary supporting user and equipment reads.

Added explicit `getForSite(siteId)` reads to the TaskSchedule repository paths and changed `OverdueSummaryService` to use them. This removes the final all-schedule load from that site-specific overdue path while preserving its existing active-schedule filtering.

### Sprint 1 completion checkpoint

Finished the remaining site-known operational reads:

- Shift handover latest note now supports site-scoped lookup in local and backend repositories.
- The task carousel resolves equipment instances from the current user's site.
- End-of-session manager choices are limited to managers at the current user's site.
- Reliability dashboard staff lookup uses the site-scoped user repository method.
- Problems, training records, task submissions, suppliers, and EHO export paths were confirmed already site-scoped at their consuming boundaries.

Sprint 1 is complete for the unambiguous site-scoping work. Regional/director cross-site aggregation remains deliberately unchanged pending a product decision about site selection versus permitted-site aggregation.

## Session: 2026-09-12 (continued)

### Task-reorder feature — completed end to end

Building on the uncommitted working tree (schema 36→37, `sortOrder` on
`TaskSchedule` + `Area`), this session:

1. `lib/features/tasks/reorder_tasks_screen.dart` (new — the manager UI)
   - One screen, grouped by Area (venue zones), "Ungrouped" last.
   - Rows show the template title + equipment name + frequency.
   - Move up / down per row; the displayed order is the saved order.
   - Save writes one venue-wide contiguous `sortOrder` sequence (1..n in
     display order), NOT 1..n per group — the worker carousel sorts by a
     single global sortOrder, so per-group restarts would collide across
     areas and produce arbitrary tie-breaks.
   - Site-scoped: operates on the active site (falling back to the
     current user's home / default site). Never mixes venues.

2. `lib/core/widgets/management_drawer.dart`
   - New "Reorder Tasks" drawer item (`swap_vert` icon), venueManager+,
     placed directly after "Assign Tasks" (same tier, edits the same
     recurring TaskSchedule rows).

3. Fixes to the pre-existing uncommitted change set (found via
   `flutter analyze`, which had never been run on it):
   - `area_repository.dart` / `task_schedule_repository.dart`: replaced
     the invalid `OrderingTerm(x.isNull(), mode: ...)` positional calls
     with `OrderingTerm.asc(col, nulls: NullsOrder.last)` — the correct
     drift 2.34 API for "nulls last".
   - `supabase_area_repository.dart`: added the missing
     `setSortOrder` stub (throws `UnimplementedError` — backend column
     deferred, matching `SupabaseTaskScheduleRepository.setSortOrder`).
   - `task_model.dart` + `task_controller.dart`: `ResolvedTask` now carries
     `sortOrder` (threaded from `TaskSchedule`), and the carousel sort
     uses it (locked tasks last, then sortOrder within each group).
   - `dashboard_screen.dart`: removed an unused `_organisationId` field.
   - `end_of_session_summary_screen.dart`: removed an unused import.

### Validation

- `flutter analyze` on the full change set: passed (No issues found).
- `dart run build_runner build --delete-conflicting-outputs`: exited 0,
  no drift schema drift.

### Still open (unchanged)

- Backend `sort_order` columns on `task_schedules` / `areas` remain
  deferred (Supabase stubs throw `UnimplementedError`).
- `HANDOFF_NEXT_CHAT.md` in the repo root is a working artifact from the
  handoff; it is not part of the app and was left uncommitted.

## Current known state

- Guided Cards shared foundation already exists in the repository: theme tokens, shared cards, banners, status badges, metric chips, primary buttons, section headers, drawer navigation, user titles, and responsive content.
- The current checkout is based on the C1d backend/onboarding save point, while the decision log documents later work. Verify current files before assuming every decision-log entry is present in this checkout.
- Backend Phase B0-B5 and Phase C1a-C1d are documented as completed and proven in the project decision records.
- Task reorder is complete end to end on the local/Drift path (schema, models, repos, worker-carousel sort, manager Reorder Tasks screen, drawer entry). Backend `sort_order` columns are intentionally deferred (Supabase stubs).
- Multi-site operational reads still require a dedicated usability pass before multiple real venues are used day to day.
- The human RLS security review and dedicated-server gate remain important before real customer data goes live.

## Next planned work

### Task reorder — remaining items (mostly deferred by design)

- The Reorder Tasks UI and local persistence are done. Backend
  `sort_order` columns remain stubbed (`UnimplementedError`) pending a
  later cluster migration.

### Guided Cards completion

- Finish the screen-by-screen visual consistency pass.
- Preserve task logic, role permissions, authentication, repositories, migrations, and backend behaviour.
- Validate phone, tablet, and desktop layouts.

### Multi-site usability

- Add site-scoped reads where current repository interfaces still return mixed venue data.
- Wire active-site context through management screens.
- Verify staff, equipment, areas, schedules, dashboards, and exports do not mix sites.
- Prove cross-site isolation with focused tests before proceeding.

## Open questions / stop points

- Do not introduce new multi-site repository APIs or change shared model contracts without confirming the intended site-selection behaviour for regional and executive users.
- Do not change backend authentication key format until the self-hosted Supabase configuration is migrated and verified.
- Do not treat the older `SPRINT.md` as authoritative without reconciling it with `DECISIONS_LOG.md`, `BACKEND_INFRA.md`, and the actual code.
