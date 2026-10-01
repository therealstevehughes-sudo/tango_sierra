-- Rota calendar, Sprint 1 (2026-10-01) — leadership-configured shift
-- periods (2 or 3 per site, e.g. Morning/Afternoon/Night), used to
-- categorise shifts for the upcoming calendar views' period filter.

create table if not exists shift_periods (
  id bigint generated always as identity primary key,
  site_id integer not null references sites(id),
  name text not null,
  start_minutes integer not null check (start_minutes >= 0 and start_minutes < 1440),
  end_minutes integer not null check (end_minutes >= 0 and end_minutes < 1440),
  sort_order integer not null default 0
);

alter table shift_periods enable row level security;

create policy "shift_periods_read" on shift_periods
  for select
  using (can_access_site(site_id));

-- Write restricted to venueManager+ — leadership configures the shape of
-- the whole day for a site, not something every staff member edits.
create policy "shift_periods_write" on shift_periods
  for insert
  with check (
    can_access_site(site_id)
    and (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
      in ('venueManager', 'regional', 'executive')
  );

create policy "shift_periods_delete" on shift_periods
  for delete
  using (
    can_access_site(site_id)
    and (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
      in ('venueManager', 'regional', 'executive')
  );
