-- Privilege-escalation fix (2026-10-02) — found during a full-project
-- security review. Both manager_assign_shift and claim_shift trusted a
-- plain caller-supplied integer parameter (p_assigned_by_user_id /
-- p_user_id) for authorization, with no check that it actually matched
-- the authenticated caller. Concretely, for manager_assign_shift: ANY
-- authenticated user with site access could pass a real manager's
-- user_id as p_assigned_by_user_id to pass the venueManager+ role gate,
-- then assign any shift to anyone — a genuine role-boundary bypass, not
-- just a misattribution, fully defeating the reason this RPC was written
-- in the first place (see phase2_manager_assign_shift_rpc_migration.sql's
-- own header comment).
--
-- Fix: the AUTHORIZATION decision now reads the caller's own role_tier
-- straight from the JWT claim (the same pattern every other role-gated
-- RLS policy in this backend already uses, e.g. shift_periods_write) —
-- never a lookup keyed by a client-supplied id. This closes the hole
-- regardless of session type (PIN or GoTrue) since role_tier is reliably
-- set on both.
--
-- claim_shift has the weaker, already-accepted version of this same
-- pattern: p_user_id doesn't cross a role boundary (claiming a shift
-- needs no elevated permission), but it does let one staff member claim
-- "as" another, affecting that person's reliability stats or bypassing
-- their own priority-window ineligibility. Tightened where it CAN be
-- tightened without breaking a real path: PIN sessions carry a
-- `local_user_id` claim (confirmed live via the service-provider-
-- directory feature) — when present, it must match p_user_id. GoTrue
-- (Leadership) sessions have no such claim (tenant-signup only ever sets
-- role_tier/organisation_id — confirmed in tools/tenant-signup_index.ts)
-- so the check is skipped for that session type, same as it always has
-- been — no regression for the one path that genuinely can't carry it.

create or replace function manager_assign_shift(
  p_shift_id bigint,
  p_user_id integer,
  p_assigned_by_user_id integer
)
returns setof shifts
language plpgsql
security definer
as $$
declare
  target_site_id integer;
  caller_role_tier text;
  caller_local_user_id integer;
  assignee_job_role text;
  cert_ineligible boolean;
begin
  select site_id into target_site_id from shifts where id = p_shift_id;
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

  select job_role into assignee_job_role from users where id = p_user_id;

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
$$;

create or replace function claim_shift(p_shift_id bigint, p_user_id integer)
returns setof shifts
language plpgsql
security definer
as $$
declare
  target_site_id integer;
  target_priority_until timestamptz;
  target_category text;
  category_cap jsonb;
  weekly_count int;
  target_job_role text;
  cert_ineligible boolean;
  caller_local_user_id integer;
begin
  select site_id, priority_until, category
    into target_site_id, target_priority_until, target_category
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

  select job_role into target_job_role from users where id = p_user_id;

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
$$;

-- Off-day-request approval bypass (2026-10-02) — tools/r4_r5_migration.sql's
-- own tenant_isolation policy let ANY site-accessible user directly PATCH
-- status/decided_by_user_id/decided_at on ANY colleague's off_day_requests
-- row via a raw REST call, including approving their own leave or
-- impersonating a manager's decision — the "only a manager decides" rule
-- was UI-only. Splits the single catch-all policy into real read/insert
-- (unchanged behaviour) plus a genuinely role-gated decide policy.
drop policy if exists "tenant_isolation" on off_day_requests;

create policy "off_day_requests_read" on off_day_requests
  for select
  using (can_access_site(site_id) and roster_addon_active(site_id));

create policy "off_day_requests_insert" on off_day_requests
  for insert
  with check (can_access_site(site_id) and roster_addon_active(site_id));

-- Deciding (approve/deny) requires venueManager+, checked from the
-- caller's own JWT claim — same pattern as manager_assign_shift's fix
-- above, not a lookup keyed by a client-supplied id.
create policy "off_day_requests_decide" on off_day_requests
  for update
  using (can_access_site(site_id) and roster_addon_active(site_id))
  with check (
    can_access_site(site_id)
    and roster_addon_active(site_id)
    and (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
      in ('venueManager', 'regional', 'executive')
  );
