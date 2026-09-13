# HANDOFF — Next Chat Continuation (2026-09-13)

You are continuing work on the **VenuRite** Flutter app.
Workspace: `c:\Projects\Tango Sierra\tango_sierra`.

**Do NOT re-invent or re-do completed work.** The state below is verified as of
this file's creation. Verify it with `git status` / file reads, then continue.

---

## Step 1 — Read these control documents first

- `AGENT_CHANGELOG.md` — everything done up to 2026-09-13 (six sessions logged).
- `DECISIONS_LOG.md` — latest project-state reference.
- `BACKEND_INFRA.md` — backend/security state reference.
- `ARCHITECTURE_LOCK.md`, `DESIGN_SYSTEM_LOCK.md`, `DRIFT_GUARD.md`,
  `SPRINT_RULES.md`, `MASTER_PLAN.md`.
- `HANDOFF_PROMPT.md` — standing project rules (never guess file names,
  never invent architecture, never change UI/UX without approval, always
  state files before coding, stop and ask if anything is missing).
- ⚠️ Older `SPRINT.md` is **NOT authoritative** — reconcile against the code.

---

## Step 2 — Verify current state

All work below is **COMMITTED** on `master` branch, pushed to
`https://github.com/therealstevehughes-sudo/tango_sierra`.
Latest commits (2026-09-13):
- Photo-evidence P1 + UX-polish pass (prune manager, wizard suppliers step,
  A–Z quick-jump, EHO range picker) — see `AGENT_CHANGELOG.md` session 8
- `7bc5db4` — **VenuRite launcher icons** (Android/iOS/macOS/Windows)
- `2696b12` — **Photo evidence P0** (real capture + persist + PDF embed)
- `a83c747` — **VenuRite branding** (logos, splash, branded headers)
No uncommitted changes.
`flutter analyze`: No issues found. All tests: 14/14 passing.

⚠️ Verified 2026-09-13 (session 5): a ~14.9 GB disk cleanup was done first
(emulator AVD + system images + NDK, `flutter clean`, stale Gradle, %TEMP%
%) — all committed, none of it touches project data.

---

## Step 3 — What's done in this project (six sessions, all shipped)

### Session 1: Task Reorder + Live Safe-Range + Leadership Region Scoping (bf22ee1)
- Schema 36→37: `sortOrder` on `TaskSchedule` + `Area`
- Local/Drift repos: `setSortOrder`, `getForSite` sort by sortOrder nulls-last
- Supabase `setSortOrder` stubs (throws `UnimplementedError` — backend col deferred)
- Worker carousel sorts by `sortOrder` (locked last, then sortOrder)
- Worker task screen: live "Safe: X°C – Y°C" helper text, prominent FAIL card on entry
- Leadership dashboard: site set via `getForRegion`/`getForOrganisation` (no `getAll()` leak); multi-region Directors get grouped venues

### Session 2: Multi-site Isolation Audit + Proof (81ac902)
- **EHO export fix**: `getById(siteId)` + `getForSite(siteId)` instead of `getAll()`
- **Other `getAll()` calls verified as intentional cross-site behavior** (left unchanged):
  - FAIL fan-out (org-wide rules reach every site)
  - Escalation person-targeted recipients
  - Setup checklist org-level counts
  - Venue Details / Branch Management admin screens
- **Isolation proof test**: `test/multi_site_isolation_test.dart` — headless Drift, 4 tests pinning `getForSite` isolation for Users, Areas, Equipment, TaskSchedules

### Session 3: Guided Cards — Worker Task Header (b53b252)
- New `lib/core/widgets/guided_task_header.dart` — guided header for worker task cards:
  - Progress line: "Task 2 of 6" (from controller's index, hidden for single task)
  - Section pill: segment name (e.g. "KITCHEN", teal informational tone, blank=hidden)
  - Instance name + title (unchanged, compliance-critical)
- Replaces private `_TaskTitleHeader` in `task_screen.dart` (both active and locked cards)
- 5 widget tests: content renders, instance leads, no overflow at 360px, identical at 600/1200, blank segment hides pill
- Zero logic/permission/repo/backend changes — pure presentation

### Session 4: Visual-consistency pass — shared alert banner + drill-down + theme-token sweep (5b51367)
- **Shared `TriggerNotificationsBanner`** (`lib/core/widgets/trigger_notifications_banner.dart`):
  extracted the duplicated `_TriggerNotificationsBanner` from `manager_screen.dart` +
  `top_screen.dart`; optional `onRowTap` — manager wires the alert→task drill-down, top-tier keeps rows plain
- **Manager alert drill-down**: tapping an alert row opens the failed submission detail
  (logged by, result, corrective action); falls back to lightweight detail for filtered-out old FAILs
- **Theme-token sweep** across 9 screens (hardcoded fontSize/`Colors.red`/`Colors.grey` → textTheme + `AppColors`)
- **New test**: `test/trigger_notifications_banner_test.dart` (5 tests: tally, instance lead, ack, OVERDUE, row-tap)
- 14/14 tests total; analyze clean; zero logic/permission/repo/backend changes

### Session 5: VenuRite branding — logos, branded headers, native splash (2026-09-13)
- **Assets**: user-supplied `assets/logos/` (VR_square 1024², VenueRite_favicon 1024², VenuRite_long 2000×500, VenuRite_long_white 2000×500) registered in `pubspec.yaml`
- **Web branding**: `web/index.html` VenuRite title + favicon; `web/manifest.json` VenuRite-branded (teal #0E6B6C)
- **App title**: `MaterialApp.title` + Windows runner window → `VenuRite`
- **Shared `BrandHeader`** (`lib/core/widgets/brand_header.dart`): VR square mark top-left (72px), client branding centred
  (client logo 64px + company name + branch name) — used by login (pre-auth) + tier-home (post-auth)
- **Native splash**: Android (teal `launch_background.xml` + Android 12+ `values-v31` SplashScreen API + VR square in `drawable-nodpi`); iOS (LaunchImage 1x/2x/3x regenerated from VR square + teal storyboard bg); Windows title only
- Client-logo sizing confirmed with a temporary brain stand-in (64px)
- Analyze clean; 14/14 tests passing; Windows debug build + launch verified

### Session 6: Photo evidence P0 — real capture, persist, PDF embed (2696b12, 2026-09-13)
- **`pubspec.yaml`**: `image_picker: ^1.1.2` (only new dep; deduped a doubled draft entry)
- **`lib/core/services/evidence_store.dart`** (new): `EvidenceStore` — camera-first capture + gallery fallback,
  JPEG copied into `<documents>/evidence/`, stable path; `readPhotoBytes` best-effort (null, never throws);
  provider `evidenceStoreProvider`
- **`task_screen.dart`**: "Add Photo" runs a real capture (`_capturePhoto`), disabled once taken;
  `photoPath` now flows through `logTaskSubmission` (previously never set); reset between tasks
- **`task_controller.dart`**: `logTaskSubmission` accepts + forwards `photoPath`
- **`eho_export_service.dart`**: preloads bytes in `generate()`; full detailed log embeds the real image
  (96px) with title caption; corrupt/missing bytes degrade to `[Photo attached]` marker; limitations notice updated
- **`ios/Runner/Info.plist`**: `NSCameraUsageDescription` + `NSPhotoLibraryUsageDescription`
- No Drift migration (photoPath column existed since schemaVersion 1); analyze clean; 14/14 tests; committed + pushed

---

## Step 4 — What's running
- **Windows desktop debug build live** (first native compile completed ~5 min)
- App at login screen (multi-tenant kitchen compliance — staff PIN, senior login)
- To see Guided Card: sign in as base-tier staff with assigned tasks → My Tasks
- Hot reload works (`r` in terminal), DevTools at `http://127.0.0.1:61126/.../devtools`

---

## Step 5 — Known gaps / open items (documented in changelog)

- Backend `sort_order` columns on `task_schedules`/`areas` still stubbed (deferred to later cluster)
- Guided Cards visual pass: **worker task header** + **alert banner/drill-down** done; the broader "screen-by-screen visual consistency pass" continues (theme-token sweep across other screens can continue)
- Multi-site: walk-up "Who are you?" roster is a logged design question (kiosk credential), not a quick fix
# Launcher icons now built (session 7, commit 7bc5db4): Android legacy + adaptive (teal bg + VR badge), iOS full AppIcon set, macOS set, Windows .ico — all VR badge on brand teal. Linux runner has no icon wiring (template) — left as-is.
# Photo evidence is now real (session 6): camera-first capture, JPEGs in <documents>/evidence/, embedded in the EHO export's full detailed log. Deferred: evidence prune/"free space" P1 + cloud photo sync (v2)

---

## Step 6 — Next work bit (if you pick it up)

**Launcher/app icons** — DONE (session 7, `7bc5db4`): Android legacy +
adaptive (teal bg + VR badge), iOS full AppIcon set, macOS set, Windows
.ico rebuilt. The remaining branding piece is minimal (Linux has no icon
wiring in the Flutter template — optional).

**Where the project actually is now** (verified 2026-09-13): photo
evidence P0 (session 6) + launcher icons (session 7) are complete. The
finalized beta build order (items 1–7) is done; the project pivots to
backend work — Phase B0–B5 + C1a–C1d documented, with **human RLS review +
dedicated-server gate still pending** before real customer data goes live
(per `BACKEND_INFRA.md` / Step 7 constraints).

**Candidate next activities** (not yet chosen):
1. **Photo-evidence P1** — "back up evidence → free space" prune manager. Deliberately deferred in `PHOTO_EVIDENCE_PLAN.md`.
2. **Backend Phase 2/3 remaining** — the human RLS review / dedicated-server gate requires a human; not agent-work.
3. **UX backlog P0s** (`UX_RESEARCH_REPORT.md`) — staged venue-setup wizard, exec trend dashboard (were P0 at research time).
4. **A–Z quick-jump / calendar range-picker for EHO export** — small polish items from `DECISIONS_LOG.md`.

---

## Step 7 — Constraints / rules (from HANDOFF_PROMPT.md)

- Do not change UI/UX without stating it first
- Preserve task logic, role permissions, authentication, repositories, migrations, backend behaviour
- Keep multi-site screens site-scoped (never mix venues)
- Do not change backend authentication key format
- Do not add new multi-site repository APIs without the site-selection decision
- Backend Phase B0–B5 and Phase C1a–C1d documented complete; human RLS review + dedicated-server gate still pending before real customer data goes live
- If you hit a blocker, ambiguity, or repeated loop — **stop and tell the user immediately**; do not silently hang

---

## Goal for this session (when you resume)

Pick up the **branded launch/splash screen** work, or whichever item you prioritize. The tree is clean, tested, and backed up on GitHub.
