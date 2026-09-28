class Equipment {
  final int id;
  final String name;
  final int equipmentTypeId;
  final int? areaId;
  final int siteId;
  final bool active;
  // Model/serial number (2026-09-28, direct founder request) — helps
  // ordering the right replacement part when something breaks. Both
  // nullable/optional.
  final String? model;
  final String? serialNumber;
  // Department scoping (2026-09-28, direct founder request) — see
  // Area.departmentId's own doc comment. Independent of areaId's own
  // department rather than always derived from it, since equipment can
  // exist with no area assigned at all.
  final int? departmentId;

  const Equipment({
    required this.id,
    required this.name,
    required this.equipmentTypeId,
    this.areaId,
    required this.siteId,
    required this.active,
    this.model,
    this.serialNumber,
    this.departmentId,
  });
}
