import '../../core/network/backend_rest_client.dart';
import '../models/team.dart';
import 'team_repository.dart';

// Backend-hosted Teams (2026-09-18), same pattern as SupabaseDepartmentRepository
// — RLS reuses can_access_site(site_id) via a join to the parent department's
// site (teams have no site_id column of their own, same shape choice as
// issue_events' join to its parent issue).
class SupabaseTeamRepository implements TeamRepository {
  SupabaseTeamRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<Team>> getForDepartment(int departmentId) async {
    final rows = await _client.select(
      'teams',
      query: 'department_id=eq.$departmentId&order=name.asc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<Team> create({
    required String name,
    required int departmentId,
  }) async {
    final row = await _client.insertOne('teams', {
      'name': name,
      'department_id': departmentId,
    });
    return _toModel(row);
  }

  @override
  Future<void> rename(int id, String newName) async {
    await _client.update(
      'teams',
      filter: 'id=eq.$id',
      body: {'name': newName},
    );
  }

  @override
  Future<void> setActive(int id, bool active) async {
    await _client.update(
      'teams',
      filter: 'id=eq.$id',
      body: {'active': active},
    );
  }

  Team _toModel(Map<String, dynamic> row) => Team(
    id: row['id'] as int,
    name: row['name'] as String,
    departmentId: row['department_id'] as int,
    active: row['active'] as bool,
    createdAt: DateTime.parse(row['created_at'] as String),
  );
}
