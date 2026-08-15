import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/home/tier_home_screen.dart';
import '../../features/notifications/notification_rules_screen.dart';
import '../../features/onboarding/staff_assignment_screen.dart';
import '../../features/settings/department_management_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/staff_management_screen.dart';
import '../../features/settings/supplier_management_screen.dart';
import '../../features/settings/third_party_contacts_screen.dart';
import '../../features/settings/venue_details_screen.dart';
import '../../features/task_library/preset_management_screen.dart';
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

// Sprint 031: single source of truth for management-drawer visibility, per
// "Tier feature access" — venue-configuration items are venueManager-
// minimum (Assign Tasks included: it creates recurring TaskSchedule rows,
// a setup responsibility, not shift-floor work, so supervisor doesn't get
// it). Regional/executive inherit this same set via roleTierRank, plus
// whatever their own tier-specific items add once those are built.
final List<_DrawerItemDef> _managementItems = [
  _DrawerItemDef(
    icon: Icons.store,
    label: 'Venue Setup',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const VenueSetupWizardScreen(),
  ),
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
    icon: Icons.checklist,
    label: 'Task Presets',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const PresetManagementScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.badge,
    label: 'Staff Management',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const StaffManagementScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.notifications,
    label: 'Notification Rules',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const NotificationRulesScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.contact_phone,
    label: 'Maintenance Contacts',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const ThirdPartyContactsScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.local_shipping,
    label: 'Supplier Management',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const SupplierManagementScreen(),
  ),
  _DrawerItemDef(
    icon: Icons.groups,
    label: 'Department Management',
    minTier: RoleTier.venueManager,
    screenBuilder: (_) => const DepartmentManagementScreen(),
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
class ManagementDrawer extends ConsumerWidget {
  const ManagementDrawer({
    super.key,
    required this.title,
    this.onBackUp,
    this.onEhoExport,
    this.onLogout,
  });

  final String title;
  // Nullable (Sprint 031, navigation-consistency pass) — Back Up Now / EHO
  // Export only appear when the caller supplies these, since only
  // ManagerScreen/TopScreen wire them; every other screen this drawer is
  // now on (TierHomeScreen, TaskScreen, Settings, the 9 tool screens) omits
  // them rather than duplicating the callback wiring everywhere. Home is
  // always one tap away from any of those two actions regardless.
  //
  // A callback captured from the calling screen's own long-lived `ref`,
  // not a call made directly with this widget's own `ref` — found via a
  // real runtime crash (Sprint 031): the export dialog awaits a date
  // picker before its first `ref.read`, and by then this Drawer had
  // already been disposed by the Navigator.pop() that closed it, making
  // its own `ref` unsafe to use. Back Up Now already avoided this by
  // using a callback; this now matches that same pattern.
  final VoidCallback? onBackUp;
  final VoidCallback? onEhoExport;
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final tier = currentUser?.roleTier;

    bool atLeast(RoleTier minTier) =>
        tier != null && roleTierRank(tier) >= roleTierRank(minTier);

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
          // Universal navigation (Sprint 031, navigation-consistency pass)
          // — present on every screen this drawer is used on, ungated,
          // since every non-base tier can always reach its own tasks, the
          // oversight view for its tier, and Settings. Home pops to root
          // rather than pushing — TierHomeScreen is already MaterialApp.home
          // for every non-base tier, so this never stacks a duplicate copy.
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('My Tasks'),
            onTap: () => _navigate(context, const TaskScreen()),
          ),
          if (tier != null)
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Oversight'),
              onTap: () => _navigate(
                context,
                TierHomeScreen.oversightScreenFor(tier),
              ),
            ),
          // Dashboard + worker recognition (Sprint 031, Sub-sprint B) —
          // supervisor and above, matching supervisor sharing venueManager's
          // venue-wide dashboard (confirmed before building). This drawer
          // only ever renders for supervisor+ in the first place (base has
          // no drawer at all), so `atLeast` is always true here — kept for
          // documentation clarity, not because it currently excludes anyone.
          if (tier != null && atLeast(RoleTier.supervisor))
            ListTile(
              leading: const Icon(Icons.insights),
              title: const Text('Dashboard'),
              onTap: () => _navigate(context, const DashboardScreen()),
            ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => _navigate(context, const SettingsScreen()),
          ),
          const Divider(),
          for (final item in _managementItems)
            if (atLeast(item.minTier))
              ListTile(
                leading: Icon(item.icon),
                title: Text(item.label),
                onTap: () => _navigate(context, item.screenBuilder(context)),
              ),
          if (onBackUp != null && atLeast(_backUpMinTier))
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Back Up Now'),
              onTap: () {
                Navigator.pop(context);
                onBackUp!();
              },
            ),
          if (onEhoExport != null && atLeast(_ehoExportMinTier))
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: const Text('EHO / Audit Export'),
              onTap: () {
                Navigator.pop(context);
                onEhoExport!();
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
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
