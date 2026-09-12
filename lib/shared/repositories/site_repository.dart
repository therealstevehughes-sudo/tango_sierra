import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/site.dart';

abstract class SiteRepository {
  Future<List<Site>> getAll();

  /// Phase B0-scoped read: the sites in one Region (a Regional Manager's
  /// permitted set). No global getAll() for Regions — this is the
  /// authoritative "which venues can this regional see" query. RLS on the
  /// backend (`can_access_site`) enforces the same boundary server-side.
  Future<List<Site>> getForRegion(int regionId);

  /// Organisation-scoped read: every site a Director/Executive owns. Same
  /// RLS boundary as getForRegion, one level up.
  Future<List<Site>> getForOrganisation(int organisationId);
  Future<Site> getDefault();
  // Branding inheritance (Part E): the branch home screen needs its own
  // site's name specifically, not "the default site" — a regional/
  // executive user's currentSiteProvider-style default would show the
  // wrong venue's name for anyone not at the first-created site.
  Future<Site?> getById(int id);
  // Phase B0 — null clears the assignment (site attaches directly to the
  // Organisation again), same "explicit null, not hidden" convention as
  // Department assignment elsewhere in this app.
  Future<void> setRegion(int siteId, int? regionId);
  Future<void> rename(int id, String newName);
  // Phase C1c — regionId lets a regional manager's own "add branch" write
  // pass RLS in one step (their WITH CHECK requires region_id to already
  // equal their own claim at insert time — setRegion() afterward would be
  // a second write). Null (the default) keeps every existing call site's
  // behaviour: an executive-created site attaches directly to the
  // Organisation, same as before this parameter existed.
  Future<Site> create({
    required String name,
    String? address,
    required int organisationId,
    int? regionId,
  });

  /// The venue type ids currently tagged on a site (Sprint 029). A site can
  /// have more than one (e.g. a gastropub is kitchen + bar).
  Future<List<int>> getVenueTypeIds(int siteId);

  /// Replaces the full set of venue types tagged on a site with exactly
  /// [venueTypeIds].
  Future<void> setVenueTypeIds(int siteId, List<int> venueTypeIds);
}

class DriftSiteRepository implements SiteRepository {
  DriftSiteRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Site>> getAll() async {
    final rows = await _db.select(_db.sites).get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<Site>> getForRegion(int regionId) async {
    final query = _db.select(_db.sites)
      ..where((s) => s.regionId.equals(regionId));
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<Site>> getForOrganisation(int organisationId) async {
    final query = _db.select(_db.sites)
      ..where((s) => s.organisationId.equals(organisationId));
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<Site> getDefault() async {
    final query = _db.select(_db.sites)
      ..orderBy([(s) => OrderingTerm.asc(s.id)])
      ..limit(1);
    final row = await query.getSingle();
    return _toModel(row);
  }

  @override
  Future<Site?> getById(int id) async {
    final query = _db.select(_db.sites)..where((s) => s.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  @override
  Future<void> rename(int id, String newName) async {
    await (_db.update(_db.sites)..where((s) => s.id.equals(id))).write(
      SitesCompanion(name: Value(newName)),
    );
  }

  @override
  Future<void> setRegion(int siteId, int? regionId) async {
    await (_db.update(_db.sites)..where((s) => s.id.equals(siteId))).write(
      SitesCompanion(regionId: Value(regionId)),
    );
  }

  @override
  Future<Site> create({
    required String name,
    String? address,
    required int organisationId,
    int? regionId,
  }) async {
    final createdAt = DateTime.now();
    final id = await _db
        .into(_db.sites)
        .insert(
          SitesCompanion.insert(
            organisationId: organisationId,
            name: name,
            address: Value(address),
            createdAt: createdAt,
            regionId: Value(regionId),
          ),
        );
    return Site(
      id: id,
      organisationId: organisationId,
      name: name,
      address: address,
      createdAt: createdAt,
      regionId: regionId,
    );
  }

  @override
  Future<List<int>> getVenueTypeIds(int siteId) async {
    final rows = await (_db.select(
      _db.siteVenueTypes,
    )..where((j) => j.siteId.equals(siteId))).get();
    return rows.map((row) => row.venueTypeId).toList();
  }

  @override
  Future<void> setVenueTypeIds(int siteId, List<int> venueTypeIds) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.siteVenueTypes,
      )..where((j) => j.siteId.equals(siteId))).go();
      for (final venueTypeId in venueTypeIds) {
        await _db
            .into(_db.siteVenueTypes)
            .insert(
              SiteVenueTypesCompanion.insert(
                siteId: siteId,
                venueTypeId: venueTypeId,
              ),
            );
      }
    });
  }

  Site _toModel(SiteEntity row) {
    return Site(
      id: row.id,
      organisationId: row.organisationId,
      name: row.name,
      address: row.address,
      createdAt: row.createdAt,
      regionId: row.regionId,
    );
  }
}
