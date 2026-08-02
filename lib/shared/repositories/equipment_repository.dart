import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/equipment.dart';
import '../models/equipment_type.dart';

abstract class EquipmentRepository {
  Future<List<EquipmentType>> getEquipmentTypes();
  Future<EquipmentType> createEquipmentType(String name);
  Future<List<Equipment>> getAll();
  Future<Equipment> create({
    required String name,
    required int equipmentTypeId,
    int? areaId,
    required int siteId,
  });
}

class DriftEquipmentRepository implements EquipmentRepository {
  DriftEquipmentRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<EquipmentType>> getEquipmentTypes() async {
    final rows = await _db.select(_db.equipmentTypes).get();
    return rows
        .map((row) => EquipmentType(id: row.id, name: row.name))
        .toList();
  }

  @override
  Future<EquipmentType> createEquipmentType(String name) async {
    final id = await _db
        .into(_db.equipmentTypes)
        .insert(EquipmentTypesCompanion.insert(name: name));
    return EquipmentType(id: id, name: name);
  }

  @override
  Future<List<Equipment>> getAll() async {
    final rows = await _db.select(_db.equipmentInstances).get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<Equipment> create({
    required String name,
    required int equipmentTypeId,
    int? areaId,
    required int siteId,
  }) async {
    final id = await _db
        .into(_db.equipmentInstances)
        .insert(
          EquipmentInstancesCompanion.insert(
            name: name,
            equipmentTypeId: equipmentTypeId,
            areaId: Value(areaId),
            siteId: Value(siteId),
          ),
        );
    return Equipment(
      id: id,
      name: name,
      equipmentTypeId: equipmentTypeId,
      areaId: areaId,
      siteId: siteId,
    );
  }

  Equipment _toModel(EquipmentInstanceEntity row) => Equipment(
    id: row.id,
    name: row.name,
    equipmentTypeId: row.equipmentTypeId,
    areaId: row.areaId,
    siteId: row.siteId!,
  );
}
