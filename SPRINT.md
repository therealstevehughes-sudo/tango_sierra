# SPRINT.md

## Current Sprint
Sprint 034 — Customer Onboarding & Billing Foundation — **COMPLETE (2026-09-14)**, all 6 stages built, proven live, and committed. See DECISIONS_LOG.md for full detail on each stage.

## Objective
Build a proper multi-step company onboarding wizard (admin account → company details → org structure → first venue → subscription → payment placeholder), a token-based "Join existing company" invite-redeem flow, and the underlying schema (company legal details, subscriptions, invite tokens) — extending the existing Organisation/Region/Site/Users hierarchy and RoleTier model, not replacing them. See DECISIONS_LOG.md's "Phase D" entry for the full inspection findings and the four scoping decisions made.

## Stages (each gets its own commit + doc update)
1. Schema: `organisations` legal fields + `owner_user_id`; new `subscriptions` table; new `organisation_invites` table. Local Drift + backend Postgres, both.
2. Extend `tenant-signup` Edge Function: collect company legal details, create the first venue, create a trialing subscription row, set `owner_user_id`.
3. New `create-invite` + `redeem-invite` Edge Functions: token-based join flow.
4. New multi-step onboarding wizard UI (replaces the single-screen `TenantSignupScreen`).
5. New "Join existing company" screen (redeem an invite token/link).
6. Landing screen: persistent "Sign in another way" link opening Sign in / Create company / Join company.

## Files In Scope
- `lib/core/storage/app_database.dart` (schema/migration)
- `lib/features/onboarding/*` (new wizard screens, join screen)
- `lib/features/auth/login_screen.dart` (persistent link only — no gating rewrite)
- `lib/shared/repositories/tenant_provisioning_repository.dart` (new methods)
- Backend: `tenant-signup`, new `create-invite`/`redeem-invite` Edge Functions, matching Postgres migration

## Files Out of Scope
- `RoleTier` enum and every RLS policy keyed off it — unchanged, per decision #1
- Real Stripe API calls — schema-only this sprint, per decision #3
- The PIN walk-up grid's own gating logic — unchanged, per decision #4
- Everything already proven in Phases B0-B5/C1a-C1d

## Lock Check
- aligned to PROJECT_BIBLE: yes
- aligned to ARCHITECTURE_LOCK: yes — extends the existing repository/RLS pattern, no new architecture
- aligned to DESIGN_SYSTEM_LOCK: yes — reuses ResponsiveContent/AppBanner/AppCard/the existing wizard-step pattern from VenueSetupWizardScreen
- aligned to SPRINT_RULES: yes
- aligned to DRIFT_GUARD: yes — additive schema only, no data loss

## Completion Criteria
A company can sign up through the new wizard (including a first venue and a trial subscription), a Director can generate a real invite token and a new user can redeem it to join, and the landing screen offers all three entry paths — all proven live (not just analyzed), `flutter analyze` clean, existing tests still passing.

## Save Point Name
SPRINT_034_ONBOARDING_LOCK (pending completion)

---

# Previous sprint (complete)

## Sprint 033 — Guided Cards visual refresh: reconciliation & completion

## Objective
Finish rolling the approved "Guided Cards" visual design system out across the app, starting by reconciling which screens other sessions already converted against the original batch plan, then completing the remaining screens in the same order (highest-traffic first) — a visual/design-system pass only, no behavior or backend changes.

## Context (why this sprint exists, not a fresh idea)
Guided Cards was approved as a full-app visual refresh (see DECISIONS_LOG.md "UX DESIGN DIRECTIONS" and the "Guided Cards" plan). Before this sprint started, other coding-assistant sessions working on this codebase in parallel had already built parts of it independently: the worker task header (`guided_task_header.dart`), a shared alert banner + drill-down (`trigger_notifications_banner.dart`), and a theme-token sweep across 9 screens (see `HANDOFF_NEXT_CHAT.md` session log). This sprint's first job is reconciling that work against the original proposed batch plan before continuing, not re-doing it.

## This Sprint Includes
- Audit: which screens already match the Guided Cards spec (palette, shape/spacing radii, type scale, the four key patterns including progressive disclosure), which are partially done, which haven't been touched.
- Complete the remaining screens, highest-traffic first (staff task screen + manager oversight, per the original approved ordering), narrow-width/responsive safe.
- Commit per batch; update DECISIONS_LOG.md and BACKEND_INFRA.md (if any backend-adjacent screen data shapes are touched — expected: none, this is UI-only) with each batch.

## Files In Scope
- `lib/app/theme/*` (palette/shape/type tokens)
- `lib/core/widgets/*` (shared card/header/banner widgets)
- `lib/features/tasks/task_screen.dart`, `lib/features/manager/manager_screen.dart` (highest-traffic, first)
- Remaining feature screens as the audit identifies them

## Files Out of Scope
- Backend/Postgres (Phases B0-B5, C1a-C1d) — untouched, this is a pure visual pass
- Auth, role model, task submission logic, repositories — behavior unchanged
- Phase C2 (branded-per-branch home screen) and C3 (interactive org-builder) — separate, later sprints (see MASTER_PLAN.md)

## Lock Check
- aligned to PROJECT_BIBLE: yes
- aligned to ARCHITECTURE_LOCK: yes (visual layer only, no repository/state-management changes)
- aligned to DESIGN_SYSTEM_LOCK: this sprint's exact purpose is implementing the approved Guided Cards direction on top of it — see DECISIONS_LOG.md for the full spec as given
- aligned to SPRINT_RULES: yes
- aligned to DRIFT_GUARD: yes — no schema/backend changes

## Completion Criteria
Every screen in scope matches the Guided Cards spec, `flutter analyze` is clean, a real Windows build has been launched and visually checked (not just analyzed), and both DECISIONS_LOG.md and this file are updated to reflect the finished state.

## Progress
- **Batch 1 (done, 2026-09-14)**: shared theme tokens (palette, card/button radii, warm shadows), staff task screen (main card + PASS/FAIL buttons), manager oversight and every other `AppCard`/`StatusBadge`-based screen (picked up automatically). Confirmed visually by the user on a real Windows build.
- **Batch 2 (done, 2026-09-14)**: dashboard's two raw `Card` usages swapped to `AppCard`; `ManagementDrawer` nav items given the rounded/tinted active-state treatment; login screen's staff picker audited (already fully theme-driven, no change needed).
- See DECISIONS_LOG.md for full detail on both batches, including two deliberate spec deviations (PASS/FAIL kept equal-weight, not the mockup's asymmetric styling; type scale kept at its existing 14px accessibility floor rather than the mockup's smaller sizes).

## Status: COMPLETE (2026-09-14)
Every screen built on the shared `AppCard`/`StatusBadge`/`AppTheme` foundation now reflects the Guided Cards direction. `flutter analyze` clean, all 17 tests passing, verified on a real Windows build.

## Save Point Name
SPRINT_033_GUIDED_CARDS_LOCK

## Standing status note (2026-09-14)
This file previously said "Sprint 001" and had not been updated since the project's very first setup sprint — genuinely stale for over 30 sprints' worth of real work. `DECISIONS_LOG.md` has been the actual living record of decisions/status since; `CHANGELOG_LOCK.md` has the detailed per-sprint changelog through Sprint 032; `BACKEND_INFRA.md` covers the backend/Phase B-C work. This file is now being kept current going forward as the single "what's the current sprint" pointer.
