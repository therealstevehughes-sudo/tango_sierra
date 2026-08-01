import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/session_summary_repository.dart';
import '../repositories/shift_handover_repository.dart';
import 'task_submission_providers.dart' show appDatabaseProvider;

final shiftHandoverRepositoryProvider = Provider<ShiftHandoverRepository>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return DriftShiftHandoverRepository(db);
});

final sessionSummaryRepositoryProvider = Provider<SessionSummaryRepository>((
  ref,
) {
  final db = ref.watch(appDatabaseProvider);
  return DriftSessionSummaryRepository(db);
});
