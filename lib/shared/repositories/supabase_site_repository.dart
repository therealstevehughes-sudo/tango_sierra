import '../../core/network/backend_rest_client.dart';
import '../models/site.dart';
import 'site_repository.dart';

// Phase B2 — backend-hosted Sites. RLS uses can_access_site(id) directly
// on the site's own id (built and proven in Phase B1) — a branch session
// sees only its own site, regional/executive see their region's/org's
// sites, cross-tenant reads/writes are rejected. Proven via curl including
// the WITH CHECK boundary-crossing-write trap before this class was written.
class SupabaseSiteRepository implements SiteRepository {
  SupabaseSiteRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<Site>> getAll() async {
    final rows = await _client.select('sites');
    return rows.map(_toModel).toList();
  }

  @override
  Future<Site> getDefault() async {
    final rows = await _client.select('sites', query: 'order=id.asc&limit=1');
    if (rows.isEmpty) {
      throw StateError('No site visible to this session.');
    }
    return _toModel(rows.first);
  }

  @override
  Future<Site?> getById(int id) async {
    final rows = await _client.select('sites', query: 'id=eq.$id');
    if (rows.isEmpty) return null;
    return _toModel(rows.first);
  }

  @override
  Future<void> setRegion(int siteId, int? regionId) async {
    await _client.update(
      'sites',
      filter: 'id=eq.$siteId',
      body: {'region_id': regionId},
    );
  }

  @override
  Future<void> rename(int id, String newName) async {
    await _client.update(
      'sites',
      filter: 'id=eq.$id',
      body: {'name': newName},
    );
  }

  @override
  Future<Site> create({
    required String name,
    String? address,
    required int organisationId,
    int? regionId,
  }) async {
    final row = await _client.insertOne('sites', {
      'name': name,
      'address': address,
      'organisation_id': organisationId,
      'region_id': regionId,
    });
    return _toModel(row);
  }

  // Venue-type tagging (SiteVenueTypes) is proven in B2's RLS/proof but not
  // yet wired to a backend repository call here — Venue Details' tagging UI
  // stays on the Drift path until that screen is retrofitted, matching the
  // "capability built, app wiring incremental" approach agreed for B2.
  @override
  Future<List<int>> getVenueTypeIds(int siteId) {
    throw UnimplementedError(
      'Site venue-type tagging is not yet wired to the backend path — '
      'still Drift-only pending the Venue Details screen retrofit.',
    );
  }

  @override
  Future<void> setVenueTypeIds(int siteId, List<int> venueTypeIds) {
    throw UnimplementedError(
      'Site venue-type tagging is not yet wired to the backend path — '
      'still Drift-only pending the Venue Details screen retrofit.',
    );
  }

  Site _toModel(Map<String, dynamic> row) => Site(
    id: row['id'] as int,
    organisationId: row['organisation_id'] as int,
    name: row['name'] as String,
    address: row['address'] as String?,
    createdAt: DateTime.parse(row['created_at'] as String),
    regionId: row['region_id'] as int?,
  );
}
