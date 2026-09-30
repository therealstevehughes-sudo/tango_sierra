import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/date_format.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/training_item.dart';
import '../../shared/models/training_record.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart' show backendDataEnabledProvider, currentUserProvider;
import '../../shared/providers/backend_providers.dart' show backendRestClientProvider;
import '../../shared/providers/training_record_providers.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../l10n/app_localizations.dart';

// Certificate document upload bucket (Phase 2, 2026-09-30) — private (not
// public), since these are personal staff records. Created manually in
// Supabase Studio, not by app code — see PHASE_2_ROADMAP.md/BACKEND_INFRA.md
// for the exact bucket + RLS policy this relies on.
const _certificateBucket = 'certification-documents';

class TrainingRecordsScreen extends ConsumerStatefulWidget {
  const TrainingRecordsScreen({super.key, required this.staffMember});

  final User staffMember;

  @override
  ConsumerState<TrainingRecordsScreen> createState() =>
      _TrainingRecordsScreenState();
}

class _TrainingRecordsScreenState extends ConsumerState<TrainingRecordsScreen> {
  bool loading = true;
  String? loadError;
  List<TrainingRecord> records = [];

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
    try {
      final repo = ref.read(trainingRecordRepositoryProvider);
      final loaded = await repo.getForUser(widget.staffMember.id);

      if (!mounted) return;
      setState(() {
        records = loaded;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loadError = e.toString();
        loading = false;
      });
    }
  }

  Future<void> _addRecord() async {
    var itemType = TrainingItemType.level2FoodHygiene;
    final customTitleController = TextEditingController();
    var completedAt = DateTime.now();
    DateTime? expiresAt;
    final certificateController = TextEditingController();
    String? uploadedFilePath;
    var uploading = false;
    final canUpload = ref.read(backendDataEnabledProvider);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;

          Future<void> pickAndUploadCertificate() async {
            final picker = ImagePicker();
            XFile? file;
            try {
              file = await picker.pickImage(
                source: ImageSource.camera,
                imageQuality: 80,
              );
            } catch (_) {
              // Camera unavailable (e.g. desktop) — fall through to gallery,
              // same fallback EvidenceStore uses for task photo evidence.
            }
            file ??= await picker.pickImage(
              source: ImageSource.gallery,
              imageQuality: 80,
            );
            if (file == null) return;

            setDialogState(() => uploading = true);
            try {
              final bytes = await file.readAsBytes();
              final client = ref.read(backendRestClientProvider);
              final ext = file.name.contains('.')
                  ? file.name.split('.').last
                  : 'jpg';
              final path =
                  '${widget.staffMember.siteId}/${widget.staffMember.id}/'
                  '${DateTime.now().millisecondsSinceEpoch}.$ext';
              await client.uploadToStorage(
                _certificateBucket,
                path,
                bytes,
                contentType: 'image/$ext',
              );
              setDialogState(() {
                uploadedFilePath = path;
                uploading = false;
              });
            } catch (_) {
              setDialogState(() => uploading = false);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.certificateUploadFailed)),
              );
            }
          }

          return AlertDialog(
            title: Text(l10n.addTrainingRecordTitle(widget.staffMember.name)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<TrainingItemType>(
                    initialValue: itemType,
                    decoration: InputDecoration(labelText: l10n.itemFieldLabel),
                    items: TrainingItemType.values
                        .map(
                          (t) => DropdownMenuItem(
                            value: t,
                            child: Text(trainingItemTypeLabel(t, l10n)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setDialogState(() => itemType = value ?? itemType),
                  ),
                  if (itemType == TrainingItemType.other) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: customTitleController,
                      decoration: InputDecoration(
                        labelText: l10n.customItemTitleLabel,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: Text(l10n.completedOnLabel(formatDate(completedAt))),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDate: completedAt,
                      );
                      if (picked != null) {
                        setDialogState(() => completedAt = picked);
                      }
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.event_busy),
                    title: Text(
                      expiresAt == null
                          ? l10n.expiryNoneLabel
                          : l10n.expiryOnLabel(formatDate(expiresAt!)),
                    ),
                    trailing: expiresAt == null
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            tooltip: l10n.clearExpiryTooltip,
                            onPressed: () =>
                                setDialogState(() => expiresAt = null),
                          ),
                    onTap: () async {
                      // firstDate deliberately not restricted to today/later —
                      // a record can legitimately already be expired (e.g.
                      // backfilling a lapsed item that hasn't been renewed
                      // yet), and that's exactly the case this field needs to
                      // support for the expired-training flagging to work.
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                        initialDate: expiresAt ?? DateTime.now(),
                      );
                      if (picked != null) {
                        setDialogState(() => expiresAt = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: certificateController,
                    decoration: InputDecoration(
                      labelText: l10n.certificateReferenceLabel,
                      hintText: l10n.certificateReferenceHint,
                    ),
                  ),
                  if (canUpload) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: uploading ? null : pickAndUploadCertificate,
                      icon: uploading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              uploadedFilePath == null
                                  ? Icons.upload_file
                                  : Icons.check_circle,
                            ),
                      label: Text(
                        uploadedFilePath == null
                            ? l10n.uploadCertificateDocumentButton
                            : l10n.certificateDocumentUploadedLabel,
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
                onPressed:
                    (itemType != TrainingItemType.other ||
                        customTitleController.text.trim().isNotEmpty)
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

    final signedOffBy = ref.read(currentUserProvider);
    if (signedOffBy == null) return;

    final repo = ref.read(trainingRecordRepositoryProvider);
    await repo.add(
      TrainingRecord(
        id: null,
        userId: widget.staffMember.id,
        siteId: widget.staffMember.siteId!,
        itemType: itemType,
        customItemTitle: itemType == TrainingItemType.other
            ? customTitleController.text.trim()
            : null,
        completedAt: completedAt,
        expiresAt: expiresAt,
        signedOffByUserId: signedOffBy.id,
        certificateReference: certificateController.text.trim().isEmpty
            ? null
            : certificateController.text.trim(),
        certificateFileUrl: uploadedFilePath,
        createdAt: DateTime.now(),
      ),
    );

    if (!mounted) return;
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final current = latestPerItem(records);
    current.sort((a, b) => a.displayTitle.compareTo(b.displayTitle));
    final supersededCount = records.length - current.length;

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.trainingRecordsTitle(widget.staffMember.name)),
        actions: const [AssistantIconButton()],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : loadError != null
          ? LoadErrorView(error: loadError!, onRetry: _loadData)
          : SafeArea(
        child: ResponsiveContent(
          child: records.isEmpty
              ? Center(child: Text(l10n.noTrainingRecordsYetText))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...current.map(_buildCurrentTile),
                    if (supersededCount > 0) ...[
                      const SizedBox(height: 8),
                      Card(
                        child: ExpansionTile(
                          // Layout fix (2026-09-25) — see faq_screen.dart's
                          // own comment on this same ExpansionTile-vs-Card
                          // corner artifact fix.
                          shape: const RoundedRectangleBorder(
                            side: BorderSide.none,
                          ),
                          collapsedShape: const RoundedRectangleBorder(
                            side: BorderSide.none,
                          ),
                          title: Text(l10n.fullHistoryLabel(supersededCount)),
                          children: records
                              .where((r) => !current.contains(r))
                              .map(_buildHistoryTile)
                              .toList(),
                        ),
                      ),
                    ],
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addRecord,
        icon: const Icon(Icons.add),
        label: Text(l10n.addRecordButton),
      ),
    );
  }

  Widget _buildCurrentTile(TrainingRecord record) {
    final l10n = AppLocalizations.of(context)!;
    final status = computeTrainingStatus(record.expiresAt);
    final (kind, label) = switch (status) {
      TrainingStatus.current => (StatusKind.pass, l10n.currentLabel),
      TrainingStatus.expiringSoon => (StatusKind.caution, l10n.expiringSoonLabel),
      TrainingStatus.expired => (StatusKind.critical, l10n.expiredLabel),
    };

    return Card(
      child: ListTile(
        title: Text(record.displayTitle),
        subtitle: Text(_subtitleFor(record)),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (record.certificateFileUrl != null)
              IconButton(
                icon: const Icon(Icons.description_outlined),
                tooltip: l10n.viewCertificateDocumentTooltip,
                onPressed: () => _viewCertificate(record.certificateFileUrl!),
              ),
            StatusBadge(kind: kind, label: label),
          ],
        ),
      ),
    );
  }

  Future<void> _viewCertificate(String storagePath) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final client = ref.read(backendRestClientProvider);
      final signedUrl = await client.createSignedStorageUrl(
        _certificateBucket,
        storagePath,
      );
      await launchUrl(Uri.parse(signedUrl));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.certificateUploadFailed)));
    }
  }

  Widget _buildHistoryTile(TrainingRecord record) {
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      title: Text(record.displayTitle),
      subtitle: Text(
        '${_subtitleFor(record)}\n${l10n.supersededLabel}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      isThreeLine: true,
    );
  }

  String _subtitleFor(TrainingRecord record) {
    final l10n = AppLocalizations.of(context)!;
    final parts = <String>[
      l10n.completedDateLabel(formatDate(record.completedAt)),
      record.expiresAt == null
          ? l10n.noExpiryLabel
          : l10n.expiresOnLabel(formatDate(record.expiresAt!)),
    ];
    if (record.certificateReference != null) {
      parts.add(l10n.certRefLabel(record.certificateReference!));
    }
    return parts.join(' · ');
  }
}
