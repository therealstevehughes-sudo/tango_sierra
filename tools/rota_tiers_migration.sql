-- Rota tiers (2026-10-17, founder-approved plan N).
--
-- 1. users.books_shifts: who books shifts on the rota. Staff and
--    supervisors default on; venue managers and above default off
--    (salaried). Set by the Branch Manager in Staff Management.
-- 2. shift_requirements.min_tier / shifts.min_tier: null = any staff,
--    'supervisor' = supervisor or above. A master-rota line like
--    "Sat night: 1 Supervisor + 4 Staff" is two requirement rows.
-- 3. claim_shift / manager_assign_shift re-created from the live bodies
--    with the tier gate (claim_shift also refuses people off the rota).

-- First run only, so re-applying never overwrites a manager's choices.
do $$ begin
  if not exists (select 1 from information_schema.columns
                 where table_name = 'users' and column_name = 'books_shifts') then
    alter table users add column books_shifts boolean not null default true;
    update users set books_shifts = false
      where role_tier in ('venueManager', 'regional', 'executive');
  end if;
end $$;

alter table shift_requirements add column if not exists min_tier text;
alter table shifts add column if not exists min_tier text;

do $$ begin
  alter table shift_requirements add constraint shift_requirements_min_tier_check
    check (min_tier is null or min_tier = 'supervisor');
exception when duplicate_object then null; end $$;
do $$ begin
  alter table shifts add constraint shifts_min_tier_check
    check (min_tier is null or min_tier = 'supervisor');
exception when duplicate_object then null; end $$;

-- Only managers change who is on the rota.
create or replace function users_guard_books_shifts() returns trigger
language plpgsql as $$
declare
  caller_tier text := current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier';
begin
  if new.books_shifts is distinct from old.books_shifts
     and current_user in ('authenticated', 'anon')
     and coalesce(caller_tier, '') not in ('venueManager', 'regional', 'executive') then
    raise exception 'only a manager can change who books shifts';
  end if;
  return new;
end $$;
drop trigger if exists users_guard_books_shifts on users;
create trigger users_guard_books_shifts before update on users
  for each row execute function users_guard_books_shifts();

CREATE OR REPLACE FUNCTION public.claim_shift(p_shift_id bigint, p_user_id integer)
 RETURNS SETOF shifts
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
  target_site_id integer;
  target_priority_until timestamptz;
  target_category text;
  category_cap jsonb;
  weekly_count int;
  target_job_role text;
  cert_ineligible boolean;
  caller_local_user_id integer;
  target_min_tier text;
  claimant_tier text;
  claimant_books boolean;
begin
  select site_id, priority_until, category, min_tier
    into target_site_id, target_priority_until, target_category, target_min_tier
    from shifts where id = p_shift_id;

  if target_site_id is null then
    return;
  end if;

  if not (can_access_site(target_site_id) and roster_addon_active(target_site_id)) then
    return;
  end if;

  -- Identity check (2026-10-02) — see this migration's header comment.
  -- Only enforced when the session actually carries a local_user_id
  -- claim (PIN sessions); a GoTrue session has none, so this is a no-op
  -- for that path, same as before.
  caller_local_user_id := nullif((current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'local_user_id'), '')::integer;
  if caller_local_user_id is not null and caller_local_user_id <> p_user_id then
    return;
  end if;

  select job_role, role_tier, coalesce(books_shifts, true)
    into target_job_role, claimant_tier, claimant_books
    from users where id = p_user_id;

  -- Rota tiers (2026-10-17): only people on the rota can book, and a
  -- supervisor shift needs a supervisor or above.
  if not claimant_books then
    return;
  end if;
  if target_min_tier = 'supervisor' and coalesce(claimant_tier, 'base') = 'base' then
    return;
  end if;

  with required_certs as (
    select unnest(
      case target_job_role
        when 'chefCook' then array['fireSafety','induction','level2FoodHygiene','allergenAwareness']
        when 'kitchenPorter' then array['fireSafety','induction','level2FoodHygiene','allergenAwareness']
        when 'bar' then array['fireSafety','induction','level2FoodHygiene','allergenAwareness']
        when 'management' then array['fireSafety','induction','level2FoodHygiene','allergenAwareness']
        when 'frontOfHouse' then array['fireSafety','induction','allergenAwareness']
        else array['fireSafety','induction']
      end
    ) as item_type
    union
    select item_type from site_role_certification_requirements
      where site_id = target_site_id and job_role = target_job_role
  ),
  latest_records as (
    select distinct on (item_type) item_type, expires_at
    from training_records
    where user_id = p_user_id
    order by item_type, completed_at desc
  )
  select exists (
    select 1 from required_certs rc
    left join latest_records lr on lr.item_type = rc.item_type
    where lr.item_type is null
       or (lr.expires_at is not null and lr.expires_at < now())
  ) into cert_ineligible;

  if cert_ineligible then
    return;
  end if;

  if target_priority_until is not null and now() < target_priority_until then
    declare
      reliability_kept int;
      reliability_cancelled_early int;
      reliability_cancelled_late int;
      reliability_score numeric;
    begin
      with latest_events as (
        select distinct on (sc.shift_id)
          sc.shift_id, sc.event_type, sc.created_at, s.starts_at
        from shift_claims sc
        join shifts s on s.id = sc.shift_id
        where sc.user_id = p_user_id
          and sc.created_at >= now() - interval '90 days'
        order by sc.shift_id, sc.created_at desc
      )
      select
        count(*) filter (where event_type in ('claimed', 'manager_assigned')),
        count(*) filter (
          where event_type = 'cancelled'
            and starts_at - created_at >= interval '24 hours'
        ),
        count(*) filter (
          where event_type = 'cancelled'
            and starts_at - created_at < interval '24 hours'
        )
      into reliability_kept, reliability_cancelled_early, reliability_cancelled_late
      from latest_events;

      if (reliability_kept + reliability_cancelled_early + reliability_cancelled_late) < 3 then
        reliability_score := null;
      else
        reliability_score := reliability_kept::numeric / nullif(
          reliability_kept + reliability_cancelled_early + (reliability_cancelled_late * 2),
          0
        );
      end if;

      if reliability_score is null or reliability_score < 0.7 then
        return;
      end if;
    end;
  end if;

  if target_category is not null then
    select roster_category_caps -> target_category
      into category_cap
      from sites where id = target_site_id;

    if category_cap is not null then
      select count(*) into weekly_count
        from shift_claims sc
        join shifts s on s.id = sc.shift_id
        where sc.user_id = p_user_id
          and sc.event_type = 'claimed'
          and s.category = target_category
          and sc.created_at >= date_trunc('week', now());

      if weekly_count >= (category_cap)::int then
        return;
      end if;
    end if;
  end if;

  return query
    update shifts
    set status = 'claimed', claimed_by_user_id = p_user_id
    where id = p_shift_id and status = 'open'
    returning *;
end;
$function$;

CREATE OR REPLACE FUNCTION public.manager_assign_shift(p_shift_id bigint, p_user_id integer, p_assigned_by_user_id integer)
 RETURNS SETOF shifts
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
  target_site_id integer;
  caller_role_tier text;
  caller_local_user_id integer;
  assignee_job_role text;
  cert_ineligible boolean;
  target_min_tier text;
  assignee_tier text;
begin
  select site_id, min_tier into target_site_id, target_min_tier from shifts where id = p_shift_id;
  if target_site_id is null then
    return;
  end if;

  if not (can_access_site(target_site_id) and roster_addon_active(target_site_id)) then
    return;
  end if;

  -- Role gate: the CALLER's own JWT claim, never a lookup keyed by the
  -- client-supplied p_assigned_by_user_id (that was the actual hole).
  caller_role_tier := current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier';
  if caller_role_tier is null or caller_role_tier not in ('venueManager', 'regional', 'executive') then
    return;
  end if;

  -- Defense-in-depth on the attribution value, where it can actually be
  -- checked: a PIN session's own local_user_id must match what it claims
  -- to be assigning as. Skipped (not enforced either way) for a GoTrue
  -- session, which carries no local_user_id claim at all.
  caller_local_user_id := nullif((current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'local_user_id'), '')::integer;
  if caller_local_user_id is not null and caller_local_user_id <> p_assigned_by_user_id then
    return;
  end if;

  select job_role, role_tier into assignee_job_role, assignee_tier from users where id = p_user_id;

  -- Rota tiers (2026-10-17): a supervisor shift needs a supervisor or
  -- above. (A manager may still assign someone who is off the rota.)
  if target_min_tier = 'supervisor' and coalesce(assignee_tier, 'base') = 'base' then
    return;
  end if;

  with required_certs as (
    select unnest(
      case assignee_job_role
        when 'chefCook' then array['fireSafety','induction','level2FoodHygiene','allergenAwareness']
        when 'kitchenPorter' then array['fireSafety','induction','level2FoodHygiene','allergenAwareness']
        when 'bar' then array['fireSafety','induction','level2FoodHygiene','allergenAwareness']
        when 'management' then array['fireSafety','induction','level2FoodHygiene','allergenAwareness']
        when 'frontOfHouse' then array['fireSafety','induction','allergenAwareness']
        else array['fireSafety','induction']
      end
    ) as item_type
    union
    select item_type from site_role_certification_requirements
      where site_id = target_site_id and job_role = assignee_job_role
  ),
  latest_records as (
    select distinct on (item_type) item_type, expires_at
    from training_records
    where user_id = p_user_id
    order by item_type, completed_at desc
  )
  select exists (
    select 1 from required_certs rc
    left join latest_records lr on lr.item_type = rc.item_type
    where lr.item_type is null
       or (lr.expires_at is not null and lr.expires_at < now())
  ) into cert_ineligible;

  if cert_ineligible then
    return;
  end if;

  return query
    update shifts
    set status = 'assigned', claimed_by_user_id = p_user_id, assigned_by_user_id = p_assigned_by_user_id
    where id = p_shift_id
    returning *;
end;
$function$;
