import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/status_badge.dart';
import '../../shared/models/supplier.dart';
import '../../shared/models/supplier_category.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/supplier_providers.dart';

enum _SupplierAction { editDetails, changeApprovalStatus, toggleActive }

class SupplierManagementScreen extends ConsumerStatefulWidget {
  const SupplierManagementScreen({super.key});

  @override
  ConsumerState<SupplierManagementScreen> createState() =>
      _SupplierManagementScreenState();
}

class _SupplierManagementScreenState
    extends ConsumerState<SupplierManagementScreen> {
  bool loading = true;
  List<Supplier> suppliers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;
    final repo = ref.read(supplierRepositoryProvider);
    final loaded = await repo.getForSite(currentUser.siteId);

    if (!mounted) return;
    setState(() {
      suppliers = loaded;
      loading = false;
    });
  }

  Future<void> _addSupplier() async {
    final nameController = TextEditingController();
    final contactController = TextEditingController();
    final customCategoryController = TextEditingController();
    final approvalNoteController = TextEditingController();
    var category = SupplierCategory.freshProduce;
    var approvalStatus = SupplierApprovalStatus.approved;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Supplier'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact (optional)',
                    hintText: 'Phone or email',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<SupplierCategory>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: SupplierCategory.values
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(supplierCategoryLabel(c)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => category = value ?? category),
                ),
                if (category == SupplierCategory.other) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: customCategoryController,
                    decoration: const InputDecoration(
                      labelText: 'Custom category title',
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                DropdownButtonFormField<SupplierApprovalStatus>(
                  initialValue: approvalStatus,
                  decoration: const InputDecoration(
                    labelText: 'Approval status',
                  ),
                  items: SupplierApprovalStatus.values
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(supplierApprovalStatusLabel(s)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setDialogState(
                    () => approvalStatus = value ?? approvalStatus,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: approvalNoteController,
                  decoration: const InputDecoration(
                    labelText: 'Approval / due-diligence note (optional)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: nameController.text.trim().isNotEmpty
                  ? () => Navigator.pop(context, true)
                  : null,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final repo = ref.read(supplierRepositoryProvider);
    await repo.create(
      name: nameController.text.trim(),
      contact: contactController.text.trim().isEmpty
          ? null
          : contactController.text.trim(),
      category: category,
      customCategoryTitle: category == SupplierCategory.other
          ? customCategoryController.text.trim()
          : null,
      approvalStatus: approvalStatus,
      approvalNote: approvalNoteController.text.trim().isEmpty
          ? null
          : approvalNoteController.text.trim(),
      siteId: currentUser.siteId,
    );

    if (!mounted) return;
    await _loadData();
  }

  Future<void> _editDetails(Supplier supplier) async {
    final nameController = TextEditingController(text: supplier.name);
    final contactController = TextEditingController(
      text: supplier.contact ?? '',
    );
    final customCategoryController = TextEditingController(
      text: supplier.customCategoryTitle ?? '',
    );
    var category = supplier.category;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit Details — ${supplier.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<SupplierCategory>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: SupplierCategory.values
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(supplierCategoryLabel(c)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => category = value ?? category),
                ),
                if (category == SupplierCategory.other) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: customCategoryController,
                    decoration: const InputDecoration(
                      labelText: 'Custom category title',
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: nameController.text.trim().isNotEmpty
                  ? () => Navigator.pop(context, true)
                  : null,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    final repo = ref.read(supplierRepositoryProvider);
    await repo.updateDetails(
      supplier.id!,
      name: nameController.text.trim(),
      contact: contactController.text.trim().isEmpty
          ? null
          : contactController.text.trim(),
      category: category,
      customCategoryTitle: category == SupplierCategory.other
          ? customCategoryController.text.trim()
          : null,
    );

    if (!mounted) return;
    await _loadData();
  }

  Future<void> _changeApprovalStatus(Supplier supplier) async {
    var status = supplier.approvalStatus;
    final noteController = TextEditingController(
      text: supplier.approvalNote ?? '',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Change Approval Status — ${supplier.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<SupplierApprovalStatus>(
                initialValue: status,
                decoration: const InputDecoration(
                  labelText: 'Approval status',
                ),
                items: SupplierApprovalStatus.values
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(supplierApprovalStatusLabel(s)),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setDialogState(() => status = value ?? status),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Approval / due-diligence note (optional)',
                ),
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

    if (confirmed != true) return;

    final repo = ref.read(supplierRepositoryProvider);
    await repo.setApprovalStatus(
      supplier.id!,
      status,
      approvalNote: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
    );

    if (!mounted) return;
    await _loadData();
  }

  Future<void> _toggleActive(Supplier supplier) async {
    final repo = ref.read(supplierRepositoryProvider);
    await repo.setActive(supplier.id!, !supplier.active);

    if (!mounted) return;
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Supplier Management')),
      body: SafeArea(
        child: suppliers.isEmpty
            ? const Center(child: Text('No suppliers added yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: suppliers.length,
                itemBuilder: (context, index) =>
                    _buildSupplierTile(suppliers[index]),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSupplier,
        icon: const Icon(Icons.add),
        label: const Text('Add Supplier'),
      ),
    );
  }

  Widget _buildSupplierTile(Supplier supplier) {
    final subtitleParts = <String>[
      supplier.displayCategory,
      if (supplier.contact != null) supplier.contact!,
      if (!supplier.active) '(inactive)',
    ];

    final (kind, label) = switch (supplier.approvalStatus) {
      SupplierApprovalStatus.approved => (StatusKind.pass, 'Approved'),
      SupplierApprovalStatus.pending => (StatusKind.caution, 'Pending'),
      SupplierApprovalStatus.suspended => (StatusKind.critical, 'Suspended'),
    };

    return Card(
      child: ListTile(
        title: Text(supplier.name),
        subtitle: Text(subtitleParts.join(' · ')),
        isThreeLine: subtitleParts.length > 2,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusBadge(kind: kind, label: label),
            PopupMenuButton<_SupplierAction>(
              tooltip: 'More actions',
              onSelected: (action) {
                switch (action) {
                  case _SupplierAction.editDetails:
                    _editDetails(supplier);
                  case _SupplierAction.changeApprovalStatus:
                    _changeApprovalStatus(supplier);
                  case _SupplierAction.toggleActive:
                    _toggleActive(supplier);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: _SupplierAction.editDetails,
                  child: Text('Edit Details'),
                ),
                const PopupMenuItem(
                  value: _SupplierAction.changeApprovalStatus,
                  child: Text('Change Approval Status'),
                ),
                PopupMenuItem(
                  value: _SupplierAction.toggleActive,
                  child: Text(supplier.active ? 'Deactivate' : 'Reactivate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
