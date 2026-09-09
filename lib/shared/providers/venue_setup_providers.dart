import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/area_repository.dart';
import '../repositories/equipment_repository.dart';
import '../repositories/supabase_area_repository.dart';
import '../repositories/supabase_equipment_repository.dart';
import 'auth_providers.dart'
    show backendDataEnabledProvider, currentBackendOrganisationIdProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final areaRepositoryProvider = Provider<AreaRepository>((ref) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseAreaRepository(ref.watch(backendRestClientProvider));
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftAreaRepository(db);
});

final equipmentRepositoryProvider = Provider<EquipmentRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  // EquipmentInstances stay local regardless of the flag (out of B2 scope
  // — see SupabaseEquipmentRepository's doc comment); the Drift instance
  // is always built so it's available either as the whole repository or
  // as the local delegate the backend-types wrapper falls back to.
  final driftRepository = DriftEquipmentRepository(db);
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseEquipmentRepository(
      ref.watch(backendRestClientProvider),
      () => ref.read(currentBackendOrganisationIdProvider) ??
          (throw StateError(
            'No organisation_id claim on the current session — cannot '
            'create a tenant-scoped equipment type.',
          )),
      driftRepository,
    );
  }
  return driftRepository;
});
