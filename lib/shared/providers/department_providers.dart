import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/department_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final departmentRepositoryProvider = Provider<DepartmentRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftDepartmentRepository(db);
});
