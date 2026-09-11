# Agent Change Log

## Purpose

This file records work completed by assisting coding agents so future agents can understand what changed, why, and what remains open.

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

Maintenance contacts preserve organisation-wide records (`siteId == null`) while also showing contacts specific to the selected site.

This prevents local multi-site screens from mixing staff, areas, and equipment from different venues. Backend reads remain additionally protected by RLS.

Validation:

- Focused analysis of all six repository/screen files passed after a null-safe site guard was added to Assign Tasks.

## Current known state

- Guided Cards shared foundation already exists in the repository: theme tokens, shared cards, banners, status badges, metric chips, primary buttons, section headers, drawer navigation, user titles, and responsive content.
- The current checkout is based on the C1d backend/onboarding save point, while the decision log documents later work. Verify current files before assuming every decision-log entry is present in this checkout.
- Backend Phase B0-B5 and Phase C1a-C1d are documented as completed and proven in the project decision records.
- Multi-site operational reads still require a dedicated usability pass before multiple real venues are used day to day.
- The human RLS security review and dedicated-server gate remain important before real customer data goes live.

## Next planned work

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
