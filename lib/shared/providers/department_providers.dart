import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/department_repository.dart';
import '../repositories/supabase_department_repository.dart';
import 'auth_providers.dart' show backendDataEnabledProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final departmentRepositoryProvider = Provider<DepartmentRepository>((ref) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseDepartmentRepository(ref.watch(backendRestClientProvider));
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftDepartmentRepository(db);
});
