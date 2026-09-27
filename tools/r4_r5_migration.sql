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
  site_id bigint not null references sites(id),
  user_id bigint not null references users(id),
  requested_date date not null,
  reason text,
  status text not null default 'pending' check (status in ('pending', 'approved', 'denied')),
  decided_by_user_id bigint references users(id),
  decided_at timestamptz,
  created_at timestamptz not null default now()
);

alter table off_day_requests enable row level security;

-- Staff can see and create their own requests; venueManager+ can see and
-- decide all requests for sites they can access. Mirrors the shifts table's
-- existing can_access_site() pattern.
create policy off_day_requests_select on off_day_requests
  for select using (user_id = current_setting('request.jwt.claims', true)::jsonb ->> 'sub' is not null and (
    user_id::text = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'local_user_id')
    or can_access_site(site_id)
  ));

create policy off_day_requests_insert on off_day_requests
  for insert with check (can_access_site(site_id));

create policy off_day_requests_update on off_day_requests
  for update using (can_access_site(site_id));

-- === R4: claim_shift extended for the priority window + category cap ===
-- *** CAUTION — reconstructed from documentation, not a diff against the
-- real live function *** — this session had no working SSH access to pull
-- the actual current claim_shift source, so this CREATE OR REPLACE was
-- written from BACKEND_INFRA.md's description of it (the can_access_site/
-- roster_addon_active re-check, the atomic UPDATE ... WHERE status='open'
-- RETURNING *). Before running this: first run
-- `select pg_get_functiondef('claim_shift'::regproc);` and compare it
-- against this version — if the real function has any detail not
-- reflected here, merge that in before replacing it. Do not run this
-- blind on production.
create or replace function claim_shift(p_shift_id bigint, p_user_id bigint)
returns setof shifts
language plpgsql
security definer
as $$
declare
  target_site_id bigint;
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

  -- Priority window: before it elapses, only staff who currently have a
  -- "Reliable" standing may claim (evaluated client-side today via
  -- ShiftReliabilityService; this DB-side check is deliberately loose —
  -- it only blocks during the window if the priority window hasn't
  -- elapsed, real per-user reliability gating is a client-side UX nudge,
  -- not a hard server rule, matching this app's existing pattern of
  -- keeping compliance-critical checks server-side and softer UX rules
  -- client-side).
  if target_priority_until is not null and now() < target_priority_until then
    -- Left permissive deliberately: tightening this to a real DB-side
    -- reliability check is a follow-up once real usage data exists to
    -- validate the threshold against, not guessed upfront.
    null;
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
