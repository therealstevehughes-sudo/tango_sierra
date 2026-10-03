import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/friendly_error.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/job_title_field.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/common_job_title.dart';
import '../../shared/models/department.dart';
import '../../shared/models/team.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/department_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/team_providers.dart';
import '../settings/widgets/add_staff_dialog.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../l10n/app_localizations.dart';

// Chain of command / branch organogram (2026-09-15, upgraded 2026-09-27
// from read-only to interactive per the founder's original ask: "people
// added, moved, removed, from tiers, positions, and such"). Deliberately a
// SEPARATE screen from OrganisationTreeScreen (Phase C3), not an extra
// level added to it — that one is executive/regional-scoped (Head Office
// -> Region -> Venue managers); this one is branch-manager-scoped, going
// inside a single venue to show its own staff's reporting lines via
// User.reportsToUserId.
//
// Menu-based actions, not drag-and-drop (confirmed with the founder,
// 2026-09-27) — reuses the exact tested dialog patterns Staff Management
// already has, rather than building this app's first gesture-based
// drag-and-drop UI for a "nice-to-have, not a hard requirement" per the
// founder's own framing.
//
// Renders downward-expanding, same convention as OrganisationTreeScreen. A
// person with no reportsToUserId set is a root of their own — most
// branches will show several roots until a manager goes through this
// screen (or Staff Management) and sets it for everyone, which is expected
// and shown honestly, not hidden.
class BranchOrgChartScreen extends ConsumerStatefulWidget {
  const BranchOrgChartScreen({super.key});

  @override
  ConsumerState<BranchOrgChartScreen> createState() =>
      _BranchOrgChartScreenState();
}

class _BranchOrgChartScreenState extends ConsumerState<BranchOrgChartScreen> {
  bool _loading = true;
  String? _error;
  List<User> _staff = [];
  Map<int, Department> _departmentsById = {};
  Map<int, Team> _teamsById = {};
  int? _siteId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final activeSite = ref.read(activeSiteProvider);
      final currentUser = ref.read(currentUserProvider);
      final siteId =
          activeSite?.id ??
          currentUser?.siteId ??
          (await ref.read(currentSiteProvider.future)).id;
      final staff = await ref.read(userRepositoryProvider).getForSite(siteId);

      final departmentRepo = ref.read(departmentRepositoryProvider);
      final teamRepo = ref.read(teamRepositoryProvider);
      final departments = await departmentRepo.getForSite(siteId);
      final departmentsById = <int, Department>{};
      final teamsById = <int, Team>{};
      for (final d in departments) {
        departmentsById[d.id!] = d;
        for (final t in await teamRepo.getForDepartment(d.id!)) {
          teamsById[t.id!] = t;
        }
      }

      if (!mounted) return;
      setState(() {
        _staff = staff.where((u) => u.active).toList();
        _departmentsById = departmentsById;
        _teamsById = teamsById;
        _siteId = siteId;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyErrorMessage(AppLocalizations.of(context)!, e);
        _loading = false;
      });
    }
  }

  RoleTier? get _managerTier => ref.read(currentUserProvider)?.roleTier;

  Future<void> _addStaff() async {
    final manager = ref.read(currentUserProvider);
    final siteId = _siteId;
    if (manager == null || siteId == null) return;
    final created = await showAddStaffDialog(
      context,
      ref: ref,
      siteId: siteId,
      actingManagerTier: manager.roleTier,
    );
    if (created == null || !mounted) return;
    await _load();
  }

  // Mirrors staff_management_screen.dart's _changeReportsTo exact shape —
  // deliberately unrestricted by tier, per the standing decision that an
  // informal reporting line between peers isn't this app's business to
  // police.
  Future<void> _changeReportsTo(User user) async {
    final options = _staff.where((u) => u.id != user.id).toList();
    var selected = user.reportsToUserId;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.changeManagerTitle(user.name)),
            content: DropdownButtonFormField<int?>(
              initialValue: selected,
              decoration: InputDecoration(labelText: l10n.reportsToFieldLabel),
              items: [
                DropdownMenuItem<int?>(value: null, child: Text(l10n.notSetOption)),
                ...options.map(
                  (u) => DropdownMenuItem<int?>(value: u.id, child: Text(u.name)),
                ),
              ],
              onChanged: (value) => setDialogState(() => selected = value),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.saveButton),
              ),
            ],
          );
        },
      ),
    );
    if (confirmed != true || selected == user.reportsToUserId) return;

    await ref
        .read(userRepositoryProvider)
        .assignReportsTo(userId: user.id, reportsToUserId: selected);
    if (!mounted) return;
    await _load();
  }

  // Mirrors staff_management_screen.dart's _changeDepartment shape, gated
  // by canMoveDepartment (2026-09-27) — see that function's own doc
  // comment in user.dart.
  Future<void> _changeDepartment(User user) async {
    final siteId = _siteId;
    if (siteId == null) return;
    final departmentRepo = ref.read(departmentRepositoryProvider);
    final teamRepo = ref.read(teamRepositoryProvider);
    final siteDepartments = await departmentRepo.getForSite(siteId);
    final currentDepartment = user.departmentId == null
        ? null
        : _departmentsById[user.departmentId];
    final departmentOptions = [
      ...siteDepartments,
      if (currentDepartment != null &&
          !siteDepartments.any((d) => d.id == currentDepartment.id))
        currentDepartment,
    ];
    final teamsByDept = <int, List<Team>>{};
    for (final d in departmentOptions) {
      teamsByDept[d.id!] = await teamRepo.getForDepartment(d.id!);
    }
    if (!mounted) return;

    var selectedDepartment = user.departmentId;
    var selectedTeam = user.teamId;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          final teamOptions = selectedDepartment == null
              ? const <Team>[]
              : (teamsByDept[selectedDepartment] ?? const <Team>[]);
          return AlertDialog(
            title: Text(l10n.moveDepartmentTitle(user.name)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<int?>(
                  initialValue: selectedDepartment,
                  decoration: InputDecoration(labelText: l10n.departmentLabel),
                  items: [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text(l10n.noDepartmentOption),
                    ),
                    ...departmentOptions.map(
                      (d) => DropdownMenuItem<int?>(
                        value: d.id,
                        child: Text(
                          d.active ? d.name : '${d.name}${l10n.inactiveParenSuffix}',
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) => setDialogState(() {
                    selectedDepartment = value;
                    if (value == null ||
                        !(teamsByDept[value] ?? const <Team>[]).any(
                          (t) => t.id == selectedTeam,
                        )) {
                      selectedTeam = null;
                    }
                  }),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int?>(
                  initialValue: selectedTeam,
                  decoration: InputDecoration(
                    labelText: l10n.teamOptionalLabel,
                  ),
                  items: [
                    DropdownMenuItem<int?>(
                      value: null,
                      child: Text(l10n.noSpecificTeamOption),
                    ),
                    ...teamOptions.map(
                      (t) => DropdownMenuItem<int?>(
                        value: t.id,
                        child: Text(
                          t.active ? t.name : '${t.name}${l10n.inactiveParenSuffix}',
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) =>
                      setDialogState(() => selectedTeam = value),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.saveButton),
              ),
            ],
          );
        },
      ),
    );
    if (confirmed != true) return;
    if (selectedDepartment == user.departmentId &&
        selectedTeam == user.teamId) {
      return;
    }

    final repo = ref.read(userRepositoryProvider);
    if (selectedDepartment != user.departmentId) {
      await repo.changeDepartment(
        userId: user.id,
        departmentId: selectedDepartment,
      );
    }
    if (selectedTeam != user.teamId) {
      await repo.assignTeam(userId: user.id, teamId: selectedTeam);
    }
    if (!mounted) return;
    await _load();
  }

  // Gated by canChangeTier (2026-09-27) — the dropdown only offers tiers
  // the acting manager is actually allowed to set; re-checked before the
  // write, same defense-in-depth reasoning as staff_management_screen.dart.
  Future<void> _changeTier(User user) async {
    final managerTier = _managerTier;
    if (managerTier == null) return;
    var selected = user.roleTier;
    final allowedTiers = [
      user.roleTier,
      ...RoleTier.values.where(
        (t) =>
            t != user.roleTier &&
            canChangeTier(
              actingTier: managerTier,
              targetTier: user.roleTier,
              newTier: t,
            ),
      ),
    ];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.changeTierTitle2(user.name)),
            content: DropdownButtonFormField<RoleTier>(
              initialValue: selected,
              decoration: InputDecoration(labelText: l10n.roleTierLabel),
              items: allowedTiers
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(roleTierDisplayName(t, l10n)),
                    ),
                  )
                  .toList(),
              onChanged: (value) =>
                  setDialogState(() => selected = value ?? selected),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.saveButton),
              ),
            ],
          );
        },
      ),
    );
    if (confirmed != true || selected == user.roleTier) return;
    if (!canChangeTier(
      actingTier: managerTier,
      targetTier: user.roleTier,
      newTier: selected,
    )) {
      return;
    }

    await ref
        .read(userRepositoryProvider)
        .changeRoleTier(userId: user.id, newTier: selected);
    if (!mounted) return;
    await _load();
  }

  Future<void> _editJobTitle(User user) async {
    final controller = TextEditingController(text: user.jobTitle);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.editJobTitleTitle(user.name)),
          content: JobTitleField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.saveButton),
            ),
          ],
        );
      },
    );
    final newTitle = controller.text.trim();
    controller.dispose();
    if (confirmed != true || newTitle.isEmpty || newTitle == user.jobTitle) {
      return;
    }

    await ref
        .read(userRepositoryProvider)
        .updateDetails(userId: user.id, jobTitle: newTitle);
    if (!mounted) return;
    await _load();
  }

  // Orphan protection (2026-09-27, agreed with the founder: warn-and-
  // optionally-reassign, not a hard block) — anyone currently reporting to
  // [user] would otherwise silently become their own root the moment
  // [user] is deactivated. Shown explicitly, with a one-tap fix offered
  // rather than left to be discovered later.
  Future<void> _removeFromBranch(User user) async {
    final managerTier = _managerTier;
    final manager = ref.read(currentUserProvider);
    if (managerTier == null ||
        manager == null ||
        !canDeactivate(actingTier: managerTier, targetTier: user.roleTier)) {
      return;
    }

    final reports = _staff.where((u) => u.reportsToUserId == user.id).toList();
    var reassign = false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.removeFromBranchTitle(user.name)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.removeFromBranchConfirmText(user.name)),
                if (reports.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.reportsWillBeUnassignedText(
                      reports.length,
                      user.name,
                      reports.map((r) => r.name).join(', '),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: reassign,
                    onChanged: (v) =>
                        setDialogState(() => reassign = v ?? false),
                    title: Text(
                      l10n.reassignToManagerLabel(user.name),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.removeAnywayButton),
              ),
            ],
          );
        },
      ),
    );
    if (confirmed != true) return;

    final repo = ref.read(userRepositoryProvider);
    if (reassign && reports.isNotEmpty) {
      for (final report in reports) {
        await repo.assignReportsTo(
          userId: report.id,
          reportsToUserId: user.reportsToUserId,
        );
      }
    }
    await repo.setActive(
      userId: user.id,
      active: false,
      actingUserId: manager.id,
    );
    if (!mounted) return;
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final staffIds = _staff.map((u) => u.id).toSet();
    final childrenOf = <int, List<User>>{};
    for (final u in _staff) {
      if (u.reportsToUserId != null && staffIds.contains(u.reportsToUserId)) {
        childrenOf.putIfAbsent(u.reportsToUserId!, () => []).add(u);
      }
    }
    // Leaf siblings before branch siblings (2026-09-28, direct founder
    // report): plain depth-first + alphabetical buried a childless Duty
    // Manager at the very bottom of the list, after her same-tier sibling
    // F&B Manager's entire Kitchen + Functions & Events subtree — even
    // though both report directly to the GM. A person with no reports of
    // their own now sorts ahead of a same-tier sibling who has reports, so
    // they render right under the GM alongside the other department heads
    // instead of being pushed down by however large a sibling's branch is.
    int byLeafThenTierThenName(User a, User b) {
      final aHasReports = childrenOf[a.id]?.isNotEmpty ?? false;
      final bHasReports = childrenOf[b.id]?.isNotEmpty ?? false;
      if (aHasReports != bHasReports) return aHasReports ? 1 : -1;
      return _byTierThenName(a, b);
    }

    final roots = _staff
        .where(
          (u) =>
              u.reportsToUserId == null ||
              !staffIds.contains(u.reportsToUserId),
        )
        .toList()
      ..sort(byLeafThenTierThenName);
    for (final list in childrenOf.values) {
      list.sort(byLeafThenTierThenName);
    }

    final managerTier = _managerTier;

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.branchTeamStructureTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt),
            tooltip: l10n.addStaffTooltip,
            onPressed: _addStaff,
          ),
          const AssistantIconButton(),
        ],
      ),
      drawer: ManagementDrawer(title: l10n.branchTeamStructureTitle),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? LoadErrorView(error: _error!, onRetry: _load)
          : _staff.isEmpty
          ? Center(child: Text(l10n.noStaffAtBranchText))
          : ResponsiveContent(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final root in roots)
                    _PersonNode(
                      user: root,
                      childrenOf: childrenOf,
                      depth: 0,
                      departmentsById: _departmentsById,
                      teamsById: _teamsById,
                      managerTier: managerTier,
                      onChangeReportsTo: _changeReportsTo,
                      onChangeDepartment: _changeDepartment,
                      onChangeTier: _changeTier,
                      onEditJobTitle: _editJobTitle,
                      onRemove: _removeFromBranch,
                    ),
                ],
              ),
            ),
    );
  }

  int _byTierThenName(User a, User b) {
    final tierCompare = roleTierRank(b.roleTier).compareTo(
      roleTierRank(a.roleTier),
    );
    return tierCompare != 0 ? tierCompare : a.name.compareTo(b.name);
  }
}

enum _NodeAction { changeManager, changeDepartment, changeTier, editJobTitle, remove }

class _PersonNode extends StatelessWidget {
  const _PersonNode({
    required this.user,
    required this.childrenOf,
    required this.depth,
    required this.departmentsById,
    required this.teamsById,
    required this.managerTier,
    required this.onChangeReportsTo,
    required this.onChangeDepartment,
    required this.onChangeTier,
    required this.onEditJobTitle,
    required this.onRemove,
  });

  final User user;
  final Map<int, List<User>> childrenOf;
  final int depth;
  final Map<int, Department> departmentsById;
  final Map<int, Team> teamsById;
  final RoleTier? managerTier;
  final ValueChanged<User> onChangeReportsTo;
  final ValueChanged<User> onChangeDepartment;
  final ValueChanged<User> onChangeTier;
  final ValueChanged<User> onEditJobTitle;
  final ValueChanged<User> onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reports = childrenOf[user.id] ?? const <User>[];
    final department = user.departmentId == null
        ? null
        : departmentsById[user.departmentId];
    final team = user.teamId == null ? null : teamsById[user.teamId];
    final subtitleParts = [
      '${localizedJobTitle(user.jobTitle, l10n)} · ${roleTierDisplayName(user.roleTier, l10n)}',
      if (department != null)
        team != null ? '${department.name} · ${team.name}' : department.name,
    ];

    final canChangeThisTier =
        managerTier != null &&
        RoleTier.values.any(
          (t) => canChangeTier(
            actingTier: managerTier!,
            targetTier: user.roleTier,
            newTier: t,
          ),
        );
    final canMoveThis =
        managerTier != null &&
        canMoveDepartment(actingTier: managerTier!, targetTier: user.roleTier);
    final canRemoveThis =
        managerTier != null &&
        canDeactivate(actingTier: managerTier!, targetTier: user.roleTier);

    final card = Padding(
      padding: EdgeInsets.only(left: depth * 24.0, bottom: 8),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitleParts.join(' · '),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (reports.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.tealTint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.reportsCountBadge(reports.length),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.tealInk,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            PopupMenuButton<_NodeAction>(
              tooltip: l10n.moreActionsTooltip,
              onSelected: (action) {
                switch (action) {
                  case _NodeAction.changeManager:
                    onChangeReportsTo(user);
                  case _NodeAction.changeDepartment:
                    onChangeDepartment(user);
                  case _NodeAction.changeTier:
                    onChangeTier(user);
                  case _NodeAction.editJobTitle:
                    onEditJobTitle(user);
                  case _NodeAction.remove:
                    onRemove(user);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _NodeAction.changeManager,
                  child: Text(l10n.changeManagerMenuItem),
                ),
                if (canMoveThis)
                  PopupMenuItem(
                    value: _NodeAction.changeDepartment,
                    child: Text(l10n.moveDepartmentMenuItem),
                  ),
                if (canChangeThisTier)
                  PopupMenuItem(
                    value: _NodeAction.changeTier,
                    child: Text(l10n.changeTierMenuItem),
                  ),
                PopupMenuItem(
                  value: _NodeAction.editJobTitle,
                  child: Text(l10n.editJobTitleMenuItem),
                ),
                if (canRemoveThis)
                  PopupMenuItem(
                    value: _NodeAction.remove,
                    child: Text(l10n.removeFromBranchMenuItem),
                  ),
              ],
            ),
          ],
        ),
      ),
    );

    if (reports.isEmpty) return card;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        card,
        for (final report in reports)
          _PersonNode(
            user: report,
            childrenOf: childrenOf,
            depth: depth + 1,
            departmentsById: departmentsById,
            teamsById: teamsById,
            managerTier: managerTier,
            onChangeReportsTo: onChangeReportsTo,
            onChangeDepartment: onChangeDepartment,
            onChangeTier: onChangeTier,
            onEditJobTitle: onEditJobTitle,
            onRemove: onRemove,
          ),
      ],
    );
  }
}
