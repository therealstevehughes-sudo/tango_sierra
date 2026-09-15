import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme/app_colors.dart';
import '../../core/services/document_store.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/document.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/document_providers.dart';
import '../../shared/providers/site_providers.dart';

// Document Centre (roadmap v1.1, built 2026-09-15) — policies, certs,
// procedures, EHO reports, plus an expiry summary so a manager sees
// what's expiring before an inspector does. Gated venueManager+ in the
// drawer (see ManagementDrawer), same floor as Supplier/Third-party
// Contacts management.
class DocumentCentreScreen extends ConsumerStatefulWidget {
  const DocumentCentreScreen({super.key});

  @override
  ConsumerState<DocumentCentreScreen> createState() =>
      _DocumentCentreScreenState();
}

class _DocumentCentreScreenState extends ConsumerState<DocumentCentreScreen> {
  bool _loading = true;
  int? _siteId;
  List<Document> _documents = [];
  DocumentCategory? _categoryFilter;

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
    final documents = await ref
        .read(documentRepositoryProvider)
        .getForSite(siteId);
    if (!mounted) return;
    setState(() {
      _siteId = siteId;
      _documents = documents.where((d) => d.active).toList();
      _loading = false;
    });
  }

  Future<void> _upload() async {
    final siteId = _siteId;
    final currentUser = ref.read(currentUserProvider);
    if (siteId == null || currentUser == null) return;

    final path = await ref.read(documentStoreProvider).pickAndPersist();
    if (path == null || !mounted) return;

    final titleController = TextEditingController();
    var category = DocumentCategory.policy;
    DateTime? expiryDate;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Document'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<DocumentCategory>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: DocumentCategory.values
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(documentCategoryDisplayName(c)),
                      ),
                    )
                    .toList(),
                onChanged: (v) =>
                    setDialogState(() => category = v ?? category),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  expiryDate == null
                      ? 'No expiry date'
                      : 'Expires ${formatDate(expiryDate!)}',
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (picked != null) {
                      setDialogState(() => expiryDate = picked);
                    }
                  },
                  child: const Text('Set expiry'),
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

    final title = titleController.text.trim();
    titleController.dispose();
    if (confirmed != true || title.isEmpty) return;

    await ref.read(documentRepositoryProvider).create(
      siteId: siteId,
      title: title,
      category: category,
      filePath: path,
      expiryDate: expiryDate,
      uploadedByUserId: currentUser.id,
    );

    if (!mounted) return;
    await _load();
  }

  Future<void> _openDocument(Document doc) async {
    final uri = Uri.file(doc.filePath);
    final opened = await launchUrl(uri);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this file.')),
      );
    }
  }

  Future<void> _retire(Document doc) async {
    if (doc.id == null) return;
    await ref.read(documentRepositoryProvider).setActive(doc.id!, false);
    if (!mounted) return;
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _categoryFilter == null
        ? _documents
        : _documents.where((d) => d.category == _categoryFilter).toList();

    final expiringCount = _documents
        .where((d) => d.expiryStatus == DocumentExpiryStatus.expiringSoon)
        .length;
    final expiredCount = _documents
        .where((d) => d.expiryStatus == DocumentExpiryStatus.expired)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Centre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Add Document',
            onPressed: _upload,
          ),
        ],
      ),
      drawer: const ManagementDrawer(title: 'Document Centre'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ResponsiveContent(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: _ExpiryCount(
                              count: _documents.length - expiringCount - expiredCount,
                              label: 'Valid',
                              color: AppColors.pass,
                            ),
                          ),
                          Expanded(
                            child: _ExpiryCount(
                              count: expiringCount,
                              label: 'Expiring soon',
                              color: AppColors.caution,
                            ),
                          ),
                          Expanded(
                            child: _ExpiryCount(
                              count: expiredCount,
                              label: 'Expired',
                              color: AppColors.critical,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('All'),
                          selected: _categoryFilter == null,
                          onSelected: (_) =>
                              setState(() => _categoryFilter = null),
                        ),
                        for (final c in DocumentCategory.values)
                          ChoiceChip(
                            label: Text(documentCategoryDisplayName(c)),
                            selected: _categoryFilter == c,
                            onSelected: (_) =>
                                setState(() => _categoryFilter = c),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: visible.isEmpty
                        ? const Center(child: Text('No documents yet.'))
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: visible.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) => _DocumentTile(
                              document: visible[index],
                              onOpen: () => _openDocument(visible[index]),
                              onRetire: () => _retire(visible[index]),
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _ExpiryCount extends StatelessWidget {
  const _ExpiryCount({
    required this.count,
    required this.label,
    required this.color,
  });

  final int count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.w700),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.document,
    required this.onOpen,
    required this.onRetire,
  });

  final Document document;
  final VoidCallback onOpen;
  final VoidCallback onRetire;

  @override
  Widget build(BuildContext context) {
    final (Color fg, Color bg, String label) = switch (document.expiryStatus) {
      DocumentExpiryStatus.valid => (AppColors.pass, AppColors.passBg, 'Valid'),
      DocumentExpiryStatus.expiringSoon => (
        AppColors.caution,
        AppColors.cautionBg,
        'Expiring soon',
      ),
      DocumentExpiryStatus.expired => (
        AppColors.critical,
        AppColors.criticalBg,
        'Expired',
      ),
    };

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  documentCategoryDisplayName(document.category),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (document.expiryDate != null)
                  Text(
                    'Expires ${formatDate(document.expiryDate!)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: fg, fontWeight: FontWeight.w600),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) => v == 'open' ? onOpen() : onRetire(),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'open', child: Text('Open')),
              PopupMenuItem(value: 'retire', child: Text('Retire')),
            ],
          ),
        ],
      ),
    );
  }
}
