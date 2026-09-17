import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/navigator_key.dart';
import '../../app/theme/app_colors.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/dashboard/leadership_dashboard_screen.dart';
import '../../features/export/eho_export_dialog.dart';
import '../../features/home/tier_home_screen.dart';
import '../../features/manager/backup_dialog.dart';
import '../../features/notifications/notification_rules_screen.dart';
import '../../features/onboarding/staff_assignment_screen.dart';
import '../../features/onboarding/staff_provisioning_screen.dart';
import '../../features/problems/problems_register_screen.dart';
import '../../features/regions/branch_management_screen.dart';
import '../../features/regions/branch_org_chart_screen.dart';
import '../../features/regions/organisation_tree_screen.dart';
import '../../features/settings/department_management_screen.dart';
import '../../features/settings/document_centre_screen.dart';
import '../../features/settings/evidence_prune_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/staff_management_screen.dart';
import '../../features/settings/supplier_management_screen.dart';
import '../../features/settings/third_party_contacts_screen.dart';
import '../../features/settings/two_factor_settings_screen.dart';
import '../../features/settings/venue_details_screen.dart';
import '../../features/task_library/preset_management_screen.dart';
import '../../features/tasks/reorder_tasks_screen.dart';
import '../../features/tasks/task_screen.dart';
import '../../features/venue_setup/venue_setup_wizard_screen.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';

class _DrawerItemDef {
  const _DrawerItemDef({
    required this.icon,
    required this.label,
    required this.minTier,
    required this.screenBuilder,
  });

  final IconData icon;
  final String label;
  final RoleTier minTier;
  final WidgetBuilder screenBuilder;
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
final List<_DrawerItemDef> _insightsItems = [
  _DrawerItemDef(
    icon: Icons.bar_chart,
    label: 'Dashboard Overview',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const LeadershipDashboardScreen(),
  ),
  // EHO Export is a dialog action, not a screen push — handled by hand in
  // the INSIGHTS section body below, not this list (WidgetBuilder can't
  // express "run a dialog" cleanly). Kept here in the doc comment only so
  // the section's full item order is legible in one place: Dashboard
  // Overview, EHO / Audit Export, Photo Evidence, Document Centre.
  _DrawerItemDef(
    icon: Icons.photo_library_outlined,
    label: 'Photo Evidence',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const EvidencePruneScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.folder_copy_outlined,
    label: 'Document Centre',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const DocumentCentreScreen(),
  ),
];

final List<_DrawerItemDef> _peopleItems = [
  _DrawerItemDef(
    icon: Icons.badge,
    label: 'Staff Management',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const StaffManagementScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.person_add_alt,
    label: 'Add Team Member',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const StaffProvisioningScreen(),
  ),
  // Chain of command / branch organogram (2026-09-15) — kept at its
  // original supervisor+ gate (unchanged by this redesign, only its
  // section moved): this is where "who does this escalate to" gets set
  // up and seen, so anyone who can act on an escalated issue should be
  // able to see the reporting lines, not just venueManager+.
  _DrawerItemDef(
    icon: Icons.account_tree_outlined,
    label: 'Branch Team Structure',
    minTier: RoleTier.supervisor,
    screenBuilder: (_) => const BranchOrgChartScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.groups,
    label: 'Department Management',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const DepartmentManagementScreen(),
  ),
];

final List<_DrawerItemDef> _venueSetupItems = [
  _DrawerItemDef(
    icon: Icons.location_city,
    label: 'Venue Details',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const VenueDetailsScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.assignment_ind,
    label: 'Assign Tasks',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const StaffAssignmentScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.swap_vert,
    label: 'Reorder Tasks',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const ReorderTasksScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.checklist,
    label: 'Task Presets',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const PresetManagementScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.local_shipping,
    label: 'Supplier Management',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const SupplierManagementScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.contact_phone,
    label: 'Maintenance Contacts',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const ThirdPartyContactsScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.notifications,
    label: 'Notification Rules',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const NotificationRulesScreen(),
  ),
  // Renamed from "Venue Setup" (2026-09-17) — reads distinctly from
  // "Venue Details" above rather than the two sounding like the same
  // screen.
  _DrawerItemDef(
    icon: Icons.store,
    label: 'Setup Wizard',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const VenueSetupWizardScreen(),
  ),
];

final List<_DrawerItemDef> _companyItems = [
  // Phase C3 — the visual org organogram: Head Office -> Regions ->
  // Venues, each level showing its actual people, expandable downward,
  // add/invite/rename/reset-password actions right on it. Executive-only.
  _DrawerItemDef(
    icon: Icons.account_tree_outlined,
    label: 'Organisation',
    minTier: RoleTier.executive,
    screenBuilder: (_) => const OrganisationTreeScreen(),
  ),
  // A REGIONAL manager's own single-region view, a different tier than
  // the executive-only Organisation tree above.
  _DrawerItemDef(
    icon: Icons.storefront_outlined,
    label: 'Branches',
    minTier: RoleTier.regional,
    screenBuilder: (_) => const BranchManagementScreen(),
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
  Widget? _section({
    required String label,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    if (children.isEmpty) return null;
    return ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      childrenPadding: EdgeInsets.zero,
      children: children,
    );
  }

  List<Widget> _itemTiles(
    BuildContext context,
    List<_DrawerItemDef> items,
    bool Function(RoleTier) atLeast,
  ) {
    return [
      for (final item in items)
        if (atLeast(item.minTier))
          _navTile(
            icon: item.icon,
            label: item.label,
            onTap: () => _navigate(context, item.screenBuilder(context)),
          ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final tier = currentUser?.roleTier;

    bool atLeast(RoleTier minTier) =>
        tier != null && roleTierRank(tier) >= roleTierRank(minTier);

    final sections = <Widget?>[
      // DAILY — always non-empty for any tier that reaches this Drawer at
      // all (Home/My Tasks/Oversight are unconditional), expanded by
      // default: the items a supervisor+ actually touches every shift.
      _section(
        label: 'Daily',
        initiallyExpanded: true,
        children: [
          _navTile(
            icon: Icons.home_outlined,
            label: 'Home',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          _navTile(
            icon: Icons.checklist,
            label: 'My Tasks',
            onTap: () => _navigate(context, const TaskScreen()),
          ),
          if (tier != null)
            _navTile(
              icon: Icons.visibility,
              label: 'Oversight',
              onTap: () => _navigate(
                context,
                TierHomeScreen.oversightScreenFor(tier),
              ),
            ),
          // Renamed from "Fails & Problems Register" (2026-09-17) — the
          // screen gained an Issues & Incidents tab 2026-09-15; the old
          // name only reflected half of what's actually in there now.
          if (atLeast(RoleTier.supervisor))
            _navTile(
              icon: Icons.report_problem_outlined,
              label: 'Problems & Issues',
              onTap: () => _navigate(context, const ProblemsRegisterScreen()),
            ),
          if (atLeast(RoleTier.supervisor))
            _navTile(
              icon: Icons.insights,
              label: 'Dashboard',
              onTap: () => _navigate(context, const DashboardScreen()),
            ),
        ],
      ),
      // INSIGHTS — venueManager+ reporting/monitoring, collapsed by
      // default (checked occasionally, not every shift).
      _section(
        label: 'Insights',
        children: [
          ..._itemTiles(context, [_insightsItems[0]], atLeast),
          if (atLeast(_ehoExportMinTier))
            _navTile(
              icon: Icons.picture_as_pdf_outlined,
              label: 'EHO / Audit Export',
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
          ..._itemTiles(context, _insightsItems.sublist(1), atLeast),
        ],
      ),
      // PEOPLE — staff/team structure. Branch Team Structure keeps its
      // original supervisor+ gate (moved here from the top nav cluster,
      // gate unchanged), so a supervisor sees this section with just that
      // one item — a harmless, deliberately-accepted one-item section
      // rather than complicating the tier-gating rule to avoid it.
      _section(
        label: 'People',
        children: _itemTiles(context, _peopleItems, atLeast),
      ),
      // VENUE SETUP — venueManager+ configuration, all one tier floor.
      _section(
        label: 'Venue Setup',
        children: _itemTiles(context, _venueSetupItems, atLeast),
      ),
      // COMPANY — org-structure viewers grouped together (previously sat
      // apart, mid-list, among unrelated config items). Invisible to
      // supervisor/venueManager (neither item's gate reaches that low).
      _section(
        label: 'Company',
        children: _itemTiles(context, _companyItems, atLeast),
      ),
      // ACCOUNT — collapsed by default like every non-Daily section, per
      // the approved spec, even though Log out is used every session.
      _section(
        label: 'Account',
        children: [
          _navTile(
            icon: Icons.settings,
            label: 'Settings',
            onTap: () => _navigate(context, const SettingsScreen()),
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
              label: 'Two-Factor Authentication',
              onTap: () =>
                  _navigate(context, const TwoFactorSettingsScreen()),
            ),
          if (atLeast(_backUpMinTier))
            _navTile(
              icon: Icons.backup,
              label: 'Back Up Now',
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
          _navTile(
            icon: Icons.logout,
            label: 'Log out',
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
    ].whereType<Widget>().toList();

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
        ],
      ),
    );
  }
}
