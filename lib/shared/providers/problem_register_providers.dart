import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/problem_register_repository.dart';
import '../repositories/supabase_problem_register_repository.dart';
import 'auth_providers.dart' show backendDataEnabledProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final problemRegisterRepositoryProvider = Provider<ProblemRegisterRepository>((
  ref,
) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseProblemRegisterRepository(
      ref.watch(backendRestClientProvider),
    );
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftProblemRegisterRepository(db);
});
