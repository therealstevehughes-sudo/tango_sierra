import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/supabase_task_template_repository.dart';
import '../repositories/task_template_repository.dart';
import 'auth_providers.dart'
    show backendDataEnabledProvider, currentBackendOrganisationIdProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final taskTemplateRepositoryProvider = Provider<TaskTemplateRepository>((
  ref,
) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseTaskTemplateRepository(
      ref.watch(backendRestClientProvider),
      () => ref.read(currentBackendOrganisationIdProvider) ??
          (throw StateError(
            'No organisation_id claim on the current session — cannot '
            'save a tenant-scoped task template.',
          )),
    );
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftTaskTemplateRepository(db);
});
