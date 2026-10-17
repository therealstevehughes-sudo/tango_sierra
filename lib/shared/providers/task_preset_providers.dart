import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/task_preset_repository.dart';
import 'task_schedule_providers.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final taskPresetRepositoryProvider = Provider<TaskPresetRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  // Preset definitions are read from the shared library seeded on every
  // device; applying one assigns through the app's schedule repository
  // (the server in live mode).
  return DriftTaskPresetRepository(db, ref.watch(taskScheduleRepositoryProvider));
});
