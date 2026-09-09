import '../../core/network/backend_rest_client.dart';
import '../models/department.dart';
import 'department_repository.dart';

// Phase B2 — backend-hosted Departments. RLS reuses can_access_site(site_id)
// (the same function/shape proven on Sites in B1) — a branch session sees
// only its own site's departments; cross-tenant reads/writes rejected.
// Proven via curl before this class was written.
class SupabaseDepartmentRepository implements DepartmentRepository {
  SupabaseDepartmentRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<Department>> getForSite(int siteId) async {
    final rows = await _client.select(
      'departments',
      query: 'site_id=eq.$siteId&order=name.asc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<Department> create({
    required String name,
    required int siteId,
  }) async {
    final row = await _client.insertOne('departments', {
      'name': name,
      'site_id': siteId,
    });
    return _toModel(row);
  }

  @override
  Future<void> rename(int id, String newName) async {
    await _client.update(
      'departments',
      filter: 'id=eq.$id',
      body: {'name': newName},
    );
  }

  @override
  Future<void> setActive(int id, bool active) async {
    await _client.update(
      'departments',
      filter: 'id=eq.$id',
      body: {'active': active},
    );
  }

  Department _toModel(Map<String, dynamic> row) => Department(
    id: row['id'] as int,
    name: row['name'] as String,
    siteId: row['site_id'] as int,
    active: row['active'] as bool,
    createdAt: DateTime.parse(row['created_at'] as String),
  );
}
