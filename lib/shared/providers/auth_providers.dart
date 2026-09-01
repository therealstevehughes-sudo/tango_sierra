import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

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
