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
  // Fails & Problems Register (Part A) — 'open'/'resolved'/null (null for
  // PASS rows, where it doesn't apply). Denormalized for fast filtering;
  // the real audit trail lives in ProblemStatusEvents.
  final String? problemStatus;
  // Instance-name prominence (2026-09-06) — the equipment instance's name
  // as it was at submission time, denormalized so every display surface
  // can render it separately (bold/leading) from taskTitle rather than as
  // an indistinct suffix baked into one string. Null for tasks with no
  // linked equipment.
  final String? equipmentInstanceName;
  // Detailed delivery-by-supplier records (roadmap v1 item #1, built
  // 2026-09-15) — only meaningful when this submission's task had
  // requiresSupplierSelection set; null/false for every other submission.
  final double? deliveryTemperatureC;
  final bool deliveryShortDelivery;
  final bool deliveryDamagedStock;
  final bool deliveryLateDelivery;
  final bool deliveryQualityProblem;
  // accepted | rejected | partial — null for non-delivery submissions.
  final String? deliveryOutcome;

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
    this.problemStatus,
    this.equipmentInstanceName,
    this.deliveryTemperatureC,
    this.deliveryShortDelivery = false,
    this.deliveryDamagedStock = false,
    this.deliveryLateDelivery = false,
    this.deliveryQualityProblem = false,
    this.deliveryOutcome,
  });

  // Flat-string fallback for contexts that just want one combined display
  // string (e.g. the end-of-session summary's plain failed-task list) —
  // not one of the five surfaces that need bold/leading treatment, but
  // shouldn't lose the instance name either now that taskTitle is plain.
  String get displayTitle => equipmentInstanceName == null
      ? taskTitle
      : '$taskTitle — $equipmentInstanceName';
}
