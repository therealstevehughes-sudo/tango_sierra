import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../core/services/evidence_store.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';

// Photo-evidence P1 (Sprint 032, after P0): the "back up to free space"
// flow PHOTO_EVIDENCE_PLAN.md deliberately deferred so the P0 sprint never
// claimed to reclaim space it didn't. This screen makes real evidence
// space-frugal the honest way — it lists what's on THIS device (the same
// evidence dir the capture + export read), shows the byte totals, and can
// delete only whole evidence files the user explicitly selects.
//
// Scope discipline: this is a per-device housekeeping tool, NOT a
// compliance deletion. Deleting evidence here cannot alter what was
// exported to a PDF (that's already bytes on disk elsewhere) — and once a
// real backend exists, upload-then-prune is a v2 concern (see
// DECISIONS_LOG "Real photo capture"). This screen stays honest about it:
// nothing is ever silently deleted, and the manager sees exactly how many
// bytes each selection reclaims before confirming.
class EvidencePruneScreen extends ConsumerStatefulWidget {
  const EvidencePruneScreen({super.key});

  @override
  ConsumerState<EvidencePruneScreen> createState() =>
      _EvidencePruneScreenState();
}

class _EvidencePruneScreenState extends ConsumerState<EvidencePruneScreen> {
  bool _loading = true;
  int _totalBytes = 0;
  List<File> _files = [];
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final store = ref.read(evidenceStoreProvider);
    final entities = await store.listEvidenceFiles();
    final files = entities.whereType<File>().toList()
      ..sort((a, b) => b.path.compareTo(a.path));
    final total = await store.evidenceTotalBytes();
    if (!mounted) return;
    setState(() {
      _files = files;
      _totalBytes = total;
      _loading = false;
    });
  }

  int _selectedBytes() {
    final names = _selected;
    var total = 0;
    for (final file in _files) {
      if (names.contains(file.path)) {
        try {
          total += file.lengthSync();
        } catch (_) {}
      }
    }
    return total;
  }

  String _friendlyName(String path) {
    final base = p.basename(path);
    // Filenames are <epochMs>_<original> — show the original and the
    // capture time rather than a raw millisecond timestamp.
    final parts = base.split('_');
    if (parts.length >= 2) {
      final epoch = int.tryParse(parts.first);
      if (epoch != null) {
        final time = DateTime.fromMillisecondsSinceEpoch(
          epoch,
          isUtc: true,
        ).toLocal().toString().split('.').first;
        parts.removeAt(0);
        return '$time — ${parts.join('_')}';
      }
    }
    return base;
  }

  String _formatBytes(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '$bytes B';
  }

  Future<void> _deleteSelected() async {
    final count = _selected.length;
    final reclaimed = _selectedBytes();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete selected evidence?'),
        content: Text(
          'This permanently deletes $count photo${count == 1 ? '' : 's'} '
          '(${_formatBytes(reclaimed)}) from this device. Already-exported '
          'PDFs are unaffected. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final store = ref.read(evidenceStoreProvider);
    await store.deleteEvidenceFiles([
      for (final file in _files)
        if (_selected.contains(file.path)) file,
    ]);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Evidence')),
      drawer: const ManagementDrawer(title: 'Photo Evidence'),
      body: SafeArea(
        child: ResponsiveContent(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.photo_camera_back_outlined),
                              const SizedBox(width: 8),
                              Text(
                                'On this device',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_files.length} evidence photo${_files.length == 1 ? '' : 's'} · '
                            '${_formatBytes(_totalBytes)} total',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Deleting also frees device space. Exported EHO '
                            'PDFs already contain their copies and are '
                            'unaffected.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_files.isEmpty)
                      const AppCard(child: Text('No evidence photos yet.'))
                    else ...[
                      for (final file in _files)
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          secondary: const Icon(Icons.image_outlined),
                          title: Text(_friendlyName(file.path)),
                          subtitle: Text(_formatBytes(_friendlySize(file))),
                          value: _selected.contains(file.path),
                          onChanged: (checked) => setState(() {
                            if (checked ?? false) {
                              _selected.add(file.path);
                            } else {
                              _selected.remove(file.path);
                            }
                          }),
                        ),
                      const SizedBox(height: 12),
                      if (_selected.isNotEmpty)
                        PrimaryActionButton(
                          label:
                              'Delete ${_selected.length} selected '
                              '(${_formatBytes(_selectedBytes())})',
                          onPressed: _deleteSelected,
                        ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }

  int _friendlySize(File file) {
    try {
      return file.lengthSync();
    } catch (_) {
      return 0;
    }
  }
}
