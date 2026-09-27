-- Roster R4 (priority claim window + per-category caps) + R5 (off-day
-- requests) — staged migration, 2026-09-27. NOT YET APPLIED to the live
-- server (SSH access was unavailable this session — see BACKEND_INFRA.md's
-- R4/R5 entry). Run this via psql on the VPS, then the standing rule:
-- `docker restart supabase-rest` afterward so PostgREST picks up the new
-- columns/table/function.

-- === R4: priority claim window ===
alter table shifts add column if not exists priority_until timestamptz;

-- === R4: per-category weekly claim caps (optional, off unless a manager
-- sets one) ===
alter table sites add column if not exists roster_category_caps jsonb;

-- === R5: off-day requests ===
create table if not exists off_day_requests (
  id bigint generated always as identity primary key,
  site_id integer not null references sites(id),
  user_id integer not null references users(id),
  requested_date date not null,
  reason text,
  status text not null default 'pending' check (status in ('pending', 'approved', 'denied')),
  decided_by_user_id integer references users(id),
  decided_at timestamptz,
  created_at timestamptz not null default now()
);

alter table off_day_requests enable row level security;

-- Verified against the real shifts table policy before writing this
-- (2026-09-27, via pg_policy) — there is no per-local-user JWT claim
-- anywhere in this backend at all, only site/org/region/role_tier claims
-- (see BACKEND_INFRA.md's standing note on this). shifts' own policy is a
-- single tenant_isolation rule using ONLY can_access_site() +
-- roster_addon_active() for every operation — "staff see only their own
-- request" and "only a manager decides" are both enforced client-side
-- (the UI only shows the request form to the requester and the
-- approve/deny menu on RosterBoardScreen), matching this app's established
-- pattern of client-trusted attribution for non-tenant-isolation
-- distinctions (e.g. task_submissions.completed_by_user_id). One unified
-- policy, exactly mirroring shifts' own shape.
create policy tenant_isolation on off_day_requests
  for all
  using (can_access_site(site_id) and roster_addon_active(site_id))
  with check (can_access_site(site_id) and roster_addon_active(site_id));

-- === R4: claim_shift extended for the priority window + category cap ===
-- Verified against the real live function via
-- `select pg_get_functiondef('claim_shift'::regproc);` before writing this
-- (2026-09-27) — the can_access_site/roster_addon_active re-check and the
-- atomic UPDATE ... WHERE status='open' RETURNING * are carried over
-- unchanged; only the p_user_id parameter type (integer, not bigint,
-- corrected below) and the two new checks are additions.
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
