import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';

class StaffManagementScreen extends ConsumerStatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  ConsumerState<StaffManagementScreen> createState() =>
      _StaffManagementScreenState();
}

class _StaffManagementScreenState
    extends ConsumerState<StaffManagementScreen> {
  bool loading = true;
  List<User> staff = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = ref.read(userRepositoryProvider);
    final loaded = await repo.getAll();

    if (!mounted) return;
    setState(() {
      staff = loaded;
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
                .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
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

    return Scaffold(
      appBar: AppBar(title: const Text('Staff Management')),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: staff.length,
          itemBuilder: (context, index) => _buildStaffTile(staff[index]),
        ),
      ),
    );
  }

  Widget _buildStaffTile(User user) {
    final deactivatedBy = _deactivatedByName(user);
    final subtitleParts = <String>[
      '${user.jobTitle} · ${user.roleTier.name}',
      if (!user.active) '(deactivated)',
      if (!user.active && user.deactivatedAt != null && deactivatedBy != null)
        'on ${user.deactivatedAt!.toLocal().toString().split('.').first} '
            'by $deactivatedBy',
    ];

    return Card(
      child: ListTile(
        title: Text(user.name),
        subtitle: Text(subtitleParts.join('\n')),
        isThreeLine: subtitleParts.length > 2,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => _changeRoleTier(user),
              child: const Text('Change Tier'),
            ),
            TextButton(
              onPressed: () => _resetPin(user),
              child: const Text('Reset PIN'),
            ),
            TextButton(
              onPressed: () => user.active
                  ? _deactivate(user)
                  : _setActive(user, true),
              child: Text(user.active ? 'Deactivate' : 'Reactivate'),
            ),
          ],
        ),
      ),
    );
  }
}
