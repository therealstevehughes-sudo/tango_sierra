import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/friendly_error.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/supplier.dart';
import '../../shared/models/supplier_category.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/supplier_providers.dart';
import '../suppliers/supplier_detail_screen.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../l10n/app_localizations.dart';

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
  String? loadError;
  List<Supplier> suppliers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      loading = true;
      loadError = null;
    });
    // One silent retry before showing an error — see
    // venue_setup_wizard_screen.dart's own _loadData() for the full
    // explanation: reading `currentSiteProvider.future` this early can hit
    // a rare Riverpod internal race ("_listenedElement was called on
    // null"), caught live during a demo. A persistent failure still
    // surfaces via loadError on the second attempt.
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        final currentUser = ref.read(currentUserProvider);
        if (currentUser == null) {
          setState(() {
            loadError = AppLocalizations.of(context)!.noSignedInUserError;
            loading = false;
          });
          return;
        }
        final repo = ref.read(supplierRepositoryProvider);
        final siteId =
            ref.read(activeSiteProvider)?.id ??
            currentUser.siteId ??
            (await ref.read(currentSiteProvider.future)).id;
        final loaded = await repo.getForSite(siteId);

        if (!mounted) return;
        setState(() {
          suppliers = loaded;
          loading = false;
        });
        return;
      } catch (e) {
        if (!mounted) return;
        if (attempt == 0) continue;
        setState(() {
          loadError = friendlyErrorMessage(AppLocalizations.of(context)!, e);
          loading = false;
        });
      }
    }
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
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.addSupplierButton),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: l10n.nameAxisLabel),
                    autofocus: true,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: contactController,
                    decoration: InputDecoration(
                      labelText: l10n.contactOptionalLabel,
                      hintText: l10n.phoneOrEmailHint,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<SupplierCategory>(
                    initialValue: category,
                    decoration: InputDecoration(labelText: l10n.categoryLabel),
                    items: SupplierCategory.values
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(supplierCategoryLabel(c, l10n)),
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
                      decoration: InputDecoration(
                        labelText: l10n.customCategoryTitleLabel,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(l10n.approvalStatusLabel),
                  const SizedBox(height: 4),
                  // Visual pass follow-up (2026-09-24, app-wide tick-box
                  // sweep) — 3 fixed options, converted from a dropdown to
                  // a compact chip row (not a vertical list, to keep this
                  // dialog's height sane).
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final s in SupplierApprovalStatus.values)
                        ChoiceChip(
                          label: Text(supplierApprovalStatusLabel(s, l10n)),
                          selected: approvalStatus == s,
                          onSelected: (_) =>
                              setDialogState(() => approvalStatus = s),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: approvalNoteController,
                    decoration: InputDecoration(
                      labelText: l10n.approvalNoteLabel,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: nameController.text.trim().isNotEmpty
                    ? () => Navigator.pop(context, true)
                    : null,
                child: Text(l10n.saveButton),
              ),
            ],
          );
        },
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
      siteId: currentUser.siteId!,
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
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.editDetailsForSupplierTitle(supplier.name)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: l10n.nameAxisLabel),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: contactController,
                    decoration: InputDecoration(
                      labelText: l10n.contactOptionalLabel,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<SupplierCategory>(
                    initialValue: category,
                    decoration: InputDecoration(labelText: l10n.categoryLabel),
                    items: SupplierCategory.values
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(supplierCategoryLabel(c, l10n)),
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
                      decoration: InputDecoration(
                        labelText: l10n.customCategoryTitleLabel,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: nameController.text.trim().isNotEmpty
                    ? () => Navigator.pop(context, true)
                    : null,
                child: Text(l10n.saveButton),
              ),
            ],
          );
        },
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
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.changeApprovalStatusTitle(supplier.name)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.approvalStatusLabel),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final s in SupplierApprovalStatus.values)
                      ChoiceChip(
                        label: Text(supplierApprovalStatusLabel(s, l10n)),
                        selected: status == s,
                        onSelected: (_) => setDialogState(() => status = s),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: l10n.approvalNoteLabel,
                  ),
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.supplierManagementTitle),
        actions: const [AssistantIconButton()],
      ),
      drawer: ManagementDrawer(title: l10n.supplierManagementTitle),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : loadError != null
          ? LoadErrorView(error: loadError!, onRetry: _loadData)
          : SafeArea(
        child: ResponsiveContent(
          child: suppliers.isEmpty
              ? Center(child: Text(l10n.noSuppliersAddedYetText))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: suppliers.length,
                  itemBuilder: (context, index) =>
                      _buildSupplierTile(suppliers[index]),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addSupplier,
        icon: const Icon(Icons.add),
        label: Text(l10n.addSupplierButton),
      ),
    );
  }

  Widget _buildSupplierTile(Supplier supplier) {
    final l10n = AppLocalizations.of(context)!;
    final subtitleParts = <String>[
      supplier.displayCategory,
      if (supplier.contact != null) supplier.contact!,
      if (!supplier.active) l10n.inactiveStandaloneLabel,
    ];

    final (kind, label) = switch (supplier.approvalStatus) {
      SupplierApprovalStatus.approved => (StatusKind.pass, l10n.supplierStatusApproved),
      SupplierApprovalStatus.pending => (StatusKind.caution, l10n.supplierStatusPending),
      SupplierApprovalStatus.suspended => (StatusKind.critical, l10n.supplierStatusSuspended),
    };

    return AppCard(
      child: ListTile(
        title: Text(supplier.name),
        subtitle: Text(subtitleParts.join(' · ')),
        isThreeLine: subtitleParts.length > 2,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SupplierDetailScreen(supplier: supplier),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusBadge(kind: kind, label: label),
            PopupMenuButton<_SupplierAction>(
              tooltip: l10n.moreActionsTooltip,
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
                PopupMenuItem(
                  value: _SupplierAction.editDetails,
                  child: Text(l10n.editDetailsTitle),
                ),
                PopupMenuItem(
                  value: _SupplierAction.changeApprovalStatus,
                  child: Text(l10n.changeApprovalStatusMenuItem),
                ),
                PopupMenuItem(
                  value: _SupplierAction.toggleActive,
                  child: Text(supplier.active ? l10n.deactivateButton : l10n.reactivateButton),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
