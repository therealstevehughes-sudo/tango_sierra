import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/area.dart';

abstract class AreaRepository {
  Future<List<Area>> getAll();
  Future<List<Area>> getForSite(int siteId);
  Future<Area> create(String name, int siteId);
  Future<void> rename(int id, String newName);
  // Task-reorder (2026-09-12): the manager-controlled order of a zone.
  Future<void> setSortOrder(int areaId, int? sortOrder);
}

class DriftAreaRepository implements AreaRepository {
  DriftAreaRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Area>> getAll() async {
    final rows = await _db.select(_db.areas).get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<Area>> getForSite(int siteId) async {
    final query = _db.select(_db.areas)
      ..where((area) => area.siteId.equals(siteId))
      // Task-reorder (2026-09-12): explicit sortOrder first (nulls last —
      // rows without an order yet fall behind ordered ones), then id for
      // stability. Reads use the SQL `NULLS LAST` clause via OrderingTerm.
      ..orderBy([
        (a) => OrderingTerm.asc(a.sortOrder, nulls: NullsOrder.last),
        (a) => OrderingTerm.asc(a.id),
      ]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<Area> create(String name, int siteId) async {
    final id = await _db
        .into(_db.areas)
        .insert(AreasCompanion.insert(name: name, siteId: Value(siteId)));
    return Area(id: id, name: name, siteId: siteId, sortOrder: null);
  }

  @override
  Future<void> rename(int id, String newName) async {
    await (_db.update(_db.areas)..where((a) => a.id.equals(id))).write(
      AreasCompanion(name: Value(newName)),
    );
  }

  @override
  Future<void> setSortOrder(int areaId, int? sortOrder) async {
    await (_db.update(_db.areas)..where((a) => a.id.equals(areaId))).write(
      AreasCompanion(sortOrder: Value(sortOrder)),
    );
  }

  Area _toModel(AreaEntity row) => Area(
    id: row.id,
    name: row.name,
    siteId: row.siteId!,
    sortOrder: row.sortOrder,
  );
}
