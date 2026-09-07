import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/department.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/department_providers.dart';

enum _DepartmentAction { rename, toggleActive }

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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;
    final repo = ref.read(departmentRepositoryProvider);
    final loaded = await repo.getForSite(currentUser.siteId);

    if (!mounted) return;
    setState(() {
      departments = loaded;
      loading = false;
    });
  }

  Future<void> _addDepartment() async {
    final nameController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Department'),
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

    if (confirmed != true) return;
    if (nameController.text.trim().isEmpty) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final repo = ref.read(departmentRepositoryProvider);
    await repo.create(
      name: nameController.text.trim(),
      siteId: currentUser.siteId,
    );

    if (!mounted) return;
    await _loadData();
  }

  Future<void> _rename(Department department) async {
    final nameController = TextEditingController(text: department.name);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename — ${department.name}'),
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

    if (confirmed != true) return;
    if (nameController.text.trim().isEmpty) return;

    final repo = ref.read(departmentRepositoryProvider);
    await repo.rename(department.id!, nameController.text.trim());

    if (!mounted) return;
    await _loadData();
  }

  Future<void> _toggleActive(Department department) async {
    final repo = ref.read(departmentRepositoryProvider);
    await repo.setActive(department.id!, !department.active);

    if (!mounted) return;
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Department Management')),
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
    return Card(
      child: ListTile(
        title: Text(department.name),
        subtitle: department.active ? null : const Text('(inactive)'),
        trailing: PopupMenuButton<_DepartmentAction>(
          tooltip: 'More actions',
          onSelected: (action) {
            switch (action) {
              case _DepartmentAction.rename:
                _rename(department);
              case _DepartmentAction.toggleActive:
                _toggleActive(department);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: _DepartmentAction.rename,
              child: Text('Rename'),
            ),
            PopupMenuItem(
              value: _DepartmentAction.toggleActive,
              child: Text(department.active ? 'Deactivate' : 'Reactivate'),
            ),
          ],
        ),
      ),
    );
  }
}
