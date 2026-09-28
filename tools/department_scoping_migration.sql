-- Department scoping for equipment delegation (2026-09-28, direct founder
-- request) — see Area.departmentId/Equipment.departmentId's own doc
-- comments in the Flutter models for the full reasoning. Both nullable:
-- existing rows have no department until set, same additive-column
-- pattern as every prior migration here.
alter table areas add column if not exists department_id integer references departments(id);
alter table equipment_instances add column if not exists department_id integer references departments(id);
