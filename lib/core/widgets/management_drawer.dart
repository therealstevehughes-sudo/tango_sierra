import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../features/notifications/notification_rules_screen.dart';
import '../../features/onboarding/staff_assignment_screen.dart';
import '../../features/settings/staff_management_screen.dart';
import '../../features/settings/third_party_contacts_screen.dart';
import '../../features/settings/venue_details_screen.dart';
import '../../features/task_library/preset_management_screen.dart';
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
    required this.onBackUp,
    required this.onEhoExport,
  });

  final String title;
  final VoidCallback onBackUp;
  // A callback captured from the calling screen's own long-lived `ref`,
  // not a call made directly with this widget's own `ref` — found via a
  // real runtime crash (Sprint 031): the export dialog awaits a date
  // picker before its first `ref.read`, and by then this Drawer had
  // already been disposed by the Navigator.pop() that closed it, making
  // its own `ref` unsafe to use. Back Up Now already avoided this by
  // using a callback; this now matches that same pattern.
  final VoidCallback onEhoExport;

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
          for (final item in _managementItems)
            if (atLeast(item.minTier))
              ListTile(
                leading: Icon(item.icon),
                title: Text(item.label),
                onTap: () => _navigate(context, item.screenBuilder(context)),
              ),
          if (atLeast(_backUpMinTier))
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Back Up Now'),
              onTap: () {
                Navigator.pop(context);
                onBackUp();
              },
            ),
          if (atLeast(_ehoExportMinTier))
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: const Text('EHO / Audit Export'),
              onTap: () {
                Navigator.pop(context);
                onEhoExport();
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () {
              Navigator.pop(context);
              ref.read(currentUserProvider.notifier).state = null;
            },
          ),
        ],
      ),
    );
  }
}
