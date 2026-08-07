class TaskSubmission {
  final int? id;
  final String taskTitle;
  final String status;
  final String completedBy;
  final DateTime completedAt;
  final String? numericValue;
  final bool photoAttached;
  final String? photoPath;
  final String? notes;
  final int? taskScheduleId;
  final int? taskTemplateGroupId;
  final int? equipmentInstanceId;
  final String? customFieldValuesJson;
  final int? completedByUserId;
  final int siteId;
  final String? correctiveActionOutcome;
  final String? correctiveActionNote;

  const TaskSubmission({
    this.id,
    required this.taskTitle,
    required this.status,
    required this.completedBy,
    required this.completedAt,
    this.numericValue,
    required this.photoAttached,
    this.photoPath,
    this.notes,
    this.taskScheduleId,
    this.taskTemplateGroupId,
    this.equipmentInstanceId,
    this.customFieldValuesJson,
    this.completedByUserId,
    required this.siteId,
    this.correctiveActionOutcome,
    this.correctiveActionNote,
  });
}
