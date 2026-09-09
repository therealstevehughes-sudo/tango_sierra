import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/network/supabase_client.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftUserRepository(db);
});

final staffDirectoryProvider = FutureProvider<List<User>>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  final staff = await repository.getAll();
  return staff.where((u) => u.active).toList();
});

final currentUserProvider = StateProvider<User?>((ref) => null);

// Phase 2 (real backend auth) — the single switch that turns on
// server-side PIN verification. Off by default: the app behaves exactly
// as it always has until this is flipped, and even once on, any staff
// member not yet synced to the backend (no supabaseUserId) still falls
// back to the local check automatically (see UserRepository.authenticate).
final backendAuthEnabledProvider = Provider<bool>((ref) => false);

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
final backendDataEnabledProvider = Provider<bool>((ref) => false);

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
