import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/backend_rest_client.dart';
import '../../core/network/supabase_client.dart';
import '../models/department.dart';
import '../models/user.dart';
import '../repositories/supabase_user_repository.dart';
import '../repositories/user_repository.dart';
import 'department_providers.dart' show departmentRepositoryProvider;
import 'site_providers.dart' show currentSiteProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final driftRepository = DriftUserRepository(db);
  // Phase B3 — authenticate()/resetPin()/createStaffMember() always stay
  // on this same Drift instance regardless of the flag (see
  // SupabaseUserRepository's doc comment) — built here once so it's
  // available either as the whole repository or as the credential
  // delegate the backend-profile wrapper falls back to.
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseUserRepository(
      BackendRestClient(() => ref.read(currentBackendAccessTokenProvider)),
      driftRepository,
    );
  }
  return driftRepository;
});

// Device pairing (2026-09-20) — closes a real gap: in backend mode, with
// no session yet, the walk-up staff list has nothing to authenticate the
// request with, so RLS fails closed and getAll() always came back empty.
// A device proves it belongs to a venue with that venue's device_credential
// (a shared setup code, shown to a manager in Venue Details, typed once
// into a new tablet) instead. Local-only installs never hit this path —
// the install itself is already the trusted device.
const _kDevicePairedSiteIdKey = 'device_paired_site_id';
const _kDeviceCredentialKey = 'device_credential';

class DevicePairing {
  const DevicePairing({required this.siteId, required this.deviceCredential});
  final int siteId;
  final String deviceCredential;
}

/// Thrown by [staffDirectoryProvider] when running in backend mode with no
/// stored device pairing yet — the login screen shows a "pair this
/// device" prompt for this specific error rather than a generic failure
/// or an empty roster.
class DeviceNotPairedException implements Exception {
  const DeviceNotPairedException();
}

/// Thrown when a setup code is entered but the backend rejects it (wrong
/// or unknown code).
class DevicePairingException implements Exception {
  DevicePairingException(this.message);
  final String message;
  @override
  String toString() => message;
}

final devicePairingProvider = FutureProvider<DevicePairing?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final siteId = prefs.getInt(_kDevicePairedSiteIdKey);
  final credential = prefs.getString(_kDeviceCredentialKey);
  if (siteId == null || credential == null) return null;
  return DevicePairing(siteId: siteId, deviceCredential: credential);
});

/// Verifies [deviceCredential] against the `device-login` Edge Function
/// and, on success, stores the pairing locally so this device never has
/// to ask again. Returns the active staff roster from that same call so
/// the login screen can show it immediately, with no extra round trip.
Future<List<User>> pairDevice(WidgetRef ref, String deviceCredential) async {
  final client = BackendRestClient(() => null);
  Map<String, dynamic> data;
  try {
    data = await client.invokeFunction('device-login', {
      'device_credential': deviceCredential,
    });
  } catch (_) {
    throw DevicePairingException('Could not reach the server');
  }
  if (data['error'] != null) {
    throw DevicePairingException(
      data['error'] is String ? data['error'] as String : 'Invalid setup code',
    );
  }
  final siteId = data['site_id'] as int;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_kDevicePairedSiteIdKey, siteId);
  await prefs.setString(_kDeviceCredentialKey, deviceCredential);
  ref.invalidate(devicePairingProvider);
  ref.invalidate(staffDirectoryProvider);
  return _staffFromDeviceLoginRows(
    (data['staff'] as List).cast<Map<String, dynamic>>(),
  );
}

List<User> _staffFromDeviceLoginRows(List<Map<String, dynamic>> rows) {
  return rows
      .map(
        (row) => User(
          id: row['id'] as int,
          name: row['name'] as String,
          jobTitle: row['job_title'] as String,
          roleTier: RoleTier.values.byName(row['role_tier'] as String),
          // Section picker (2026-09-23) — device-login now returns this
          // too, so the pre-login staff list can be grouped/filtered by
          // department the same way a local install already can.
          departmentId: row['department_id'] as int?,
        ),
      )
      .toList();
}

// Section picker (2026-09-23) — one shared cache for the device-login
// call, so staffDirectoryProvider and staffDirectoryDepartmentsProvider
// (below) don't each trigger their own separate network round trip to
// the same Edge Function. Riverpod memoizes this per ProviderContainer,
// same as any other FutureProvider.
final _deviceLoginResponseProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final pairing = await ref.watch(devicePairingProvider.future);
  if (pairing == null) {
    throw const DeviceNotPairedException();
  }
  final client = BackendRestClient(() => null);
  Map<String, dynamic> data;
  try {
    data = await client.invokeFunction('device-login', {
      'device_credential': pairing.deviceCredential,
    });
  } catch (_) {
    throw DevicePairingException('Could not reach the server');
  }
  if (data['error'] != null) {
    // A previously-valid code stopped working (regenerated by a
    // manager) — clear the stale pairing so the prompt reappears
    // instead of silently retrying a dead code forever.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kDevicePairedSiteIdKey);
    await prefs.remove(_kDeviceCredentialKey);
    throw const DeviceNotPairedException();
  }
  return data;
});

final staffDirectoryProvider = FutureProvider<List<User>>((ref) async {
  if (ref.watch(backendDataEnabledProvider)) {
    final data = await ref.watch(_deviceLoginResponseProvider.future);
    return _staffFromDeviceLoginRows(
      (data['staff'] as List).cast<Map<String, dynamic>>(),
    );
  }
  final repository = ref.watch(userRepositoryProvider);
  final staff = await repository.getAll();
  return staff.where((u) => u.active).toList();
});

// Section picker (2026-09-23) — this venue's active departments, resolved
// pre-login the same way staffDirectoryProvider resolves staff: from the
// device-login response in backend mode, or straight from the local
// Drift DB's one default site otherwise. Used by LoginScreen to decide
// whether to show a department-first picker (2+ departments with staff)
// instead of today's single flat list.
final staffDirectoryDepartmentsProvider = FutureProvider<List<Department>>((
  ref,
) async {
  if (ref.watch(backendDataEnabledProvider)) {
    final data = await ref.watch(_deviceLoginResponseProvider.future);
    final siteId = data['site_id'] as int;
    final rows = (data['departments'] as List).cast<Map<String, dynamic>>();
    return rows
        .map(
          (row) => Department(
            id: row['id'] as int,
            name: row['name'] as String,
            siteId: siteId,
            createdAt: DateTime.now(),
          ),
        )
        .toList();
  }
  final site = await ref.watch(currentSiteProvider.future);
  final departments = await ref
      .watch(departmentRepositoryProvider)
      .getForSite(site.id);
  return departments.where((d) => d.active).toList();
});

final currentUserProvider = StateProvider<User?>((ref) => null);

// Shift welcome screen (2026-09-24) — set true by a real PIN login
// (login_screen.dart's submitPin), gating MyApp's own routing (app.dart)
// to show ShiftWelcomeScreen once before the normal home screen. Reset
// to false by that screen's own "Get started" button. Deliberately NOT
// set by senior/exec email+password login or by _restoreBackendSession's
// session restore on app relaunch — this is a walk-up shift-start
// moment, not something that should re-appear just because the app was
// reopened mid-shift.
final justLoggedInForShiftProvider = StateProvider<bool>((ref) => false);

// Phase 2 (real backend auth) — the single switch that turns on
// server-side PIN verification. Off by default: the app behaves exactly
// as it always has until this is flipped, and even once on, any staff
// member not yet synced to the backend (no supabaseUserId) still falls
// back to the local check automatically (see UserRepository.authenticate).
//
// A real StateProvider, not a constant (2026-09-22, Sprint 046) —
// implements Phase C1's own decision #5 ("real installs = both backend
// flags forced ON, no runtime toggle"), which had been approved but
// never actually wired to anything: this and backendDataEnabledProvider
// were both hardcoded `false` literals, meaning even the tenant-signup
// wizard's own brand-new backend account would have landed on an empty
// local Drift install with no way to see its own real data. The wizard
// flips both to true right after a successful sign-up + sign-in — the
// one place a running session actually KNOWS it just became a real
// backend tenant, not a demo. Every other entry point (the local demo
// flavour, PIN walk-up) is completely unaffected — both still start
// false exactly as before, since nothing else in the app sets them.
final backendAuthEnabledProvider = StateProvider<bool>((ref) => false);

// Holds the real Supabase session token once a tap-name+PIN login has been
// verified server-side. Null when signed out, or when the current session
// came from the local-only fallback path (no backend session exists then).
// Deliberately NOT persisted across app restarts — matches currentUserProvider
// and the shared-kitchen-tablet expectation that every session starts fresh.
final currentSessionTokenProvider = StateProvider<String?>((ref) => null);

// Phase B2 — the single switch that turns on backend-hosted Foundation-
// cluster data (Organisations/Regions/Sites/VenueTypes/Departments/Areas/
// EquipmentTypes). Off by default: every one of those repositories behaves
// exactly as it always has, 100% local, until this is flipped — mirrors
// backendAuthEnabledProvider's "safe add-on" shape above. Only produces
// anything once backendAuthEnabledProvider is ALSO on for that session —
// RLS needs a real JWT with org/site/region claims to let anything through;
// with only this flag on, every backend-scoped call comes back empty (the
// same fail-closed behaviour Phase B1 proved for a missing/anon token).
final backendDataEnabledProvider = StateProvider<bool>((ref) => false);

// The one access token every Supabase-backed Phase B2 repository actually
// sends — unifies PIN sessions (their own HS256 token, minted by
// `pin-login` and held in currentSessionTokenProvider; supabase_flutter's
// own auth state never sees it) and Leadership sessions (real GoTrue
// email+password, whose token lives in Supabase.instance.client.auth as
// usual). Read fresh at request time by BackendRestClient, never cached.
final currentBackendAccessTokenProvider = Provider<String?>((ref) {
  final pinToken = ref.watch(currentSessionTokenProvider);
  if (pinToken != null) return pinToken;
  return supabase.auth.currentSession?.accessToken;
});

// Decodes organisation_id straight out of the current session's own
// app_metadata claim — the same value RLS itself reads, so a
// Supabase*Repository create() call can never disagree with what the
// server would enforce anyway. Not a JWT signature check (the app has no
// reason to verify its own already-trusted token) — just reading the
// claim back out.
int? _decodeOrganisationIdFromToken(String? token) {
  if (token == null) return null;
  final parts = token.split('.');
  if (parts.length != 3) return null;
  try {
    final payload =
        jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))))
            as Map<String, dynamic>;
    final appMetadata = payload['app_metadata'] as Map<String, dynamic>?;
    return appMetadata?['organisation_id'] as int?;
  } catch (_) {
    return null;
  }
}

final currentBackendOrganisationIdProvider = Provider<int?>((ref) {
  final token = ref.watch(currentBackendAccessTokenProvider);
  return _decodeOrganisationIdFromToken(token);
});
