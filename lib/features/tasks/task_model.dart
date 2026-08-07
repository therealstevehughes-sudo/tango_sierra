class ResolvedTask {
  final int scheduleId;
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
  final List<String>? choiceOptions;
  final int? equipmentInstanceId;
  final String? equipmentInstanceName;
  // Who assigned this task (TaskSchedule.assignedByUserId) — used by the
  // corrective-action "Reported to manager" guaranteed-floor escalation
  // (Sprint 031, Sub-sprint 4) to notify the actual assigning manager first,
  // before falling back to the lowest non-base tier at the site.
  final int assignedByUserId;

  const ResolvedTask({
    required this.scheduleId,
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
    this.choiceOptions,
    this.equipmentInstanceId,
    this.equipmentInstanceName,
    required this.assignedByUserId,
  });

  bool get hasNumericRange => minLimit != null && maxLimit != null;

  bool get hasChoice => choiceOptions != null && choiceOptions!.isNotEmpty;

  String get displayTitle =>
      equipmentInstanceName == null ? title : '$title — $equipmentInstanceName';
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
