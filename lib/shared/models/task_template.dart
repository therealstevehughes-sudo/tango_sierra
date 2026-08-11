import 'job_role.dart';
import 'user.dart';

// Real 3-level priority from the checklist source (Sprint 023), replacing
// the binary isCritical for new data going forward. isCritical itself is
// kept unchanged alongside this for full backward compatibility.
enum TaskPriority { critical, high, standard }

class TaskTemplate {
  final int id;
  final int templateGroupId;
  final int versionNumber;
  final int? previousVersionId;
  final String title;
  final String segment;
  final List<RoleTier> applicableRoleTiers;
  final String method;
  final bool requiresPhoto;
  final bool requiresNotes;
  final String? customFieldsJson;
  final double? minLimit;
  final double? maxLimit;
  final String? unit;
  final String? legalLimitCategory;
  final bool isCritical;
  final bool requiresCorrectiveActionOnFail;
  final String? fixInstructions;
  final int? equipmentTypeId;
  final DateTime createdAt;
  final int? createdByUserId;
  final TaskPriority? priority;
  // Both nullable: added by Sprint 031's HORECA_TASK_ENRICHMENT.md load.
  // A default (not a lockout, unlike applicableRoleTiers) for which job
  // usually does this task — Assign Tasks uses it to pre-filter the list,
  // but a manager can still assign anything within their tier's access.
  // Null on rows not yet enriched (custom tasks, or library tasks the
  // enrichment doc doesn't cover).
  final JobRole? jobRole;
  final String? guidanceText;

  // Null on rows created before Sprint 023 (can't be reconstructed from
  // isCritical without guessing high vs. standard); falls back to the
  // PROJECT_BIBLE-documented mapping for those legacy rows.
  TaskPriority get effectivePriority =>
      priority ?? (isCritical ? TaskPriority.critical : TaskPriority.standard);

  const TaskTemplate({
    required this.id,
    required this.templateGroupId,
    required this.versionNumber,
    this.previousVersionId,
    required this.title,
    required this.segment,
    required this.applicableRoleTiers,
    required this.method,
    required this.requiresPhoto,
    required this.requiresNotes,
    this.customFieldsJson,
    this.minLimit,
    this.maxLimit,
    this.unit,
    this.legalLimitCategory,
    required this.isCritical,
    required this.requiresCorrectiveActionOnFail,
    this.fixInstructions,
    this.equipmentTypeId,
    required this.createdAt,
    this.createdByUserId,
    this.priority,
    this.jobRole,
    this.guidanceText,
  });
}
