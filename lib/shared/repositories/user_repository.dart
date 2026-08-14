import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../../core/utils/pin_hasher.dart';
import '../models/job_role.dart';
import '../models/user.dart';

abstract class UserRepository {
  Future<List<User>> getAll();
  Future<User?> authenticate({required int userId, required String pin});
  Future<User> createStaffMember({
    required String name,
    required String jobTitle,
    required RoleTier roleTier,
    required JobRole jobRole,
    required String pin,
    required int siteId,
  });
  Future<void> resetPin({required int userId, required String newPin});
  // Deactivating also deactivates this user's own active TaskSchedules, so
  // a manager doesn't see someone who can't log in as still assigned.
  // Reactivating does NOT restore those schedules — re-assignment is a
  // deliberate, separate action. deactivatedAt/deactivatedByUserId are
  // preserved on reactivation (not cleared) — kept on record even once
  // the person is active again.
  Future<void> setActive({
    required int userId,
    required bool active,
    required int actingUserId,
  });
  // Corrects a user's tier after creation — needed alongside the Sprint 027
  // three-to-five-tier migration, since the automatic mid/top remap default
  // (mid->venueManager, top->executive) is a lossy guess for real users who
  // were actually supervisor- or regional-flavored.
  Future<void> changeRoleTier({
    required int userId,
    required RoleTier newTier,
  });
  // Departments (Sprint 031, Build Order item 5, Sub-sprint B). departmentId
  // null clears the assignment — explicit, not silently omitted, mirrors
  // how a "No department" dropdown option is always shown, never hidden.
  Future<void> changeDepartment({
    required int userId,
    required int? departmentId,
  });
}

class DriftUserRepository implements UserRepository {
  DriftUserRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<User>> getAll() async {
    final rows = await _db.select(_db.users).get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<User?> authenticate({
    required int userId,
    required String pin,
  }) async {
    final query = _db.select(_db.users)..where((u) => u.id.equals(userId));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    if (!row.active) return null;

    if (hashPin(pin, row.pinSalt) != row.pinHash) return null;

    return _toModel(row);
  }

  @override
  Future<User> createStaffMember({
    required String name,
    required String jobTitle,
    required RoleTier roleTier,
    required JobRole jobRole,
    required String pin,
    required int siteId,
  }) async {
    final salt = generateSalt();
    final id = await _db
        .into(_db.users)
        .insert(
          UsersCompanion.insert(
            name: name,
            jobTitle: jobTitle,
            roleTier: roleTier.name,
            jobRole: Value(jobRole.name),
            pinHash: hashPin(pin, salt),
            pinSalt: salt,
            siteId: Value(siteId),
          ),
        );
    return User(
      id: id,
      name: name,
      jobTitle: jobTitle,
      roleTier: roleTier,
      jobRole: jobRole,
      siteId: siteId,
    );
  }

  @override
  Future<void> resetPin({
    required int userId,
    required String newPin,
  }) async {
    final salt = generateSalt();
    await (_db.update(_db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        pinHash: Value(hashPin(newPin, salt)),
        pinSalt: Value(salt),
      ),
    );
  }

  @override
  Future<void> setActive({
    required int userId,
    required bool active,
    required int actingUserId,
  }) async {
    if (active) {
      await (_db.update(_db.users)..where((u) => u.id.equals(userId))).write(
        const UsersCompanion(active: Value(true)),
      );
      return;
    }

    await (_db.update(_db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        active: const Value(false),
        deactivatedAt: Value(DateTime.now()),
        deactivatedByUserId: Value(actingUserId),
      ),
    );
    await (_db.update(_db.taskSchedules)..where(
          (s) => s.assignedUserId.equals(userId) & s.active.equals(true),
        ))
        .write(const TaskSchedulesCompanion(active: Value(false)));
  }

  @override
  Future<void> changeRoleTier({
    required int userId,
    required RoleTier newTier,
  }) async {
    await (_db.update(_db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(roleTier: Value(newTier.name)),
    );
  }

  @override
  Future<void> changeDepartment({
    required int userId,
    required int? departmentId,
  }) async {
    await (_db.update(_db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(departmentId: Value(departmentId)),
    );
  }

  User _toModel(UserEntity row) {
    return User(
      id: row.id,
      name: row.name,
      jobTitle: row.jobTitle,
      roleTier: RoleTier.values.byName(row.roleTier),
      jobRole: row.jobRole == null ? null : JobRole.values.byName(row.jobRole!),
      preferredTemperatureUnit: TemperatureUnit.values.byName(
        row.preferredTemperatureUnit,
      ),
      siteId: row.siteId!,
      active: row.active,
      deactivatedAt: row.deactivatedAt,
      deactivatedByUserId: row.deactivatedByUserId,
      departmentId: row.departmentId,
    );
  }
}
