import '../../l10n/app_localizations.dart';

// Job-role tags (Sprint 031 — HORECA_TASK_ENRICHMENT.md load). A distinct
// dimension from RoleTier: RoleTier is org-level access control (who CAN be
// assigned what — a real lockout); JobRole is content relevance (who a task
// is USUALLY for) and is a default, not a lockout — a manager can still
// assign anything to anyone within their tier's existing access.
//
// Shared by both `User.jobRole` (a person's own day job, single value) and
// `TaskTemplate.jobRole` (which job a task defaults to, also single value)
// — mirrors RoleTier already being reused across both a single-value field
// (User.roleTier) and template applicability. `everyone` is only ever set
// on a TaskTemplate (a handful of hygiene-basics tasks that apply
// regardless of job — e.g. handwashing); it's never offered as a person's
// own job role.
// Departments content build (2026-09-23) — four new values for the
// Maintenance/Housekeeping/Reception/Security task content drafted in
// HORECA_TASK_LIBRARY.md's Segments 22-25. Same "default, not a lockout"
// meaning as every existing value — a manager can still assign any task
// to anyone within that person's own RoleTier access.
enum JobRole {
  chefCook,
  kitchenPorter,
  frontOfHouse,
  bar,
  management,
  everyone,
  maintenance,
  housekeeping,
  reception,
  security,
}

String jobRoleDisplayName(JobRole role, [AppLocalizations? l10n]) {
  if (l10n == null) {
    switch (role) {
      case JobRole.chefCook:
        return 'Chef/Cook';
      case JobRole.kitchenPorter:
        return 'Kitchen Porter';
      case JobRole.frontOfHouse:
        return 'Front of House';
      case JobRole.bar:
        return 'Bar';
      case JobRole.management:
        return 'Management';
      case JobRole.everyone:
        return 'Everyone';
      case JobRole.maintenance:
        return 'Maintenance';
      case JobRole.housekeeping:
        return 'Housekeeping';
      case JobRole.reception:
        return 'Reception';
      case JobRole.security:
        return 'Security';
    }
  }
  switch (role) {
    case JobRole.chefCook:
      return l10n.jobRoleChefCook;
    case JobRole.kitchenPorter:
      return l10n.jobRoleKitchenPorter;
    case JobRole.frontOfHouse:
      return l10n.jobRoleFrontOfHouse;
    case JobRole.bar:
      return l10n.jobRoleBar;
    case JobRole.management:
      return l10n.jobRoleManagement;
    case JobRole.everyone:
      return l10n.jobRoleEveryone;
    case JobRole.maintenance:
      return l10n.jobRoleMaintenance;
    case JobRole.housekeeping:
      return l10n.jobRoleHousekeeping;
    case JobRole.reception:
      return l10n.jobRoleReception;
    case JobRole.security:
      return l10n.jobRoleSecurity;
  }
}
