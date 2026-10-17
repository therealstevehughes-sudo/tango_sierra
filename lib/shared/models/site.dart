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
  // Shift verification photos (2026-10-02) — off by default; a venue
  // manager+ turns this on per-site. Retention is in days, GDPR
  // storage-limitation default of 90, deliberately configurable rather
  // than a hardcoded "legal" number nobody has actually confirmed for
  // this specific record type (see the migration's own doc comment).
  final bool shiftVerificationPhotosEnabled;
  final int shiftPhotoRetentionDays;
  // Location-checked clock-in (2026-10-15) — off by default; flag-and-
  // review, never a block. The venue's own location + allowed distance,
  // and whether a manager has recorded the venue's internet connection
  // (the IP itself stays server-side; the app only needs to know it's set).
  final bool clockLocationCheckEnabled;
  // Fryer oil (2026-10-17): amber warning above, fail above.
  final int fryerAmberC;
  final int fryerRedC;
  final double? clockLatitude;
  final double? clockLongitude;
  final int clockRadiusM;
  final bool clockNetworkSet;

  bool get hasClockLocation => clockLatitude != null && clockLongitude != null;

  const Site({
    required this.id,
    required this.organisationId,
    required this.name,
    this.address,
    required this.createdAt,
    this.regionId,
    this.deviceCredential,
    this.shiftVerificationPhotosEnabled = false,
    this.shiftPhotoRetentionDays = 90,
    this.clockLocationCheckEnabled = false,
    this.fryerAmberC = 180,
    this.fryerRedC = 185,
    this.clockLatitude,
    this.clockLongitude,
    this.clockRadiusM = 150,
    this.clockNetworkSet = false,
  });
}
