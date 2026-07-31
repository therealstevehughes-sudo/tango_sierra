class LegalLimitReference {
  final int id;
  final String category;
  final double? legalMin;
  final double? legalMax;
  final String unit;

  const LegalLimitReference({
    required this.id,
    required this.category,
    this.legalMin,
    this.legalMax,
    required this.unit,
  });
}
