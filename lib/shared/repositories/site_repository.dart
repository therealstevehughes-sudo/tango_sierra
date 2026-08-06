import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/site.dart';

abstract class SiteRepository {
  Future<List<Site>> getAll();
  Future<Site> getDefault();
  Future<void> rename(int id, String newName);
  Future<Site> create({
    required String name,
    String? address,
    required int organisationId,
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
  Future<Site> getDefault() async {
    final query = _db.select(_db.sites)
      ..orderBy([(s) => OrderingTerm.asc(s.id)])
      ..limit(1);
    final row = await query.getSingle();
    return _toModel(row);
  }

  @override
  Future<void> rename(int id, String newName) async {
    await (_db.update(_db.sites)..where((s) => s.id.equals(id))).write(
      SitesCompanion(name: Value(newName)),
    );
  }

  @override
  Future<Site> create({
    required String name,
    String? address,
    required int organisationId,
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
          ),
        );
    return Site(
      id: id,
      organisationId: organisationId,
      name: name,
      address: address,
      createdAt: createdAt,
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
    );
  }
}
