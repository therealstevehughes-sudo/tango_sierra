class Area {
  final int id;
  final String name;
  final int siteId;
  // Task-reorder (2026-09-12): the manager-controlled order of this
  // venue's zones. Nullable; null = no explicit order yet.
  final int? sortOrder;
  // Department scoping (2026-09-28, direct founder request) — lets a
  // department head's delegated equipment access be scoped to their own
  // section instead of the whole site. Nullable: an area with no
  // department stays visible to everyone.
  final int? departmentId;

  const Area({
    required this.id,
    required this.name,
    required this.siteId,
    this.sortOrder,
    this.departmentId,
  });
}
