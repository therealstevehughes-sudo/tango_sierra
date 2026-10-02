// Bug/error reporting (2026-10-02) — the capture side of a gap flagged
// against the admin tool's original spec: nothing previously let a
// customer report a software bug anywhere VenuRite could see it.
// Deliberately separate from Issue (operational/venue incidents like
// accidents or supply problems) — this is specifically about the app
// itself. Backend-only: a local-only install has no organisation to
// attach a report to.
class BugReport {
  const BugReport({
    required this.id,
    required this.organisationId,
    this.siteId,
    this.reportedByUserId,
    required this.title,
    required this.description,
    this.platform,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
  });

  final int id;
  final int organisationId;
  final int? siteId;
  final int? reportedByUserId;
  final String title;
  final String description;
  final String? platform;
  final String status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
}
