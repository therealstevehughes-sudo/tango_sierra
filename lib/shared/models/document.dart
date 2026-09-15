// Document Centre (roadmap v1.1, built 2026-09-15) — policies, certs,
// procedures, and EHO reports, plus an expiry dashboard so a manager sees
// what's valid/expiring/expired at a glance rather than finding out a
// certificate lapsed when an inspector asks for it.
enum DocumentCategory { policy, certificate, procedure, ehoReport, other }

String documentCategoryDisplayName(DocumentCategory category) {
  switch (category) {
    case DocumentCategory.policy:
      return 'Policy';
    case DocumentCategory.certificate:
      return 'Certificate';
    case DocumentCategory.procedure:
      return 'Procedure';
    case DocumentCategory.ehoReport:
      return 'EHO Report';
    case DocumentCategory.other:
      return 'Other';
  }
}

// Only meaningful when a document HAS an expiry date — policies/procedures
// commonly don't. `valid` is also what a no-expiry document always is.
enum DocumentExpiryStatus { valid, expiringSoon, expired }

// 30 days — the same order of magnitude most food-safety/insurance
// certificates give as a renewal notice period. Not sourced from a legal
// figure (this isn't a compliance threshold, just a helpful heads-up
// window), so it's a plain constant here rather than something routed
// through LegalLimitReference.
const documentExpiryWarningWindow = Duration(days: 30);

DocumentExpiryStatus documentExpiryStatus(
  DateTime? expiryDate, {
  DateTime? now,
}) {
  if (expiryDate == null) return DocumentExpiryStatus.valid;
  final reference = now ?? DateTime.now();
  if (expiryDate.isBefore(reference)) return DocumentExpiryStatus.expired;
  if (expiryDate.isBefore(reference.add(documentExpiryWarningWindow))) {
    return DocumentExpiryStatus.expiringSoon;
  }
  return DocumentExpiryStatus.valid;
}

class Document {
  final int? id;
  final int siteId;
  final String title;
  final DocumentCategory category;
  // A path into this app's own local storage — the picked file is copied
  // in at upload time, same "never reference the original pick location"
  // reasoning as BrandingConfig.logoPath (the source could be a USB
  // drive, a network share, a Downloads folder that gets cleared).
  final String filePath;
  final DateTime? expiryDate;
  final int uploadedByUserId;
  final DateTime uploadedAt;
  final bool active;

  const Document({
    this.id,
    required this.siteId,
    required this.title,
    required this.category,
    required this.filePath,
    this.expiryDate,
    required this.uploadedByUserId,
    required this.uploadedAt,
    this.active = true,
  });

  DocumentExpiryStatus get expiryStatus => documentExpiryStatus(expiryDate);
}
