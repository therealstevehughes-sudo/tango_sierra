-- Shift verification photos (2026-10-02), direct founder request — a photo
-- at shift start/end to deter buddy-punching/fraudulent clock-in-out,
-- moved to the backend (shift_logs was previously local-only, a habit-
-- tracker only) specifically so a supervisor on ANY device can see and
-- confirm a clock-in/out when the staff member declined the photo.
--
-- Consent, not a forced requirement: a staff member can decline, in which
-- case their clock-in/out is simply left unverified until a supervisor+
-- confirms it happened (a real alternative with no detriment — matters
-- for UK GDPR's "freely given" consent test in an employment context).
--
-- All writes go through the three RPCs below (SECURITY DEFINER, bypass
-- RLS internally) rather than plain REST table writes — shift_logs has
-- NO insert/update policy at all, only SELECT, so a raw REST write is
-- always rejected regardless of role. This avoids needing fragile
-- column-level RLS to distinguish "I'm clocking myself out" from "I'm
-- verifying someone else's declined clock-in" on the same table.

-- === Per-site toggle + configurable retention (venue manager+ decides) ===
alter table sites add column if not exists shift_verification_photos_enabled boolean not null default false;
-- GDPR storage-limitation default: 90 days of full-size photo, then
-- deleted (see shift_photo_retention_days' own lazy-cleanup note below).
-- Deliberately NOT a long fixed legal-retention number — no confirmed UK
-- legal minimum applies to a shift-attendance photo specifically, and the
-- storage-limitation principle argues for the shortest period that still
-- serves the fraud-deterrence purpose. Configurable per site so a real
-- legal minimum, once confirmed, is a settings change, not a code change.
alter table sites add column if not exists shift_photo_retention_days integer not null default 90;

-- === Per-person consent (not org-wide, not a blanket ToS checkbox) ===
alter table users add column if not exists shift_photo_consent text check (shift_photo_consent in ('allowed', 'declined'));
alter table users add column if not exists shift_photo_consent_at timestamptz;
alter table users add column if not exists shift_photo_consent_version text;

-- === shift_logs (backend, supersedes the local-only Drift table for any
-- site with the feature enabled) ===
create table if not exists shift_logs (
  id bigint generated always as identity primary key,
  user_id integer not null references users(id),
  site_id integer not null references sites(id),
  clock_in_at timestamptz not null default now(),
  clock_in_photo_path text,
  clock_in_photo_purged boolean not null default false,
  clock_in_verified_by_user_id integer references users(id),
  clock_in_verified_at timestamptz,
  clock_out_at timestamptz,
  clock_out_photo_path text,
  clock_out_photo_purged boolean not null default false,
  clock_out_verified_by_user_id integer references users(id),
  clock_out_verified_at timestamptz
);

alter table shift_logs enable row level security;

-- Read-only policy — same site-scoping as every other operational table.
-- A supervisor+ needs to see pending (unverified, no-photo) rows here to
-- run the verification queue; a base-tier person sees the same site list,
-- same as the existing Shift Log screen already shows everyone's entries.
create policy "shift_logs_read" on shift_logs
  for select
  using (can_access_site(site_id));

-- No insert/update/delete policy — every write goes through the RPCs
-- below, which is the actual security boundary for this table.

create or replace function shift_clock_in(
  p_site_id integer,
  p_photo_path text default null
)
returns setof shift_logs
language plpgsql
security definer
as $$
declare
  caller_local_user_id integer;
begin
  if not can_access_site(p_site_id) then
    return;
  end if;
  -- Required, not optional: this RPC's whole point is asserting a
  -- specific person clocked in, so a session with no verifiable identity
  -- (a GoTrue/Leadership session, which carries no local_user_id claim)
  -- cannot use it. Shift Log is a floor-staff/supervisor concept in
  -- practice, so this is a real narrowing, not a regression.
  caller_local_user_id := nullif((current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'local_user_id'), '')::integer;
  if caller_local_user_id is null then
    return;
  end if;

  return query
    insert into shift_logs (user_id, site_id, clock_in_photo_path)
    values (caller_local_user_id, p_site_id, p_photo_path)
    returning *;
end;
$$;

create or replace function shift_clock_out(
  p_shift_log_id bigint,
  p_photo_path text default null
)
returns setof shift_logs
language plpgsql
security definer
as $$
declare
  caller_local_user_id integer;
  target_user_id integer;
  target_site_id integer;
begin
  select user_id, site_id into target_user_id, target_site_id
    from shift_logs where id = p_shift_log_id;
  if target_site_id is null or not can_access_site(target_site_id) then
    return;
  end if;

  caller_local_user_id := nullif((current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'local_user_id'), '')::integer;
  -- Only the person who clocked in may clock themselves out — never a
  -- client-supplied id, always the caller's own signed claim.
  if caller_local_user_id is null or caller_local_user_id <> target_user_id then
    return;
  end if;

  return query
    update shift_logs
    set clock_out_at = now(), clock_out_photo_path = p_photo_path
    where id = p_shift_log_id
    returning *;
end;
$$;

-- Supervisor+ confirms a clock-in or clock-out that had no photo (the
-- staff member declined). p_which is 'in' or 'out'. Role check reads the
-- CALLER's own JWT claim directly — never a lookup keyed by a parameter,
-- the exact pattern the 2026-10-02 manager_assign_shift fix established
-- after finding that class of bug live.
create or replace function shift_verify_clock_event(
  p_shift_log_id bigint,
  p_which text
)
returns setof shift_logs
language plpgsql
security definer
as $$
declare
  caller_role_tier text;
  caller_local_user_id integer;
  target_site_id integer;
begin
  if p_which not in ('in', 'out') then
    return;
  end if;

  select site_id into target_site_id from shift_logs where id = p_shift_log_id;
  if target_site_id is null or not can_access_site(target_site_id) then
    return;
  end if;

  caller_role_tier := current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier';
  if caller_role_tier is null or caller_role_tier not in ('supervisor', 'venueManager', 'regional', 'executive') then
    return;
  end if;

  caller_local_user_id := nullif((current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'local_user_id'), '')::integer;
  if caller_local_user_id is null then
    return;
  end if;

  if p_which = 'in' then
    return query
      update shift_logs
      set clock_in_verified_by_user_id = caller_local_user_id, clock_in_verified_at = now()
      where id = p_shift_log_id and clock_in_photo_path is null
        and clock_in_photo_purged = false and clock_in_verified_by_user_id is null
      returning *;
  else
    return query
      update shift_logs
      set clock_out_verified_by_user_id = caller_local_user_id, clock_out_verified_at = now()
      where id = p_shift_log_id and clock_out_photo_path is null
        and clock_out_photo_purged = false and clock_out_verified_by_user_id is null
      returning *;
  end if;
end;
$$;

-- Retention purge (2026-10-02) — this backend has no cron (standing
-- architecture choice, see BACKEND_INFRA.md), so purging is triggered
-- lazily: a supervisor+ viewing the shift log for a site calls this (via
-- the Flutter repository) for any row whose photo is older than that
-- site's own shift_photo_retention_days. The client deletes the actual
-- Storage object FIRST (a separate Storage API call, not SQL), then
-- calls this to null the path — if the client dies between the two, the
-- photo is already gone from Storage and this just gets called again
-- next view; the reverse order would risk an orphaned, undeletable
-- Storage object with no path on record.
create or replace function shift_clear_expired_photo(
  p_shift_log_id bigint,
  p_which text
)
returns void
language plpgsql
security definer
as $$
declare
  target_site_id integer;
  caller_role_tier text;
begin
  if p_which not in ('in', 'out') then
    return;
  end if;
  select site_id into target_site_id from shift_logs where id = p_shift_log_id;
  if target_site_id is null or not can_access_site(target_site_id) then
    return;
  end if;
  caller_role_tier := current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier';
  if caller_role_tier is null or caller_role_tier not in ('supervisor', 'venueManager', 'regional', 'executive') then
    return;
  end if;

  if p_which = 'in' then
    update shift_logs
      set clock_in_photo_path = null, clock_in_photo_purged = true
      where id = p_shift_log_id;
  else
    update shift_logs
      set clock_out_photo_path = null, clock_out_photo_purged = true
      where id = p_shift_log_id;
  end if;
end;
$$;

-- === Storage bucket for the photos — private, same pattern as
-- certification-documents (tools/phase2_certification_migration.sql).
-- Path convention: {site_id}/{user_id}/{timestamp}_{in|out}.jpg
insert into storage.buckets (id, name, public)
values ('shift-verification-photos', 'shift-verification-photos', false)
on conflict (id) do nothing;

drop policy if exists "shift_verification_photos_tenant_isolation" on storage.objects;

create policy "shift_verification_photos_tenant_isolation"
  on storage.objects
  for all
  using (
    bucket_id = 'shift-verification-photos'
    and can_access_site((storage.foldername(name))[1]::integer)
  )
  with check (
    bucket_id = 'shift-verification-photos'
    and can_access_site((storage.foldername(name))[1]::integer)
  );
