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
