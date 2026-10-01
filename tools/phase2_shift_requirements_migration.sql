-- Rota calendar, Sprint 3 (2026-10-01) — master rota settings
-- (ShiftRequirement) + the shifts.is_standby flag Sprint 3's "generate
-- shifts" action needs.

alter table shifts add column if not exists is_standby boolean not null default false;

create table if not exists shift_requirements (
  id bigint generated always as identity primary key,
  site_id integer not null references sites(id),
  department_id integer references departments(id),
  job_role text,
  period_id bigint not null references shift_periods(id),
  day_of_week integer not null check (day_of_week between 1 and 7),
  required_count integer not null default 1,
  standby_count integer not null default 0
);

alter table shift_requirements enable row level security;

create policy "shift_requirements_read" on shift_requirements
  for select
  using (can_access_site(site_id));

-- Write restricted to venueManager+ — same "leadership configures the
-- shape of the rota" gate as shift_periods itself.
create policy "shift_requirements_write" on shift_requirements
  for insert
  with check (
    can_access_site(site_id)
    and (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
      in ('venueManager', 'regional', 'executive')
  );

create policy "shift_requirements_delete" on shift_requirements
  for delete
  using (
    can_access_site(site_id)
    and (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
      in ('venueManager', 'regional', 'executive')
  );
