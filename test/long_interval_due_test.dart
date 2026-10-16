// Long-interval tasks (2026-10-16): a 3/6/12-monthly task must stay off
// the list until its interval has passed since the last completion.
import 'package:flutter_test/flutter_test.dart';
import 'package:venurite/features/tasks/due_status_service.dart';
import 'package:venurite/shared/models/task_schedule.dart';
import 'package:venurite/shared/repositories/task_submission_repository.dart';

class _FakeSubmissions implements TaskSubmissionRepository {
  _FakeSubmissions(this.completions);

  final List<DateTime> completions;

  @override
  Future<int> countForScheduleInRange({
    required int taskScheduleId,
    required DateTime start,
    required DateTime end,
  }) async =>
      completions.where((c) => !c.isBefore(start) && c.isBefore(end)).length;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

TaskSchedule _schedule(ScheduleFrequency f, DateTime assignedAt) =>
    TaskSchedule(
      id: 1,
      taskTemplateGroupId: 1,
      assignedUserId: 1,
      frequency: f,
      assignedByUserId: 1,
      assignedAt: assignedAt,
      active: true,
      siteId: 1,
    );

void main() {
  final now = DateTime(2026, 10, 16, 9);

  Future<ScheduleDueState> state(
    ScheduleFrequency f,
    List<DateTime> done, {
    DateTime? assignedAt,
  }) async => (await DueStatusService(_FakeSubmissions(done)).computeStatus(
    _schedule(f, assignedAt ?? DateTime(2025, 1, 1)),
    now: now,
  )).state;

  test('3-monthly task done 2 months ago is hidden', () async {
    expect(
      await state(ScheduleFrequency.quarterly, [DateTime(2026, 8, 16)]),
      ScheduleDueState.satisfied,
    );
  });

  test('3-monthly task done just over 3 months ago is due, not overdue', () async {
    expect(
      await state(ScheduleFrequency.quarterly, [DateTime(2026, 7, 10)]),
      ScheduleDueState.due,
    );
  });

  test('overdue once 14 days past due', () async {
    expect(
      await state(ScheduleFrequency.quarterly, [DateTime(2026, 6, 20)]),
      ScheduleDueState.overdue,
    );
  });

  test('yearly task done 11 months ago is hidden', () async {
    expect(
      await state(ScheduleFrequency.annually, [DateTime(2025, 11, 20)]),
      ScheduleDueState.satisfied,
    );
  });

  test('never-done task is due straight away after assignment', () async {
    expect(
      await state(
        ScheduleFrequency.sixMonthly,
        const [],
        assignedAt: DateTime(2026, 10, 14),
      ),
      ScheduleDueState.due,
    );
  });

  test('month subtraction clamps to month end', () {
    expect(subtractMonths(DateTime(2026, 5, 31), 3), DateTime(2026, 2, 28));
  });
}
