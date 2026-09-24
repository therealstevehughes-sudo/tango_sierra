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

String jobRoleDisplayName(JobRole role) {
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
