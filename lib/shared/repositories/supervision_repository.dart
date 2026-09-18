import '../../core/network/backend_rest_client.dart';
import '../../core/storage/app_database.dart';

// Supervision scope (2026-09-18) — which Departments (sections) and/or
// Teams a Supervisor is responsible for. "set" replaces the whole list for
// that user each time, matching a multi-select checklist UI (pick which
// sections/teams, save) rather than one-at-a-time add/remove calls.
abstract class SupervisionRepository {
  Future<List<int>> getSupervisedDepartmentIds(int userId);
  Future<List<int>> getSupervisedTeamIds(int userId);
  Future<void> setSupervisedDepartments({
    required int userId,
    required List<int> departmentIds,
  });
  Future<void> setSupervisedTeams({
    required int userId,
    required List<int> teamIds,
  });
}

class DriftSupervisionRepository implements SupervisionRepository {
  DriftSupervisionRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<int>> getSupervisedDepartmentIds(int userId) async {
    final rows =
        await (_db.select(_db.supervisedDepartments)
              ..where((s) => s.userId.equals(userId)))
            .get();
    return rows.map((r) => r.departmentId).toList();
  }

  @override
  Future<List<int>> getSupervisedTeamIds(int userId) async {
    final rows =
        await (_db.select(_db.supervisedTeams)
              ..where((s) => s.userId.equals(userId)))
            .get();
    return rows.map((r) => r.teamId).toList();
  }

  @override
  Future<void> setSupervisedDepartments({
    required int userId,
    required List<int> departmentIds,
  }) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.supervisedDepartments,
      )..where((s) => s.userId.equals(userId))).go();
      final now = DateTime.now();
      for (final departmentId in departmentIds) {
        await _db
            .into(_db.supervisedDepartments)
            .insert(
              SupervisedDepartmentsCompanion.insert(
                userId: userId,
                departmentId: departmentId,
                assignedAt: now,
              ),
            );
      }
    });
  }

  @override
  Future<void> setSupervisedTeams({
    required int userId,
    required List<int> teamIds,
  }) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.supervisedTeams,
      )..where((s) => s.userId.equals(userId))).go();
      final now = DateTime.now();
      for (final teamId in teamIds) {
        await _db
            .into(_db.supervisedTeams)
            .insert(
              SupervisedTeamsCompanion.insert(
                userId: userId,
                teamId: teamId,
                assignedAt: now,
              ),
            );
      }
    });
  }
}

class SupabaseSupervisionRepository implements SupervisionRepository {
  SupabaseSupervisionRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<int>> getSupervisedDepartmentIds(int userId) async {
    final rows = await _client.select(
      'supervised_departments',
      query: 'user_id=eq.$userId',
    );
    return rows.map((r) => r['department_id'] as int).toList();
  }

  @override
  Future<List<int>> getSupervisedTeamIds(int userId) async {
    final rows = await _client.select(
      'supervised_teams',
      query: 'user_id=eq.$userId',
    );
    return rows.map((r) => r['team_id'] as int).toList();
  }

  @override
  Future<void> setSupervisedDepartments({
    required int userId,
    required List<int> departmentIds,
  }) async {
    await _client.delete('supervised_departments', filter: 'user_id=eq.$userId');
    for (final departmentId in departmentIds) {
      await _client.insertOne('supervised_departments', {
        'user_id': userId,
        'department_id': departmentId,
      });
    }
  }

  @override
  Future<void> setSupervisedTeams({
    required int userId,
    required List<int> teamIds,
  }) async {
    await _client.delete('supervised_teams', filter: 'user_id=eq.$userId');
    for (final teamId in teamIds) {
      await _client.insertOne('supervised_teams', {
        'user_id': userId,
        'team_id': teamId,
      });
    }
  }
}
