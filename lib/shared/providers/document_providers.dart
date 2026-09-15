import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/document_repository.dart';
import '../repositories/supabase_document_repository.dart';
import 'auth_providers.dart' show backendDataEnabledProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseDocumentRepository(ref.watch(backendRestClientProvider));
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftDocumentRepository(db);
});
