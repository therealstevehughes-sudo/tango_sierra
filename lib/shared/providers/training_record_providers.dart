import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/training_record_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final trainingRecordRepositoryProvider = Provider<TrainingRecordRepository>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return DriftTrainingRecordRepository(db);
});
