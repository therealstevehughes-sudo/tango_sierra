import 'package:flutter/material.dart';

import '../../features/auth/shift_verification_queue_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/dashboard/leadership_dashboard_screen.dart';
import '../../features/home/tier_home_screen.dart';
import '../../features/notifications/notification_rules_screen.dart';
import '../../features/onboarding/staff_assignment_screen.dart';
import '../../features/onboarding/staff_provisioning_screen.dart';
import '../../features/problems/problems_register_screen.dart';
import '../../features/providers/service_providers_screen.dart';
import '../../features/regions/branch_management_screen.dart';
import '../../features/regions/branch_org_chart_screen.dart';
import '../../features/regions/organisation_tree_screen.dart';
import '../../features/roster/fair_auto_assign_screen.dart';
import '../../features/roster/rota_claim_screen.dart';
import '../../features/roster/rota_month_screen.dart';
import '../../features/roster/shift_fairness_screen.dart';
import '../../features/roster/shift_period_settings_screen.dart';
import '../../features/roster/shift_requirements_screen.dart';
import '../../features/settings/billing_screen.dart';
import '../../features/settings/certification_requirements_screen.dart';
import '../../features/settings/department_management_screen.dart';
import '../../features/settings/document_centre_screen.dart';
import '../../features/settings/evidence_prune_screen.dart';
import '../../features/settings/menu_management_screen.dart';
import '../../features/settings/shift_log_screen.dart';
import '../../features/settings/staff_management_screen.dart';
import '../../features/settings/supplier_management_screen.dart';
import '../../features/settings/venue_details_screen.dart';
import '../../features/task_library/preset_management_screen.dart';
import '../../features/tasks/reorder_tasks_screen.dart';
import '../../features/tasks/task_screen.dart';
import '../../features/tasks/training/training_screens.dart';
import '../../features/venue_setup/venue_setup_wizard_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/user.dart';
import '../widgets/menu_hub_screen.dart';

// Menu by role (2026-10-17, founder-approved design — mock-ups at
// https://claude.ai/artifact/ELxn1J9cAYbTmLt54rdryw). One definition of
// what each tier can reach, shared by the side menu, its "Find a screen"
// search and the home tiles, so they can never drift apart.
//
//  - Staff (base): home tiles only (WorkerHubScreen), no side menu.
//  - Supervisor: home tiles + a short flat side menu (supervisorMenu).
//  - Venue Manager and up: 4 headings — Today / Team / Venue / Reports —
//    plus Company for regional/executive (managerMenu).
//
// Items that bundle several screens ("People", "Tasks", "Rota"…) open a
// MenuHubScreen listing their parts. Stage 2 (logged) merges the three
// overview screens behind "Trends" into one.

/// What a menu entry does when tapped.
enum MenuActionKind { push, home, auditExport }

class MenuEntry {
  const MenuEntry({
    required this.icon,
    required this.label,
    this.subtitle,
    this.builder,
    this.children = const [],
    this.action = MenuActionKind.push,
    this.rotaAddon = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final WidgetBuilder? builder;
  final List<MenuEntry> children;
  final MenuActionKind action;

  /// Paid Rota add-on: shown locked (opens the upsell) until it's enabled.
  final bool rotaAddon;

  bool get isHub => children.isNotEmpty;

  /// The screen to open: the item's own, or a hub listing its children.
  WidgetBuilder get screen =>
      builder ??
      (_) => MenuHubScreen(title: label, entries: children);
}

class MenuSection {
  const MenuSection(this.title, this.entries);

  final String title;
  final List<MenuEntry> entries;
}

/// Everything a menu needs to know about the signed-in person.
class MenuContext {
  const MenuContext({
    required this.tier,
    required this.rotaEnabled,
    required this.canSeeBilling,
    required this.onRota,
  });

  final RoleTier tier;
  final bool rotaEnabled;
  final bool canSeeBilling;

  /// Books their own shifts (staff and supervisors by default).
  final bool onRota;

  bool atLeast(RoleTier t) => roleTierRank(tier) >= roleTierRank(t);
}

MenuEntry myShiftsEntry(AppLocalizations l10n) => MenuEntry(
  icon: Icons.calendar_month_outlined,
  label: l10n.menuMyShifts,
  subtitle: l10n.menuMyShiftsSubtitle,
  builder: (_) => const RotaClaimScreen(),
);

/// Supervisor's short, flat side menu (their home is tiles).
List<MenuEntry> supervisorMenu(AppLocalizations l10n, MenuContext c) => [
  MenuEntry(
    icon: Icons.home_outlined,
    label: l10n.homeLabel,
    action: MenuActionKind.home,
  ),
  MenuEntry(
    icon: Icons.checklist,
    label: l10n.myTasksTitle,
    builder: (_) => const TaskScreen(),
  ),
  if (c.rotaEnabled && c.onRota) myShiftsEntry(l10n),
  teamTodayEntry(l10n, c),
  MenuEntry(
    icon: Icons.report_problem_outlined,
    label: l10n.problemsAndIssues,
    builder: (_) => const ProblemsRegisterScreen(),
  ),
  MenuEntry(
    icon: Icons.groups_outlined,
    label: l10n.teamTrainingTitle,
    builder: (_) => const TeamTrainingScreen(),
  ),
  MenuEntry(
    icon: Icons.school_outlined,
    label: l10n.myTrainingTitle,
    builder: (_) => const MyTrainingScreen(),
  ),
  MenuEntry(
    icon: Icons.restaurant_menu_outlined,
    label: l10n.menuManagementTitle,
    builder: (_) => const MenuManagementScreen(),
  ),
  MenuEntry(
    icon: Icons.kitchen_outlined,
    label: l10n.menuAddEquipment,
    builder: (_) => const VenueSetupWizardScreen(),
  ),
];

/// "Team today": what the shift needs from a supervisor right now.
MenuEntry teamTodayEntry(AppLocalizations l10n, MenuContext c) => MenuEntry(
  icon: Icons.groups_2_outlined,
  label: l10n.menuTeamToday,
  subtitle: l10n.menuTeamTodaySubtitle,
  children: [
    MenuEntry(
      icon: Icons.visibility_outlined,
      label: l10n.menuTodayAcrossTeam,
      builder: (_) => TierHomeScreen.oversightScreenFor(c.tier),
    ),
    MenuEntry(
      icon: Icons.verified_outlined,
      label: l10n.shiftVerificationQueueTitle,
      subtitle: l10n.menuClockInsSubtitle,
      builder: (_) => const ShiftVerificationQueueScreen(),
    ),
  ],
);

/// Venue Manager and above: Today / Team / Venue / Reports (+ Company).
List<MenuSection> managerMenu(AppLocalizations l10n, MenuContext c) => [
  MenuSection(l10n.menuSectionToday, [
    MenuEntry(
      icon: Icons.home_outlined,
      label: l10n.homeLabel,
      subtitle: l10n.menuHomeSubtitle,
      action: MenuActionKind.home,
    ),
    MenuEntry(
      icon: Icons.checklist,
      label: l10n.myTasksTitle,
      builder: (_) => const TaskScreen(),
    ),
    MenuEntry(
      icon: Icons.school_outlined,
      label: l10n.myTrainingTitle,
      builder: (_) => const MyTrainingScreen(),
    ),
    if (c.rotaEnabled && c.onRota) myShiftsEntry(l10n),
    MenuEntry(
      icon: Icons.report_problem_outlined,
      label: l10n.problemsAndIssues,
      builder: (_) => const ProblemsRegisterScreen(),
    ),
  ]),
  MenuSection(l10n.menuSectionTeam, [
    MenuEntry(
      icon: Icons.badge_outlined,
      label: l10n.menuPeople,
      subtitle: l10n.menuPeopleSubtitle,
      children: [
        MenuEntry(
          icon: Icons.badge,
          label: l10n.staffManagement,
          builder: (_) => const StaffManagementScreen(),
        ),
        MenuEntry(
          icon: Icons.person_add_alt,
          label: l10n.addTeamMember,
          builder: (_) => const StaffProvisioningScreen(),
        ),
        MenuEntry(
          icon: Icons.groups,
          label: l10n.departmentManagement,
          builder: (_) => const DepartmentManagementScreen(),
        ),
        MenuEntry(
          icon: Icons.account_tree_outlined,
          label: l10n.branchTeamStructure,
          builder: (_) => const BranchOrgChartScreen(),
        ),
      ],
    ),
    MenuEntry(
      icon: Icons.school_outlined,
      label: l10n.teamTrainingTitle,
      builder: (_) => const TeamTrainingScreen(),
    ),
    MenuEntry(
      icon: Icons.schedule_outlined,
      label: l10n.menuClockIns,
      subtitle: l10n.menuClockInsSubtitle,
      children: [
        MenuEntry(
          icon: Icons.schedule_outlined,
          label: l10n.shiftLog,
          builder: (_) => const ShiftLogScreen(),
        ),
        MenuEntry(
          icon: Icons.verified_outlined,
          label: l10n.shiftVerificationQueueTitle,
          builder: (_) => const ShiftVerificationQueueScreen(),
        ),
      ],
    ),
    MenuEntry(
      icon: Icons.calendar_month_outlined,
      label: l10n.menuRota,
      subtitle: l10n.menuRotaSubtitle,
      rotaAddon: true,
      children: [
        MenuEntry(
          icon: Icons.calendar_month_outlined,
          label: l10n.rotaMonthTitle,
          builder: (_) => const RotaMonthScreen(),
        ),
        MenuEntry(
          icon: Icons.rule_outlined,
          label: l10n.masterRotaSettingsTitle,
          builder: (_) => const ShiftRequirementsScreen(),
        ),
        MenuEntry(
          icon: Icons.schedule,
          label: l10n.shiftPeriodsTitle,
          builder: (_) => const ShiftPeriodSettingsScreen(),
        ),
        MenuEntry(
          icon: Icons.auto_awesome_outlined,
          label: l10n.fairAutoAssignTitle,
          builder: (_) => const FairAutoAssignScreen(),
        ),
        MenuEntry(
          icon: Icons.balance_outlined,
          label: l10n.shiftFairnessReview,
          builder: (_) => const ShiftFairnessScreen(),
        ),
      ],
    ),
  ]),
  MenuSection(l10n.menuSectionVenue, [
    MenuEntry(
      icon: Icons.assignment_ind_outlined,
      label: l10n.menuTasks,
      subtitle: l10n.menuTasksSubtitle,
      children: [
        MenuEntry(
          icon: Icons.assignment_ind,
          label: l10n.assignTasks,
          builder: (_) => const StaffAssignmentScreen(),
        ),
        MenuEntry(
          icon: Icons.swap_vert,
          label: l10n.reorderTasksTitle,
          builder: (_) => const ReorderTasksScreen(),
        ),
        MenuEntry(
          icon: Icons.checklist,
          label: l10n.taskPresets,
          builder: (_) => const PresetManagementScreen(),
        ),
      ],
    ),
    MenuEntry(
      icon: Icons.kitchen_outlined,
      label: l10n.menuEquipmentAreas,
      builder: (_) => const VenueSetupWizardScreen(),
    ),
    MenuEntry(
      icon: Icons.restaurant_menu_outlined,
      label: l10n.menuManagementTitle,
      builder: (_) => const MenuManagementScreen(),
    ),
    MenuEntry(
      icon: Icons.handshake_outlined,
      label: l10n.menuSuppliersContractors,
      children: [
        MenuEntry(
          icon: Icons.local_shipping,
          label: l10n.supplierManagement,
          builder: (_) => const SupplierManagementScreen(),
        ),
        MenuEntry(
          icon: Icons.handshake_outlined,
          label: l10n.serviceProviders,
          builder: (_) => const ServiceProvidersScreen(),
        ),
      ],
    ),
    MenuEntry(
      icon: Icons.folder_copy_outlined,
      label: l10n.documentCentre,
      builder: (_) => const DocumentCentreScreen(),
    ),
    MenuEntry(
      icon: Icons.notifications_outlined,
      label: l10n.menuAlerts,
      builder: (_) => const NotificationRulesScreen(),
    ),
    MenuEntry(
      icon: Icons.location_city,
      label: l10n.menuVenueSettings,
      subtitle: l10n.menuVenueSettingsSubtitle,
      builder: (_) => const VenueDetailsScreen(),
    ),
  ]),
  MenuSection(l10n.menuSectionReports, [
    MenuEntry(
      icon: Icons.insights,
      label: l10n.menuTrends,
      subtitle: l10n.menuTrendsSubtitle,
      children: [
        MenuEntry(
          icon: Icons.visibility_outlined,
          label: l10n.menuTodayAcrossTeam,
          builder: (_) => TierHomeScreen.oversightScreenFor(c.tier),
        ),
        MenuEntry(
          icon: Icons.bar_chart,
          label: l10n.menuTasksIncidentsOverTime,
          subtitle: c.atLeast(RoleTier.regional) ? l10n.menuCompareBranches : null,
          builder: (_) => const LeadershipDashboardScreen(),
        ),
        MenuEntry(
          icon: Icons.insights,
          label: l10n.menuReliabilityTeam,
          builder: (_) => const DashboardScreen(),
        ),
      ],
    ),
    MenuEntry(
      icon: Icons.picture_as_pdf_outlined,
      label: l10n.menuAuditExport,
      action: MenuActionKind.auditExport,
    ),
    MenuEntry(
      icon: Icons.photo_library_outlined,
      label: l10n.photoEvidence,
      builder: (_) => const EvidencePruneScreen(),
    ),
  ]),
  if (c.atLeast(RoleTier.regional))
    MenuSection(l10n.menuSectionCompany, [
      MenuEntry(
        icon: Icons.account_tree_outlined,
        label: l10n.menuCompanyStructure,
        subtitle: l10n.menuCompanyStructureSubtitle,
        children: [
          if (c.atLeast(RoleTier.executive))
            MenuEntry(
              icon: Icons.account_tree_outlined,
              label: l10n.organisationLabel,
              builder: (_) => const OrganisationTreeScreen(),
            ),
          MenuEntry(
            icon: Icons.storefront_outlined,
            label: l10n.branchesLabel,
            builder: (_) => const BranchManagementScreen(),
          ),
        ],
      ),
      MenuEntry(
        icon: Icons.verified_outlined,
        label: l10n.certificationRequirementsTitle,
        builder: (_) => const CertificationRequirementsScreen(),
      ),
      if (c.canSeeBilling)
        MenuEntry(
          icon: Icons.receipt_long_outlined,
          label: l10n.billingLabel,
          subtitle: l10n.menuBillingSubtitle,
          builder: (_) => const BillingScreen(),
        ),
    ]),
  // A Venue Manager a Director has allowed billing access gets it here.
  if (!c.atLeast(RoleTier.regional) && c.canSeeBilling)
    MenuSection(l10n.menuSectionCompany, [
      MenuEntry(
        icon: Icons.receipt_long_outlined,
        label: l10n.billingLabel,
        builder: (_) => const BillingScreen(),
      ),
    ]),
];

/// Flattened, searchable list: every reachable screen, including the
/// parts inside hubs, paired with where it lives.
List<(MenuEntry entry, String where)> searchableEntries(
  List<MenuSection> sections,
) => [
  for (final s in sections)
    for (final e in s.entries) ...[
      (e, s.title),
      for (final child in e.children) (child, '${s.title} › ${e.label}'),
    ],
];
