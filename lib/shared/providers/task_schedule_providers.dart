import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/supabase_task_schedule_repository.dart';
import '../repositories/task_schedule_repository.dart';
import 'auth_providers.dart' show backendDataEnabledProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final taskScheduleRepositoryProvider = Provider<TaskScheduleRepository>((
  ref,
) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseTaskScheduleRepository(ref.watch(backendRestClientProvider));
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftTaskScheduleRepository(db);
});
