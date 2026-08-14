// Departments (Sprint 031, Build Order item 5, Sub-sprint B) — a
// venue-defined grouping (Kitchen, Housekeeping, Reception, ...), set up
// per-venue rather than a fixed enum. Distinct from both a user's jobRole
// ("what you do") and roleTier ("how much you can see/escalate to") — this
// is "which part of the venue." Editable, not append-only — mirrors
// Supplier's shape, not TaskTemplate's versioning rule.
class Department {
  final int? id;
  final String name;
  final int siteId;
  final bool active;
  final DateTime createdAt;

  const Department({
    this.id,
    required this.name,
    required this.siteId,
    this.active = true,
    required this.createdAt,
  });
}
