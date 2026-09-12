import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_format.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/training_item.dart';
import '../../shared/models/training_record.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/training_record_providers.dart';

class TrainingRecordsScreen extends ConsumerStatefulWidget {
  const TrainingRecordsScreen({super.key, required this.staffMember});

  final User staffMember;

  @override
  ConsumerState<TrainingRecordsScreen> createState() =>
      _TrainingRecordsScreenState();
}

class _TrainingRecordsScreenState extends ConsumerState<TrainingRecordsScreen> {
  bool loading = true;
  List<TrainingRecord> records = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = ref.read(trainingRecordRepositoryProvider);
    final loaded = await repo.getForUser(widget.staffMember.id);

    if (!mounted) return;
    setState(() {
      records = loaded;
      loading = false;
    });
  }

  Future<void> _addRecord() async {
    var itemType = TrainingItemType.level2FoodHygiene;
    final customTitleController = TextEditingController();
    var completedAt = DateTime.now();
    DateTime? expiresAt;
    final certificateController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Add Training Record — ${widget.staffMember.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<TrainingItemType>(
                  initialValue: itemType,
                  decoration: const InputDecoration(labelText: 'Item'),
                  items: TrainingItemType.values
                      .map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Text(trainingItemTypeLabel(t)),
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
                    decoration: const InputDecoration(
                      labelText: 'Custom item title',
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: Text('Completed: ${formatDate(completedAt)}'),
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
                        ? 'Expiry: none'
                        : 'Expiry: ${formatDate(expiresAt!)}',
                  ),
                  trailing: expiresAt == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: 'Clear expiry',
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
                  decoration: const InputDecoration(
                    labelText: 'Certificate reference (optional)',
                    hintText: 'e.g. certificate number, provider',
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
              onPressed:
                  (itemType != TrainingItemType.other ||
                      customTitleController.text.trim().isNotEmpty)
                  ? () => Navigator.pop(context, true)
                  : null,
              child: const Text('Save'),
            ),
          ],
        ),
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
        createdAt: DateTime.now(),
      ),
    );

    if (!mounted) return;
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final current = latestPerItem(records);
    current.sort((a, b) => a.displayTitle.compareTo(b.displayTitle));
    final supersededCount = records.length - current.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Training Records — ${widget.staffMember.name}'),
      ),
      body: SafeArea(
        child: ResponsiveContent(
          child: records.isEmpty
              ? const Center(child: Text('No training records yet.'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...current.map(_buildCurrentTile),
                    if (supersededCount > 0) ...[
                      const SizedBox(height: 8),
                      Card(
                        child: ExpansionTile(
                          title: Text(
                            'Full history ($supersededCount earlier record'
                            '${supersededCount == 1 ? '' : 's'})',
                          ),
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
        label: const Text('Add Record'),
      ),
    );
  }

  Widget _buildCurrentTile(TrainingRecord record) {
    final status = computeTrainingStatus(record.expiresAt);
    final (kind, label) = switch (status) {
      TrainingStatus.current => (StatusKind.pass, 'Current'),
      TrainingStatus.expiringSoon => (StatusKind.caution, 'Expiring soon'),
      TrainingStatus.expired => (StatusKind.critical, 'Expired'),
    };

    return Card(
      child: ListTile(
        title: Text(record.displayTitle),
        subtitle: Text(_subtitleFor(record)),
        isThreeLine: true,
        trailing: StatusBadge(kind: kind, label: label),
      ),
    );
  }

  Widget _buildHistoryTile(TrainingRecord record) {
    return ListTile(
      title: Text(record.displayTitle),
      subtitle: Text(
        '${_subtitleFor(record)}\n(superseded)',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      isThreeLine: true,
    );
  }

  String _subtitleFor(TrainingRecord record) {
    final parts = <String>[
      'Completed ${formatDate(record.completedAt)}',
      record.expiresAt == null
          ? 'No expiry'
          : 'Expires ${formatDate(record.expiresAt!)}',
    ];
    if (record.certificateReference != null) {
      parts.add('Ref: ${record.certificateReference}');
    }
    return parts.join(' · ');
  }
}
