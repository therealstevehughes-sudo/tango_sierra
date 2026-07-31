import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/task_schedule_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final taskScheduleRepositoryProvider = Provider<TaskScheduleRepository>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return DriftTaskScheduleRepository(db);
});
