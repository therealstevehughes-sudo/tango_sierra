import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/region.dart';

abstract class RegionRepository {
  // Scoped by organisationId, not a global getAll() — a Region only ever
  // makes sense within one tenant, and once real multi-tenant data exists
  // (Phase B2+), a global list would cross the exact boundary this whole
  // phase exists to enforce.
  Future<List<Region>> getForOrganisation(int organisationId);
  Future<Region> create({required String name, required int organisationId});
  Future<void> rename(int id, String newName);
}

class DriftRegionRepository implements RegionRepository {
  DriftRegionRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Region>> getForOrganisation(int organisationId) async {
    final query = _db.select(_db.regions)
      ..where((r) => r.organisationId.equals(organisationId));
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<Region> create({
    required String name,
    required int organisationId,
  }) async {
    final createdAt = DateTime.now();
    final id = await _db
        .into(_db.regions)
        .insert(
          RegionsCompanion.insert(
            organisationId: organisationId,
            name: name,
            createdAt: createdAt,
          ),
        );
    return Region(
      id: id,
      organisationId: organisationId,
      name: name,
      createdAt: createdAt,
    );
  }

  @override
  Future<void> rename(int id, String newName) async {
    await (_db.update(_db.regions)..where((r) => r.id.equals(id))).write(
      RegionsCompanion(name: Value(newName)),
    );
  }

  Region _toModel(RegionEntity row) => Region(
    id: row.id,
    organisationId: row.organisationId,
    name: row.name,
    createdAt: row.createdAt,
  );
}
