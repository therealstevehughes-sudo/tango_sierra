class ResolvedTask {
  // Nullable (2026-09-17, ad-hoc task path build) — a schedule-less ad-hoc
  // submission (picked from the library directly, not assigned via a
  // TaskSchedule) has no schedule to reference. TaskSubmission.taskScheduleId
  // was already nullable for exactly this reason; this just lets a
  // ResolvedTask represent that case too, so TaskController.logTaskSubmission
  // can be reused unchanged for both paths.
  final int? scheduleId;
  final int templateGroupId;
  final String title;
  final String segment;
  final String method;
  final bool requiresPhoto;
  final bool requiresNotes;
  final double? minLimit;
  final double? maxLimit;
  final String? unit;
  final bool isCritical;
  final bool requiresCorrectiveActionOnFail;
  final String? fixInstructions;
  // Sprint 031 (HORECA_TASK_ENRICHMENT.md load): short "what to do / what
  // to record" text shown prominently when the worker opens the task. Null
  // on tasks not yet enriched (custom tasks, or ones outside the doc).
  final String? guidanceText;
  final List<String>? choiceOptions;
  final int? equipmentInstanceId;
  final String? equipmentInstanceName;
  // Who assigned this task (TaskSchedule.assignedByUserId) — used by the
  // corrective-action "Reported to manager" guaranteed-floor escalation
  // (Sprint 031, Sub-sprint 4) to notify the actual assigning manager first,
  // before falling back to the lowest non-base tier at the site.
  final int assignedByUserId;
  // Due/overdue tracking (Sprint 031, Sub-sprint A). isOverdue is false for
  // both "genuinely due, not yet overdue" and "non-clock frequency, not
  // tracked" — a satisfied schedule is filtered out of the carousel
  // entirely before a ResolvedTask is ever built for it, so there's no
  // third "satisfied" state to represent here.
  final bool isOverdue;
  final DateTime? overdueSince;
  // Time-windowed tasks (Sprint 031, Sub-sprint C) — both null or both
  // set, minutes since midnight, end exclusive. HONEST LIMIT: isLocked
  // reads the device clock (DateTime.now()), fakeable until a backend
  // provides trusted server time — same limitation already logged for
  // completedAt and due/overdue, not newly introduced here.
  final int? windowStartMinutes;
  final int? windowEndMinutesExclusive;
  // Task-reorder (2026-09-12): the manager-configured execution order of
  // the underlying schedule, passed through so the carousel can sort by it.
  // Null = no explicit order yet; sorts after ordered tasks.
  final int? sortOrder;
  // Supplier register + traceability (Sprint 031, finalized beta build
  // order item 4, Sub-sprint B) — true only on "Supplier traceability
  // captured"; task_screen.dart shows a supplier picker when set.
  final bool requiresSupplierSelection;

  const ResolvedTask({
    this.scheduleId,
    required this.templateGroupId,
    required this.title,
    required this.segment,
    required this.method,
    required this.requiresPhoto,
    required this.requiresNotes,
    this.minLimit,
    this.maxLimit,
    this.unit,
    required this.isCritical,
    required this.requiresCorrectiveActionOnFail,
    this.fixInstructions,
    this.guidanceText,
    this.choiceOptions,
    this.equipmentInstanceId,
    this.equipmentInstanceName,
    required this.assignedByUserId,
    this.isOverdue = false,
    this.overdueSince,
    this.windowStartMinutes,
    this.windowEndMinutesExclusive,
    this.sortOrder,
    this.requiresSupplierSelection = false,
  });

  bool get hasNumericRange => minLimit != null && maxLimit != null;

  bool get hasChoice => choiceOptions != null && choiceOptions!.isNotEmpty;

  String get displayTitle =>
      equipmentInstanceName == null ? title : '$title — $equipmentInstanceName';

  bool get isLocked {
    if (windowStartMinutes == null || windowEndMinutesExclusive == null) {
      return false;
    }
    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;
    return nowMinutes < windowStartMinutes! ||
        nowMinutes >= windowEndMinutesExclusive!;
  }
}

class SessionStats {
  final int passCount;
  final int failCount;
  final List<String> failedTaskTitles;

  const SessionStats({
    required this.passCount,
    required this.failCount,
    required this.failedTaskTitles,
  });
}
