import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/supabase_training_record_repository.dart';
import '../repositories/training_record_repository.dart';
import 'auth_providers.dart' show backendDataEnabledProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final trainingRecordRepositoryProvider = Provider<TrainingRecordRepository>((
  ref,
) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseTrainingRecordRepository(
      ref.watch(backendRestClientProvider),
    );
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftTrainingRecordRepository(db);
});
