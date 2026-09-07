import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/problem_register_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final problemRegisterRepositoryProvider = Provider<ProblemRegisterRepository>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return DriftProblemRegisterRepository(db);
});
