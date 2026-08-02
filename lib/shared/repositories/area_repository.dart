import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/area.dart';

abstract class AreaRepository {
  Future<List<Area>> getAll();
  Future<Area> create(String name, int siteId);
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
  Future<Area> create(String name, int siteId) async {
    final id = await _db
        .into(_db.areas)
        .insert(AreasCompanion.insert(name: name, siteId: Value(siteId)));
    return Area(id: id, name: name, siteId: siteId);
  }

  Area _toModel(AreaEntity row) =>
      Area(id: row.id, name: row.name, siteId: row.siteId!);
}
