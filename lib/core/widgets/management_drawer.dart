import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/navigator_key.dart';
import '../../app/theme/app_colors.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/dashboard/leadership_dashboard_screen.dart';
import '../../features/export/eho_export_dialog.dart';
import '../../features/help/help_screen.dart';
import '../../features/home/tier_home_screen.dart';
import '../../features/manager/backup_dialog.dart';
import '../../features/notifications/notification_rules_screen.dart';
import '../../features/onboarding/staff_assignment_screen.dart';
import '../../features/onboarding/staff_provisioning_screen.dart';
import '../../features/problems/problems_register_screen.dart';
import '../../features/providers/service_providers_screen.dart';
import '../../features/regions/branch_management_screen.dart';
import '../../features/regions/branch_org_chart_screen.dart';
import '../../features/regions/organisation_tree_screen.dart';
import '../../features/roster/claim_board_screen.dart';
import '../../features/roster/request_off_day_screen.dart';
import '../../features/roster/roster_billing_service.dart' show rosterAddonEnabledProvider;
import '../../features/roster/roster_board_screen.dart';
import '../../features/roster/roster_upsell_screen.dart';
import '../../features/roster/rota_claim_screen.dart';
import '../../features/roster/rota_week_screen.dart';
import '../../features/roster/shift_period_settings_screen.dart';
import '../../features/roster/shift_requirements_screen.dart';
import '../../features/roster/shift_fairness_screen.dart';
import '../../features/settings/certification_requirements_screen.dart';
import '../../features/settings/department_management_screen.dart';
import '../../features/settings/menu_management_screen.dart';
import '../../features/settings/document_centre_screen.dart';
import '../../features/settings/evidence_prune_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/shift_log_screen.dart';
import '../../features/settings/staff_management_screen.dart';
import '../../features/settings/supplier_management_screen.dart';
import '../../features/settings/two_factor_settings_screen.dart';
import '../../features/settings/venue_details_screen.dart';
import '../../features/task_library/preset_management_screen.dart';
import '../../features/tasks/reorder_tasks_screen.dart';
import '../../features/tasks/task_screen.dart';
import '../../features/venue_setup/venue_setup_wizard_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';

class _DrawerItemDef {
  const _DrawerItemDef({
    required this.icon,
    required this.label,
    required this.minTier,
    required this.screenBuilder,
    this.requiresRosterAddon = false,
  });

  final IconData icon;
  final String label;
  final RoleTier minTier;
  final WidgetBuilder screenBuilder;
  // Roster paid-add-on teaser (2026-09-27) — when true and the org hasn't
  // enabled Roster, this item renders dimmed with a lock icon and opens
  // RosterUpsellScreen instead of screenBuilder. This is the ONLY
  // feature-flag gate this drawer has ever needed (every other item is
  // tier-only), so a single bool here beats a more general mechanism no
  // other item would use.
  final bool requiresRosterAddon;
}

// Menu redesign (2026-09-17) — grouped by purpose into 6 collapsible
// sections (see ManagementDrawer.build() for the section shells and the
// hand-written items — Home, Oversight, Back Up Now, EHO Export, Log out
// — that don't fit this simple "push a screen" shape). Every item here
// keeps EXACTLY the tier gate it had before this redesign; only which
// section it lives in changed, per the user's explicit list. Two renames
// also happened in this pass: "Fails & Problems Register" -> "Problems &
// Issues" (the screen gained an Issues & Incidents tab 2026-09-15, the
// old name was stale) and "Venue Setup" -> "Setup Wizard" (to read
// distinctly from "Venue Details" next to it).
List<_DrawerItemDef> _insightsItems(AppLocalizations l10n) => [
  // Sections/Teams scoping (2026-09-18) — lowered from venueManager so a
  // Supervisor can reach their own section/team-scoped view (see
  // leadership_dashboard_screen.dart). This is the one gate this build
  // deliberately changes, for a stated reason — every other item's gate
  // stays byte-for-byte as it was.
  // Renamed from "Dashboard Overview" (2026-09-29, drawer audit) — the
  // Daily section's own "Dashboard" item and this one both starting with
  // "Dashboard" was a real, confirmed naming collision (two different
  // screens, no way to tell them apart from the label alone). This name
  // now matches the screen's own class name (LeadershipDashboardScreen)
  // and its actual audience.
  _DrawerItemDef(
    icon: Icons.bar_chart,
    label: l10n.leadershipOverview,
    minTier: RoleTier.supervisor,
    screenBuilder: (_) => const LeadershipDashboardScreen(),
  ),
  // EHO Export is a dialog action, not a screen push — handled by hand in
  // the INSIGHTS section body below, not this list (WidgetBuilder can't
  // express "run a dialog" cleanly). Kept here in the doc comment only so
  // the section's full item order is legible in one place: Leadership
  // Overview, EHO / Audit Export, Photo Evidence.
  _DrawerItemDef(
    icon: Icons.photo_library_outlined,
    label: l10n.photoEvidence,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const EvidencePruneScreen(),
  ),
];

List<_DrawerItemDef> _peopleItems(AppLocalizations l10n) => [
  _DrawerItemDef(
    icon: Icons.badge,
    label: l10n.staffManagement,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const StaffManagementScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.person_add_alt,
    label: l10n.addTeamMember,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const StaffProvisioningScreen(),
  ),
  // Shift log (2026-09-24) — plain clock-in/out list, a habit-tracking
  // signal per its own doc comment, not a graded score.
  _DrawerItemDef(
    icon: Icons.schedule_outlined,
    label: l10n.shiftLog,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const ShiftLogScreen(),
  ),
  // Chain of command / branch organogram (2026-09-15) — kept at its
  // original supervisor+ gate (unchanged by this redesign, only its
  // section moved): this is where "who does this escalate to" gets set
  // up and seen, so anyone who can act on an escalated issue should be
  // able to see the reporting lines, not just venueManager+.
  _DrawerItemDef(
    icon: Icons.account_tree_outlined,
    label: l10n.branchTeamStructure,
    minTier: RoleTier.supervisor,
    screenBuilder: (_) => const BranchOrgChartScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.groups,
    label: l10n.departmentManagement,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const DepartmentManagementScreen(),
  ),
  // Menu & allergens (Phase 2, allergen module, 2026-09-30) — supervisor
  // is the lowest tier with any drawer access at all (base tier has none,
  // see WorkerHubScreen's own doc comment), so this is the practical
  // floor for "anyone in the kitchen can draft a dish" per the agreed
  // design; the actual approve gate (supervisor+) lives inside
  // MenuItemDetailScreen itself.
  _DrawerItemDef(
    icon: Icons.restaurant_menu_outlined,
    label: l10n.menuManagementTitle,
    minTier: RoleTier.supervisor,
    screenBuilder: (_) => const MenuManagementScreen(),
  ),
];

// ROSTER — the paid add-on's own section (2026-09-29, drawer audit): all
// four Roster pieces used to be split across People (Roster Board/Claim
// Shifts/Request a Day Off) and Insights (Shift Fairness Review) — one
// feature, two unrelated places to look for it. Grouped together so the
// add-on has one discoverable home, and gates unchanged from before this
// move.
List<_DrawerItemDef> _rosterItems(AppLocalizations l10n) => [
  // Manager side (post shifts, assign/remove) at venueManager+; the
  // staff-facing screens below at supervisor+. Locked-teaser UX
  // (2026-09-27, direct founder request): dimmed + lock icon + opens
  // RosterUpsellScreen until the org has actually paid, rather than a
  // plain "not enabled" sentence inside the real screen — see
  // _itemTiles/_lockedNavTile below.
  _DrawerItemDef(
    icon: Icons.event_note_outlined,
    label: l10n.rosterBoard,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const RosterBoardScreen(),
    requiresRosterAddon: true,
  ),
  // Rota calendar, Sprint 2 (2026-10-01) — the visual week-grid view,
  // additive alongside the list-style Roster Board for now (Sprint 4
  // covers consolidating entry points).
  _DrawerItemDef(
    icon: Icons.calendar_view_week_outlined,
    label: l10n.rotaWeekTitle,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const RotaWeekScreen(),
    requiresRosterAddon: true,
  ),
  // Rota calendar, Sprint 1 (2026-10-01) — leadership configures the
  // site's shift periods here; the upcoming week/month calendar and
  // auto-assign both read this config.
  _DrawerItemDef(
    icon: Icons.schedule_outlined,
    label: l10n.shiftPeriodsTitle,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const ShiftPeriodSettingsScreen(),
    requiresRosterAddon: true,
  ),
  // Master rota settings, Sprint 3 (2026-10-01).
  _DrawerItemDef(
    icon: Icons.rule_outlined,
    label: l10n.masterRotaSettingsTitle,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const ShiftRequirementsScreen(),
    requiresRosterAddon: true,
  ),
  _DrawerItemDef(
    icon: Icons.event_available_outlined,
    label: l10n.claimShifts,
    minTier: RoleTier.supervisor,
    screenBuilder: (_) => const ClaimBoardScreen(),
    requiresRosterAddon: true,
  ),
  // Rota calendar, Sprint 6 (2026-10-01) — slot-based claiming + the
  // integrated "book days off" toggle, additive alongside Claim Shifts'
  // existing flat list.
  _DrawerItemDef(
    icon: Icons.view_week_outlined,
    label: l10n.rotaClaimCalendarTitle,
    minTier: RoleTier.supervisor,
    screenBuilder: (_) => const RotaClaimScreen(),
    requiresRosterAddon: true,
  ),
  // Off-day requests (R5, 2026-09-27) — same supervisor+ floor as Claim
  // Shifts, same dual-entry pattern (WorkerHubScreen button for base tier).
  _DrawerItemDef(
    icon: Icons.event_busy_outlined,
    label: l10n.requestADayOff,
    minTier: RoleTier.supervisor,
    screenBuilder: (_) => const RequestOffDayScreen(),
    requiresRosterAddon: true,
  ),
  // Fairness review (R6, 2026-09-27) — venueManager+, previously sat in
  // Insights; moved here to sit with the rest of Roster.
  _DrawerItemDef(
    icon: Icons.balance_outlined,
    label: l10n.shiftFairnessReview,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const ShiftFairnessScreen(),
    requiresRosterAddon: true,
  ),
];

List<_DrawerItemDef> _venueSetupItems(AppLocalizations l10n) => [
  _DrawerItemDef(
    icon: Icons.location_city,
    label: l10n.venueDetails,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const VenueDetailsScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.assignment_ind,
    label: l10n.assignTasks,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const StaffAssignmentScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.swap_vert,
    label: l10n.reorderTasksTitle,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const ReorderTasksScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.checklist,
    label: l10n.taskPresets,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const PresetManagementScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.local_shipping,
    label: l10n.supplierManagement,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const SupplierManagementScreen(),
  ),
  // Trusted Service Provider directory, phase 1 (2026-09-29) — moved here
  // from Company (2026-09-29, direct founder report): its lower tier
  // floor than Organisation/Branches meant a venueManager only ever saw
  // it as a lone, header-less item there (see _section()'s single-item
  // rule), looking randomly placed. Sits naturally next to Supplier
  // Management instead — same "who to call" flavour. ALSO absorbs the
  // former "Maintenance Contacts" entry entirely (2026-09-29, direct
  // founder report: "isn't maintenance contacts the same as service
  // providers?" — correct, real avoidable duplication): its own "My
  // Providers" tab now covers that exact same job.
  // and every item in this section already shares its venueManager+
  // floor, so it always renders properly grouped.
  _DrawerItemDef(
    icon: Icons.handshake_outlined,
    label: l10n.serviceProviders,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const ServiceProvidersScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.notifications,
    label: l10n.notificationRules,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const NotificationRulesScreen(),
  ),
  // Moved here from Insights (2026-09-29, drawer audit) — it's document
  // storage/reference material, not a monitoring/reporting tool like the
  // rest of Insights (Leadership Overview, EHO Export, Photo Evidence).
  _DrawerItemDef(
    icon: Icons.folder_copy_outlined,
    label: l10n.documentCentre,
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const DocumentCentreScreen(),
  ),
  // Renamed from "Venue Setup" (2026-09-17) — reads distinctly from
  // "Venue Details" above rather than the two sounding like the same
  // screen.
  //
  // minTier lowered to supervisor (2026-09-28, direct founder request) —
  // a department head (Functions & Events Supervisor, Executive Chef,
  // etc.) previously had no way to add their own equipment at all, only a
  // GM could. A supervisor opening this screen only ever sees its
  // Equipment step (VenueSetupWizardScreen's own `_equipmentOnly` gate) —
  // Areas/Staff/Supplier setup stays venueManager+ only.
  _DrawerItemDef(
    icon: Icons.store,
    label: l10n.setupWizard,
    minTier: RoleTier.supervisor,
    screenBuilder: (_) => const VenueSetupWizardScreen(),
  ),
];

List<_DrawerItemDef> _companyItems(AppLocalizations l10n) => [
  // Phase C3 — the visual org organogram: Head Office -> Regions ->
  // Venues, each level showing its actual people, expandable downward,
  // add/invite/rename/reset-password actions right on it. Executive-only.
  _DrawerItemDef(
    icon: Icons.account_tree_outlined,
    label: l10n.organisationLabel,
    minTier: RoleTier.executive,
    screenBuilder: (_) => const OrganisationTreeScreen(),
  ),
  // A REGIONAL manager's own single-region view, a different tier than
  // the executive-only Organisation tree above.
  _DrawerItemDef(
    icon: Icons.storefront_outlined,
    label: l10n.branchesLabel,
    minTier: RoleTier.regional,
    screenBuilder: (_) => const BranchManagementScreen(),
  ),
  // Certification requirements (Phase 2, 2026-09-30) — leadership-only:
  // adds EXTRA required certifications per job role on top of the fixed
  // floor (see certification_requirement.dart). Regional+ per the agreed
  // "leadership can add, nobody can remove the floor" design.
  _DrawerItemDef(
    icon: Icons.verified_outlined,
    label: l10n.certificationRequirementsTitle,
    minTier: RoleTier.regional,
    screenBuilder: (_) => const CertificationRequirementsScreen(),
  ),
];

const _backUpMinTier = RoleTier.venueManager;
// EHO/audit export (Sprint 031) — venueManager and above, not
// executive-only as originally logged in PROJECT_BIBLE.md/MASTER_PLAN.md.
// Reconsidered and changed: an EHO inspection is unannounced and happens
// at the venue, so requiring the Director specifically would defeat the
// one-tap-in-the-moment value the feature exists for. Confirmed with the
// user before building — PROJECT_BIBLE.md/MASTER_PLAN.md updated to match.
const _ehoExportMinTier = RoleTier.venueManager;

/// Shared by `ManagerScreen` (supervisor/venueManager) and `TopScreen`
/// (regional/executive) — was two byte-for-byte duplicate drawers before
/// Sprint 031, which is how the trigger-notifications banner on TopScreen
/// silently went stale after manager_screen.dart was fixed in Sub-sprint 5.
/// One shared widget, tier-filtered via `roleTierRank`, removes that class
/// of drift for good — same rationale as the `PinEntry` extraction.
///
/// Menu redesign (2026-09-17): restructured from a flat 27-item list with
/// two unlabelled dividers into 6 labelled, collapsible sections (Daily,
/// Insights, People, Venue Setup, Company, Account) grouped by purpose —
/// see DECISIONS_LOG.md's "Menu/navigation audit + redesign" entry for the
/// full before/after. Also fixed a real inconsistency found during that
/// redesign: Back Up Now / EHO Export used to only appear on
/// ManagerScreen/TopScreen specifically, because they needed a `ref` that
/// outlives this Drawer's own closing (this Drawer's own `context`/`ref`
/// are disposed the instant `Navigator.pop` closes it — a real,
/// previously-hit crash, which is why those two actions were originally
/// wired as callbacks captured from the CALLER's own longer-lived `ref`
/// rather than run directly from here). Fixed at the root cause instead of
/// re-patching the same workaround: `rootNavigatorKey` (app/navigator_key.dart)
/// gives this Drawer a context that belongs to the app's root Navigator,
/// which is never disposed by a Drawer closing, and `showBackupDialog`/
/// `showEhoExportDialog` now take a `ProviderContainer` (resolved from
/// that same stable context) instead of a `WidgetRef` — safe because both
/// functions only ever call `.read()`, never `.watch()`/`.listen()`. Both
/// actions now appear consistently for venueManager+ from ANY screen this
/// Drawer is used on, and the `onBackUp`/`onEhoExport` constructor
/// parameters that used to carry the per-caller workaround are gone.
class ManagementDrawer extends ConsumerWidget {
  const ManagementDrawer({super.key, required this.title, this.onLogout});

  final String title;
  // Nullable — only TaskScreen supplies this (its own confirmation-aware
  // _confirmLogOut, which checks hasRemainingTasks first). Every other
  // screen falls back to the drawer's own default: pop to root, then null
  // currentUserProvider — there's no "remaining tasks" concept outside
  // TaskScreen, so no confirmation is needed elsewhere.
  final VoidCallback? onLogout;

  void _navigate(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  // Guided Cards (2026-09-14): rounded (10px), tinted-when-active nav
  // items, matching the mockup's sidebar nav pattern — this Drawer is a
  // slide-out overlay rather than the mockup's persistent sidebar, but
  // `title` already tells us which screen is currently open (every call
  // site passes its own screen's title), so "active" maps onto "this
  // item's label matches the screen you're already on" just as well.
  // Unchanged by the menu redesign — only which section wraps each tile
  // changed, never this widget itself.
  Widget _navTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final active = label == title;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: active ? AppColors.tealTint : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: Icon(icon, color: active ? AppColors.tealInk : null),
          title: Text(
            label,
            style: active
                ? const TextStyle(
                    color: AppColors.tealInk,
                    fontWeight: FontWeight.w600,
                  )
                : null,
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  // Menu redesign (2026-09-17) — one section shell for all 6 groups:
  // returns null (renders nothing) when [children] ends up empty for the
  // current tier, so a tier that can't see anything in a section never
  // gets shown that section's header at all. `initiallyExpanded` is true
  // only for Daily; every other section collapses by default, matching
  // the ExpansionTile pattern manager_screen.dart already uses for
  // Alerts/Overdue/Log grouping.
  //
  // Single-item sections skip the header entirely (2026-09-29, direct
  // founder follow-up on the drawer audit): several sections collapse to
  // exactly one visible row for a lower tier (e.g. a supervisor sees only
  // Branch Team Structure under "People") — same overall structure and
  // order as every other tier, just nothing to usefully group when
  // there's only one thing to show. A tap-to-expand header over a single
  // row is pure overhead in that case, so it's shown as a plain row
  // instead — the grouping/order itself is unchanged, this only affects
  // how a section with exactly one item is presented.
  Widget? _section({
    required String label,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    if (children.isEmpty) return null;
    if (children.length == 1) return children.single;
    return ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      childrenPadding: EdgeInsets.zero,
      children: children,
    );
  }

  // Locked-teaser tile (2026-09-27) — same shape as _navTile but dimmed,
  // with a trailing lock icon and an "Add-on" label instead of the normal
  // active-highlight logic (a locked item is never "the current screen").
  // Opens RosterUpsellScreen regardless of which real screen it stands in
  // for — the upsell content is identical either way.
  Widget _lockedNavTile({required IconData icon, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Builder(
        builder: (context) => Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Icon(icon, color: AppColors.muted),
            title: Text(label, style: const TextStyle(color: AppColors.muted)),
            trailing: const Icon(
              Icons.lock_outline,
              size: 18,
              color: AppColors.muted,
            ),
            onTap: () =>
                _navigate(context, const RosterUpsellScreen()),
          ),
        ),
      ),
    );
  }

  List<Widget> _itemTiles(
    BuildContext context,
    List<_DrawerItemDef> items,
    bool Function(RoleTier) atLeast,
    bool rosterAddonEnabled,
  ) {
    return [
      for (final item in items)
        if (atLeast(item.minTier))
          if (item.requiresRosterAddon && !rosterAddonEnabled)
            _lockedNavTile(icon: item.icon, label: item.label)
          else
            _navTile(
              icon: item.icon,
              label: item.label,
              onTap: () => _navigate(context, item.screenBuilder(context)),
            ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);
    final tier = currentUser?.roleTier;
    // Defaults to locked while resolving/on error — a brief false-locked
    // flash on open is far better than briefly showing a paid screen as
    // free before the real state loads.
    final rosterAddonEnabled = ref
        .watch(rosterAddonEnabledProvider)
        .maybeWhen(data: (enabled) => enabled, orElse: () => false);

    bool atLeast(RoleTier minTier) =>
        tier != null && roleTierRank(tier) >= roleTierRank(minTier);

    final sections = <Widget?>[
      // DAILY — always non-empty for any tier that reaches this Drawer at
      // all (Home/My Tasks/Oversight are unconditional), expanded by
      // default: the items a supervisor+ actually touches every shift.
      _section(
        label: l10n.dailySection,
        initiallyExpanded: true,
        children: [
          _navTile(
            icon: Icons.home_outlined,
            label: l10n.homeLabel,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          _navTile(
            icon: Icons.checklist,
            label: l10n.myTasksTitle,
            onTap: () => _navigate(context, const TaskScreen()),
          ),
          if (tier != null)
            _navTile(
              icon: Icons.visibility,
              label: l10n.oversightLabel,
              onTap: () =>
                  _navigate(context, TierHomeScreen.oversightScreenFor(tier)),
            ),
          // Renamed from "Fails & Problems Register" (2026-09-17) — the
          // screen gained an Issues & Incidents tab 2026-09-15; the old
          // name only reflected half of what's actually in there now.
          if (atLeast(RoleTier.supervisor))
            _navTile(
              icon: Icons.report_problem_outlined,
              label: l10n.problemsAndIssues,
              onTap: () => _navigate(context, const ProblemsRegisterScreen()),
            ),
          if (atLeast(RoleTier.supervisor))
            _navTile(
              icon: Icons.insights,
              label: l10n.dashboardTitle,
              onTap: () => _navigate(context, const DashboardScreen()),
            ),
        ],
      ),
      // INSIGHTS — venueManager+ reporting/monitoring, collapsed by
      // default (checked occasionally, not every shift).
      _section(
        label: l10n.insightsSection,
        children: [
          ..._itemTiles(
            context,
            [_insightsItems(l10n)[0]],
            atLeast,
            rosterAddonEnabled,
          ),
          if (atLeast(_ehoExportMinTier))
            _navTile(
              icon: Icons.picture_as_pdf_outlined,
              label: l10n.ehoAuditExportTitle,
              onTap: () {
                Navigator.pop(context);
                showEhoExportDialog(
                  rootNavigatorKey.currentContext!,
                  ProviderScope.containerOf(
                    rootNavigatorKey.currentContext!,
                    listen: false,
                  ),
                );
              },
            ),
          ..._itemTiles(
            context,
            _insightsItems(l10n).sublist(1),
            atLeast,
            rosterAddonEnabled,
          ),
        ],
      ),
      // PEOPLE — staff/team structure. Branch Team Structure keeps its
      // original supervisor+ gate (moved here from the top nav cluster,
      // gate unchanged), so a supervisor sees this section with just that
      // one item — a harmless, deliberately-accepted one-item section
      // rather than complicating the tier-gating rule to avoid it.
      _section(
        label: l10n.peopleSection,
        children: _itemTiles(
          context,
          _peopleItems(l10n),
          atLeast,
          rosterAddonEnabled,
        ),
      ),
      // ROSTER — the paid add-on's own section (2026-09-29, drawer audit).
      // See _rosterItems' own doc comment for why this was split out of
      // People/Insights. A locked-teaser tile still renders (and this
      // section still appears) for a tier that qualifies but hasn't paid
      // — same as every other requiresRosterAddon item always has.
      _section(
        label: l10n.rosterSection,
        children: _itemTiles(
          context,
          _rosterItems(l10n),
          atLeast,
          rosterAddonEnabled,
        ),
      ),
      // VENUE SETUP — venueManager+ configuration, all one tier floor.
      _section(
        label: l10n.venueSetupSection,
        children: _itemTiles(
          context,
          _venueSetupItems(l10n),
          atLeast,
          rosterAddonEnabled,
        ),
      ),
      // COMPANY — org-structure viewers grouped together (previously sat
      // apart, mid-list, among unrelated config items). Invisible to
      // supervisor/venueManager (neither item's gate reaches that low).
      _section(
        label: l10n.companySection,
        children: _itemTiles(
          context,
          _companyItems(l10n),
          atLeast,
          rosterAddonEnabled,
        ),
      ),
      // ACCOUNT — collapsed by default like every non-Daily section.
      // Settings and Log out used to live here too, but per direct user
      // feedback (2026-09-25) those two are used every single session and
      // shouldn't be buried inside a collapsed dropdown — they're now
      // pinned, always visible, at the very bottom of the drawer (see
      // build()'s Column below). This section keeps only the genuinely
      // occasional items.
      _section(
        label: l10n.accountSection,
        children: [
          // Help hub (2026-09-24) — Contact VenuRite/FAQ/Troubleshooting,
          // the same destination base tier reaches via its own "?" icon
          // (see WorkerHubScreen/TaskScreen).
          _navTile(
            icon: Icons.help_outline,
            label: l10n.helpTitle,
            onTap: () => _navigate(context, const HelpScreen()),
          ),
          // Two-factor authentication — only meaningful for a real GoTrue
          // session (regional/executive with backendAuthEnabled). A
          // demo-mode PIN-based senior account has no GoTrue session to
          // enroll MFA against at all, so this stays hidden rather than
          // showing a screen that would error out. Gate unchanged.
          if (atLeast(RoleTier.regional) &&
              ref.watch(backendAuthEnabledProvider))
            _navTile(
              icon: Icons.verified_user_outlined,
              label: l10n.twoFactorAuthentication,
              onTap: () => _navigate(context, const TwoFactorSettingsScreen()),
            ),
          if (atLeast(_backUpMinTier))
            _navTile(
              icon: Icons.backup,
              label: l10n.backUpNow,
              onTap: () {
                Navigator.pop(context);
                showBackupDialog(
                  rootNavigatorKey.currentContext!,
                  ProviderScope.containerOf(
                    rootNavigatorKey.currentContext!,
                    listen: false,
                  ),
                );
              },
            ),
        ],
      ),
    ].whereType<Widget>().toList();

    // Settings/Log out placement (2026-09-25, direct user feedback,
    // corrected same day) — first tried pinning these outside the
    // scrollable list entirely; the actual ask was narrower: no collapsed
    // "Account" header with an irrelevant expand/contract arrow over
    // these two (they're fixed items, not a group that toggles), but
    // still ordinary members of the one scrolling list — scrolls away
    // like everything else, just always at the tail, always expanded,
    // never behind a tap-to-reveal header.
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.tealTint),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.tealInk,
                ),
              ),
            ),
          ),
          ...sections,
          const Divider(height: 1),
          _navTile(
            icon: Icons.settings,
            label: l10n.settingsLabel,
            onTap: () => _navigate(context, const SettingsScreen()),
          ),
          _navTile(
            icon: Icons.logout,
            label: l10n.logOut,
            onTap: () {
              Navigator.pop(context); // closes the drawer itself
              if (onLogout != null) {
                onLogout!();
                return;
              }
              // Pop to root before nulling currentUserProvider (Sprint 031,
              // Sub-sprint C follow-up) — ManagerScreen/TopScreen are
              // reachable via Navigator.push since Sub-sprint A, so without
              // this a pushed instance stayed mounted underneath after
              // logout while MaterialApp.home reactively swapped to
              // LoginScreen. Same fix as TaskScreen's logout paths.
              Navigator.of(context).popUntil((route) => route.isFirst);
              ref.read(currentUserProvider.notifier).state = null;
            },
          ),
        ],
      ),
    );
  }
}
