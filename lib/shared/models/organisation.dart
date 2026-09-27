class Organisation {
  final int id;
  final String name;
  final DateTime createdAt;
  // Per-employee graded dashboard bars (2026-09-24) — off by default; see
  // OrganisationRepository.setEmployeeGradedBarsEnabled's own doc comment.
  final bool employeeGradedBarsEnabled;
  // Roster add-on (2026-09-27) — the paid shift-claiming/rota feature,
  // off by default. Reuses this exact single-boolean pattern, same as
  // employeeGradedBarsEnabled above, rather than a generalized add-ons
  // table — there's no other multi-add-on need in this app yet.
  final bool rosterAddonEnabled;

  const Organisation({
    required this.id,
    required this.name,
    required this.createdAt,
    this.employeeGradedBarsEnabled = false,
    this.rosterAddonEnabled = false,
  });
}
