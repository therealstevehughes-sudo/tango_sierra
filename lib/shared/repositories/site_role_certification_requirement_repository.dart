import '../models/certification_requirement.dart';

// Leadership-added certification requirements (Phase 2, 2026-09-30) — see
// certification_requirement.dart's own doc comment for why this is purely
// additive on top of the fixed systemRequiredCertifications() floor.
// Backend-only, no local Drift mirror — same reasoning as ShiftRepository:
// this is a live compliance control leadership manages centrally, not
// something a local/demo install needs to fake.
abstract class SiteRoleCertificationRequirementRepository {
  Future<List<SiteRoleCertificationRequirement>> getForSite(int siteId);

  Future<SiteRoleCertificationRequirement> add(
    SiteRoleCertificationRequirement requirement,
  );

  Future<void> remove(int id);
}
