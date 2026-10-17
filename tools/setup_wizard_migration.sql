-- Setup Wizard redesign (2026-10-17, founder-approved top-down order +
-- AI conversation + 3 tweaks). Tweak 3: progress is saved after every
-- step, so a director can stop and come back - one draft per business.
-- Tweak 2: branch search (Apify / Google Maps) is capped per business per
-- day so it can't run up a bill.

create table if not exists setup_wizard_drafts (
  organisation_id integer primary key references organisations(id),
  draft jsonb not null,
  completed_at timestamptz,
  updated_at timestamptz not null default now()
);
alter table setup_wizard_drafts enable row level security;
revoke all on setup_wizard_drafts from anon, authenticated;

create table if not exists branch_search_log (
  id bigint generated always as identity primary key,
  organisation_id integer not null,
  query text,
  searched_at timestamptz not null default now()
);
alter table branch_search_log enable row level security;
revoke all on branch_search_log from anon, authenticated;

create or replace function _setup_caller_org() returns integer
language plpgsql stable as $$
declare
  c jsonb := coalesce(current_setting('request.jwt.claims', true), '{}')::jsonb;
  org integer := nullif(c -> 'app_metadata' ->> 'organisation_id', '')::integer;
begin
  if org is null or c -> 'app_metadata' ->> 'role_tier' <> 'executive'
     or not can_access_organisation(org) then
    raise exception 'only a director can run the business setup';
  end if;
  return org;
end;
$$;

create or replace function get_setup_draft()
returns table (draft jsonb, completed_at timestamptz, updated_at timestamptz)
language plpgsql stable security definer as $$
declare org integer := _setup_caller_org();
begin
  return query select d.draft, d.completed_at, d.updated_at
    from setup_wizard_drafts d where d.organisation_id = org;
end;
$$;

create or replace function save_setup_draft(p_draft jsonb, p_completed boolean default false)
returns void language plpgsql security definer as $$
declare org integer := _setup_caller_org();
begin
  insert into setup_wizard_drafts (organisation_id, draft, completed_at, updated_at)
    values (org, p_draft, case when p_completed then now() end, now())
  on conflict (organisation_id) do update
    set draft = excluded.draft,
        completed_at = case when p_completed then now() else setup_wizard_drafts.completed_at end,
        updated_at = now();
end;
$$;

-- Called by the branch-search Edge Function (service role) to enforce the
-- daily cap: returns true and logs the search if under 25 today.
create or replace function claim_branch_search(p_org integer, p_query text)
returns boolean language plpgsql security definer as $$
begin
  if (select count(*) from branch_search_log
      where organisation_id = p_org and searched_at > now() - interval '1 day') >= 25 then
    return false;
  end if;
  insert into branch_search_log (organisation_id, query) values (p_org, left(p_query, 200));
  return true;
end;
$$;

revoke execute on function get_setup_draft() from public, anon;
revoke execute on function save_setup_draft(jsonb, boolean) from public, anon;
revoke execute on function claim_branch_search(integer, text) from public, anon, authenticated;
grant execute on function get_setup_draft() to authenticated;
grant execute on function save_setup_draft(jsonb, boolean) to authenticated;
grant execute on function claim_branch_search(integer, text) to service_role;
