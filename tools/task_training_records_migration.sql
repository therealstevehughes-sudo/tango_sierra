-- Training section (2026-10-15, founder-approved) — proof that each staff
-- member has read the guide for every task they're assigned, plus a
-- manager's "watched them do it" competence sign-off for critical tasks.
-- A person's training list is NOT stored: it's derived from their active
-- task_schedules, so it can never go stale.
--
-- guide_version is a short content hash of the guide the person actually
-- read (standard or the venue's own version). When a venue manager edits
-- a guide its hash changes, so staff are asked to read it again — the old
-- acknowledgement stays as history.

create table if not exists training_acknowledgements (
  id bigint generated always as identity primary key,
  user_id integer not null references users(id),
  site_id integer not null references sites(id),
  template_group_id integer not null,
  guide_version text not null,
  acknowledged_at timestamptz not null default now(),
  unique (user_id, template_group_id, guide_version)
);

create index if not exists training_acknowledgements_site_idx
  on training_acknowledgements (site_id);

alter table training_acknowledgements enable row level security;

create policy "training_acknowledgements_read" on training_acknowledgements
  for select
  using (can_access_site(site_id));

-- Only for yourself: a PIN session's local_user_id claim must match the
-- row. GoTrue (Leadership) sessions carry no such claim — same accepted
-- gap as claim_shift (tools/phase2_rpc_identity_hardening_migration.sql).
create policy "training_acknowledgements_insert" on training_acknowledgements
  for insert
  with check (
    can_access_site(site_id)
    and (
      nullif(current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'local_user_id', '') is null
      or (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'local_user_id')::integer = user_id
    )
  );

create table if not exists training_competence_signoffs (
  id bigint generated always as identity primary key,
  user_id integer not null references users(id),
  site_id integer not null references sites(id),
  template_group_id integer not null,
  signed_off_by_user_id integer not null references users(id),
  signed_off_at timestamptz not null default now(),
  unique (user_id, template_group_id),
  check (user_id <> signed_off_by_user_id)
);

create index if not exists training_competence_signoffs_site_idx
  on training_competence_signoffs (site_id);

alter table training_competence_signoffs enable row level security;

create policy "training_competence_signoffs_read" on training_competence_signoffs
  for select
  using (can_access_site(site_id));

-- venueManager+ only (role from the caller's own JWT), signing as
-- themselves, never for their own competence (also a table check above).
create policy "training_competence_signoffs_insert" on training_competence_signoffs
  for insert
  with check (
    can_access_site(site_id)
    and (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
      in ('venueManager', 'regional', 'executive')
    and (
      nullif(current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'local_user_id', '') is null
      or (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'local_user_id')::integer = signed_off_by_user_id
    )
  );

-- Withdrawing a sign-off (e.g. given by mistake) — same gate.
create policy "training_competence_signoffs_delete" on training_competence_signoffs
  for delete
  using (
    can_access_site(site_id)
    and (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
      in ('venueManager', 'regional', 'executive')
  );

grant select, insert on training_acknowledgements to authenticated;
grant select, insert, delete on training_competence_signoffs to authenticated;
