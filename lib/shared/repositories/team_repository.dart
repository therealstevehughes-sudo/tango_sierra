import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/team.dart';

abstract class TeamRepository {
  Future<List<Team>> getForDepartment(int departmentId);
  Future<Team> create({required String name, required int departmentId});
  Future<void> rename(int id, String newName);
  Future<void> setActive(int id, bool active);
}

class DriftTeamRepository implements TeamRepository {
  DriftTeamRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Team>> getForDepartment(int departmentId) async {
    final query = _db.select(_db.teams)
      ..where((t) => t.departmentId.equals(departmentId))
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<Team> create({
    required String name,
    required int departmentId,
  }) async {
    final id = await _db
        .into(_db.teams)
        .insert(
          TeamsCompanion.insert(
            name: name,
            departmentId: departmentId,
            createdAt: DateTime.now(),
          ),
        );
    final row = await (_db.select(
      _db.teams,
    )..where((t) => t.id.equals(id))).getSingle();
    return _toModel(row);
  }

  @override
  Future<void> rename(int id, String newName) {
    return (_db.update(_db.teams)..where((t) => t.id.equals(id))).write(
      TeamsCompanion(name: Value(newName)),
    );
  }

  @override
  Future<void> setActive(int id, bool active) {
    return (_db.update(_db.teams)..where((t) => t.id.equals(id))).write(
      TeamsCompanion(active: Value(active)),
    );
  }

  Team _toModel(TeamEntity row) {
    return Team(
      id: row.id,
      name: row.name,
      departmentId: row.departmentId,
      active: row.active,
      createdAt: row.createdAt,
    );
  }
}
