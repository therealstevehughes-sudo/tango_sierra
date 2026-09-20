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
  // Device pairing (2026-09-20) — the shared setup code a new tablet is
  // given once so it can see this venue's staff list before anyone signs
  // in (backend mode only; a local-only install is already trusted and
  // has no such concept, so this is always null there).
  final String? deviceCredential;

  const Site({
    required this.id,
    required this.organisationId,
    required this.name,
    this.address,
    required this.createdAt,
    this.regionId,
    this.deviceCredential,
  });
}
