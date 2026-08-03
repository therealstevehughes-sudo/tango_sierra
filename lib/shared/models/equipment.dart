class Equipment {
  final int id;
  final String name;
  final int equipmentTypeId;
  final int? areaId;
  final int siteId;
  final bool active;

  const Equipment({
    required this.id,
    required this.name,
    required this.equipmentTypeId,
    this.areaId,
    required this.siteId,
    required this.active,
  });
}
