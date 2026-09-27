import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/department.dart';
import '../../shared/models/team.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/department_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/team_providers.dart';
import '../settings/widgets/add_staff_dialog.dart';

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
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Change manager - ${user.name}'),
          content: DropdownButtonFormField<int?>(
            initialValue: selected,
            decoration: const InputDecoration(labelText: 'Reports to'),
            items: [
              const DropdownMenuItem<int?>(value: null, child: Text('Not set')),
              ...options.map(
                (u) => DropdownMenuItem<int?>(value: u.id, child: Text(u.name)),
              ),
            ],
            onChanged: (value) => setDialogState(() => selected = value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        ),
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
          final teamOptions = selectedDepartment == null
              ? const <Team>[]
              : (teamsByDept[selectedDepartment] ?? const <Team>[]);
          return AlertDialog(
            title: Text('Move department/team - ${user.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<int?>(
                  initialValue: selectedDepartment,
                  decoration: const InputDecoration(labelText: 'Department'),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('No department'),
                    ),
                    ...departmentOptions.map(
                      (d) => DropdownMenuItem<int?>(
                        value: d.id,
                        child: Text(d.active ? d.name : '${d.name} (inactive)'),
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
                  decoration: const InputDecoration(
                    labelText: 'Team (optional)',
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('No specific team'),
                    ),
                    ...teamOptions.map(
                      (t) => DropdownMenuItem<int?>(
                        value: t.id,
                        child: Text(t.active ? t.name : '${t.name} (inactive)'),
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
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Save'),
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
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Change tier - ${user.name}'),
          content: DropdownButtonFormField<RoleTier>(
            initialValue: selected,
            decoration: const InputDecoration(labelText: 'Role tier'),
            items: allowedTiers
                .map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(roleTierDisplayName(t)),
                  ),
                )
                .toList(),
            onChanged: (value) =>
                setDialogState(() => selected = value ?? selected),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        ),
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
      builder: (context) => AlertDialog(
        title: Text('Edit job title - ${user.name}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Job title'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
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
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Remove ${user.name} from this branch'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.name} will no longer be able to log in. This can be '
                'reversed later.',
              ),
              if (reports.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  '${reports.length} ${reports.length == 1 ? 'person' : 'people'} '
                  'currently report to ${user.name}: '
                  '${reports.map((r) => r.name).join(', ')}. '
                  'Removing ${user.name} will leave them unassigned until '
                  'reassigned.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: reassign,
                  onChanged: (v) =>
                      setDialogState(() => reassign = v ?? false),
                  title: Text(
                    'Reassign them to ${user.name}\'s own manager instead',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove anyway'),
            ),
          ],
        ),
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
    final staffIds = _staff.map((u) => u.id).toSet();
    final roots = _staff
        .where(
          (u) =>
              u.reportsToUserId == null ||
              !staffIds.contains(u.reportsToUserId),
        )
        .toList()
      ..sort(_byTierThenName);
    final childrenOf = <int, List<User>>{};
    for (final u in _staff) {
      if (u.reportsToUserId != null && staffIds.contains(u.reportsToUserId)) {
        childrenOf.putIfAbsent(u.reportsToUserId!, () => []).add(u);
      }
    }
    for (final list in childrenOf.values) {
      list.sort(_byTierThenName);
    }

    final managerTier = _managerTier;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Branch Team Structure'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt),
            tooltip: 'Add Staff',
            onPressed: _addStaff,
          ),
          const AssistantIconButton(),
        ],
      ),
      drawer: const ManagementDrawer(title: 'Branch Team Structure'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _staff.isEmpty
          ? const Center(child: Text('No staff at this branch yet.'))
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
    final reports = childrenOf[user.id] ?? const <User>[];
    final department = user.departmentId == null
        ? null
        : departmentsById[user.departmentId];
    final team = user.teamId == null ? null : teamsById[user.teamId];
    final subtitleParts = [
      '${user.jobTitle} · ${roleTierDisplayName(user.roleTier)}',
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
                  '${reports.length} report${reports.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.tealInk,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            PopupMenuButton<_NodeAction>(
              tooltip: 'More actions',
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
                const PopupMenuItem(
                  value: _NodeAction.changeManager,
                  child: Text('Change manager'),
                ),
                if (canMoveThis)
                  const PopupMenuItem(
                    value: _NodeAction.changeDepartment,
                    child: Text('Move department/team'),
                  ),
                if (canChangeThisTier)
                  const PopupMenuItem(
                    value: _NodeAction.changeTier,
                    child: Text('Change tier'),
                  ),
                const PopupMenuItem(
                  value: _NodeAction.editJobTitle,
                  child: Text('Edit job title'),
                ),
                if (canRemoveThis)
                  const PopupMenuItem(
                    value: _NodeAction.remove,
                    child: Text('Remove from this branch'),
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
