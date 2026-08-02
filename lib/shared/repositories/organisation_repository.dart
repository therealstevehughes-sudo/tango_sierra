import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/organisation.dart';

abstract class OrganisationRepository {
  Future<List<Organisation>> getAll();
  Future<Organisation> getDefault();
}

class DriftOrganisationRepository implements OrganisationRepository {
  DriftOrganisationRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Organisation>> getAll() async {
    final rows = await _db.select(_db.organisations).get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<Organisation> getDefault() async {
    final query = _db.select(_db.organisations)
      ..orderBy([(o) => OrderingTerm.asc(o.id)])
      ..limit(1);
    final row = await query.getSingle();
    return _toModel(row);
  }

  Organisation _toModel(OrganisationEntity row) {
    return Organisation(id: row.id, name: row.name, createdAt: row.createdAt);
  }
}
