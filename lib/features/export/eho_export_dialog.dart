import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_format.dart';
import '../../shared/providers/auth_providers.dart';
import 'eho_export_service.dart';

// EHO/audit export (Sprint 031) — same minimal "generate, then show where
// it saved" shape as _showBackupDialog in manager_screen.dart/
// top_screen.dart, not a new UI pattern.
Future<void> showEhoExportDialog(BuildContext context, WidgetRef ref) async {
  DateTime? start;
  DateTime? end;
  // Default off: per the researched export-format decision, the common
  // case is the tight summary+exceptions view — the full detailed log is
  // opt-in, not the default bulk.
  var includeFullLog = false;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('EHO / Audit Export'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Generates a PDF of this venue's compliance records for "
              'the chosen date range.',
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(start == null ? 'From date' : formatDate(start!)),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDate: start ?? DateTime.now(),
                );
                if (picked != null) setState(() => start = picked);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(end == null ? 'To date' : formatDate(end!)),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDate: end ?? DateTime.now(),
                );
                if (picked != null) setState(() => end = picked);
              },
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: includeFullLog,
              title: const Text('Include full detailed log'),
              subtitle: const Text(
                'Off by default — the summary and exceptions above are '
                "what an inspector actually reviews; this adds every "
                'individual check on top.',
              ),
              onChanged: (checked) =>
                  setState(() => includeFullLog = checked ?? false),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: (start != null && end != null)
                ? () => Navigator.pop(context, true)
                : null,
            child: const Text('Generate'),
          ),
        ],
      ),
    ),
  );

  if (confirmed != true || start == null || end == null) return;

  final currentUser = ref.read(currentUserProvider);
  if (currentUser == null) return;

  final rangeStart = DateTime(start!.year, start!.month, start!.day);
  final rangeEnd = DateTime(
    end!.year,
    end!.month,
    end!.day,
  ).add(const Duration(days: 1));

  final service = ref.read(ehoExportServiceProvider);
  final path = await service.generate(
    siteId: currentUser.siteId,
    start: rangeStart,
    end: rangeEnd,
    generatedByName: currentUser.name,
    includeFullLog: includeFullLog,
  );

  if (!context.mounted) return;
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Export Created'),
      content: Text('Saved to:\n$path'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
