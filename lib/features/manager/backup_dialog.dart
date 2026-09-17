import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/backup_providers.dart';

// Menu redesign (2026-09-17) — extracted from manager_screen.dart's private
// _showBackupDialog (which top_screen.dart had ALSO duplicated verbatim, a
// second copy of the exact same function). One shared implementation now,
// matching eho_export_dialog.dart's existing shape.
//
// Takes a ProviderContainer, not a WidgetRef — this function only ever
// calls .read(), never .watch()/.listen(), so the two are interchangeable
// here, and ProviderContainer.read() has the identical signature/
// semantics. This is what lets ManagementDrawer call it directly using a
// container resolved from the app's root navigator context (which
// outlives the Drawer's own closing) instead of requiring every hosting
// screen to wire its own callback with a ref that stays alive.
Future<void> showBackupDialog(
  BuildContext context,
  ProviderContainer container,
) async {
  final nameController = TextEditingController();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Back Up Now'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This creates a complete copy of the local database in your '
            'Documents folder. Moving it to a USB drive or cloud-synced '
            'folder afterward is a separate manual step.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Backup name (optional)',
              hintText: 'e.g. Pre-inspection backup',
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
          child: const Text('Back Up Now'),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  final repo = container.read(backupRepositoryProvider);
  final path = await repo.createBackup(
    customName: nameController.text.trim().isEmpty
        ? null
        : nameController.text.trim(),
  );

  if (!context.mounted) return;
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Backup Created'),
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
