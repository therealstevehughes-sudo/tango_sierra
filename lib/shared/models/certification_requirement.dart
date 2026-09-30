import 'job_role.dart';
import 'training_item.dart';
import 'training_record.dart';

// Certification-linked shift eligibility (Phase 2, agreed 2026-09-30) — a
// worker whose relevant certification has expired shouldn't be schedulable
// for a shift their role requires it for. Two tiers, mirroring the
// JobRole-default-vs-RoleTier-lockout distinction already established in
// job_role.dart:
//
//   1. [systemRequiredCertifications] — a fixed floor per JobRole, based on
//      real UK food-safety/workplace-training expectations. Nobody in the
//      app (not even leadership) can remove an item from this floor — only
//      a code change can, since removing a legally-motivated requirement
//      to "make scheduling easier" is exactly the human-error risk this
//      feature exists to prevent (direct founder concern, 2026-09-30).
//   2. Site+role additions, stored server-side in
//      `site_role_certification_requirements` (siteId, jobRole, itemType) —
//      leadership (regional/executive) can ADD extra requirements on top of
//      the floor, never remove a floor item. See
//      SiteRoleCertificationRequirementRepository.
//
// First Aid is deliberately NOT included here — UK guidance requires at
// least one first-aider covering a shift, not every individual to hold the
// certificate, so it's a shift-coverage check, not a per-person eligibility
// gate. Not yet built (flagged as a later follow-up, not blocking this
// pass).
Set<TrainingItemType> systemRequiredCertifications(JobRole? role) {
  const floor = {TrainingItemType.fireSafety, TrainingItemType.induction};
  switch (role) {
    case JobRole.chefCook:
    case JobRole.kitchenPorter:
    case JobRole.bar:
    case JobRole.management:
      return {
        ...floor,
        TrainingItemType.level2FoodHygiene,
        TrainingItemType.allergenAwareness,
      };
    case JobRole.frontOfHouse:
      return {...floor, TrainingItemType.allergenAwareness};
    case JobRole.maintenance:
    case JobRole.housekeeping:
    case JobRole.reception:
    case JobRole.security:
    case JobRole.everyone:
    case null:
      return floor;
  }
}

/// The full set of certifications a person in [role] at [siteId] currently
/// needs — the system floor plus any site-specific additions a leader has
/// configured. [siteAdditions] is the site's full requirements list (see
/// SiteRoleCertificationRequirementRepository.getForSite), already filtered
/// to this call site by whoever fetched it.
Set<TrainingItemType> requiredCertificationsFor({
  required JobRole? role,
  required List<SiteRoleCertificationRequirement> siteAdditions,
}) {
  final additions = siteAdditions
      .where((r) => r.jobRole == role)
      .map((r) => r.itemType);
  return {...systemRequiredCertifications(role), ...additions};
}

/// True if [records] show every certification [role] requires as currently
/// held (not expired, not missing entirely) — [TrainingStatus.expiringSoon]
/// still counts as eligible, only [TrainingStatus.expired] (or never
/// completed at all) blocks.
bool isCertifiedForRole({
  required JobRole? role,
  required List<TrainingRecord> records,
  required List<SiteRoleCertificationRequirement> siteAdditions,
  DateTime? now,
}) {
  final required = requiredCertificationsFor(
    role: role,
    siteAdditions: siteAdditions,
  );
  if (required.isEmpty) return true;
  final latest = latestPerItem(records);
  for (final itemType in required) {
    final record = latest.cast<TrainingRecord?>().firstWhere(
      (r) => r?.itemType == itemType,
      orElse: () => null,
    );
    if (record == null) return false;
    if (computeTrainingStatus(record.expiresAt, now: now) ==
        TrainingStatus.expired) {
      return false;
    }
  }
  return true;
}

/// Which of the required certifications are currently missing/expired —
/// used to build a specific "you need X" message rather than a bare
/// "ineligible" block.
List<TrainingItemType> missingCertificationsForRole({
  required JobRole? role,
  required List<TrainingRecord> records,
  required List<SiteRoleCertificationRequirement> siteAdditions,
  DateTime? now,
}) {
  final required = requiredCertificationsFor(
    role: role,
    siteAdditions: siteAdditions,
  );
  final latest = latestPerItem(records);
  final missing = <TrainingItemType>[];
  for (final itemType in required) {
    final record = latest.cast<TrainingRecord?>().firstWhere(
      (r) => r?.itemType == itemType,
      orElse: () => null,
    );
    if (record == null ||
        computeTrainingStatus(record.expiresAt, now: now) ==
            TrainingStatus.expired) {
      missing.add(itemType);
    }
  }
  return missing;
}

/// A leadership-added certification requirement on top of the system floor
/// (see systemRequiredCertifications) — additive only, a site can never use
/// this to remove a floor item for its own JobRole.
class SiteRoleCertificationRequirement {
  final int? id;
  final int siteId;
  final JobRole jobRole;
  final TrainingItemType itemType;
  final int addedByUserId;
  final DateTime createdAt;

  const SiteRoleCertificationRequirement({
    required this.id,
    required this.siteId,
    required this.jobRole,
    required this.itemType,
    required this.addedByUserId,
    required this.createdAt,
  });
}
