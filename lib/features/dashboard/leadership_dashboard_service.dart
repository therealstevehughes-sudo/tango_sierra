import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/issue.dart';
import '../../shared/models/task_schedule.dart';
import '../../shared/models/task_submission.dart';
import '../../shared/providers/issue_providers.dart';
import '../../shared/providers/task_schedule_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../../shared/providers/venue_setup_providers.dart'
    show equipmentRepositoryProvider;
import '../../shared/repositories/equipment_repository.dart';
import '../../shared/repositories/issue_repository.dart';
import '../../shared/repositories/task_schedule_repository.dart';
import '../../shared/repositories/task_submission_repository.dart';

// Leadership dashboard overview (2026-09-15) — from the user's own
// `Visual idea.pdf` mockup. Built ONLY at aggregate (branch/section)
// level, per the governing anti-gaming rule (see app_database.dart's
// `Issues` table doc comment and DECISIONS_LOG.md's "DEFERRED SPRINT:
// Leadership dashboard overview" entry): a colour-graded breakdown of
// this exact shape must never be computed for one named individual —
// that's why `LeadershipDashboardScreen`'s Employee filter switches to a
// plain list instead of reusing these classes. Never add a per-user
// variant of TaskOverviewBreakdown/IncidentsBreakdown without going back
// to that guideline first.
//
// "Urgent" from the mockup's Incidents legend is deliberately NOT
// modelled here — IssueStatus only has open/resolved/escalated, and
// there's no existing concept an "Urgent" bucket could honestly draw
// from without inventing one. Logged as an open question in
// DECISIONS_LOG.md, not silently mapped onto something that doesn't
// mean what "Urgent" implies.
class TaskOverviewBreakdown {
  const TaskOverviewBreakdown({
    required this.onTimeNoIssues,
    required this.onTimeIssuesLogged,
    required this.offWindowNoIssues,
    required this.offWindowIssuesLogged,
    required this.notDone,
  });

  final int onTimeNoIssues;
  final int onTimeIssuesLogged;
  final int offWindowNoIssues;
  final int offWindowIssuesLogged;
  final int notDone;

  int get total =>
      onTimeNoIssues +
      onTimeIssuesLogged +
      offWindowNoIssues +
      offWindowIssuesLogged +
      notDone;

  double _rate(int n) => total == 0 ? 0 : n / total;
  double get onTimeNoIssuesRate => _rate(onTimeNoIssues);
  double get onTimeIssuesLoggedRate => _rate(onTimeIssuesLogged);
  double get offWindowNoIssuesRate => _rate(offWindowNoIssues);
  double get offWindowIssuesLoggedRate => _rate(offWindowIssuesLogged);
  double get notDoneRate => _rate(notDone);
}

class IncidentsBreakdown {
  const IncidentsBreakdown({
    required this.resolved,
    required this.unresolved,
    required this.escalated,
  });

  final int resolved;
  final int unresolved;
  final int escalated;

  int get total => resolved + unresolved + escalated;

  double _rate(int n) => total == 0 ? 0 : n / total;
  double get resolvedRate => _rate(resolved);
  double get unresolvedRate => _rate(unresolved);
  double get escalatedRate => _rate(escalated);
}

class LeadershipDashboardService {
  LeadershipDashboardService(
    this._submissionRepository,
    this._scheduleRepository,
    this._equipmentRepository,
    this._issueRepository,
  );

  final TaskSubmissionRepository _submissionRepository;
  final TaskScheduleRepository _scheduleRepository;
  final EquipmentRepository _equipmentRepository;
  final IssueRepository _issueRepository;

  // A submission "has an issue logged" if it failed outright, or (for a
  // delivery-related submission) a problem was flagged on it — reusing
  // the detailed delivery-by-supplier fields rather than a separate
  // lookup, since those already ARE the "issue" for that submission.
  // Deliberately does NOT reach into the freestanding Issues table: a
  // raised Issue isn't linked to a specific TaskSubmission id at all (see
  // Issues' own doc comment on why that separation is deliberate), so
  // there is nothing there to join against per-submission.
  bool _hasIssue(TaskSubmission s) {
    if (s.status == 'FAIL') return true;
    if (s.deliveryOutcome != null && s.deliveryOutcome != 'accepted') {
      return true;
    }
    return s.deliveryShortDelivery ||
        s.deliveryDamagedStock ||
        s.deliveryLateDelivery ||
        s.deliveryQualityProblem;
  }

  // "On time" reuses ReliabilitySummary's own convention: a schedule with
  // no window can't be judged finer than "it happened," so it counts as
  // on-time by default rather than inventing a distinction this app
  // can't back with real per-instance due times.
  bool _isOnTime(TaskSubmission s, Map<int, TaskSchedule> schedulesById) {
    final schedule = s.taskScheduleId == null
        ? null
        : schedulesById[s.taskScheduleId];
    if (schedule == null ||
        schedule.windowStartMinutes == null ||
        schedule.windowEndMinutesExclusive == null) {
      return true;
    }
    final minutes = s.completedAt.hour * 60 + s.completedAt.minute;
    return minutes >= schedule.windowStartMinutes! &&
        minutes < schedule.windowEndMinutesExclusive!;
  }

  Future<TaskOverviewBreakdown> computeTaskOverview({
    required int siteId,
    required DateTime start,
    required DateTime end,
    int? areaId,
  }) async {
    var submissions = await _submissionRepository.getForSiteAndDateRange(
      siteId: siteId,
      start: start,
      end: end,
    );

    if (areaId != null) {
      // Section filter: only reachable for submissions tied to a piece of
      // equipment in that area — a real gap for non-equipment tasks
      // (e.g. a plain cleaning checklist item), logged not hidden. Such
      // submissions are excluded rather than guessed into a section.
      final equipment = await _equipmentRepository.getForSite(siteId);
      final areaByEquipmentId = {
        for (final e in equipment) e.id: e.areaId,
      };
      submissions = submissions
          .where(
            (s) =>
                s.equipmentInstanceId != null &&
                areaByEquipmentId[s.equipmentInstanceId] == areaId,
          )
          .toList();
    }

    final schedules = await _scheduleRepository.getForSite(siteId);
    final schedulesById = {for (final sch in schedules) sch.id: sch};

    var onTimeNoIssues = 0;
    var onTimeIssuesLogged = 0;
    var offWindowNoIssues = 0;
    var offWindowIssuesLogged = 0;
    var notDone = 0;

    for (final s in submissions) {
      if (s.status == 'NOT_COMPLETED') {
        notDone++;
        continue;
      }
      if (s.status != 'PASS' && s.status != 'FAIL') continue;
      final onTime = _isOnTime(s, schedulesById);
      final hasIssue = _hasIssue(s);
      if (onTime && !hasIssue) {
        onTimeNoIssues++;
      } else if (onTime && hasIssue) {
        onTimeIssuesLogged++;
      } else if (!onTime && !hasIssue) {
        offWindowNoIssues++;
      } else {
        offWindowIssuesLogged++;
      }
    }

    return TaskOverviewBreakdown(
      onTimeNoIssues: onTimeNoIssues,
      onTimeIssuesLogged: onTimeIssuesLogged,
      offWindowNoIssues: offWindowNoIssues,
      offWindowIssuesLogged: offWindowIssuesLogged,
      notDone: notDone,
    );
  }

  Future<IncidentsBreakdown> computeIncidents({
    required int siteId,
    required DateTime start,
    required DateTime end,
  }) async {
    final issues = await _issueRepository.getForSite(siteId);
    final inRange = issues.where(
      (i) => !i.raisedAt.isBefore(start) && i.raisedAt.isBefore(end),
    );

    var resolved = 0;
    var unresolved = 0;
    var escalated = 0;
    for (final i in inRange) {
      switch (i.status) {
        case IssueStatus.resolved:
          resolved++;
        case IssueStatus.open:
          unresolved++;
        case IssueStatus.escalated:
          escalated++;
      }
    }

    return IncidentsBreakdown(
      resolved: resolved,
      unresolved: unresolved,
      escalated: escalated,
    );
  }
}

final leadershipDashboardServiceProvider =
    Provider<LeadershipDashboardService>((ref) {
      return LeadershipDashboardService(
        ref.watch(taskSubmissionRepositoryProvider),
        ref.watch(taskScheduleRepositoryProvider),
        ref.watch(equipmentRepositoryProvider),
        ref.watch(issueRepositoryProvider),
      );
    });
