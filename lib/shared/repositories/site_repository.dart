import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/site.dart';

abstract class SiteRepository {
  Future<List<Site>> getAll();
  Future<Site> getDefault();
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
