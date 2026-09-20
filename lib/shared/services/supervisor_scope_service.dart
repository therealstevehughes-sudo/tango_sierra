import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../providers/auth_providers.dart';
import '../providers/department_providers.dart';
import '../providers/supervision_providers.dart';
import '../providers/team_providers.dart';

// Sections/Teams scoping (2026-09-18), factored out (2026-09-20) — first
// built for the Leadership Dashboard, now shared with ManagerScreen's
// Oversight log too, since a Supervisor's "which people can I see data
// for" rule is one fact, not something to redefine per screen. Every
// present/future screen that shows a Supervisor other people's data
// should compute its allowed-user set through this, not re-derive its own.
class SupervisorScope {
  const SupervisorScope({required this.allowedUserIds, required this.scopeLabels});

  final Set<int> allowedUserIds;
  final List<String> scopeLabels;
}

/// Resolves which user ids a Supervisor may see data for at [siteId]: every
/// active staff member in one of their supervised Departments or Teams.
/// Returns null for every other tier (no restriction — Venue Manager+
/// still sees the whole branch, unchanged) or when [currentUser] is null.
Future<SupervisorScope?> computeSupervisorScope(
  WidgetRef ref, {
  required User? currentUser,
  required int siteId,
}) async {
  if (currentUser == null || currentUser.roleTier != RoleTier.supervisor) {
    return null;
  }

  final activeStaff = (await ref
          .read(userRepositoryProvider)
          .getForSite(siteId))
      .where((u) => u.active)
      .toList();

  final supervisionRepo = ref.read(supervisionRepositoryProvider);
  final departmentIds = (await supervisionRepo.getSupervisedDepartmentIds(
    currentUser.id,
  )).toSet();
  final teamIds = (await supervisionRepo.getSupervisedTeamIds(
    currentUser.id,
  )).toSet();

  final allowedUserIds = activeStaff
      .where(
        (u) =>
            (u.departmentId != null &&
                departmentIds.contains(u.departmentId)) ||
            (u.teamId != null && teamIds.contains(u.teamId)),
      )
      .map((u) => u.id)
      .toSet();

  final departments = await ref
      .read(departmentRepositoryProvider)
      .getForSite(siteId);
  final scopeLabels = departments
      .where((d) => departmentIds.contains(d.id))
      .map((d) => d.name)
      .toList();
  final teamRepo = ref.read(teamRepositoryProvider);
  for (final d in departments) {
    final teams = await teamRepo.getForDepartment(d.id!);
    scopeLabels.addAll(
      teams.where((t) => teamIds.contains(t.id)).map((t) => t.name),
    );
  }

  return SupervisorScope(allowedUserIds: allowedUserIds, scopeLabels: scopeLabels);
}
