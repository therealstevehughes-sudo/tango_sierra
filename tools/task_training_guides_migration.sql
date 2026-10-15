-- Task training guides (2026-10-15) — a venue's own version of a task's
-- "How to do this correctly" guide. The standard guide for every task is
-- bundled in the app (task_training_guide_data.dart); a row here only
-- exists when a venue manager has customised it for their site. Deleting
-- the row ("Reset to standard") brings the standard guide back.
--
-- Keyed by template_group_id (stable across template versions), so an
-- enriched/re-versioned template keeps the venue's custom guide.

create table if not exists task_training_guides (
  id bigint generated always as identity primary key,
  site_id integer not null references sites(id),
  template_group_id integer not null,
  steps jsonb not null default '[]'::jsonb check (jsonb_typeof(steps) = 'array'),
  why_it_matters text,
  if_it_fails text,
  updated_by_user_id integer references users(id),
  updated_at timestamptz not null default now(),
  unique (site_id, template_group_id)
);

alter table task_training_guides enable row level security;

-- Everyone at the site reads it — the guide is for the worker doing the task.
create policy "task_training_guides_read" on task_training_guides
  for select
  using (can_access_site(site_id));

-- Editing is venueManager+ only, same tiering as shift_periods.
create policy "task_training_guides_insert" on task_training_guides
  for insert
  with check (
    can_access_site(site_id)
    and (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
      in ('venueManager', 'regional', 'executive')
  );

create policy "task_training_guides_update" on task_training_guides
  for update
  using (
    can_access_site(site_id)
    and (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
      in ('venueManager', 'regional', 'executive')
  )
  with check (can_access_site(site_id));

create policy "task_training_guides_delete" on task_training_guides
  for delete
  using (
    can_access_site(site_id)
    and (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
      in ('venueManager', 'regional', 'executive')
  );

grant select, insert, update, delete on task_training_guides to authenticated;
