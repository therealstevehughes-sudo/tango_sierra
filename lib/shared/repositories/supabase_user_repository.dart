import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../core/network/backend_rest_client.dart';
import '../models/job_role.dart';
import '../models/pin_auth_outcome.dart';
import '../models/user.dart';
import 'user_repository.dart';

// Phase B3 — only the profile-data methods move to the backend this
// cluster. resetPin() still touches PIN credentials directly (hashing,
// staff_pins) via the deliberately separate, zero-grant Phase 2 table —
// delegated unchanged to a wrapped DriftUserRepository, since changing
// that wasn't what "Users onto the backend with RLS" meant, and touching
// it deserves its own explicit decision.
//
// authenticate() is one exception, added in Phase C1d: a real
// (backend-first) tenant's staff have NO local Drift row to delegate
// to at all — they were created directly on the backend via
// provision-staff-pin. Delegating to Drift here would always return
// PinAuthNotFound for them, breaking login entirely for exactly the
// accounts this phase exists to onboard. So this looks the user up on
// the backend by id, then calls the SAME already-proven pin-login Edge
// Function directly (Phase 2's real backend auth, unchanged) — no new
// verification logic, just a backend-native way to reach it.
//
// createStaffMember() is the other exception (fixed 2026-09-28 — see its
// own doc comment): it used to delegate to Drift too, a disclosed gap
// that meant the older "Add Staff" flow silently created a local-only
// phantom account in backend mode. Now calls provision-staff-pin
// directly, same as authenticate().
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
    this._localCredentialDelegate,
    this._getAccessToken, [
    SupabaseClient? functionsClient,
  ]) : _functionsClient = functionsClient ?? Supabase.instance.client;

  final BackendRestClient _client;
  final UserRepository _localCredentialDelegate;
  // createStaffMember() needs the CALLER's own session token explicitly
  // (2026-09-28 fix, see that method's own doc comment) — a PIN session
  // has no ambient GoTrue session for functions.invoke to attach on its
  // own, same reasoning tenant_provisioning_repository.dart's
  // provisionStaffPin() already documents for its own callerAccessToken
  // parameter.
  final String? Function() _getAccessToken;
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
  Future<List<User>> getForOrganisation(int organisationId) async {
    final rows = await _client.select(
      'users',
      query:
          'organisation_id=eq.$organisationId&role_tier=in.(regional,executive)',
    );
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

  // Real fix (2026-09-28) for a disclosed gap: this used to delegate
  // unchanged to local Drift even in backend mode, meaning a staff member
  // added via Staff Management/organogram/the venue wizard's "Add Staff"
  // button never actually reached the backend at all — invisible to every
  // other device, and invisible to Roster's own staff-count re-pricing
  // (which reads real backend rows). Now calls the SAME `provision-staff-
  // pin` Edge Function the backend-native StaffProvisioningScreen already
  // uses (extended to accept this caller's own chosen PIN, since that
  // screen's flow always wanted a freshly generated one instead) — gets
  // a real, tenant-isolated account AND the re-pricing this function
  // already fires internally, for free.
  @override
  Future<User> createStaffMember({
    required String name,
    required String jobTitle,
    required RoleTier roleTier,
    required JobRole jobRole,
    required String pin,
    required int siteId,
  }) async {
    final token = _getAccessToken();
    if (token == null) {
      throw StateError('No session token available to create a staff account.');
    }
    final response = await _functionsClient.functions.invoke(
      'provision-staff-pin',
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'name': name,
        'job_title': jobTitle,
        'role_tier': roleTier.name,
        'job_role': jobRole.name,
        'site_id': siteId,
        'pin': pin,
      },
    );
    final data = response.data as Map<String, dynamic>;
    final localUserId = data['local_user_id'] as int;
    // Re-fetch through the normal read path rather than hand-building a
    // User from this function's smaller response shape — guarantees the
    // exact same field defaults (preferredTemperatureUnit, etc.) every
    // other read of this table already gets via _toModel.
    final rows = await _client.select('users', query: 'id=eq.$localUserId');
    return _toModel(rows.first);
  }

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
    // Roster add-on re-pricing (2026-09-27) — a deactivation/reactivation
    // can change which price bracket a site falls into. Calling the
    // Edge Function directly here (not via lib/features/roster's
    // RosterBillingService) since lib/shared must never import from
    // lib/features. No-ops instantly if Roster isn't enabled, and
    // deliberately swallows its own errors — this must never surface as a
    // failure of the deactivate/reactivate action itself.
    try {
      await _client.invokeFunction('roster-addon-billing', {
        'action': 'reprice_if_needed',
      });
    } catch (_) {
      // Best-effort — see comment above.
    }
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
  Future<void> updateDetails({
    required int userId,
    String? name,
    String? jobTitle,
  }) async {
    final body = <String, dynamic>{
      'name': ?name,
      'job_title': ?jobTitle,
    };
    if (body.isEmpty) return;
    await _client.update('users', filter: 'id=eq.$userId', body: body);
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
  Future<void> assignTeam({
    required int userId,
    required int? teamId,
  }) async {
    await _client.update(
      'users',
      filter: 'id=eq.$userId',
      body: {'team_id': teamId},
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
  Future<void> assignReportsTo({
    required int userId,
    required int? reportsToUserId,
  }) async {
    await _client.update(
      'users',
      filter: 'id=eq.$userId',
      body: {'reports_to_user_id': reportsToUserId},
    );
  }

  @override
  Future<void> setFcmToken({
    required int userId,
    required String? token,
  }) async {
    await _client.update(
      'users',
      filter: 'id=eq.$userId',
      body: {'fcm_token': token},
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

  @override
  Future<void> setPreferredLocale({
    required int userId,
    required String? localeCode,
  }) async {
    await _client.update(
      'users',
      filter: 'id=eq.$userId',
      body: {'preferred_locale': localeCode},
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
    teamId: row['team_id'] as int?,
    regionId: row['region_id'] as int?,
    reportsToUserId: row['reports_to_user_id'] as int?,
    fcmToken: row['fcm_token'] as String?,
    preferredLocale: row['preferred_locale'] as String?,
    shiftPhotoConsent: row['shift_photo_consent'] as String?,
    shiftPhotoConsentAt: row['shift_photo_consent_at'] == null
        ? null
        : DateTime.parse(row['shift_photo_consent_at'] as String),
    shiftPhotoConsentVersion: row['shift_photo_consent_version'] as String?,
  );

  @override
  Future<void> setShiftPhotoConsent({
    required int userId,
    required String consent,
    required String version,
  }) async {
    await _client.update(
      'users',
      filter: 'id=eq.$userId',
      body: {
        'shift_photo_consent': consent,
        'shift_photo_consent_at': DateTime.now().toIso8601String(),
        'shift_photo_consent_version': version,
      },
    );
  }
}
