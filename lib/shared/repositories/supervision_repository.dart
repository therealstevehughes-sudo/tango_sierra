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

  // Insert-before-delete (2026-09-20 fix): a real bug found while running
  // the cross-tenant proof — the original delete-then-insert order meant a
  // rejected insert (RLS `WITH CHECK` failure, or any other mid-loop
  // error) left the caller's real, legitimate rows already deleted with
  // nothing put back, since PostgREST has no client-side transaction here.
  // Inserting the new rows first means a failure leaves the OLD rows
  // fully intact (worst case: briefly duplicated, never lost) — only once
  // every new row is confirmed written do the now-superseded old ones get
  // removed.
  @override
  Future<void> setSupervisedDepartments({
    required int userId,
    required List<int> departmentIds,
  }) async {
    final existing = await getSupervisedDepartmentIds(userId);
    final toAdd = departmentIds.where((id) => !existing.contains(id));
    final toRemove = existing.where((id) => !departmentIds.contains(id));
    for (final departmentId in toAdd) {
      await _client.insertOne('supervised_departments', {
        'user_id': userId,
        'department_id': departmentId,
      });
    }
    for (final departmentId in toRemove) {
      await _client.delete(
        'supervised_departments',
        filter: 'user_id=eq.$userId&department_id=eq.$departmentId',
      );
    }
  }

  @override
  Future<void> setSupervisedTeams({
    required int userId,
    required List<int> teamIds,
  }) async {
    final existing = await getSupervisedTeamIds(userId);
    final toAdd = teamIds.where((id) => !existing.contains(id));
    final toRemove = existing.where((id) => !teamIds.contains(id));
    for (final teamId in toAdd) {
      await _client.insertOne('supervised_teams', {
        'user_id': userId,
        'team_id': teamId,
      });
    }
    for (final teamId in toRemove) {
      await _client.delete(
        'supervised_teams',
        filter: 'user_id=eq.$userId&team_id=eq.$teamId',
      );
    }
  }
}
