import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_format.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/auth_providers.dart';
import 'eho_export_service.dart';

// EHO/audit export (Sprint 031) — same minimal "generate, then show where
// it saved" shape as showBackupDialog, not a new UI pattern.
//
// Menu redesign (2026-09-17): takes a ProviderContainer, not a WidgetRef —
// this function only ever calls .read(), never .watch()/.listen(), so the
// two are interchangeable here. Lets ManagementDrawer invoke this
// directly from a stable root-navigator context instead of requiring
// every hosting screen to wire its own callback (see ManagementDrawer's
// own doc comment for why a plain WidgetRef from the Drawer itself
// wouldn't survive the Drawer closing).
Future<void> showEhoExportDialog(
  BuildContext context,
  ProviderContainer container,
) async {
  DateTime? start;
  DateTime? end;
  // Default off: per the researched export-format decision, the common
  // case is the tight summary+exceptions view — the full detailed log is
  // opt-in, not the default bulk.
  var includeFullLog = false;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
        title: Text(l10n.ehoAuditExportTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.ehoExportDescription),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.date_range),
              title: Text(
                start != null && end != null
                    ? l10n.dateRangeValue(
                        formatDate(start!),
                        formatDate(end!),
                      )
                    : l10n.selectDateRangeLabel,
              ),
              subtitle: start != null && end != null
                  ? null
                  : Text(l10n.tapToChooseDates),
              onTap: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: start != null && end != null
                      ? DateTimeRange(start: start!, end: end!)
                      : DateTimeRange(
                          start: DateTime.now().subtract(
                            const Duration(days: 7),
                          ),
                          end: DateTime.now(),
                        ),
                );
                if (picked != null) {
                  setState(() {
                    start = picked.start;
                    end = picked.end;
                  });
                }
              },
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: includeFullLog,
              title: Text(l10n.includeFullDetailedLog),
              subtitle: Text(l10n.fullLogSubtitle),
              onChanged: (checked) =>
                  setState(() => includeFullLog = checked ?? false),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: (start != null && end != null)
                ? () => Navigator.pop(context, true)
                : null,
            child: Text(l10n.generateLabel),
          ),
        ],
        );
      },
    ),
  );

  if (confirmed != true || start == null || end == null) return;

  final currentUser = container.read(currentUserProvider);
  if (currentUser == null) return;

  final rangeStart = DateTime(start!.year, start!.month, start!.day);
  final rangeEnd = DateTime(
    end!.year,
    end!.month,
    end!.day,
  ).add(const Duration(days: 1));

  final service = container.read(ehoExportServiceProvider);

  // Never fail silently (found live-testing: an unhandled exception here
  // used to just close the dialog with no PDF, no file, and no indication
  // anything went wrong). Any failure now surfaces a real message.
  String? path;
  Object? error;
  try {
    path = await service.generate(
      siteId: currentUser.siteId!,
      start: rangeStart,
      end: rangeEnd,
      generatedByName: currentUser.name,
      includeFullLog: includeFullLog,
    );
  } catch (e) {
    error = e;
  }

  if (!context.mounted) return;

  if (error != null) {
    await showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.exportFailedTitle),
          content: Text(l10n.exportFailedBody('$error')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.okLabel),
            ),
          ],
        );
      },
    );
    return;
  }

  await showDialog(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return AlertDialog(
        title: Text(l10n.exportCreatedTitle),
        content: Text(l10n.savedToLabel('$path')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.okLabel),
          ),
        ],
      );
    },
  );
}
