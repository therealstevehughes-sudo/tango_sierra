import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/session_summary_repository.dart';
import '../repositories/shift_handover_repository.dart';
import '../repositories/shift_log_repository.dart';
import '../repositories/supabase_session_summary_repository.dart';
import '../repositories/supabase_shift_handover_repository.dart';
import 'auth_providers.dart' show backendDataEnabledProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

// Shift log (2026-09-24) — local-only for this first pass, unlike its
// siblings below (no backend table/Edge Function built yet — a disclosed
// follow-up, same pattern as the randomised photo-check and departments
// content this session). Always Drift, regardless of backendDataEnabled
// Provider, since there is nowhere else for it to go yet.
final shiftLogRepositoryProvider = Provider<ShiftLogRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftShiftLogRepository(db);
});

final shiftHandoverRepositoryProvider = Provider<ShiftHandoverRepository>((
  ref,
) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseShiftHandoverRepository(ref.watch(backendRestClientProvider));
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftShiftHandoverRepository(db);
});

final sessionSummaryRepositoryProvider = Provider<SessionSummaryRepository>((
  ref,
) {
  if (ref.watch(backendDataEnabledProvider)) {
    return SupabaseSessionSummaryRepository(
      ref.watch(backendRestClientProvider),
    );
  }
  final db = ref.watch(appDatabaseProvider);
  return DriftSessionSummaryRepository(db);
});
