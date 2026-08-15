import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/task_schedule.dart';
import '../../shared/models/task_submission.dart';
import '../../shared/providers/task_schedule_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../../shared/repositories/task_schedule_repository.dart';
import '../../shared/repositories/task_submission_repository.dart';

// Worker recognition (Sprint 031, dashboard + worker recognition,
// Sub-sprint A). THE CRITICAL RULE, agreed before any code was written: this
// service must reward completion, honesty, and on-time logging — never pass
// rates. A worker who correctly logs a FAILURE has done their job and must
// score exactly the same as one who logs a PASS.
//
// That guarantee isn't a rule the caller has to remember — it's structural.
// TaskSubmission.status is read here only to exclude NOT_COMPLETED (an
// abandoned task that didn't happen) from PASS/FAIL (a task that did). PASS
// and FAIL are never distinguished from each other anywhere below. Do not
// add a branch that reads a submission's status as PASS vs FAIL — that
// would reintroduce exactly the gaming incentive this service exists to
// avoid.
class ReliabilitySummary {
  const ReliabilitySummary({
    required this.totalPeriods,
    required this.completedPeriods,
    required this.onTimePeriods,
  });

  final int totalPeriods;
  final int completedPeriods;
  final int onTimePeriods;

  // Null (not 0%/100%) when there's nothing to judge yet — a brand new
  // schedule shouldn't read as a failing or a perfect record.
  double? get completionRate =>
      totalPeriods == 0 ? null : completedPeriods / totalPeriods;

  double? get onTimeRate =>
      totalPeriods == 0 ? null : onTimePeriods / totalPeriods;
}

class ReliabilityService {
  ReliabilityService(this._scheduleRepository, this._submissionRepository);

  final TaskScheduleRepository _scheduleRepository;
  final TaskSubmissionRepository _submissionRepository;

  // Only clock-based frequencies (daily/2x/3x-daily/weekly/monthly) have a
  // computable period to judge — same restriction DueStatusService already
  // applies, for the same reason: perShift/perService/etc. are shift- or
  // event-relative concepts this app doesn't model yet. A disclosed gap,
  // not a silent miscomputation.
  Future<ReliabilitySummary> computeForUser(
    int userId, {
    DateTime? now,
    Duration lookback = const Duration(days: 30),
  }) async {
    final reference = now ?? DateTime.now();
    final rangeStart = reference.subtract(lookback);

    final schedules = (await _scheduleRepository.getForStaffMember(userId))
        .where((s) => isClockBasedFrequency(s.frequency))
        .toList();
    if (schedules.isEmpty) {
      return const ReliabilitySummary(
        totalPeriods: 0,
        completedPeriods: 0,
        onTimePeriods: 0,
      );
    }

    // One query for the whole lookback window, grouped in Dart per schedule
    // below — cheaper than one countForScheduleInRange call per period per
    // schedule, and gives access to completedAt for the on-time-within-
    // window check that a bare count can't answer.
    final submissions = await _submissionRepository.getForUserSince(
      userId,
      rangeStart,
    );
    final byScheduleId = <int, List<TaskSubmission>>{};
    for (final submission in submissions) {
      // PASS/FAIL both count as "a check happened" — NOT_COMPLETED doesn't.
      // This is the only status check in this file; see the class doc.
      if (submission.status != 'PASS' && submission.status != 'FAIL') {
        continue;
      }
      final scheduleId = submission.taskScheduleId;
      if (scheduleId == null) continue;
      byScheduleId.putIfAbsent(scheduleId, () => []).add(submission);
    }

    var totalPeriods = 0;
    var completedPeriods = 0;
    var onTimePeriods = 0;

    for (final schedule in schedules) {
      final required = requiredSubmissionsPerPeriod(schedule.frequency);
      final scheduleSubmissions = byScheduleId[schedule.id] ?? const [];
      final hasWindow =
          schedule.windowStartMinutes != null &&
          schedule.windowEndMinutesExclusive != null;

      var cursor = periodStart(schedule.frequency, rangeStart);
      final scheduleStart = periodStart(schedule.frequency, schedule.assignedAt);
      if (cursor.isBefore(scheduleStart)) cursor = scheduleStart;

      while (cursor.isBefore(reference)) {
        final periodClose = periodEnd(schedule.frequency, cursor);
        // Only judge closed periods — an in-progress period hasn't failed
        // yet, matching DueStatusService's own current-period exclusion.
        if (periodClose.isAfter(reference)) break;

        totalPeriods++;
        final inPeriod = scheduleSubmissions
            .where(
              (s) =>
                  !s.completedAt.isBefore(cursor) &&
                  s.completedAt.isBefore(periodClose),
            )
            .toList();

        if (inPeriod.length >= required) {
          completedPeriods++;
          if (!hasWindow) {
            // No window set on this schedule (the common case) — on-time
            // collapses to "completed within its period," reusing
            // DueStatusService's own overdue semantics rather than
            // inventing a finer-grained notion this app can't back with
            // real per-instance due times.
            onTimePeriods++;
          } else {
            final withinWindow = inPeriod.any((s) {
              final minutes = s.completedAt.hour * 60 + s.completedAt.minute;
              return minutes >= schedule.windowStartMinutes! &&
                  minutes < schedule.windowEndMinutesExclusive!;
            });
            if (withinWindow) onTimePeriods++;
          }
        }

        cursor = periodClose;
      }
    }

    return ReliabilitySummary(
      totalPeriods: totalPeriods,
      completedPeriods: completedPeriods,
      onTimePeriods: onTimePeriods,
    );
  }
}

final reliabilityServiceProvider = Provider<ReliabilityService>((ref) {
  return ReliabilityService(
    ref.watch(taskScheduleRepositoryProvider),
    ref.watch(taskSubmissionRepositoryProvider),
  );
});
