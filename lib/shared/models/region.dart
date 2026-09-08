// Phase B0 (2026-09-08) — an optional grouping layer between an
// Organisation and its Sites. See Regions' own table doc comment in
// app_database.dart for the "why one flat level, not a tree" reasoning.
class Region {
  final int id;
  final int organisationId;
  final String name;
  final DateTime createdAt;

  const Region({
    required this.id,
    required this.organisationId,
    required this.name,
    required this.createdAt,
  });
}
