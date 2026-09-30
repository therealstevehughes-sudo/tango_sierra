-- Phase 2, certification-expiry shift eligibility, part 2 (2026-09-30).
-- Run via the same method as every prior migration in this file's folder:
-- SSH in, `docker exec -i supabase-db psql -U postgres -d postgres <
-- this_file.sql`, then `docker restart supabase-rest`.

create table if not exists site_role_certification_requirements (
  id bigint generated always as identity primary key,
  site_id integer not null references sites(id),
  job_role text not null,
  item_type text not null,
  added_by_user_id integer not null references users(id),
  created_at timestamptz not null default now(),
  unique (site_id, job_role, item_type)
);

alter table site_role_certification_requirements enable row level security;

-- Read: anyone who can access the site (matches every other site-scoped
-- table's tenant_isolation policy). Write: leadership only — regional or
-- executive role_tier, read the same way every other leadership-gated
-- policy in this backend reads it (see service_provider_directory_migration.sql
-- and BACKEND_INFRA.md line ~407): claims live under
-- request.jwt.claims -> app_metadata, not a bare auth.jwt() claim.
create policy "site_role_certification_requirements_read" on site_role_certification_requirements
  for select
  using (can_access_site(site_id));

create policy "site_role_certification_requirements_write" on site_role_certification_requirements
  for insert
  with check (
    can_access_site(site_id)
    and (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
      in ('regional', 'executive')
  );

create policy "site_role_certification_requirements_delete" on site_role_certification_requirements
  for delete
  using (
    can_access_site(site_id)
    and (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
      in ('regional', 'executive')
  );
