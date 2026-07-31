class Equipment {
  final int id;
  final String name;
  final int equipmentTypeId;
  final int? areaId;

  const Equipment({
    required this.id,
    required this.name,
    required this.equipmentTypeId,
    this.areaId,
  });
}
