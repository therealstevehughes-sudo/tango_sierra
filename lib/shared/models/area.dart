class Area {
  final int id;
  final String name;
  final int siteId;
  // Task-reorder (2026-09-12): the manager-controlled order of this
  // venue's zones. Nullable; null = no explicit order yet.
  final int? sortOrder;

  const Area({
    required this.id,
    required this.name,
    required this.siteId,
    this.sortOrder,
  });
}
