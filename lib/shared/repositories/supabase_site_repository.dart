import 'dart:math';

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
  Future<List<Site>> getForRegion(int regionId) async {
    final rows = await _client.select('sites', query: 'region_id=eq.$regionId');
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<Site>> getForOrganisation(int organisationId) async {
    final rows = await _client.select(
      'sites',
      query: 'organisation_id=eq.$organisationId',
    );
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
    await _client.update('sites', filter: 'id=eq.$id', body: {'name': newName});
  }

  @override
  Future<Site> create({
    required String name,
    String? address,
    required int organisationId,
    int? regionId,
  }) async {
    // device_credential (2026-09-21) is NOT NULL with no column default —
    // a real bug found live-testing GoCardless signup: tenant-signup's own
    // first-venue insert hit this exact same gap. Every new site needs one
    // generated at creation time, same as regenerateDeviceCredential below.
    final random = Random.secure();
    final deviceCredential = List.generate(
      8,
      (_) => _codeAlphabet[random.nextInt(_codeAlphabet.length)],
    ).join();
    final row = await _client.insertOne('sites', {
      'name': name,
      'address': address,
      'organisation_id': organisationId,
      'region_id': regionId,
      'device_credential': deviceCredential,
    });
    return _toModel(row);
  }

  // Venue-type tagging (SiteVenueTypes) — wired 2026-09-20. Was left as an
  // UnimplementedError stub since B2 ("app wiring incremental"), but
  // `venue_details_screen.dart` calls `getVenueTypeIds()` unconditionally
  // for every site on screen load via the same `siteRepositoryProvider`
  // that switches to this class in backend mode — meaning Venue Details
  // was actually broken (a thrown exception on open, not just a disclosed
  // deferred gap) for any backend-hosted venue. RLS/schema already proven
  // in B2; this was purely a missing repository implementation.
  @override
  Future<List<int>> getVenueTypeIds(int siteId) async {
    final rows = await _client.select(
      'site_venue_types',
      query: 'site_id=eq.$siteId',
    );
    return rows.map((row) => row['venue_type_id'] as int).toList();
  }

  // Insert-before-delete (same fix as SupabaseSupervisionRepository, this
  // session): a rejected/failed insert partway through must never have
  // already deleted the site's real existing tags.
  @override
  Future<void> setVenueTypeIds(int siteId, List<int> venueTypeIds) async {
    final existing = await getVenueTypeIds(siteId);
    final toAdd = venueTypeIds.where((id) => !existing.contains(id));
    final toRemove = existing.where((id) => !venueTypeIds.contains(id));
    for (final venueTypeId in toAdd) {
      await _client.insertOne('site_venue_types', {
        'site_id': siteId,
        'venue_type_id': venueTypeId,
      });
    }
    for (final venueTypeId in toRemove) {
      await _client.delete(
        'site_venue_types',
        filter: 'site_id=eq.$siteId&venue_type_id=eq.$venueTypeId',
      );
    }
  }

  // Not crypto-grade — this is a shared, human-typed-off-a-screen setup
  // code (same trust level as a wifi password taped to a shared device),
  // not a security boundary on its own. 8 chars from a 32-symbol alphabet
  // (no 0/O/1/I, easy to read aloud/off a screen) keeps false-collision
  // risk negligible at this app's scale while staying quick to type.
  static const _codeAlphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  @override
  Future<Site> regenerateDeviceCredential(int siteId) async {
    final random = Random.secure();
    final code = List.generate(
      8,
      (_) => _codeAlphabet[random.nextInt(_codeAlphabet.length)],
    ).join();
    await _client.update(
      'sites',
      filter: 'id=eq.$siteId',
      body: {'device_credential': code},
    );
    final rows = await _client.select('sites', query: 'id=eq.$siteId');
    return _toModel(rows.first);
  }

  @override
  Future<void> setShiftVerificationPhotosEnabled(
    int siteId,
    bool enabled,
  ) async {
    await _client.update(
      'sites',
      filter: 'id=eq.$siteId',
      body: {'shift_verification_photos_enabled': enabled},
    );
  }

  @override
  Future<void> setShiftPhotoRetentionDays(int siteId, int days) async {
    await _client.update(
      'sites',
      filter: 'id=eq.$siteId',
      body: {'shift_photo_retention_days': days},
    );
  }

  Site _toModel(Map<String, dynamic> row) => Site(
    id: row['id'] as int,
    organisationId: row['organisation_id'] as int,
    name: row['name'] as String,
    address: row['address'] as String?,
    createdAt: DateTime.parse(row['created_at'] as String),
    regionId: row['region_id'] as int?,
    deviceCredential: row['device_credential'] as String?,
    shiftVerificationPhotosEnabled:
        row['shift_verification_photos_enabled'] as bool? ?? false,
    shiftPhotoRetentionDays: row['shift_photo_retention_days'] as int? ?? 90,
  );
}
