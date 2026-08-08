// Five-tier model (Sprint 027, supersedes the original 3-tier top/mid/base).
// Declaration order IS rank order — base=0 through executive=4 — so
// tier.index doubles as its rank; nextRoleTierUp() relies on this.
// Each tier is a distinct escalation/visibility boundary: a problem rolls
// up exactly one level (see roleTierRank/nextRoleTierUp below).
enum RoleTier { base, supervisor, venueManager, regional, executive }

int roleTierRank(RoleTier tier) => tier.index;

// The tier one level above [tier], or null if [tier] is already the top
// (executive) — nothing escalates further.
RoleTier? nextRoleTierUp(RoleTier tier) {
  final nextIndex = tier.index + 1;
  if (nextIndex >= RoleTier.values.length) return null;
  return RoleTier.values[nextIndex];
}

// Friendly labels for wherever a tier is shown to a user (Sprint 031 —
// "Tier display names"). UI-label-only: the stored enum value (`.name`,
// e.g. 'venueManager') never changes — only what's rendered on screen.
// Every call site that puts a RoleTier in front of a user should go
// through this, not `tier.name` directly.
String roleTierDisplayName(RoleTier tier) {
  switch (tier) {
    case RoleTier.base:
      return 'Team Member';
    case RoleTier.supervisor:
      return 'Supervisor';
    case RoleTier.venueManager:
      return 'Manager';
    case RoleTier.regional:
      return 'Regional Manager';
    case RoleTier.executive:
      return 'Director';
  }
}

enum TemperatureUnit { celsius, fahrenheit }

class User {
  final int id;
  final String name;
  final String jobTitle;
  final RoleTier roleTier;
  final TemperatureUnit preferredTemperatureUnit;
  final int siteId;
  final bool active;
  final DateTime? deactivatedAt;
  final int? deactivatedByUserId;

  const User({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.roleTier,
    this.preferredTemperatureUnit = TemperatureUnit.celsius,
    required this.siteId,
    this.active = true,
    this.deactivatedAt,
    this.deactivatedByUserId,
  });
}
