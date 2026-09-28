import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/department.dart';
import '../../shared/models/team.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/department_providers.dart';
import '../../shared/providers/team_providers.dart';

enum _DepartmentAction { rename, toggleActive }

enum _TeamAction { rename, toggleActive }

// Sections/Teams (2026-09-18) — each Department (section) is now
// expandable to show and manage its Teams (e.g. "Night Team"/"Day Team"
// inside "Kitchen"). Kept as ONE screen (not a separate Team Management
// page) since a Team only ever makes sense in the context of its parent
// section — the same reasoning ManagementDrawer's own section-vs-item
// nesting already follows.
class DepartmentManagementScreen extends ConsumerStatefulWidget {
  const DepartmentManagementScreen({super.key});

  @override
  ConsumerState<DepartmentManagementScreen> createState() =>
      _DepartmentManagementScreenState();
}

class _DepartmentManagementScreenState
    extends ConsumerState<DepartmentManagementScreen> {
  bool loading = true;
  List<Department> departments = [];
  Map<int, List<Team>> teamsByDepartment = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;
    final departmentRepo = ref.read(departmentRepositoryProvider);
    final teamRepo = ref.read(teamRepositoryProvider);
    final loadedDepartments = await departmentRepo.getForSite(
      currentUser.siteId!,
    );

    final teamLists = await Future.wait(
      loadedDepartments.map((d) => teamRepo.getForDepartment(d.id!)),
    );
    final teamsByDept = {
      for (var i = 0; i < loadedDepartments.length; i++)
        loadedDepartments[i].id!: teamLists[i],
    };

    if (!mounted) return;
    setState(() {
      departments = loadedDepartments;
      teamsByDepartment = teamsByDept;
      loading = false;
    });
  }

  Future<String?> _promptForName({
    required String title,
    String initial = '',
  }) async {
    final nameController = TextEditingController(text: initial);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
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
    if (confirmed != true) return null;
    final name = nameController.text.trim();
    return name.isEmpty ? null : name;
  }

  // Category picker (2026-09-28, direct founder request) — a separate
  // dialog from _promptForName rather than folding a dropdown into it,
  // since "name" and "category" are independent concepts (see
  // Department's own doc comment): a venue can have two differently-named
  // kitchens, both tagged with the same Kitchen category. Returns null on
  // cancel; returns an explicit `DepartmentCategory?` (nullable inside the
  // result) on save, where null means "no category" was deliberately kept.
  Future<(String, DepartmentCategory?)?> _promptForDepartment({
    required String title,
    String initialName = '',
    DepartmentCategory? initialCategory,
  }) async {
    final nameController = TextEditingController(text: initialName);
    var selectedCategory = initialCategory;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<DepartmentCategory?>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  for (final category in DepartmentCategory.values)
                    DropdownMenuItem(
                      value: category,
                      child: Text(departmentCategoryDisplayName(category)),
                    ),
                ],
                onChanged: (value) =>
                    setDialogState(() => selectedCategory = value),
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
      ),
    );
    if (confirmed != true) return null;
    final name = nameController.text.trim();
    if (name.isEmpty) return null;
    return (name, selectedCategory);
  }

  Future<void> _addDepartment() async {
    final result = await _promptForDepartment(title: 'Add Department');
    if (result == null) return;
    final (name, category) = result;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final repo = ref.read(departmentRepositoryProvider);
    await repo.create(
      name: name,
      siteId: currentUser.siteId!,
      category: category,
    );

    if (!mounted) return;
    await _loadData();
  }

  Future<void> _renameDepartment(Department department) async {
    final result = await _promptForDepartment(
      title: 'Edit - ${department.name}',
      initialName: department.name,
      initialCategory: department.category,
    );
    if (result == null) return;
    final (name, category) = result;

    final repo = ref.read(departmentRepositoryProvider);
    if (name != department.name) {
      await repo.rename(department.id!, name);
    }
    if (category != department.category) {
      await repo.setCategory(department.id!, category);
    }

    if (!mounted) return;
    await _loadData();
  }

  Future<void> _toggleDepartmentActive(Department department) async {
    final repo = ref.read(departmentRepositoryProvider);
    await repo.setActive(department.id!, !department.active);

    if (!mounted) return;
    await _loadData();
  }

  Future<void> _addTeam(Department department) async {
    final name = await _promptForName(title: 'Add Team - ${department.name}');
    if (name == null) return;

    final repo = ref.read(teamRepositoryProvider);
    await repo.create(name: name, departmentId: department.id!);

    if (!mounted) return;
    await _loadData();
  }

  Future<void> _renameTeam(Team team) async {
    final name = await _promptForName(
      title: 'Rename - ${team.name}',
      initial: team.name,
    );
    if (name == null) return;

    final repo = ref.read(teamRepositoryProvider);
    await repo.rename(team.id!, name);

    if (!mounted) return;
    await _loadData();
  }

  Future<void> _toggleTeamActive(Team team) async {
    final repo = ref.read(teamRepositoryProvider);
    await repo.setActive(team.id!, !team.active);

    if (!mounted) return;
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Management'),
        actions: const [AssistantIconButton()],
      ),
      drawer: const ManagementDrawer(title: 'Department Management'),
      body: SafeArea(
        child: ResponsiveContent(
          child: departments.isEmpty
              ? const Center(child: Text('No departments added yet.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: departments.length,
                  itemBuilder: (context, index) =>
                      _buildDepartmentTile(departments[index]),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addDepartment,
        icon: const Icon(Icons.add),
        label: const Text('Add Department'),
      ),
    );
  }

  Widget _buildDepartmentTile(Department department) {
    final teams = teamsByDepartment[department.id] ?? const <Team>[];
    return AppCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        // Layout fix (2026-09-25) — see faq_screen.dart's own comment on
        // this same ExpansionTile-vs-Card corner artifact fix.
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        title: Text(department.name),
        subtitle: Text(
          [
            if (department.category != null)
              departmentCategoryDisplayName(department.category!),
            department.active
                ? (teams.isEmpty
                      ? 'No teams yet'
                      : '${teams.length} team${teams.length == 1 ? '' : 's'}')
                : '(inactive)',
          ].join(' · '),
        ),
        trailing: PopupMenuButton<_DepartmentAction>(
          tooltip: 'More actions',
          onSelected: (action) {
            switch (action) {
              case _DepartmentAction.rename:
                _renameDepartment(department);
              case _DepartmentAction.toggleActive:
                _toggleDepartmentActive(department);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: _DepartmentAction.rename,
              child: Text('Edit'),
            ),
            PopupMenuItem(
              value: _DepartmentAction.toggleActive,
              child: Text(department.active ? 'Deactivate' : 'Reactivate'),
            ),
          ],
        ),
        children: [
          for (final team in teams)
            ListTile(
              contentPadding: const EdgeInsets.only(left: 32, right: 16),
              title: Text(team.name),
              subtitle: team.active ? null : const Text('(inactive)'),
              trailing: PopupMenuButton<_TeamAction>(
                tooltip: 'More actions',
                onSelected: (action) {
                  switch (action) {
                    case _TeamAction.rename:
                      _renameTeam(team);
                    case _TeamAction.toggleActive:
                      _toggleTeamActive(team);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: _TeamAction.rename,
                    child: Text('Rename'),
                  ),
                  PopupMenuItem(
                    value: _TeamAction.toggleActive,
                    child: Text(team.active ? 'Deactivate' : 'Reactivate'),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _addTeam(department),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Team'),
                style: TextButton.styleFrom(foregroundColor: AppColors.muted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
