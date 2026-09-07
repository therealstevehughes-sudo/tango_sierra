// Branding (Sprint 031, finalized beta build order item 7). Pure data —
// no Flutter import here, matching every other model in this folder;
// primaryColorArgb is converted to a real Color/PdfColor only at the
// read sites that need one (app_theme.dart, eho_export_service.dart).
class BrandingConfig {
  final int id;
  final int configGroupId;
  final int versionNumber;
  final int? previousVersionId;
  final int organisationId;
  final String? companyName;
  final int primaryColorArgb;
  final String? contactPhone;
  final String? contactEmail;
  final int setByUserId;
  final DateTime createdAt;
  final String? logoPath;

  const BrandingConfig({
    required this.id,
    required this.configGroupId,
    required this.versionNumber,
    this.previousVersionId,
    required this.organisationId,
    this.companyName,
    required this.primaryColorArgb,
    this.contactPhone,
    this.contactEmail,
    required this.setByUserId,
    required this.createdAt,
    this.logoPath,
  });
}
