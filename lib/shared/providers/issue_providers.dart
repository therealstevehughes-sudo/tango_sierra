import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/issue_repository.dart';
import '../repositories/supabase_issue_repository.dart';
import 'auth_providers.dart' show backendDataEnabledProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final issueRepositoryProvider = Provider<IssueRepository>((ref) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseIssueRepository(ref.watch(backendRestClientProvider));
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftIssueRepository(db);
});
