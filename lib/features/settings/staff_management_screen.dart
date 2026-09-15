import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/department.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/department_providers.dart';
import '../../shared/providers/site_providers.dart';
import 'training_records_screen.dart';

// Approximate height of a single staff tile Card + padding, for the
// A–Z quick-jump scroll target calculation. Not pixel-perfect (subtitle
// lines vary) but close enough for a smooth scroll-to-letter experience.
const _kStaffTileHeight = 88.0;

enum _StaffAction {
  editDetails,
  changeTier,
  changeDepartment,
  changeReportsTo,
  resetPin,
  toggleActive,
  trainingRecords,
}

class StaffManagementScreen extends ConsumerStatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  ConsumerState<StaffManagementScreen> createState() =>
      _StaffManagementScreenState();
}

class _StaffManagementScreenState extends ConsumerState<StaffManagementScreen> {
  bool loading = true;
  List<User> staff = [];
  final ScrollController _scrollController = ScrollController();
  // Keyed by department id, populated from every site any loaded staff
  // member belongs to — Staff Management isn't itself site-filtered yet
  // (a pre-existing, separately logged gap), so this can't assume one site.
  Map<int, Department> departmentsById = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = ref.read(userRepositoryProvider);
    final activeSite = ref.read(activeSiteProvider);
    final currentUser = ref.read(currentUserProvider);
    final siteId =
        activeSite?.id ??
        currentUser?.siteId ??
        (await ref.read(currentSiteProvider.future)).id;
    final loaded = await repo.getForSite(siteId);

    final departmentRepo = ref.read(departmentRepositoryProvider);
    final byId = <int, Department>{};
    for (final siteId in loaded.map((u) => u.siteId).whereType<int>().toSet()) {
      final departments = await departmentRepo.getForSite(siteId);
      for (final department in departments) {
        byId[department.id!] = department;
      }
    }

    if (!mounted) return;
    setState(() {
      staff = loaded;
      departmentsById = byId;
      loading = false;
    });
  }

  String? _deactivatedByName(User user) {
    if (user.deactivatedByUserId == null) return null;
    for (final candidate in staff) {
      if (candidate.id == user.deactivatedByUserId) return candidate.name;
    }
    return 'user #${user.deactivatedByUserId}';
  }

  Future<void> _resetPin(User user) async {
    final controller = TextEditingController();
    final newPin = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset PIN — ${user.name}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'New PIN'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newPin == null || newPin.isEmpty) return;

    final repo = ref.read(userRepositoryProvider);
    await repo.resetPin(userId: user.id, newPin: newPin);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('PIN reset for ${user.name}')));
  }

  // Built 2026-09-14 — the one staff-detail edit no prior action covered:
  // fixing a typo or updating a title after a promotion. Mirrors
  // _changeRoleTier's exact confirm/save-then-reload shape.
  Future<void> _editDetails(User user) async {
    final nameController = TextEditingController(text: user.name);
    final jobTitleController = TextEditingController(text: user.jobTitle);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: jobTitleController,
              decoration: const InputDecoration(labelText: 'Job title'),
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
      ),
    );

    final newName = nameController.text.trim();
    final newJobTitle = jobTitleController.text.trim();
    nameController.dispose();
    jobTitleController.dispose();

    if (confirmed != true || newName.isEmpty || newJobTitle.isEmpty) return;
    if (newName == user.name && newJobTitle == user.jobTitle) return;

    final repo = ref.read(userRepositoryProvider);
    await repo.updateDetails(
      userId: user.id,
      name: newName == user.name ? null : newName,
      jobTitle: newJobTitle == user.jobTitle ? null : newJobTitle,
    );

    if (!mounted) return;
    await _loadData();
  }

  Future<void> _changeRoleTier(User user) async {
    var selected = user.roleTier;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Change Role Tier — ${user.name}'),
          content: DropdownButtonFormField<RoleTier>(
            initialValue: selected,
            decoration: const InputDecoration(labelText: 'Role tier'),
            items: RoleTier.values
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

    final repo = ref.read(userRepositoryProvider);
    await repo.changeRoleTier(userId: user.id, newTier: selected);

    if (!mounted) return;
    await _loadData();
  }

  Future<void> _changeDepartment(User user) async {
    final departmentRepo = ref.read(departmentRepositoryProvider);
    final siteDepartments = await departmentRepo.getForSite(user.siteId!);

    // If the user's current department was since deactivated, it still
    // needs to appear as a selectable option so the dialog can show the
    // real current value without silently dropping it from the list —
    // same "never silently disappear" principle used elsewhere.
    final currentDepartment = user.departmentId == null
        ? null
        : departmentsById[user.departmentId];
    final options = [
      ...siteDepartments,
      if (currentDepartment != null &&
          !siteDepartments.any((d) => d.id == currentDepartment.id))
        currentDepartment,
    ];

    if (!mounted) return;

    var selected = user.departmentId;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Change Department — ${user.name}'),
          content: DropdownButtonFormField<int?>(
            initialValue: selected,
            decoration: const InputDecoration(labelText: 'Department'),
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('No department'),
              ),
              ...options.map(
                (d) => DropdownMenuItem<int?>(
                  value: d.id,
                  child: Text(d.active ? d.name : '${d.name} (inactive)'),
                ),
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

    if (confirmed != true || selected == user.departmentId) return;

    final repo = ref.read(userRepositoryProvider);
    await repo.changeDepartment(userId: user.id, departmentId: selected);

    if (!mounted) return;
    await _loadData();
  }

  // Chain of command (2026-09-15) — per-individual, mirrors
  // _changeDepartment's exact shape. Excludes the user themselves (can't
  // report to their own self) but otherwise offers everyone at the same
  // site, deliberately not filtered by tier — an informal reporting line
  // between peers isn't this app's business to police.
  Future<void> _changeReportsTo(User user) async {
    final options = staff.where((u) => u.id != user.id).toList();
    var selected = user.reportsToUserId;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Reports To — ${user.name}'),
          content: DropdownButtonFormField<int?>(
            initialValue: selected,
            decoration: const InputDecoration(labelText: 'Reports to'),
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('Not set'),
              ),
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

    final repo = ref.read(userRepositoryProvider);
    await repo.assignReportsTo(userId: user.id, reportsToUserId: selected);

    if (!mounted) return;
    await _loadData();
  }

  Future<void> _deactivate(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Staff Member'),
        content: Text(
          '${user.name} will no longer be able to log in. Their active '
          'task assignments will be unassigned. Their submission history '
          'is not affected. This can be reversed later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await _setActive(user, false);
  }

  Future<void> _setActive(User user, bool active) async {
    final manager = ref.read(currentUserProvider);
    if (manager == null) return;

    final repo = ref.read(userRepositoryProvider);
    await repo.setActive(
      userId: user.id,
      active: active,
      actingUserId: manager.id,
    );

    if (!mounted) return;
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Alphabetical index for quick-jump: staff are already sorted by name
    // from the repo, so we can compute which letters have at least one
    // entry and create a fast-access index column on the right.
    final staffByInitial = <String, int>{};
    for (var i = 0; i < staff.length; i++) {
      final initial = staff[i].name.isNotEmpty
          ? staff[i].name[0].toUpperCase()
          : '#';
      staffByInitial.putIfAbsent(initial, () => i);
    }
    final indexLetters = staffByInitial.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Staff Management')),
      drawer: const ManagementDrawer(title: 'Staff Management'),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ResponsiveContent(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: staff.length,
                  itemBuilder: (context, index) =>
                      _buildStaffTile(staff[index]),
                ),
              ),
            ),
            if (indexLetters.length > 1)
              SizedBox(
                width: 28,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final letter in indexLetters)
                      GestureDetector(
                        onTap: () {
                          final idx = staffByInitial[letter];
                          if (idx != null) {
                            _scrollController.animateTo(
                              idx * _kStaffTileHeight,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Text(
                            letter,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffTile(User user) {
    final deactivatedBy = _deactivatedByName(user);
    final department = user.departmentId == null
        ? null
        : departmentsById[user.departmentId];
    final reportsTo = user.reportsToUserId == null
        ? null
        : staff.where((u) => u.id == user.reportsToUserId).firstOrNull;
    final subtitleParts = <String>[
      '${user.jobTitle} · ${roleTierDisplayName(user.roleTier)}',
      if (department != null) department.name,
      if (reportsTo != null) 'Reports to ${reportsTo.name}',
      if (!user.active) '(deactivated)',
      if (!user.active && user.deactivatedAt != null && deactivatedBy != null)
        'on ${user.deactivatedAt!.toLocal().toString().split('.').first} '
            'by $deactivatedBy',
    ];

    // Sub-sprint 2 (visual/UX pass): was a Row of 3 full-text TextButtons
    // at their natural width in `trailing` — ListTile gives trailing first
    // claim on space, leaving `title: Text(user.name)` almost none, so the
    // name wrapped one letter per line. A single overflow menu guarantees
    // the name a real width while keeping every action fully labelled
    // (just not always visible).
    return Card(
      child: ListTile(
        title: Text(user.name),
        subtitle: Text(subtitleParts.join('\n')),
        isThreeLine: subtitleParts.length > 2,
        trailing: PopupMenuButton<_StaffAction>(
          tooltip: 'More actions',
          onSelected: (action) {
            switch (action) {
              case _StaffAction.editDetails:
                _editDetails(user);
              case _StaffAction.changeTier:
                _changeRoleTier(user);
              case _StaffAction.changeDepartment:
                _changeDepartment(user);
              case _StaffAction.changeReportsTo:
                _changeReportsTo(user);
              case _StaffAction.resetPin:
                _resetPin(user);
              case _StaffAction.toggleActive:
                user.active ? _deactivate(user) : _setActive(user, true);
              case _StaffAction.trainingRecords:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrainingRecordsScreen(staffMember: user),
                  ),
                );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: _StaffAction.editDetails,
              child: Text('Edit Details'),
            ),
            const PopupMenuItem(
              value: _StaffAction.changeTier,
              child: Text('Change Tier'),
            ),
            const PopupMenuItem(
              value: _StaffAction.changeDepartment,
              child: Text('Change Department'),
            ),
            const PopupMenuItem(
              value: _StaffAction.changeReportsTo,
              child: Text('Reports To'),
            ),
            const PopupMenuItem(
              value: _StaffAction.resetPin,
              child: Text('Reset PIN'),
            ),
            PopupMenuItem(
              value: _StaffAction.toggleActive,
              child: Text(user.active ? 'Deactivate' : 'Reactivate'),
            ),
            const PopupMenuItem(
              value: _StaffAction.trainingRecords,
              child: Text('Training Records'),
            ),
          ],
        ),
      ),
    );
  }
}
