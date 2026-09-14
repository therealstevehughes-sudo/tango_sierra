import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../core/storage/app_database.dart';
import '../../core/utils/pin_hasher.dart';
import '../models/job_role.dart';
import '../models/pin_auth_outcome.dart';
import '../models/user.dart';

abstract class UserRepository {
  Future<List<User>> getAll();
  Future<List<User>> getForSite(int siteId);
  // Leadership accounts (regional/executive, site-less) for an
  // organisation — built 2026-09-14 so RegionManagementScreen can list
  // who to reset a password for. Local Drift is always implicitly a
  // single organisation (same assumption brandingConfigProvider already
  // makes via organisationRepositoryProvider.getDefault()), so the Drift
  // implementation ignores [organisationId] and just filters by tier.
  Future<List<User>> getForOrganisation(int organisationId);
  // Phase 2 (real backend auth) — Leadership Access uses this to map a
  // real Supabase auth session (email+password) back to the local staff
  // profile it belongs to. Null if no local row has been linked to that
  // Supabase identity yet (linking is currently a manual/admin step, not
  // a self-service flow — see Phase 2 notes).
  Future<User?> findBySupabaseUserId(String supabaseUserId);
  // Phase 2 (real backend auth): useBackendAuth defaults to false, keeping
  // every existing caller's behaviour byte-for-byte unchanged until it's
  // explicitly opted in via backendAuthEnabledProvider. Even when true,
  // a user with no supabaseUserId yet (not synced to the backend) still
  // falls back to the local check — a safe, gradual add-on, not a
  // hard cutover.
  Future<PinAuthOutcome> authenticate({
    required int userId,
    required String pin,
    bool useBackendAuth = false,
  });
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
  Future<void> changeRoleTier({required int userId, required RoleTier newTier});
  // Departments (Sprint 031, Build Order item 5, Sub-sprint B). departmentId
  // null clears the assignment — explicit, not silently omitted, mirrors
  // how a "No department" dropdown option is always shown, never hidden.
  Future<void> changeDepartment({
    required int userId,
    required int? departmentId,
  });
  // Phase B0 — one region per manager: assigns (or clears, if null) which
  // region a regional-tier account oversees. Not tier-checked here — the
  // caller (an admin screen, not built yet) is responsible for only
  // offering this to regional-tier accounts; this method just records it.
  Future<void> assignRegion({required int userId, required int? regionId});
  // Settings shell (Sprint 031, Build Order item 5, Sub-sprint C) — a
  // self-serve personal preference, not an admin action on someone else.
  // Display-only: canonical storage (Celsius) is never touched, conversion
  // happens only where a value is shown or entered.
  Future<void> setPreferredTemperatureUnit({
    required int userId,
    required TemperatureUnit unit,
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
  Future<List<User>> getForSite(int siteId) async {
    final query = _db.select(_db.users)
      ..where((user) => user.siteId.equals(siteId));
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<User>> getForOrganisation(int organisationId) async {
    final query = _db.select(_db.users)
      ..where(
        (u) =>
            u.roleTier.equals('regional') | u.roleTier.equals('executive'),
      );
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<User?> findBySupabaseUserId(String supabaseUserId) async {
    final query = _db.select(_db.users)
      ..where((u) => u.supabaseUserId.equals(supabaseUserId));
    final row = await query.getSingleOrNull();
    if (row == null || !row.active) return null;
    return _toModel(row);
  }

  @override
  Future<PinAuthOutcome> authenticate({
    required int userId,
    required String pin,
    bool useBackendAuth = false,
  }) async {
    final query = _db.select(_db.users)..where((u) => u.id.equals(userId));
    final row = await query.getSingleOrNull();
    if (row == null) return const PinAuthNotFound();
    if (!row.active) return const PinAuthNotFound();

    if (useBackendAuth && row.supabaseUserId != null) {
      return _authenticateViaBackend(row: row, pin: pin);
    }

    if (hashPin(pin, row.pinSalt) != row.pinHash) {
      return const PinAuthIncorrect();
    }
    return PinAuthSuccess(_toModel(row));
  }

  // Calls the pin-login Edge Function, which does the real verification
  // (and lockout enforcement) server-side — this method never sees or
  // checks the PIN itself, only interprets the function's response.
  Future<PinAuthOutcome> _authenticateViaBackend({
    required UserEntity row,
    required String pin,
  }) async {
    try {
      final response = await Supabase.instance.client.functions.invoke(
        'pin-login',
        body: {'user_id': row.supabaseUserId, 'pin': pin},
      );
      final data = response.data as Map<String, dynamic>;
      return PinAuthSuccess(
        _toModel(row),
        accessToken: data['access_token'] as String,
      );
    } on FunctionException catch (e) {
      if (e.status == 423) {
        final details = e.details;
        final lockedUntilStr = details is Map
            ? details['locked_until'] as String?
            : null;
        return PinAuthLocked(
          lockedUntilStr != null
              ? DateTime.parse(lockedUntilStr)
              : DateTime.now().add(const Duration(minutes: 15)),
        );
      }
      if (e.status == 401) return const PinAuthIncorrect();
      return PinAuthError('Could not reach the server (${e.status})');
    } catch (_) {
      return const PinAuthError('Could not reach the server');
    }
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
  Future<void> resetPin({required int userId, required String newPin}) async {
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

  @override
  Future<void> assignRegion({
    required int userId,
    required int? regionId,
  }) async {
    await (_db.update(_db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(regionId: Value(regionId)),
    );
  }

  @override
  Future<void> setPreferredTemperatureUnit({
    required int userId,
    required TemperatureUnit unit,
  }) async {
    await (_db.update(_db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(preferredTemperatureUnit: Value(unit.name)),
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
      siteId: row.siteId,
      active: row.active,
      deactivatedAt: row.deactivatedAt,
      deactivatedByUserId: row.deactivatedByUserId,
      departmentId: row.departmentId,
      regionId: row.regionId,
    );
  }
}
