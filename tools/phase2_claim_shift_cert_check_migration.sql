-- Phase 2, certification-expiry shift eligibility, part 3 (2026-09-30).
-- SERVER-SIDE enforcement — the client-side checks in ClaimBoardScreen and
-- RosterBoardScreen are UX only; this is what actually stops the claim.
--
-- DEPENDS ON tools/phase2_cert_requirements_migration.sql being applied
-- FIRST (creates site_role_certification_requirements) — this file will
-- fail if that table doesn't exist yet. Verified column names against the
-- live users/training_records tables before writing this (job_role and
-- item_type are stored as the Dart enum's .name, e.g. 'chefCook',
-- 'level2FoodHygiene' — confirmed via SupabaseUserRepository/
-- SupabaseTrainingRecordRepository, not guessed).
--
-- Mirrors certification_requirement.dart's systemRequiredCertifications()
-- and missingCertificationsForRole() EXACTLY, same "two places, kept in
-- sync deliberately" pattern claim_shift's priority-window check already
-- uses for ShiftReliabilityService's Dart logic. If that Dart function
-- changes, this CASE must change too.
--
-- Verified against the real live function via
-- `select pg_get_functiondef('claim_shift'::regproc);` before writing this
-- (2026-09-30) — every existing line (priority window, category cap, the
-- atomic UPDATE) is carried over unchanged; only the new cert check block
-- is an addition, inserted right after the initial access check.
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

  -- Certification-expiry eligibility (Phase 2, 2026-09-30) — see the
  -- header comment above for why this duplicates Dart logic on purpose.
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

  -- Priority window: before it elapses, only staff at "Reliable" standing
  -- may claim. Mirrors ShiftReliabilityService's own Dart logic exactly
  -- (lib/features/roster/shift_reliability_service.dart) so the two never
  -- disagree: latest event per shift only (a claim later cancelled counts
  -- once, as its final outcome), 90-day lookback, late cancellation
  -- (<24h before the shift started) weighted double, manager_removed
  -- excluded, fewer than 3 decisions ever = not yet eligible (a brand new
  -- starter hasn't earned priority access yet either).
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

  -- Per-category weekly cap, if the site has one configured.
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
