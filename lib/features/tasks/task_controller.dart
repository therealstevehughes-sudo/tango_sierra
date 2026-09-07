import 'dart:convert';

import '../../shared/models/notification_rule.dart';
import '../../shared/models/problem_status_event.dart';
import '../../shared/models/task_submission.dart';
import '../../shared/models/task_template.dart';
import '../../shared/models/user.dart';
import '../../shared/repositories/equipment_repository.dart';
import '../../shared/repositories/notification_rule_repository.dart';
import '../../shared/repositories/problem_register_repository.dart';
import '../../shared/repositories/task_schedule_repository.dart';
import '../../shared/repositories/task_submission_repository.dart';
import '../../shared/repositories/task_template_repository.dart';
import '../../shared/repositories/trigger_notification_repository.dart';
import '../../shared/repositories/user_repository.dart';
import 'due_status_service.dart';
import 'task_model.dart';

class TaskController {
  TaskController(
    this._submissionRepository,
    this._scheduleRepository,
    this._templateRepository,
    this._equipmentRepository,
    this._currentUser,
    this._notificationRuleRepository,
    this._triggerNotificationRepository,
    this._userRepository,
    this._problemRegisterRepository, [
    DueStatusService? dueStatusService,
  ]) : _dueStatusService = dueStatusService ??
            DueStatusService(_submissionRepository);

  final TaskSubmissionRepository _submissionRepository;
  final TaskScheduleRepository _scheduleRepository;
  final TaskTemplateRepository _templateRepository;
  final EquipmentRepository _equipmentRepository;
  final User _currentUser;
  final NotificationRuleRepository _notificationRuleRepository;
  final TriggerNotificationRepository _triggerNotificationRepository;
  final UserRepository _userRepository;
  final ProblemRegisterRepository _problemRegisterRepository;
  final DueStatusService _dueStatusService;

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

      // Due/overdue tracking (Sprint 031, Sub-sprint A): previously every
      // active schedule showed up every session regardless of whether it
      // had already been completed for its period — a worker would see
      // today's fridge check again five minutes after submitting it. A
      // satisfied schedule is skipped entirely; an overdue one is still
      // shown (never hidden — see the compliance principle established
      // for FAILs) with isOverdue/overdueSince set.
      final dueResult = await _dueStatusService.computeStatus(schedule);
      if (dueResult.state == ScheduleDueState.satisfied) continue;

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
          guidanceText: template.guidanceText,
          choiceOptions: _parseChoiceOptions(template.customFieldsJson),
          equipmentInstanceId: schedule.equipmentInstanceId,
          equipmentInstanceName: equipmentInstanceName,
          assignedByUserId: schedule.assignedByUserId,
          isOverdue: dueResult.state == ScheduleDueState.overdue,
          overdueSince: dueResult.overdueSince,
          windowStartMinutes: schedule.windowStartMinutes,
          windowEndMinutesExclusive: schedule.windowEndMinutesExclusive,
          requiresSupplierSelection: template.requiresSupplierSelection,
        ),
      );
    }

    // Time-windowed tasks (Sprint 031, Sub-sprint C): a locked task is
    // never hidden (same principle as overdue/FAILs), but it also can't
    // be the one blocking everything else — sorting locked tasks to the
    // end means the worker naturally reaches every actionable task first.
    // stable sort — doesn't reorder within either group.
    resolved.sort((a, b) {
      if (a.isLocked == b.isLocked) return 0;
      return a.isLocked ? 1 : -1;
    });

    tasks = resolved;
    currentIndex = 0;
  }

  // Time-windowed tasks (Sprint 031, Sub-sprint C): the only way past a
  // locked task if it's still the current one once every unlocked task is
  // done (sorting alone doesn't help once nothing unlocked remains) — the
  // worker can't submit it, so without this they'd be trapped, violating
  // the standing "never trapped" rule. Not logged as NOT_COMPLETED: unlike
  // exit behaviour's abandoned tasks, a locked task was never actually
  // offered as available, so there's nothing to record — it's simply
  // re-evaluated, and re-offered, next time loadTasks() runs.
  bool skipLockedTask() {
    if (!hasTasks || !getCurrentTask().isLocked) return false;
    return nextTask();
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

  // Exit behaviour (Sprint 031, Build Order item 5, Sub-sprint B): whether
  // leaving right now would abandon anything — everything from
  // currentIndex onward hasn't been submitted this session (nextTask()
  // only advances past a task once it's actually submitted).
  bool get hasRemainingTasks => hasTasks && currentIndex < tasks.length;

  // Logs each not-yet-submitted task as NOT_COMPLETED so leaving mid-shift
  // is recorded, not silent — never vanishes, stays outstanding (matching
  // the same "never silently hidden" principle already applied to FAILs
  // and overdue tasks). Deliberately does NOT call _fireNotifications:
  // leaving before finishing is allowed, expected behaviour per the
  // logged exit-behaviour decision, not itself a compliance failure
  // needing escalation. countForScheduleInRange (Sub-sprint A) only counts
  // PASS/FAIL, so this correctly does not satisfy the task's period — it
  // reappears as due (or overdue) when the worker returns.
  Future<void> logRemainingAsNotCompleted() async {
    for (final task in tasks.sublist(currentIndex)) {
      final submissionId = await _submissionRepository.submit(
        TaskSubmission(
          taskTitle: task.title,
          status: 'NOT_COMPLETED',
          completedBy: '${_currentUser.name} (${_currentUser.jobTitle})',
          completedAt: DateTime.now(),
          photoAttached: false,
          taskScheduleId: task.scheduleId,
          taskTemplateGroupId: task.templateGroupId,
          equipmentInstanceId: task.equipmentInstanceId,
          completedByUserId: _currentUser.id,
          siteId: _currentUser.siteId,
          equipmentInstanceName: task.equipmentInstanceName,
        ),
      );
      // Fails & Problems Register (Part A2): an abandoned task is a
      // problem that must never silently disappear, same as a FAIL —
      // starts open, same as a plain fail with no corrective action.
      await _problemRegisterRepository.initialize(
        taskSubmissionId: submissionId,
        status: ProblemStatus.open,
        byUserId: _currentUser.id,
      );
    }
  }

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
      failedTaskTitles: failed.map((s) => s.displayTitle).toList(),
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
    String? correctiveActionOutcome,
    String? correctiveActionNote,
    int? supplierId,
  }) async {
    final submissionId = await _submissionRepository.submit(
      TaskSubmission(
        taskTitle: task.title,
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
        correctiveActionOutcome: correctiveActionOutcome,
        correctiveActionNote: correctiveActionNote,
        supplierId: supplierId,
        equipmentInstanceName: task.equipmentInstanceName,
      ),
    );

    if (status == 'FAIL') {
      // Fails & Problems Register (Part A1): "I fixed it" auto-resolves
      // (but stays visible in the register — resolved is a filter, not a
      // deletion); "Reported to manager," or a plain fail with no
      // corrective action at all, starts open until a manager closes it.
      await _problemRegisterRepository.initialize(
        taskSubmissionId: submissionId,
        status: correctiveActionOutcome == 'fixed'
            ? ProblemStatus.resolved
            : ProblemStatus.open,
        byUserId: _currentUser.id,
      );
      await _fireNotifications(
        taskSubmissionId: submissionId,
        task: task,
        correctiveActionOutcome: correctiveActionOutcome,
      );
    }
  }

  Future<void> _fireNotifications({
    required int taskSubmissionId,
    required ResolvedTask task,
    String? correctiveActionOutcome,
  }) async {
    final siteId = _currentUser.siteId;
    final allRules = await _notificationRuleRepository.getAllCurrentVersions();

    final matchingRules = allRules.where((rule) {
      if (!rule.active) return false;
      final triggerMatches =
          rule.taskTemplateGroupId == null ||
          rule.taskTemplateGroupId == task.templateGroupId;
      final siteMatches = rule.siteId == null || rule.siteId == siteId;
      return triggerMatches && siteMatches;
    }).toList();

    // Precedence: within each exact trigger scope, rules set by the
    // highest-ranked tier present suppress rules set by any lower tier in
    // that same scope (generalizes the original "top overrides mid" to all
    // five tiers — Sprint 027).
    final byScope = <int?, List<NotificationRule>>{};
    for (final rule in matchingRules) {
      byScope.putIfAbsent(rule.taskTemplateGroupId, () => []).add(rule);
    }
    final firingRules = <NotificationRule>[];
    for (final scoped in byScope.values) {
      final highestRank = scoped
          .map((r) => roleTierRank(r.setByTier))
          .reduce((a, b) => a > b ? a : b);
      firingRules.addAll(
        scoped.where((r) => roleTierRank(r.setByTier) == highestRank),
      );
    }

    final isReported = correctiveActionOutcome == 'reported';
    // Corrective-action redesign (Sprint 031, Sub-sprint 4): a plain FAIL
    // with no matching rule stays silent, same as always. But "Reported to
    // manager" specifically must always reach someone — a worker saying "I
    // can't fix this" reaching nobody is the exact silent failure this
    // feature exists to prevent — so skip the early return in that one case.
    if (firingRules.isEmpty && !isReported) return;

    final allUsers = await _userRepository.getAll();
    final message = isReported
        ? 'REPORTED (could not fix): ${task.displayTitle} '
              '(submitted by ${_currentUser.name})'
        : 'FAIL: ${task.displayTitle} (submitted by ${_currentUser.name})';

    final notifiedUserIds = <int>{};

    for (final rule in firingRules) {
      final recipients = <User>[];
      final isSpecificPersonTarget = rule.targetUserId != null;
      if (isSpecificPersonTarget) {
        recipients.addAll(allUsers.where((u) => u.id == rule.targetUserId));
      } else if (rule.targetRoleTier != null) {
        recipients.addAll(
          allUsers.where(
            (u) =>
                u.roleTier == rule.targetRoleTier &&
                // Site-specific rules fan out within that site only;
                // org-wide rules (siteId null) fan out across every site.
                (rule.siteId == null || u.siteId == rule.siteId),
          ),
        );
      }

      // Denormalized onto the notification (Sprint 022) so the escalation
      // sweep can decide eligibility without a rule lookup. A specific-
      // person target is recorded as null (same as tier == null) so it's
      // treated as escalate-eligible, same as a mid-tier target.
      final originTargetRoleTier = isSpecificPersonTarget
          ? null
          : rule.targetRoleTier;

      for (final recipient in recipients) {
        notifiedUserIds.add(recipient.id);
        await _triggerNotificationRepository.create(
          notificationRuleId: rule.id,
          taskSubmissionId: taskSubmissionId,
          recipientUserId: recipient.id,
          message: message,
          siteId: siteId,
          originTargetRoleTier: originTargetRoleTier,
          equipmentInstanceName: task.equipmentInstanceName,
        );
      }
    }

    if (!isReported) return;

    // Guaranteed floor: the assigning manager first; if they can't be
    // resolved, the lowest non-base tier present at the site (everyone at
    // that tier, not an arbitrary pick — under-notifying defeats the
    // point). Configured rules above add recipients on top of this floor,
    // never replace it; dedup so nobody gets the same fail twice.
    final floorRecipients = <User>[];
    final assignedBy = allUsers.where((u) => u.id == task.assignedByUserId);
    if (assignedBy.isNotEmpty) {
      floorRecipients.add(assignedBy.first);
    } else {
      final nonBaseAtSite = allUsers
          .where((u) => u.roleTier != RoleTier.base && u.siteId == siteId)
          .toList();
      if (nonBaseAtSite.isNotEmpty) {
        final lowestRank = nonBaseAtSite
            .map((u) => roleTierRank(u.roleTier))
            .reduce((a, b) => a < b ? a : b);
        floorRecipients.addAll(
          nonBaseAtSite.where((u) => roleTierRank(u.roleTier) == lowestRank),
        );
      }
      // If neither resolves (no assigning manager on record and no non-base
      // staff at this site at all), there is genuinely nobody at this site
      // to notify — an accepted edge case, not solved by reaching outside
      // the site.
    }

    for (final recipient in floorRecipients) {
      if (notifiedUserIds.contains(recipient.id)) continue;
      notifiedUserIds.add(recipient.id);
      await _triggerNotificationRepository.create(
        notificationRuleId: null,
        taskSubmissionId: taskSubmissionId,
        recipientUserId: recipient.id,
        message: message,
        siteId: siteId,
        originTargetRoleTier: null,
        equipmentInstanceName: task.equipmentInstanceName,
      );
    }
  }
}
