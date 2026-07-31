import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/area_repository.dart';
import '../repositories/equipment_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final areaRepositoryProvider = Provider<AreaRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftAreaRepository(db);
});

final equipmentRepositoryProvider = Provider<EquipmentRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftEquipmentRepository(db);
});
