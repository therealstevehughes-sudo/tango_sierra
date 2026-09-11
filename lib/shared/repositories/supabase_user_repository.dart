import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../core/network/backend_rest_client.dart';
import '../models/job_role.dart';
import '../models/pin_auth_outcome.dart';
import '../models/user.dart';
import 'user_repository.dart';

// Phase B3 — only the profile-data methods move to the backend this
// cluster. resetPin()/createStaffMember() still touch PIN credentials
// directly (hashing, staff_pins) via the deliberately separate,
// zero-grant Phase 2 table — delegated unchanged to a wrapped
// DriftUserRepository, since changing those wasn't what "Users onto the
// backend with RLS" meant, and touching them deserves its own explicit
// decision.
//
// authenticate() is the one exception, added in Phase C1d: a real
// (backend-first) tenant's staff have NO local Drift row to delegate
// to at all — they were created directly on the backend via
// provision-staff-pin. Delegating to Drift here would always return
// PinAuthNotFound for them, breaking login entirely for exactly the
// accounts this phase exists to onboard. So this looks the user up on
// the backend by id, then calls the SAME already-proven pin-login Edge
// Function directly (Phase 2's real backend auth, unchanged) — no new
// verification logic, just a backend-native way to reach it. The
// Dart integration test proves the Drift-delegated methods still work
// unchanged (resetPin/createStaffMember), and that this backend-native
// authenticate() path round-trips a real PIN login.
//
// RLS on public.users reuses can_access_site(site_id) — the same function
// proven on sites/departments/areas/training_records. Isolation only, not
// permission: a deactivated colleague at your own site is still fully
// visible and editable, exactly as proven via curl before this class was
// written — this cluster draws the tenant boundary, not the who-can-see-
// what-within-a-tenant boundary (that stays app-layer, unchanged).
class SupabaseUserRepository implements UserRepository {
  SupabaseUserRepository(
    this._client,
    this._localCredentialDelegate, [
    SupabaseClient? functionsClient,
  ]) : _functionsClient = functionsClient ?? Supabase.instance.client;

  final BackendRestClient _client;
  final UserRepository _localCredentialDelegate;
  final SupabaseClient _functionsClient;

  @override
  Future<List<User>> getAll() async {
    final rows = await _client.select('users');
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<User>> getForSite(int siteId) async {
    final rows = await _client.select('users', query: 'site_id=eq.$siteId');
    return rows.map(_toModel).toList();
  }

  @override
  Future<User?> findBySupabaseUserId(String supabaseUserId) async {
    final rows = await _client.select(
      'users',
      query: 'supabase_user_id=eq.$supabaseUserId&active=eq.true',
    );
    if (rows.isEmpty) return null;
    return _toModel(rows.first);
  }

  @override
  Future<PinAuthOutcome> authenticate({
    required int userId,
    required String pin,
    bool useBackendAuth = false,
  }) async {
    // userId here is a backend users.id (this repository's getAll()/the
    // login screen's staff list both come from the backend). Resolving
    // it to a supabase_user_id client-side would need an authenticated
    // read under RLS — which doesn't exist yet at login time (a genuine
    // finding: the walk-up staff list itself needing its own pre-auth
    // scoping is a separate, larger question, logged as a follow-on, not
    // solved here). So pin-login resolves local_user_id -> supabase_user_id
    // itself, service-role, the same privileged way it already resolves
    // staff_pins/verify_staff_pin — never a client-side lookup.
    try {
      final response = await _functionsClient.functions.invoke(
        'pin-login',
        body: {'local_user_id': userId, 'pin': pin},
      );
      final data = response.data as Map<String, dynamic>;
      final accessToken = data['access_token'] as String;

      // The token is real now, so fetch the full profile the normal
      // RLS-protected way (a person can always read their own row) —
      // via a one-off client carrying this brand-new token directly,
      // since currentSessionTokenProvider (what _client's ambient token
      // reads) isn't set until the caller processes this very outcome.
      final freshClient = BackendRestClient(() => accessToken);
      final rows = await freshClient.select('users', query: 'id=eq.$userId');
      if (rows.isEmpty) {
        return const PinAuthError(
          'Signed in, but the profile could not be loaded',
        );
      }
      return PinAuthSuccess(_toModel(rows.first), accessToken: accessToken);
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
  }) => _localCredentialDelegate.createStaffMember(
    name: name,
    jobTitle: jobTitle,
    roleTier: roleTier,
    jobRole: jobRole,
    pin: pin,
    siteId: siteId,
  );

  @override
  Future<void> resetPin({required int userId, required String newPin}) =>
      _localCredentialDelegate.resetPin(userId: userId, newPin: newPin);

  @override
  Future<void> setActive({
    required int userId,
    required bool active,
    required int actingUserId,
  }) async {
    await _client.update(
      'users',
      filter: 'id=eq.$userId',
      body: {
        'active': active,
        if (!active) ...{
          'deactivated_at': DateTime.now().toIso8601String(),
          'deactivated_by_user_id': actingUserId,
        },
      },
    );
  }

  @override
  Future<void> changeRoleTier({
    required int userId,
    required RoleTier newTier,
  }) async {
    await _client.update(
      'users',
      filter: 'id=eq.$userId',
      body: {'role_tier': newTier.name},
    );
  }

  @override
  Future<void> changeDepartment({
    required int userId,
    required int? departmentId,
  }) async {
    await _client.update(
      'users',
      filter: 'id=eq.$userId',
      body: {'department_id': departmentId},
    );
  }

  @override
  Future<void> assignRegion({
    required int userId,
    required int? regionId,
  }) async {
    await _client.update(
      'users',
      filter: 'id=eq.$userId',
      body: {'region_id': regionId},
    );
  }

  @override
  Future<void> setPreferredTemperatureUnit({
    required int userId,
    required TemperatureUnit unit,
  }) async {
    await _client.update(
      'users',
      filter: 'id=eq.$userId',
      body: {'preferred_temperature_unit': unit.name},
    );
  }

  User _toModel(Map<String, dynamic> row) => User(
    id: row['id'] as int,
    name: row['name'] as String,
    jobTitle: row['job_title'] as String,
    roleTier: RoleTier.values.byName(row['role_tier'] as String),
    jobRole: row['job_role'] == null
        ? null
        : JobRole.values.byName(row['job_role'] as String),
    preferredTemperatureUnit: TemperatureUnit.values.byName(
      row['preferred_temperature_unit'] as String,
    ),
    siteId: row['site_id'] as int?,
    active: row['active'] as bool,
    deactivatedAt: row['deactivated_at'] == null
        ? null
        : DateTime.parse(row['deactivated_at'] as String),
    deactivatedByUserId: row['deactivated_by_user_id'] as int?,
    departmentId: row['department_id'] as int?,
    regionId: row['region_id'] as int?,
  );
}
