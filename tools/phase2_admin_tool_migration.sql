-- Account-management/admin tool, part 1 (Plan B, 2026-09-30) — superadmin
-- infrastructure: a small admin_users table (just the VenuRite team, not
-- tenant staff) and additive read-only RLS policies granting superadmins
-- cross-tenant visibility, without touching or weakening any existing
-- tenant_isolation policy (Postgres RLS policies on the same table are
-- OR'd together, so this is purely additive).

create table if not exists admin_users (
  id bigint generated always as identity primary key,
  supabase_auth_uid uuid not null unique,
  email text not null,
  name text not null,
  created_at timestamptz not null default now()
);

alter table admin_users enable row level security;

-- A superadmin can see the admin_users list (so the UI can show "you're
-- logged in as X"); no INSERT/UPDATE/DELETE policy at all - rows are
-- added directly by the VenuRite team via SSH, matching this app's
-- existing "no self-signup for leadership-level access" convention.
create policy "admin_users_self_read" on admin_users
  for select
  using (supabase_auth_uid = auth.uid());

create or replace function is_superadmin() returns boolean
language sql stable
as $$
  select exists (select 1 from admin_users where supabase_auth_uid = auth.uid());
$$;

-- Additive cross-tenant READ ONLY policies. Never a write policy here -
-- the admin tool's own actions (block/grant free access) go through the
-- existing, already-scoped columns (subscriptions.restricted_at,
-- subscriptions.free_access_granted) via the tenant_isolation policy's
-- own executive-role path, OR a dedicated RPC if that path doesn't fit -
-- see part 2 of this migration for the actual action functions.
create policy "superadmin_read_organisations" on organisations
  for select using (is_superadmin());

create policy "superadmin_read_subscriptions" on subscriptions
  for select using (is_superadmin());

create policy "superadmin_read_sites" on sites
  for select using (is_superadmin());

create policy "superadmin_read_users" on users
  for select using (is_superadmin());

create policy "superadmin_read_service_provider_unlocks" on service_provider_unlocks
  for select using (is_superadmin());

-- Part 2: superadmin WRITE actions, as dedicated SECURITY DEFINER RPCs
-- rather than a table policy - subscriptions' own write policy requires
-- role_tier='executive' AND can_access_organisation(), which a superadmin
-- session (an admin_users row, not a tenant JWT with an organisation_id
-- claim) can never satisfy. v1 manual actions only, per the agreed
-- "automation is a fast-follow" scope - a superadmin explicitly toggles
-- these, nothing fires on its own yet.
create or replace function admin_set_subscription_restricted(
  p_organisation_id integer,
  p_restricted boolean
)
returns void
language plpgsql
security definer
as $$
begin
  if not is_superadmin() then
    raise exception 'not authorized';
  end if;
  update subscriptions
    set restricted_at = case when p_restricted then now() else null end,
        updated_at = now()
    where organisation_id = p_organisation_id;
end;
$$;

create or replace function admin_set_free_access(
  p_organisation_id integer,
  p_granted boolean
)
returns void
language plpgsql
security definer
as $$
begin
  if not is_superadmin() then
    raise exception 'not authorized';
  end if;
  update subscriptions
    set free_access_granted = p_granted,
        updated_at = now()
    where organisation_id = p_organisation_id;
end;
$$;
