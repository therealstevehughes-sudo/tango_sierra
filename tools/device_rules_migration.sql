-- Device rules (2026-10-17, founder-approved decisions 6-10).
--
-- * Who can use VenuRite at a branch:
--     branch_and_personal      branch devices and staff's own phones (default)
--     branch_only              only the branch's registered devices
--     personal_rota_training   own phones for rota and training only;
--                              checks only on branch devices
--   No "personal only" option: the branch-device route must always work.
-- * Where staff can clock in/out: any device (default) or branch devices only.
-- * Head office (organisation) sets the default; each branch can override
--   (null on the site = follow head office).
-- * A branch device is registered individually by a manager on that device:
--   it makes its own key pair, the public half is stored here, and pin-login
--   checks a fresh signature on every login — so a shared setup code alone
--   can't turn a staff phone into a "branch device". Lost/stolen devices are
--   removed from the Devices list.
-- * Enforcement is here in the database (triggers on task_submissions and
--   shift_logs), from the session's own signed claims. Leadership logins
--   (email + password, e.g. a manager's laptop) carry no device claim and
--   aren't device-restricted.

begin;

alter table organisations add column if not exists default_device_policy text not null default 'branch_and_personal'
  check (default_device_policy in ('branch_only', 'branch_and_personal', 'personal_rota_training'));
alter table organisations add column if not exists default_clock_policy text not null default 'any'
  check (default_clock_policy in ('branch_only', 'any'));
alter table sites add column if not exists device_policy text
  check (device_policy in ('branch_only', 'branch_and_personal', 'personal_rota_training'));
alter table sites add column if not exists clock_policy text
  check (clock_policy in ('branch_only', 'any'));

create table if not exists branch_devices (
  id bigint generated always as identity primary key,
  site_id integer not null references sites(id),
  name text not null check (length(trim(name)) between 1 and 60),
  public_key text not null,
  registered_by_user_id integer references users(id),
  created_at timestamptz not null default now(),
  last_used_at timestamptz,
  revoked_at timestamptz
);
create index if not exists branch_devices_site_idx on branch_devices (site_id);
alter table branch_devices enable row level security;
revoke all on branch_devices from anon, authenticated;

alter table task_submissions add column if not exists device_kind text
  check (device_kind in ('branch', 'personal'));
alter table task_submissions add column if not exists device_name text;
alter table shift_logs add column if not exists clock_in_device_kind text
  check (clock_in_device_kind in ('branch', 'personal'));
alter table shift_logs add column if not exists clock_in_device_name text;
alter table shift_logs add column if not exists clock_out_device_kind text
  check (clock_out_device_kind in ('branch', 'personal'));
alter table shift_logs add column if not exists clock_out_device_name text;

commit;

create or replace function effective_device_policy(p_site_id integer) returns text
language sql stable security definer as $$
  select coalesce(s.device_policy, o.default_device_policy, 'branch_and_personal')
  from sites s left join organisations o on o.id = s.organisation_id
  where s.id = p_site_id
$$;

create or replace function effective_clock_policy(p_site_id integer) returns text
language sql stable security definer as $$
  select coalesce(s.clock_policy, o.default_clock_policy, 'any')
  from sites s left join organisations o on o.id = s.organisation_id
  where s.id = p_site_id
$$;

-- The session's device, from its signed claims: ('branch', name) for a
-- verified branch device, ('personal', null) for any other PIN login, and
-- (null, null) for leadership logins (not device-restricted).
create or replace function _session_device(out kind text, out name text)
language sql stable as $$
  select
    case
      when c -> 'app_metadata' ->> 'provider' <> 'pin' then null
      when c -> 'app_metadata' ->> 'device_kind' = 'branch' then 'branch'
      else 'personal'
    end,
    case when c -> 'app_metadata' ->> 'device_kind' = 'branch'
         then c -> 'app_metadata' ->> 'device_name' end
  from (select coalesce(current_setting('request.jwt.claims', true), '{}')::jsonb as c) x
$$;

create or replace function device_rules_task_submission() returns trigger
language plpgsql security definer as $$
declare
  d record;
begin
  select * into d from _session_device();
  if d.kind is null then
    return new;  -- leadership login, or a server-side insert
  end if;
  if d.kind <> 'branch' and effective_device_policy(new.site_id) <> 'branch_and_personal' then
    raise exception 'At this venue, checks can only be done on the venue''s own devices.';
  end if;
  new.device_kind := d.kind;
  new.device_name := d.name;
  return new;
end;
$$;
drop trigger if exists task_submissions_device_rules on task_submissions;
create trigger task_submissions_device_rules
  before insert on task_submissions
  for each row execute function device_rules_task_submission();

create or replace function device_rules_shift_log() returns trigger
language plpgsql security definer as $$
declare
  d record;
  clocking_in boolean := tg_op = 'INSERT';
  clocking_out boolean := tg_op = 'UPDATE' and old.clock_out_at is null and new.clock_out_at is not null;
begin
  if not (clocking_in or clocking_out) then
    return new;
  end if;
  select * into d from _session_device();
  if d.kind is null then
    return new;
  end if;
  if d.kind <> 'branch' and (
       effective_clock_policy(new.site_id) = 'branch_only'
       or effective_device_policy(new.site_id) = 'branch_only') then
    raise exception 'At this venue, clocking in and out is only on the venue''s own devices.';
  end if;
  if clocking_in then
    new.clock_in_device_kind := d.kind;
    new.clock_in_device_name := d.name;
  else
    new.clock_out_device_kind := d.kind;
    new.clock_out_device_name := d.name;
  end if;
  return new;
end;
$$;
drop trigger if exists shift_logs_device_rules on shift_logs;
create trigger shift_logs_device_rules
  before insert or update on shift_logs
  for each row execute function device_rules_shift_log();

create or replace function _device_caller_is_manager() returns boolean
language sql stable as $$
  select coalesce(current_setting('request.jwt.claims', true)::jsonb
                  -> 'app_metadata' ->> 'role_tier', '')
         in ('venueManager', 'regional', 'executive')
$$;

-- Devices list + rules for a branch (managers).
create or replace function list_branch_devices(p_site_id integer)
returns table (id bigint, name text, created_at timestamptz, last_used_at timestamptz,
               revoked_at timestamptz)
language plpgsql stable security definer as $$
begin
  if not (can_access_site(p_site_id) and _device_caller_is_manager()) then
    raise exception 'only a manager can see branch devices';
  end if;
  return query select b.id, b.name, b.created_at, b.last_used_at, b.revoked_at
    from branch_devices b where b.site_id = p_site_id order by b.revoked_at nulls first, b.name;
end;
$$;

create or replace function register_branch_device(p_site_id integer, p_name text, p_public_key text,
                                                   p_user_id integer default null)
returns table (device_id bigint)
language plpgsql security definer as $$
declare
  me integer := nullif(current_setting('request.jwt.claims', true)::jsonb
                       -> 'app_metadata' ->> 'local_user_id', '')::integer;
begin
  if not (can_access_site(p_site_id) and _device_caller_is_manager()) then
    raise exception 'only a manager can register a branch device';
  end if;
  if p_public_key !~ '^[A-Za-z0-9+/=_-]{40,60}$' then
    raise exception 'invalid device key';
  end if;
  return query insert into branch_devices (site_id, name, public_key, registered_by_user_id)
    values (p_site_id, trim(p_name), p_public_key,
            coalesce(me, (select u.id from users u where u.supabase_user_id::text = auth.uid()::text limit 1), p_user_id))
    returning branch_devices.id;
end;
$$;

create or replace function revoke_branch_device(p_device_id bigint) returns void
language plpgsql security definer as $$
declare
  s integer;
begin
  select site_id into s from branch_devices where id = p_device_id;
  if s is null or not (can_access_site(s) and _device_caller_is_manager()) then
    raise exception 'only a manager can remove a branch device';
  end if;
  update branch_devices set revoked_at = now() where id = p_device_id and revoked_at is null;
end;
$$;

create or replace function device_rules_for_site(p_site_id integer)
returns table (site_device_policy text, site_clock_policy text,
               org_device_policy text, org_clock_policy text,
               effective_device text, effective_clock text)
language sql stable security definer as $$
  select s.device_policy, s.clock_policy, o.default_device_policy, o.default_clock_policy,
         effective_device_policy(s.id), effective_clock_policy(s.id)
  from sites s left join organisations o on o.id = s.organisation_id
  where s.id = p_site_id and can_access_site(p_site_id)
$$;

-- A branch manager sets their branch (null = follow head office);
-- executives set the head-office default.
create or replace function set_site_device_rules(p_site_id integer, p_device_policy text, p_clock_policy text)
returns void
language plpgsql security definer as $$
begin
  if not (can_access_site(p_site_id) and _device_caller_is_manager()) then
    raise exception 'only a manager can change device rules';
  end if;
  update sites set device_policy = p_device_policy, clock_policy = p_clock_policy where id = p_site_id;
end;
$$;

create or replace function set_org_device_rules(p_device_policy text, p_clock_policy text)
returns void
language plpgsql security definer as $$
declare
  org integer := nullif(current_setting('request.jwt.claims', true)::jsonb
                        -> 'app_metadata' ->> 'organisation_id', '')::integer;
begin
  if org is null or coalesce(current_setting('request.jwt.claims', true)::jsonb
                             -> 'app_metadata' ->> 'role_tier', '') <> 'executive'
     or not can_access_organisation(org) then
    raise exception 'only a director can change the head-office default';
  end if;
  update organisations set default_device_policy = p_device_policy,
                           default_clock_policy = p_clock_policy where id = org;
end;
$$;

revoke execute on function list_branch_devices(integer) from public, anon;
revoke execute on function register_branch_device(integer, text, text, integer) from public, anon;
revoke execute on function revoke_branch_device(bigint) from public, anon;
revoke execute on function device_rules_for_site(integer) from public, anon;
revoke execute on function set_site_device_rules(integer, text, text) from public, anon;
revoke execute on function set_org_device_rules(text, text) from public, anon;
grant execute on function list_branch_devices(integer) to authenticated;
grant execute on function register_branch_device(integer, text, text, integer) to authenticated;
grant execute on function revoke_branch_device(bigint) to authenticated;
grant execute on function device_rules_for_site(integer) to authenticated;
grant execute on function set_site_device_rules(integer, text, text) to authenticated;
grant execute on function set_org_device_rules(text, text) to authenticated;
