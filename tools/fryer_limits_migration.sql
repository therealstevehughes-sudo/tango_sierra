-- Fryer oil thresholds (2026-10-17, founder-approved): amber over 180°C
-- (still a pass, with a "turn it down" warning), red/fail over 185°C.
-- Each venue can change both.
alter table sites add column if not exists fryer_amber_c integer not null default 180;
alter table sites add column if not exists fryer_red_c integer not null default 185;
do $$ begin
  alter table sites add constraint sites_fryer_limits_check
    check (fryer_amber_c between 120 and 230 and fryer_red_c between 120 and 230
           and fryer_amber_c < fryer_red_c);
exception when duplicate_object then null; end $$;

-- The library task now fails only above the red line.
update task_templates
  set max_limit = 185,
      fix_instructions = '[BEST] Fryer oil: amber above 180°C (turn the thermostat down), fail above 185°C. Your venue can change both. No UK legal limit - industry best practice.'
  where title = 'Oil temperature' and organisation_id is null;

create or replace function set_fryer_limits(p_site_id integer, p_amber integer, p_red integer)
returns void language plpgsql security definer as $$
begin
  if not (can_access_site(p_site_id)
          and coalesce(current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier', '')
              in ('venueManager', 'regional', 'executive')) then
    raise exception 'only a manager can change fryer limits';
  end if;
  update sites set fryer_amber_c = p_amber, fryer_red_c = p_red where id = p_site_id;
end;
$$;
revoke execute on function set_fryer_limits(integer, integer, integer) from public, anon;
grant execute on function set_fryer_limits(integer, integer, integer) to authenticated;
