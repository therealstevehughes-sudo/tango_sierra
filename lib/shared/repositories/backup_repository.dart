import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/storage/app_database.dart';

abstract class BackupRepository {
  Future<String> createBackup({String? customName});
}

class DriftBackupRepository implements BackupRepository {
  DriftBackupRepository(this._db);

  final AppDatabase _db;

  @override
  Future<String> createBackup({String? customName}) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final backupsDir = Directory(
      p.join(documentsDir.path, 'KitchenControlBackups'),
    );
    if (!await backupsDir.exists()) {
      await backupsDir.create(recursive: true);
    }

    final timestamp = _formatTimestamp(DateTime.now());
    final trimmedName = customName?.trim();
    final sanitizedName = (trimmedName == null || trimmedName.isEmpty)
        ? null
        : _sanitizeForFilename(trimmedName);

    final filename = sanitizedName == null
        ? 'kitchen_control_backup_$timestamp.sqlite'
        : 'kitchen_control_backup_${timestamp}_$sanitizedName.sqlite';

    final destinationPath = p.join(backupsDir.path, filename);
    await _db.backupTo(destinationPath);
    return destinationPath;
  }

  String _formatTimestamp(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}${two(dt.month)}${two(dt.day)}'
        '_${two(dt.hour)}${two(dt.minute)}${two(dt.second)}';
  }

  // Strips characters illegal in Windows filenames; keeps spaces so a name
  // like "Pre-inspection backup" stays readable in the saved file.
  String _sanitizeForFilename(String name) {
    return name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '');
  }
}
