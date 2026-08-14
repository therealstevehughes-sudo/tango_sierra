import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/supplier_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final supplierRepositoryProvider = Provider<SupplierRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftSupplierRepository(db);
});
