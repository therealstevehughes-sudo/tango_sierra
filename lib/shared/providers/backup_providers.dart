import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/backup_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final backupRepositoryProvider = Provider<BackupRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftBackupRepository(db);
});
