class Organisation {
  final int id;
  final String name;
  final DateTime createdAt;
  // Per-employee graded dashboard bars (2026-09-24) — off by default; see
  // OrganisationRepository.setEmployeeGradedBarsEnabled's own doc comment.
  final bool employeeGradedBarsEnabled;

  const Organisation({
    required this.id,
    required this.name,
    required this.createdAt,
    this.employeeGradedBarsEnabled = false,
  });
}
