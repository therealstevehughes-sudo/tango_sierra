// Departments (Sprint 031, Build Order item 5, Sub-sprint B) — a
// venue-defined grouping, set up per-venue. Distinct from both a user's
// jobRole ("what you do") and roleTier ("how much you can see/escalate
// to") — this is "which part of the venue." Editable, not append-only —
// mirrors Supplier's shape, not TaskTemplate's versioning rule.
//
// Category added (2026-09-28, direct founder request) — a venue with two
// physically separate kitchens (e.g. "Kitchen - Ground Floor" and
// "Kitchen - Basement") needs each to be its own Department so staff can
// be assigned to the right one and moved between them, but still wants
// both recognised as "a kitchen" for the walk-up screen's grouping and
// any future filtering/reporting. `name` stays the free-text per-instance
// label; `category` is the new fixed tag carrying that "kind of place"
// meaning — the two are independent (a venue can rename a kitchen to
// anything without touching its category). Nullable: every department
// created before this field has no category yet, and setting one is a
// deliberate action, not forced retroactively.
enum DepartmentCategory {
  kitchen,
  frontOfHouse,
  bar,
  management,
  maintenance,
  housekeeping,
  reception,
  security,
}

String departmentCategoryDisplayName(DepartmentCategory category) {
  switch (category) {
    case DepartmentCategory.kitchen:
      return 'Kitchen';
    case DepartmentCategory.frontOfHouse:
      return 'Front of House';
    case DepartmentCategory.bar:
      return 'Bar';
    case DepartmentCategory.management:
      return 'Management';
    case DepartmentCategory.maintenance:
      return 'Maintenance';
    case DepartmentCategory.housekeeping:
      return 'Housekeeping';
    case DepartmentCategory.reception:
      return 'Reception';
    case DepartmentCategory.security:
      return 'Security';
  }
}

DepartmentCategory? departmentCategoryFromString(String? value) {
  if (value == null) return null;
  for (final category in DepartmentCategory.values) {
    if (category.name == value) return category;
  }
  return null;
}

class Department {
  final int? id;
  final String name;
  final int siteId;
  final bool active;
  final DateTime createdAt;
  final DepartmentCategory? category;

  const Department({
    this.id,
    required this.name,
    required this.siteId,
    this.active = true,
    required this.createdAt,
    this.category,
  });
}
