import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/issue.dart';
import '../../shared/models/task_schedule.dart';
import '../../shared/models/task_submission.dart';
import '../../shared/models/task_template.dart';
import '../../shared/providers/issue_providers.dart';
import '../../shared/providers/problem_register_providers.dart';
import '../../shared/providers/task_schedule_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../shared/providers/venue_setup_providers.dart'
    show equipmentRepositoryProvider;
import '../../shared/repositories/equipment_repository.dart';
import '../../shared/repositories/issue_repository.dart';
import '../../shared/repositories/problem_register_repository.dart';
import '../../shared/repositories/task_schedule_repository.dart';
import '../../shared/repositories/task_submission_repository.dart';
import '../../shared/repositories/task_template_repository.dart';
import 'due_status_service.dart';

// Shift Handover Intelligence (Sprint 039, 2026-09-17) — auto-generates a
// summary to augment the existing manual ShiftHandoverNotes surface (see
// task_screen.dart), not replace it. Pure read/aggregation over data that
// already exists and is already RLS-proven; no new table/column.
//
// Anti-gaming: confirmed with the user before building — every list here
// is site-level operational fact (an open issue, a flagged piece of
// equipment, a task not yet done today), never attributed to which staff
// member raised/logged/is-assigned-to it. This is deliberately narrower
// than OverdueSummaryService (the Manager screen's own overdue tracker,
// which DOES name a staff member — that's an existing, separate,
// manager-facing surface). A shift-handover note is read by whoever's
// coming on next, not used to judge whoever just left, so no name belongs
// here.
class OutstandingTaskEntry {
  const OutstandingTaskEntry({
    required this.taskTitle,
    this.equipmentInstanceName,
  });

  final String taskTitle;
  final String? equipmentInstanceName;
}

class ShiftHandoverSummary {
  const ShiftHandoverSummary({
    required this.openIssues,
    required this.flaggedEquipment,
    required this.outstandingTasks,
  });

  /// Unresolved (open or escalated) Issues at the site — the freeform
  /// Issues & Incidents log, not linked to any specific task submission.
  final List<Issue> openIssues;

  /// Problems Register entries still open (`problemStatus == 'open'`)
  /// that are tied to a specific piece of equipment — "flagged equipment"
  /// means equipment with an outstanding, unresolved fail against it, not
  /// a separate equipment-status field (none exists).
  final List<TaskSubmission> flaggedEquipment;

  /// Today's scheduled tasks with no submission yet — named accurately as
  /// "not yet done today" rather than "pending prep" (this app has no
  /// prep-list concept to honestly back that label). Scoped to daily/2x/
  /// 3x-daily frequencies only — the only ones whose period IS "today";
  /// weekly/monthly schedules aren't meaningfully "today's" tasks.
  final List<OutstandingTaskEntry> outstandingTasks;

  bool get isEmpty =>
      openIssues.isEmpty &&
      flaggedEquipment.isEmpty &&
      outstandingTasks.isEmpty;
}

class ShiftHandoverSummaryService {
  ShiftHandoverSummaryService(
    this._issueRepository,
    this._problemRegisterRepository,
    this._scheduleRepository,
    this._templateRepository,
    this._equipmentRepository,
    TaskSubmissionRepository submissionRepository, [
    DueStatusService? dueStatusService,
  ]) : _dueStatusService =
           dueStatusService ?? DueStatusService(submissionRepository);

  final IssueRepository _issueRepository;
  final ProblemRegisterRepository _problemRegisterRepository;
  final TaskScheduleRepository _scheduleRepository;
  final TaskTemplateRepository _templateRepository;
  final EquipmentRepository _equipmentRepository;
  final DueStatusService _dueStatusService;

  static const _todaysFrequencies = {
    ScheduleFrequency.daily,
    ScheduleFrequency.twoXDaily,
    ScheduleFrequency.threeXDaily,
  };

  Future<ShiftHandoverSummary> computeSummary(int siteId) async {
    final issues = await _issueRepository.getForSite(siteId);
    final openIssues = issues
        .where((i) => i.status != IssueStatus.resolved)
        .toList();

    final submissions = await _problemRegisterRepository
        .watchForSite(siteId)
        .first;
    final flaggedEquipment = submissions
        .where(
          (s) => s.problemStatus == 'open' && s.equipmentInstanceId != null,
        )
        .toList();

    final schedules = (await _scheduleRepository.getForSite(
      siteId,
    )).where((s) => s.active && _todaysFrequencies.contains(s.frequency));
    final templates = await _templateRepository.getAllCurrentVersions();
    final equipmentInstances = await _equipmentRepository.getForSite(siteId);

    final outstandingTasks = <OutstandingTaskEntry>[];
    for (final schedule in schedules) {
      final result = await _dueStatusService.computeStatus(schedule);
      if (result.state == ScheduleDueState.satisfied) continue;

      TaskTemplate? template;
      for (final candidate in templates) {
        if (candidate.templateGroupId == schedule.taskTemplateGroupId) {
          template = candidate;
          break;
        }
      }
      if (template == null) continue;

      String? equipmentInstanceName;
      if (schedule.equipmentInstanceId != null) {
        for (final instance in equipmentInstances) {
          if (instance.id == schedule.equipmentInstanceId) {
            equipmentInstanceName = instance.name;
            break;
          }
        }
      }

      outstandingTasks.add(
        OutstandingTaskEntry(
          taskTitle: template.title,
          equipmentInstanceName: equipmentInstanceName,
        ),
      );
    }

    return ShiftHandoverSummary(
      openIssues: openIssues,
      flaggedEquipment: flaggedEquipment,
      outstandingTasks: outstandingTasks,
    );
  }
}

final shiftHandoverSummaryServiceProvider =
    Provider<ShiftHandoverSummaryService>((ref) {
      return ShiftHandoverSummaryService(
        ref.watch(issueRepositoryProvider),
        ref.watch(problemRegisterRepositoryProvider),
        ref.watch(taskScheduleRepositoryProvider),
        ref.watch(taskTemplateRepositoryProvider),
        ref.watch(equipmentRepositoryProvider),
        ref.watch(taskSubmissionRepositoryProvider),
      );
    });
