import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/supabase_venue_type_repository.dart';
import '../repositories/venue_type_repository.dart';
import 'auth_providers.dart'
    show backendDataEnabledProvider, currentBackendOrganisationIdProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final venueTypeRepositoryProvider = Provider<VenueTypeRepository>((ref) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseVenueTypeRepository(
      ref.watch(backendRestClientProvider),
      () => ref.read(currentBackendOrganisationIdProvider) ??
          (throw StateError(
            'No organisation_id claim on the current session — cannot '
            'create a tenant-scoped venue type.',
          )),
    );
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftVenueTypeRepository(db);
});
