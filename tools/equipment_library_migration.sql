-- Equipment library (2026-10-17, plan research_notes/equipment_library_plan_2026-10.md,
-- built as approved). Model-specific "packs" (checks + steps) live on the
-- server and are searched on demand, so the app stays small however big
-- the library gets.
--   status 'live'   — VenuRite's checked library, visible to everyone
--   status 'venue'  — drafted by a venue (AI-assisted, approved by its own
--                     manager); visible only to that business, and waiting
--                     in VenuRite's review queue to be promoted to 'live'
--   status 'retired'
-- checks: [{"title","frequency","method":"tick|data","min","max","unit",
--           "critical":bool,"photo":bool,"steps":[...],"why","if_fails"}]

create table if not exists equipment_models (
  id bigint generated always as identity primary key,
  manufacturer text not null,
  model text not null,
  equipment_type_id integer references equipment_types(id),
  aliases text,
  checks jsonb not null default '[]',
  manual_url text,
  source_urls text[],
  checked_on date,
  status text not null default 'live' check (status in ('live', 'venue', 'retired')),
  organisation_id integer references organisations(id),
  created_by_user_id integer references users(id),
  created_at timestamptz not null default now(),
  check ((status = 'venue') = (organisation_id is not null))
);
create index if not exists equipment_models_search_idx
  on equipment_models (lower(manufacturer), lower(model));
alter table equipment_models enable row level security;
revoke all on equipment_models from anon, authenticated;

create or replace function _equipment_caller_org() returns integer
language sql stable as $$
  select nullif(current_setting('request.jwt.claims', true)::jsonb
                -> 'app_metadata' ->> 'organisation_id', '')::integer
$$;

-- Search the library (and the caller's own business's approved drafts).
create or replace function search_equipment_models(p_query text)
returns table (id bigint, manufacturer text, model text, equipment_type_id integer,
               equipment_type_name text, check_count integer, status text,
               checked_on date)
language sql stable security definer as $$
  select m.id, m.manufacturer, m.model, m.equipment_type_id, et.name,
         jsonb_array_length(m.checks), m.status, m.checked_on
  from equipment_models m
  left join equipment_types et on et.id = m.equipment_type_id
  where (m.status = 'live' or (m.status = 'venue' and m.organisation_id = _equipment_caller_org()))
    and length(trim(p_query)) >= 2
    and (lower(m.manufacturer || ' ' || m.model || ' ' || coalesce(m.aliases, ''))
           like '%' || lower(trim(p_query)) || '%'
         or lower(m.model) like '%' || lower(trim(p_query)) || '%')
  order by m.status = 'live' desc, m.manufacturer, m.model
  limit 30
$$;

create or replace function get_equipment_model(p_id bigint)
returns table (id bigint, manufacturer text, model text, equipment_type_id integer,
               checks jsonb, manual_url text, source_urls text[], checked_on date, status text)
language sql stable security definer as $$
  select m.id, m.manufacturer, m.model, m.equipment_type_id, m.checks, m.manual_url,
         m.source_urls, m.checked_on, m.status
  from equipment_models m
  where m.id = p_id
    and (m.status = 'live' or (m.status = 'venue' and m.organisation_id = _equipment_caller_org()))
$$;

-- A manager saves an approved, AI-drafted pack for a model not in the
-- library: usable straight away by their own business, queued for us.
create or replace function save_venue_equipment_model(
  p_manufacturer text, p_model text, p_equipment_type_id integer, p_checks jsonb,
  p_user_id integer default null
) returns table (model_id bigint)
language plpgsql security definer as $$
declare
  org integer := _equipment_caller_org();
begin
  if org is null or coalesce(current_setting('request.jwt.claims', true)::jsonb
                             -> 'app_metadata' ->> 'role_tier', '')
                    not in ('venueManager', 'regional', 'executive')
     or not can_access_organisation(org) then
    raise exception 'only a manager can add an equipment model';
  end if;
  if jsonb_typeof(p_checks) <> 'array' or jsonb_array_length(p_checks) = 0 then
    raise exception 'add at least one check';
  end if;
  return query insert into equipment_models
      (manufacturer, model, equipment_type_id, checks, status, organisation_id, created_by_user_id)
    values (trim(p_manufacturer), trim(p_model), p_equipment_type_id, p_checks, 'venue', org,
            coalesce(nullif(current_setting('request.jwt.claims', true)::jsonb
                            -> 'app_metadata' ->> 'local_user_id', '')::integer, p_user_id))
    returning equipment_models.id;
end;
$$;

revoke execute on function search_equipment_models(text) from public, anon;
revoke execute on function get_equipment_model(bigint) from public, anon;
revoke execute on function save_venue_equipment_model(text, text, integer, jsonb, integer) from public, anon;
grant execute on function search_equipment_models(text) to authenticated;
grant execute on function get_equipment_model(bigint) to authenticated;
grant execute on function save_venue_equipment_model(text, text, integer, jsonb, integer) to authenticated;
