import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/supabase_team_repository.dart';
import '../repositories/team_repository.dart';
import 'auth_providers.dart' show backendDataEnabledProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseTeamRepository(ref.watch(backendRestClientProvider));
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftTeamRepository(db);
});
