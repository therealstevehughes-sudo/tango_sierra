import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/organisation.dart';

abstract class OrganisationRepository {
  Future<List<Organisation>> getAll();
  Future<Organisation> getDefault();
  Future<void> rename(int id, String newName);
  // Per-employee graded dashboard bars (2026-09-24, direct user request) —
  // off by default. When enabled, the leadership dashboard's Employee
  // filter shows the same colour-graded bar the branch/section view uses
  // instead of a plain lookup list — reframed by the user as "work
  // oversight for risk assessment," not grading. The underlying
  // computation (LeadershipDashboardService.computeTaskOverview/
  // computeIncidents with employeeId set) already existed and was already
  // approved for this exact use; this flag only controls whether the
  // screen is allowed to use it for a given organisation.
  Future<void> setEmployeeGradedBarsEnabled(int id, bool enabled);
  // Roster add-on (2026-09-27) — the paid shift-claiming/rota feature,
  // off by default. See Organisation.rosterAddonEnabled's own doc comment.
  Future<void> setRosterAddonEnabled(int id, bool enabled);
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

  @override
  Future<void> rename(int id, String newName) async {
    await (_db.update(_db.organisations)..where((o) => o.id.equals(id))).write(
      OrganisationsCompanion(name: Value(newName)),
    );
  }

  @override
  Future<void> setEmployeeGradedBarsEnabled(int id, bool enabled) async {
    await (_db.update(_db.organisations)..where((o) => o.id.equals(id))).write(
      OrganisationsCompanion(employeeGradedBarsEnabled: Value(enabled)),
    );
  }

  @override
  Future<void> setRosterAddonEnabled(int id, bool enabled) async {
    await (_db.update(_db.organisations)..where((o) => o.id.equals(id))).write(
      OrganisationsCompanion(rosterAddonEnabled: Value(enabled)),
    );
  }

  Organisation _toModel(OrganisationEntity row) {
    return Organisation(
      id: row.id,
      name: row.name,
      createdAt: row.createdAt,
      employeeGradedBarsEnabled: row.employeeGradedBarsEnabled,
      rosterAddonEnabled: row.rosterAddonEnabled,
    );
  }
}
