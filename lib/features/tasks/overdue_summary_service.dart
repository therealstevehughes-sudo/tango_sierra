import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/task_template.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/task_schedule_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../shared/providers/venue_setup_providers.dart'
    show equipmentRepositoryProvider;
import '../../shared/repositories/equipment_repository.dart';
import '../../shared/repositories/task_schedule_repository.dart';
import '../../shared/repositories/task_submission_repository.dart';
import '../../shared/repositories/task_template_repository.dart';
import '../../shared/repositories/user_repository.dart';
import 'due_status_service.dart';

// Manager-facing overdue tracking (Sprint 031, Build Order item 5,
// Sub-sprint D). One entry per overdue schedule — deliberately a live
// query result, not a stored/persisted record. Overdue is a continuously
// recomputed fact (DueStatusService), not a discrete event like a FAIL,
// so there's nothing here that needs acknowledging or could go stale.
class OverdueSummaryEntry {
  const OverdueSummaryEntry({
    required this.staffName,
    required this.taskTitle,
    this.overdueSince,
    this.equipmentInstanceName,
  });

  final String staffName;
  final String taskTitle;
  final DateTime? overdueSince;
  // Instance-name prominence (2026-09-06) — this list previously showed
  // only the plain template title, so two overdue fridges were
  // indistinguishable here (a real gap found while fixing the other four
  // surfaces, not one of the originally-reported five, but the same
  // underlying problem in the same EHO export document).
  final String? equipmentInstanceName;
}

class OverdueSummaryService {
  OverdueSummaryService(
    this._scheduleRepository,
    this._userRepository,
    this._templateRepository,
    this._equipmentRepository,
    TaskSubmissionRepository submissionRepository, [
    DueStatusService? dueStatusService,
  ]) : _dueStatusService =
           dueStatusService ?? DueStatusService(submissionRepository);

  final TaskScheduleRepository _scheduleRepository;
  final UserRepository _userRepository;
  final TaskTemplateRepository _templateRepository;
  final EquipmentRepository _equipmentRepository;
  final DueStatusService _dueStatusService;

  // Site-scoped using TaskSchedule's own real siteId column — every
  // assignment already sets it (staff_assignment_screen.dart) and
  // beforeOpen backfills any pre-existing row, so this is properly
  // scoped, not inheriting the older "reads not filtered by site" gap
  // logged elsewhere in this app.
  //
  // Excludes non-clock frequencies and not-yet-open windowed tasks with
  // no new logic — DueStatusService.computeStatus already only ever
  // marks a *closed* period overdue, and a window can only be missed
  // once its period has closed (confirmed in Sub-sprint C), so both
  // cases are already correctly excluded by the existing per-schedule
  // check reused here.
  Future<List<OverdueSummaryEntry>> getSummaryForSite(int siteId) async {
    final allSchedules = await _scheduleRepository.getAll();
    final schedules = allSchedules.where((s) => s.active && s.siteId == siteId);
    final users = await _userRepository.getForSite(siteId);
    final templates = await _templateRepository.getAllCurrentVersions();
    final equipmentInstances = await _equipmentRepository.getForSite(siteId);

    final entries = <OverdueSummaryEntry>[];
    for (final schedule in schedules) {
      final result = await _dueStatusService.computeStatus(schedule);
      if (result.state != ScheduleDueState.overdue) continue;

      String? staffName;
      for (final user in users) {
        if (user.id == schedule.assignedUserId) {
          staffName = user.name;
          break;
        }
      }
      if (staffName == null) continue;

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

      entries.add(
        OverdueSummaryEntry(
          staffName: staffName,
          taskTitle: template.title,
          overdueSince: result.overdueSince,
          equipmentInstanceName: equipmentInstanceName,
        ),
      );
    }
    return entries;
  }
}

final overdueSummaryServiceProvider = Provider<OverdueSummaryService>((ref) {
  return OverdueSummaryService(
    ref.watch(taskScheduleRepositoryProvider),
    ref.watch(userRepositoryProvider),
    ref.watch(taskTemplateRepositoryProvider),
    ref.watch(equipmentRepositoryProvider),
    ref.watch(taskSubmissionRepositoryProvider),
  );
});
