-- Phase 2, cert-expiry follow-up: real server-side enforcement for direct
-- shift assignment (2026-09-30). Closes the known gap logged in
-- PHASE_2_ROADMAP.md and phase2_claim_shift_cert_check_migration.sql's
-- own header comment: managerAssign was a plain PostgREST table UPDATE
-- against `shifts`, whose only RLS policy is tenant_isolation
-- (can_access_site + roster_addon_active) — confirmed via a direct query
-- against the live pg_policy table before writing this. That meant
-- ANYONE with site access could call the raw REST endpoint to assign any
-- shift to anyone, bypassing both the venueManager+ role gate the UI
-- enforces (client-side only, easily bypassed by calling the API
-- directly) and the certification-expiry eligibility check entirely.
--
-- This RPC closes both gaps in one atomic, SECURITY DEFINER function,
-- mirroring claim_shift's own cert-check block exactly (same "duplicate
-- Dart logic in SQL on purpose" pattern already established there).
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
  assigner_role_tier text;
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

  -- Role gate: only venueManager+ may assign directly, matching the
  -- drawer's own gate on RosterBoardScreen (client-side only until now).
  select role_tier into assigner_role_tier from users where id = p_assigned_by_user_id;
  if assigner_role_tier is null or assigner_role_tier not in ('venueManager', 'regional', 'executive') then
    return;
  end if;

  -- Certification-expiry eligibility — identical logic to claim_shift's
  -- own check (see that function's header comment for why this is
  -- deliberately duplicated rather than shared, since a plpgsql function
  -- can't call Dart, and factoring this into a shared SQL function is a
  -- reasonable future follow-up, not done here to keep this change small
  -- and reviewable against the function it mirrors).
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
