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
  });

  bool get hasNumericRange => minLimit != null && maxLimit != null;

  bool get hasChoice => choiceOptions != null && choiceOptions!.isNotEmpty;

  String get displayTitle =>
      equipmentInstanceName == null ? title : '$title — $equipmentInstanceName';
}
