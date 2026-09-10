import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/session_summary_repository.dart';
import '../repositories/shift_handover_repository.dart';
import '../repositories/supabase_session_summary_repository.dart';
import '../repositories/supabase_shift_handover_repository.dart';
import 'auth_providers.dart' show backendDataEnabledProvider;
import 'backend_providers.dart' show backendRestClientProvider;
import 'task_submission_providers.dart' show appDatabaseProvider;

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
