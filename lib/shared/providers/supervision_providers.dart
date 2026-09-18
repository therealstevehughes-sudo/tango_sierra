import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/supervision_repository.dart';
import 'auth_providers.dart' show backendDataEnabledProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final supervisionRepositoryProvider = Provider<SupervisionRepository>((ref) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseSupervisionRepository(ref.watch(backendRestClientProvider));
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftSupervisionRepository(db);
});
