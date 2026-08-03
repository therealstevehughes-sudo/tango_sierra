import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/task_preset_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final taskPresetRepositoryProvider = Provider<TaskPresetRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftTaskPresetRepository(db);
});
