import '../../core/network/backend_rest_client.dart';
import '../models/job_role.dart';
import '../models/pin_auth_outcome.dart';
import '../models/user.dart';
import 'user_repository.dart';

// Phase B3 — only the profile-data methods move to the backend this
// cluster. authenticate()/resetPin()/createStaffMember() all touch PIN
// credentials directly (hashing, staff_pins), which live in a deliberately
// separate table with its own zero-grant security model (Phase 2) and
// their own already-proven flow via the pin-login Edge Function — moving
// THOSE is not what "Users onto the backend with RLS" means, and touching
// auth behaviour deserves its own explicit decision, not a side effect of
// this migration. All three are delegated unchanged to a wrapped
// DriftUserRepository, which is exactly what guarantees auth is literally
// untouched regardless of whether backendDataEnabledProvider is on — see
// the Dart integration test proving this round-trips correctly.
//
// RLS on public.users reuses can_access_site(site_id) — the same function
// proven on sites/departments/areas/training_records. Isolation only, not
// permission: a deactivated colleague at your own site is still fully
// visible and editable, exactly as proven via curl before this class was
// written — this cluster draws the tenant boundary, not the who-can-see-
// what-within-a-tenant boundary (that stays app-layer, unchanged).
class SupabaseUserRepository implements UserRepository {
  SupabaseUserRepository(this._client, this._localCredentialDelegate);

  final BackendRestClient _client;
  final UserRepository _localCredentialDelegate;

  @override
  Future<List<User>> getAll() async {
    final rows = await _client.select('users');
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
  }) => _localCredentialDelegate.authenticate(
    userId: userId,
    pin: pin,
    useBackendAuth: useBackendAuth,
  );

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
