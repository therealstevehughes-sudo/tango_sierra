import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/supabase_supplier_repository.dart';
import '../repositories/supplier_repository.dart';
import 'auth_providers.dart' show backendDataEnabledProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final supplierRepositoryProvider = Provider<SupplierRepository>((ref) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseSupplierRepository(ref.watch(backendRestClientProvider));
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftSupplierRepository(db);
});
