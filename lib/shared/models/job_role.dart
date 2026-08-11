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
enum JobRole { chefCook, kitchenPorter, frontOfHouse, bar, management, everyone }

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
  }
}
