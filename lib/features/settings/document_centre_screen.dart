import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme/app_colors.dart';
import '../../core/services/document_store.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/assistant_icon_button.dart';
import 'generate_sop_document_screen.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/document.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/document_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../l10n/app_localizations.dart';

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
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.addDocumentTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: l10n.titleFieldLabel),
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<DocumentCategory>(
                  initialValue: category,
                  decoration: InputDecoration(labelText: l10n.categoryLabel),
                  items: DocumentCategory.values
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(documentCategoryDisplayName(c, l10n)),
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
                        ? l10n.noExpiryDateText
                        : l10n.expiresOnLabel(formatDate(expiryDate!)),
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
                    child: Text(l10n.setExpiryButton),
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
        SnackBar(content: Text(AppLocalizations.of(context)!.couldNotOpenFileText)),
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
    final l10n = AppLocalizations.of(context)!;
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
      appBar: AppScreenHeader(
        title: Text(l10n.documentCentreTitle),
        actions: [
          const AssistantIconButton(),
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: l10n.generateWithAiButton,
            onPressed: () async {
              final saved = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => const GenerateSopDocumentScreen(),
                ),
              );
              if (saved == true) await _load();
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: l10n.addDocumentTitle,
            onPressed: _upload,
          ),
        ],
      ),
      drawer: ManagementDrawer(title: l10n.documentCentreTitle),
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
                              label: l10n.validLabel,
                              color: AppColors.pass,
                            ),
                          ),
                          Expanded(
                            child: _ExpiryCount(
                              count: expiringCount,
                              label: l10n.expiringSoonLabel,
                              color: AppColors.caution,
                            ),
                          ),
                          Expanded(
                            child: _ExpiryCount(
                              count: expiredCount,
                              label: l10n.expiredLabel,
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
                          label: Text(l10n.allFilterLabel),
                          selected: _categoryFilter == null,
                          onSelected: (_) =>
                              setState(() => _categoryFilter = null),
                        ),
                        for (final c in DocumentCategory.values)
                          ChoiceChip(
                            label: Text(documentCategoryDisplayName(c, l10n)),
                            selected: _categoryFilter == c,
                            onSelected: (_) =>
                                setState(() => _categoryFilter = c),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: visible.isEmpty
                        ? Center(child: Text(l10n.noDocumentsYetText))
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
    final l10n = AppLocalizations.of(context)!;
    final (Color fg, Color bg, String label) = switch (document.expiryStatus) {
      DocumentExpiryStatus.valid => (AppColors.pass, AppColors.passBg, l10n.validLabel),
      DocumentExpiryStatus.expiringSoon => (
        AppColors.caution,
        AppColors.cautionBg,
        l10n.expiringSoonLabel,
      ),
      DocumentExpiryStatus.expired => (
        AppColors.critical,
        AppColors.criticalBg,
        l10n.expiredLabel,
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
                  documentCategoryDisplayName(document.category, l10n),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (document.expiryDate != null)
                  Text(
                    l10n.expiresOnLabel(formatDate(document.expiryDate!)),
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
            itemBuilder: (context) => [
              PopupMenuItem(value: 'open', child: Text(l10n.openMenuItem)),
              PopupMenuItem(value: 'retire', child: Text(l10n.retireButton)),
            ],
          ),
        ],
      ),
    );
  }
}
