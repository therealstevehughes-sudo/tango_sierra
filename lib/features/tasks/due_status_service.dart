import '../../shared/models/task_schedule.dart';
import '../../shared/repositories/task_submission_repository.dart';

// Due/overdue tracking (Sprint 031, Build Order item 5, Sub-sprint A).
// Shared between the worker's own carousel (TaskController) and, later,
// manager-facing overdue notifications (Sub-sprint D) — both need the same
// "is this schedule satisfied / due / overdue right now" answer.
enum ScheduleDueState { satisfied, due, overdue }

typedef DueStatusResult = ({ScheduleDueState state, DateTime? overdueSince});

class DueStatusService {
  DueStatusService(this._submissionRepository);

  final TaskSubmissionRepository _submissionRepository;

  // HONEST LIMIT: this is computed against DateTime.now() (device clock),
  // fakeable until a backend provides trusted server time — same
  // limitation already logged for completedAt/time-windows, not newly
  // introduced here.
  //
  // Only checks the single immediately-preceding period, not the schedule's
  // full history — collapses to one overdue flag per schedule rather than
  // enumerating every missed period (agreed: avoids the same "unusable
  // wall" shape of problem just fixed in the manager log). Once any
  // submission satisfies a period, the schedule stops being overdue on the
  // next check; earlier misses remain in the audit log via their absence
  // of submissions, they just don't keep blocking the active flag.
  Future<DueStatusResult> computeStatus(
    TaskSchedule schedule, {
    DateTime? now,
  }) async {
    if (!isClockBasedFrequency(schedule.frequency)) {
      // perShift/perBatch/eventBased/etc. — no computable due-time without
      // a shift/service-period system this app doesn't have yet. Always
      // shown, same as before this feature existed — a disclosed gap, not
      // a silent miscomputation.
      return (state: ScheduleDueState.due, overdueSince: null);
    }

    final reference = now ?? DateTime.now();
    final required = requiredSubmissionsPerPeriod(schedule.frequency);

    final currentStart = periodStart(schedule.frequency, reference);
    final currentEnd = periodEnd(schedule.frequency, currentStart);
    final currentCount = await _submissionRepository.countForScheduleInRange(
      taskScheduleId: schedule.id,
      start: currentStart,
      end: currentEnd,
    );
    if (currentCount >= required) {
      return (state: ScheduleDueState.satisfied, overdueSince: null);
    }

    final previousStart = periodStart(
      schedule.frequency,
      currentStart.subtract(const Duration(milliseconds: 1)),
    );
    // A freshly-assigned schedule can't be overdue for a period before it
    // existed.
    if (schedule.assignedAt.isAfter(previousStart)) {
      return (state: ScheduleDueState.due, overdueSince: null);
    }

    final previousCount = await _submissionRepository.countForScheduleInRange(
      taskScheduleId: schedule.id,
      start: previousStart,
      end: currentStart,
    );
    if (previousCount < required) {
      return (state: ScheduleDueState.overdue, overdueSince: previousStart);
    }

    return (state: ScheduleDueState.due, overdueSince: null);
  }
}
