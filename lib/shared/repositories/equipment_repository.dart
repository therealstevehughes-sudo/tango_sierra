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
  Future<void> rename(int id, String newName);
  // Retiring (active: false) also deactivates any TaskSchedules currently
  // pointing at this instance, so staff stop being asked to check equipment
  // that no longer exists. Reactivating does NOT restore those schedules —
  // re-assignment is a deliberate, separate manager action.
  Future<void> setActive(int id, bool active);

  /// The venue type ids an equipment type is tagged relevant to (Sprint
  /// 029). Schema-ready only this sprint — no seeded tag data and not yet
  /// wired into any filtering UI, since there's no sourced per-equipment
  /// venue-type data, only broad segment-level guidance.
  Future<List<int>> getVenueTypeIds(int equipmentTypeId);

  /// Replaces the full set of venue types tagged on an equipment type with
  /// exactly [venueTypeIds].
  Future<void> setVenueTypeIds(int equipmentTypeId, List<int> venueTypeIds);
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
      active: true,
    );
  }

  @override
  Future<void> rename(int id, String newName) async {
    await (_db.update(
      _db.equipmentInstances,
    )..where((e) => e.id.equals(id))).write(
      EquipmentInstancesCompanion(name: Value(newName)),
    );
  }

  @override
  Future<void> setActive(int id, bool active) async {
    await (_db.update(
      _db.equipmentInstances,
    )..where((e) => e.id.equals(id))).write(
      EquipmentInstancesCompanion(active: Value(active)),
    );

    if (!active) {
      await (_db.update(_db.taskSchedules)..where(
            (s) => s.equipmentInstanceId.equals(id) & s.active.equals(true),
          ))
          .write(const TaskSchedulesCompanion(active: Value(false)));
    }
  }

  @override
  Future<List<int>> getVenueTypeIds(int equipmentTypeId) async {
    final rows = await (_db.select(_db.equipmentTypeVenueTypes)
          ..where((j) => j.equipmentTypeId.equals(equipmentTypeId)))
        .get();
    return rows.map((row) => row.venueTypeId).toList();
  }

  @override
  Future<void> setVenueTypeIds(
    int equipmentTypeId,
    List<int> venueTypeIds,
  ) async {
    await _db.transaction(() async {
      await (_db.delete(_db.equipmentTypeVenueTypes)
            ..where((j) => j.equipmentTypeId.equals(equipmentTypeId)))
          .go();
      for (final venueTypeId in venueTypeIds) {
        await _db
            .into(_db.equipmentTypeVenueTypes)
            .insert(
              EquipmentTypeVenueTypesCompanion.insert(
                equipmentTypeId: equipmentTypeId,
                venueTypeId: venueTypeId,
              ),
            );
      }
    });
  }

  Equipment _toModel(EquipmentInstanceEntity row) => Equipment(
    id: row.id,
    name: row.name,
    equipmentTypeId: row.equipmentTypeId,
    areaId: row.areaId,
    siteId: row.siteId!,
    active: row.active,
  );
}
