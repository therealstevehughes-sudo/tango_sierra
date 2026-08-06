class LegalLimitReference {
  final int id;
  final String category;
  final double? legalMin;
  final double? legalMax;
  final String unit;
  // Which of [LAW]/[FSA]/[BEST] this figure is (Sprint 030) — 'law', 'fsa',
  // or 'best'. See HORECA_TASK_LIBRARY.md's sourcing note: only [LAW]
  // figures are actual legal requirements; [FSA] is official guidance
  // strongly expected by EHOs; [BEST] is industry best practice with no
  // legal figure.
  final String basis;
  // Nullable, unpopulated — no UI exists yet to record a professional
  // sign-off. Groundwork for a future verification-tracking sprint.
  final DateTime? verifiedAt;
  final int? verifiedByUserId;

  const LegalLimitReference({
    required this.id,
    required this.category,
    this.legalMin,
    this.legalMax,
    required this.unit,
    required this.basis,
    this.verifiedAt,
    this.verifiedByUserId,
  });
}
