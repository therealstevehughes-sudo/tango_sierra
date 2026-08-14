import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/department.dart';

abstract class DepartmentRepository {
  Future<List<Department>> getForSite(int siteId);
  Future<Department> create({required String name, required int siteId});
  Future<void> rename(int id, String newName);
  Future<void> setActive(int id, bool active);
}

class DriftDepartmentRepository implements DepartmentRepository {
  DriftDepartmentRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Department>> getForSite(int siteId) async {
    final query = _db.select(_db.departments)
      ..where((d) => d.siteId.equals(siteId))
      ..orderBy([(d) => OrderingTerm.asc(d.name)]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<Department> create({
    required String name,
    required int siteId,
  }) async {
    final id = await _db
        .into(_db.departments)
        .insert(
          DepartmentsCompanion.insert(
            name: name,
            siteId: Value(siteId),
            createdAt: DateTime.now(),
          ),
        );
    final row = await (_db.select(
      _db.departments,
    )..where((d) => d.id.equals(id))).getSingle();
    return _toModel(row);
  }

  @override
  Future<void> rename(int id, String newName) {
    return (_db.update(_db.departments)..where((d) => d.id.equals(id))).write(
      DepartmentsCompanion(name: Value(newName)),
    );
  }

  @override
  Future<void> setActive(int id, bool active) {
    return (_db.update(_db.departments)..where((d) => d.id.equals(id))).write(
      DepartmentsCompanion(active: Value(active)),
    );
  }

  Department _toModel(DepartmentEntity row) {
    return Department(
      id: row.id,
      name: row.name,
      siteId: row.siteId!,
      active: row.active,
      createdAt: row.createdAt,
    );
  }
}
