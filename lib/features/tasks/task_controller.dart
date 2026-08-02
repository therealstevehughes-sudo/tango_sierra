import 'dart:convert';

import '../../shared/models/task_submission.dart';
import '../../shared/models/task_template.dart';
import '../../shared/models/user.dart';
import '../../shared/repositories/equipment_repository.dart';
import '../../shared/repositories/task_schedule_repository.dart';
import '../../shared/repositories/task_submission_repository.dart';
import '../../shared/repositories/task_template_repository.dart';
import 'task_model.dart';

class TaskController {
  TaskController(
    this._submissionRepository,
    this._scheduleRepository,
    this._templateRepository,
    this._equipmentRepository,
    this._currentUser,
  );

  final TaskSubmissionRepository _submissionRepository;
  final TaskScheduleRepository _scheduleRepository;
  final TaskTemplateRepository _templateRepository;
  final EquipmentRepository _equipmentRepository;
  final User _currentUser;

  int currentIndex = 0;
  List<ResolvedTask> tasks = [];
  final DateTime sessionStartedAt = DateTime.now();

  bool get hasTasks => tasks.isNotEmpty;

  Future<void> loadTasks() async {
    final schedules = await _scheduleRepository.getForStaffMember(
      _currentUser.id,
    );
    final templates = await _templateRepository.getAllCurrentVersions();
    final equipmentInstances = await _equipmentRepository.getAll();

    final resolved = <ResolvedTask>[];

    for (final schedule in schedules) {
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

      resolved.add(
        ResolvedTask(
          scheduleId: schedule.id,
          templateGroupId: template.templateGroupId,
          title: template.title,
          segment: template.segment,
          method: template.method,
          requiresPhoto: template.requiresPhoto,
          requiresNotes: template.requiresNotes,
          minLimit: template.minLimit,
          maxLimit: template.maxLimit,
          unit: template.unit,
          isCritical: template.isCritical,
          requiresCorrectiveActionOnFail: template.requiresCorrectiveActionOnFail,
          fixInstructions: template.fixInstructions,
          choiceOptions: _parseChoiceOptions(template.customFieldsJson),
          equipmentInstanceId: schedule.equipmentInstanceId,
          equipmentInstanceName: equipmentInstanceName,
        ),
      );
    }

    tasks = resolved;
    currentIndex = 0;
  }

  List<String>? _parseChoiceOptions(String? customFieldsJson) {
    if (customFieldsJson == null) return null;
    try {
      final decoded = jsonDecode(customFieldsJson);
      if (decoded is Map && decoded['options'] is List) {
        return List<String>.from(decoded['options'] as List);
      }
    } catch (_) {
      // Malformed custom-field JSON (e.g. free-typed during Sprint 009's
      // custom task form) — treat as "no choice options" rather than crash.
    }
    return null;
  }

  ResolvedTask getCurrentTask() => tasks[currentIndex];

  Future<SessionStats> buildSessionStats() async {
    final submissions = await _submissionRepository.getForUserSince(
      _currentUser.id,
      sessionStartedAt,
    );

    final passCount = submissions.where((s) => s.status == 'PASS').length;
    final failed = submissions.where((s) => s.status == 'FAIL').toList();

    return SessionStats(
      passCount: passCount,
      failCount: failed.length,
      failedTaskTitles: failed.map((s) => s.taskTitle).toList(),
    );
  }

  bool nextTask() {
    if (currentIndex < tasks.length - 1) {
      currentIndex++;
      return true;
    }
    return false;
  }

  Future<void> logTaskSubmission({
    required ResolvedTask task,
    required String status,
    String? numericValue,
    required bool photoAttached,
    String? notes,
    String? customFieldValuesJson,
  }) {
    return _submissionRepository.submit(
      TaskSubmission(
        taskTitle: task.displayTitle,
        status: status,
        completedBy: '${_currentUser.name} (${_currentUser.jobTitle})',
        completedAt: DateTime.now(),
        numericValue: numericValue,
        photoAttached: photoAttached,
        notes: notes,
        taskScheduleId: task.scheduleId,
        taskTemplateGroupId: task.templateGroupId,
        equipmentInstanceId: task.equipmentInstanceId,
        customFieldValuesJson: customFieldValuesJson,
        completedByUserId: _currentUser.id,
        siteId: _currentUser.siteId,
      ),
    );
  }
}
