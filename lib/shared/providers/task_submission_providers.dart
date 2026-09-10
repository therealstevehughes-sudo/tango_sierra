import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/app_database.dart';
import '../models/task_submission.dart';
import '../repositories/supabase_task_submission_repository.dart';
import '../repositories/task_submission_repository.dart';
import 'auth_providers.dart' show backendDataEnabledProvider;
import 'backend_providers.dart' show backendRestClientProvider;

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final taskSubmissionRepositoryProvider = Provider<TaskSubmissionRepository>((
  ref,
) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseTaskSubmissionRepository(
      ref.watch(backendRestClientProvider),
    );
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftTaskSubmissionRepository(db);
});

final taskSubmissionsStreamProvider = StreamProvider<List<TaskSubmission>>((
  ref,
) {
  final repository = ref.watch(taskSubmissionRepositoryProvider);
  return repository.watchAll();
});
