import 'user.dart';

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
  });
}
