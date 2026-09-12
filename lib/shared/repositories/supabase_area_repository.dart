import '../../core/network/backend_rest_client.dart';
import '../models/area.dart';
import 'area_repository.dart';

// Phase B2 — backend-hosted Areas. RLS reuses can_access_site(site_id),
// same shape as Sites/Departments. Proven via curl before this class was
// written. Note this also fixes a known pre-existing gap logged in
// DECISIONS_LOG.md ("Multi-site is only partially usable") — the local
// getAll() has never filtered by site; the backend path now does, for
// free, via RLS, once backendDataEnabledProvider is on.
class SupabaseAreaRepository implements AreaRepository {
  SupabaseAreaRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<Area>> getAll() async {
    final rows = await _client.select('areas');
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<Area>> getForSite(int siteId) async {
    final rows = await _client.select('areas', query: 'site_id=eq.$siteId');
    return rows.map(_toModel).toList();
  }

  @override
  Future<Area> create(String name, int siteId) async {
    final row = await _client.insertOne('areas', {
      'name': name,
      'site_id': siteId,
    });
    return _toModel(row);
  }

  @override
  Future<void> rename(int id, String newName) async {
    await _client.update('areas', filter: 'id=eq.$id', body: {'name': newName});
  }

  // Task-reorder (2026-09-12): the backend Areas table has no sort_order
  // column yet — deliberately stubbed like every other reorder write, so
  // the local/Drift path stays fully functional while the column waits for
  // a later cluster migration. Mirrors
  // SupabaseTaskScheduleRepository.setSortOrder.
  @override
  Future<void> setSortOrder(int areaId, int? sortOrder) async {
    throw UnimplementedError(
      'Area.sortOrder is not yet on the backend schema — '
      'the column will be added in a later cluster migration. '
      'Local/Drift path is fully functional.',
    );
  }

  Area _toModel(Map<String, dynamic> row) => Area(
    id: row['id'] as int,
    name: row['name'] as String,
    siteId: row['site_id'] as int,
  );
}
