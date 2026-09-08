class Site {
  final int id;
  final int organisationId;
  final String name;
  final String? address;
  final DateTime createdAt;
  // Phase B0 — null means this site attaches directly to the
  // Organisation, no region layer (the common case). organisationId
  // above stays the authoritative tenant link either way.
  final int? regionId;

  const Site({
    required this.id,
    required this.organisationId,
    required this.name,
    this.address,
    required this.createdAt,
    this.regionId,
  });
}
