class Site {
  final int id;
  final int organisationId;
  final String name;
  final String? address;
  final DateTime createdAt;

  const Site({
    required this.id,
    required this.organisationId,
    required this.name,
    this.address,
    required this.createdAt,
  });
}
