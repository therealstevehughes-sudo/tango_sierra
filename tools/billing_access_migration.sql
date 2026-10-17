-- Billing access (2026-10-17, founder rule): Billing is visible only to the
-- organisation's Directors (executive tier) and to people a Director has
-- explicitly allowed. Only Directors can set up or change payment
-- (gocardless-start-mandate already enforces executive). Also closes a gap
-- from billing v2: my_billing_quote() only checked organisation access, so
-- any signed-in staff member could read the organisation's prices.

begin;

alter table users add column if not exists billing_access boolean not null default false;

-- Caller is a Director of p_org, or has been granted billing access in it.
-- Works for PIN sessions (local_user_id claim) and email/password
-- (GoTrue) sessions (auth.uid() -> users.supabase_user_id).
create or replace function can_view_billing(p_org integer) returns boolean
language sql stable security definer as $$
  select can_access_organisation(p_org) and (
    (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier') = 'executive'
    or exists (
      select 1 from users u
      where u.organisation_id = p_org
        and u.active
        and u.billing_access
        and (
          u.id = nullif(current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'local_user_id', '')::integer
          or u.supabase_user_id = auth.uid()
        )
    )
  );
$$;
revoke execute on function can_view_billing(integer) from public, anon;
grant execute on function can_view_billing(integer) to authenticated;

drop policy if exists "subscriptions_read_own" on subscriptions;
create policy "subscriptions_read_own" on subscriptions
  for select using (can_view_billing(organisation_id));

create or replace function my_billing_quote()
returns table (monthly_pence integer, branches integer, head_office boolean, breakdown jsonb)
language plpgsql stable security definer as $$
declare
  org integer := nullif(current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id', '')::integer;
begin
  if org is null or not can_view_billing(org) then
    return;
  end if;
  return query select * from org_billing_quote(org);
end;
$$;

-- Directors grant/withdraw billing access for someone in their own
-- organisation. Never for themselves (they already have it).
create or replace function set_billing_access(p_user_id integer, p_granted boolean)
returns void
language plpgsql security definer as $$
declare
  org integer := nullif(current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id', '')::integer;
begin
  if (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier') <> 'executive'
     or org is null or not can_access_organisation(org) then
    raise exception 'only a Director can change billing access';
  end if;
  update users set billing_access = p_granted
    where id = p_user_id and organisation_id = org;
  if not found then
    raise exception 'that person is not in your organisation';
  end if;
end;
$$;
revoke execute on function set_billing_access(integer, boolean) from public, anon;
grant execute on function set_billing_access(integer, boolean) to authenticated;

-- users has a broad tenant_isolation FOR ALL policy (staff at a site can
-- update user rows there — the organogram/staff screens rely on it), so
-- the column itself is guarded: only set_billing_access (SECURITY DEFINER,
-- runs as the table owner) may change it, never a direct API write.
create or replace function guard_billing_access() returns trigger
language plpgsql as $$
begin
  if new.billing_access is distinct from old.billing_access
     and current_user in ('authenticated', 'anon') then
    raise exception 'billing access can only be changed by a Director';
  end if;
  return new;
end;
$$;
drop trigger if exists users_guard_billing_access on users;
create trigger users_guard_billing_access before update on users
  for each row execute function guard_billing_access();

commit;

-- App helper: "can I see Billing?" — returns one row (PostgREST rpc shape
-- the app's BackendRestClient expects) so the menu asks the server rather
-- than trusting anything cached on the device.
create or replace function my_billing_access()
returns table (allowed boolean, can_manage boolean)
language plpgsql stable security definer as $$
declare
  org integer := nullif(current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id', '')::integer;
begin
  return query select
    coalesce(org is not null and can_view_billing(org), false),
    coalesce((current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier') = 'executive', false);
end;
$$;
revoke execute on function my_billing_access() from public, anon;
grant execute on function my_billing_access() to authenticated;
