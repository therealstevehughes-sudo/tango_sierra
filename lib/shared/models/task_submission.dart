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
  // Supplier register + traceability (Sprint 031, finalized beta build
  // order item 4, Sub-sprint B) — which supplier a delivery-related
  // submission came from, one-step-back trace. Optional: not every
  // submission is delivery-related, and even on ones that are, the worker
  // isn't blocked from submitting without picking one.
  final int? supplierId;

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
    this.supplierId,
  });
}
