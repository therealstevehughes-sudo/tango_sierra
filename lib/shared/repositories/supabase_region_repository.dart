import '../../core/network/backend_rest_client.dart';
import '../models/region.dart';
import 'region_repository.dart';

// Phase B2 — backend-hosted Regions. RLS uses the new can_access_region()
// function (branch tier: region of its own site; regional: its own region;
// executive: any region in its org) — proven directly via curl, including
// the same-org-different-region boundary, before this class was written.
class SupabaseRegionRepository implements RegionRepository {
  SupabaseRegionRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<Region>> getForOrganisation(int organisationId) async {
    // RLS already scopes this to what the caller can see; the explicit
    // filter here narrows to the requested org on top of that, matching
    // the interface's own contract (a Region only makes sense within one
    // tenant).
    final rows = await _client.select(
      'regions',
      query: 'organisation_id=eq.$organisationId',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<Region> create({
    required String name,
    required int organisationId,
  }) async {
    final row = await _client.insertOne('regions', {
      'name': name,
      'organisation_id': organisationId,
    });
    return _toModel(row);
  }

  @override
  Future<void> rename(int id, String newName) async {
    await _client.update(
      'regions',
      filter: 'id=eq.$id',
      body: {'name': newName},
    );
  }

  Region _toModel(Map<String, dynamic> row) => Region(
    id: row['id'] as int,
    organisationId: row['organisation_id'] as int,
    name: row['name'] as String,
    createdAt: DateTime.parse(row['created_at'] as String),
  );
}
