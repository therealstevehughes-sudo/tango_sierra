import '../../l10n/app_localizations.dart';
import 'job_role.dart';

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
String roleTierDisplayName(RoleTier tier, [AppLocalizations? l10n]) {
  if (l10n == null) {
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
  switch (tier) {
    case RoleTier.base:
      return l10n.tierTeamMember;
    case RoleTier.supervisor:
      return l10n.tierSupervisor;
    case RoleTier.venueManager:
      return l10n.tierManager;
    case RoleTier.regional:
      return l10n.tierRegionalManager;
    case RoleTier.executive:
      return l10n.tierDirector;
  }
}

// Organogram permission checks (2026-09-27) — roleTierRank existed before
// this only for sorting/escalation-suggestion, never for gating an actual
// action. These three are the real outrank rules for the branch organogram
// (and the retrofitted Staff Management actions): nobody can act on a peer
// or superior, and nobody can hand out a tier at or above their own rank.
// Deliberately does NOT cover reportsToUserId changes ("change manager") —
// that stays unrestricted, per the deliberate standing decision that an
// informal reporting line isn't this app's business to police.
bool canChangeTier({
  required RoleTier actingTier,
  required RoleTier targetTier,
  required RoleTier newTier,
}) =>
    roleTierRank(actingTier) > roleTierRank(targetTier) &&
    roleTierRank(newTier) < roleTierRank(actingTier);

bool canDeactivate({
  required RoleTier actingTier,
  required RoleTier targetTier,
}) => roleTierRank(actingTier) > roleTierRank(targetTier);

bool canMoveDepartment({
  required RoleTier actingTier,
  required RoleTier targetTier,
}) => roleTierRank(actingTier) >= roleTierRank(targetTier);

enum TemperatureUnit { celsius, fahrenheit }

class User {
  final int id;
  final String name;
  final String jobTitle;
  final RoleTier roleTier;
  // Nullable: rows created before Sprint 031's job-role tagging predate
  // this field. Null means "not yet formalised", not "everyone" — see
  // JobRole's own doc comment for why those two states can't collide.
  final JobRole? jobRole;
  final TemperatureUnit preferredTemperatureUnit;
  // Nullable since Phase C1b — a freshly signed-up executive (Director)
  // has no home site until they create the company's first branch. Every
  // other tier (base/supervisor/venueManager, and a regional's home site)
  // always has one; those call sites unwrap it with `!` and a note.
  final int? siteId;
  final bool active;
  final DateTime? deactivatedAt;
  final int? deactivatedByUserId;
  // Departments (Sprint 031, Build Order item 5, Sub-sprint B). Nullable
  // and genuinely optional — not every venue or every staff member has one
  // assigned. Distinct from jobRole ("what you do") and roleTier ("how much
  // you can see/escalate to") — this is "which part of the venue."
  final int? departmentId;
  // Teams (2026-09-18) — a finer subdivision within departmentId, e.g.
  // "Night Team" inside "Kitchen". Nullable and independent of
  // departmentId — a person can be in a department with no specific team.
  final int? teamId;
  // Phase B0 — set only for regional-tier accounts: which one region they
  // oversee (one region per manager). Null for every other tier.
  final int? regionId;
  // Chain of command (2026-09-15) — a real named person this user reports
  // to, set per-individual rather than derived from tier/job-role (the
  // user explicitly wanted this, since a fixed role rule like "Kitchen
  // Porters report to Head Chef" doesn't hold at every branch). Nullable
  // — unassigned until a manager sets it via Staff Management; the branch
  // organogram and issue escalation both treat null as "unassigned."
  final int? reportsToUserId;
  // Realtime push (2026-09-16) — this device's current FCM token, so the
  // backend knows where to send a push for this person. Nullable — most
  // rows predate this feature, and a local-only install has nowhere to
  // send a push anyway. "Last device wins," not a device list.
  final String? fcmToken;
  // Preferred app display language for this person, e.g. "en", "pl",
  // "ar". Null means "use the device/site default."
  final String? preferredLocale;

  const User({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.roleTier,
    this.jobRole,
    this.preferredTemperatureUnit = TemperatureUnit.celsius,
    this.siteId,
    this.active = true,
    this.deactivatedAt,
    this.deactivatedByUserId,
    this.departmentId,
    this.teamId,
    this.regionId,
    this.reportsToUserId,
    this.fcmToken,
    this.preferredLocale,
  });

  // Settings shell (Sprint 031, Build Order item 5, Sub-sprint C) — needed
  // so a self-serve preference change (temperature unit) can update the
  // already-logged-in currentUserProvider in place, without a re-login.
  User copyWith({
    TemperatureUnit? preferredTemperatureUnit,
    String? preferredLocale,
  }) {
    return User(
      id: id,
      name: name,
      jobTitle: jobTitle,
      roleTier: roleTier,
      jobRole: jobRole,
      preferredTemperatureUnit:
          preferredTemperatureUnit ?? this.preferredTemperatureUnit,
      siteId: siteId,
      active: active,
      deactivatedAt: deactivatedAt,
      deactivatedByUserId: deactivatedByUserId,
      departmentId: departmentId,
      teamId: teamId,
      regionId: regionId,
      reportsToUserId: reportsToUserId,
      fcmToken: fcmToken,
      preferredLocale: preferredLocale ?? this.preferredLocale,
    );
  }
}
