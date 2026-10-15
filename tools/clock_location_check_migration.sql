-- Location-checked clock-in/out (2026-10-15, founder-approved).
--
-- Approved design (see DECISIONS_LOG.md):
--  - Flag and review, never block: GPS indoors is often 50-100m+ out, and a
--    hard block would stop honest staff clocking in. An off-site or
--    no-location event is recorded and lands in the supervisor's
--    verification queue, alongside the existing photo check.
--  - The SERVER decides on-site/off-site, never the app.
--  - Venue network check: if the request comes from the venue's own
--    internet connection (public IP recorded once by a manager), that
--    counts as on-site — works indoors with no location permission at all,
--    and is the stronger signal for a paired venue tablet.
--  - Data minimisation (UK GDPR / ICO monitoring-at-work guidance): only
--    captured at the moment of clock-in/out, never tracked; raw
--    coordinates are NOT stored — only the distance from the venue, the
--    reported accuracy, and the resulting status.
--
-- Off by default per site; a venue manager+ turns it on and sets the
-- venue's location + allowed distance (default 150m) in Venue Details.

-- === Per-site settings ===
alter table sites add column if not exists clock_location_check_enabled boolean not null default false;
alter table sites add column if not exists clock_latitude double precision;
alter table sites add column if not exists clock_longitude double precision;
alter table sites add column if not exists clock_radius_m integer not null default 150
  check (clock_radius_m between 25 and 2000);
alter table sites add column if not exists clock_network_ip text;

-- === Per-event result on shift_logs ===
alter table shift_logs add column if not exists clock_in_location_status text
  check (clock_in_location_status in ('on_site_gps', 'on_site_network', 'off_site', 'no_location'));
alter table shift_logs add column if not exists clock_in_distance_m integer;
alter table shift_logs add column if not exists clock_in_accuracy_m integer;
alter table shift_logs add column if not exists clock_in_location_reviewed_by_user_id integer references users(id);
alter table shift_logs add column if not exists clock_in_location_reviewed_at timestamptz;
alter table shift_logs add column if not exists clock_out_location_status text
  check (clock_out_location_status in ('on_site_gps', 'on_site_network', 'off_site', 'no_location'));
alter table shift_logs add column if not exists clock_out_distance_m integer;
alter table shift_logs add column if not exists clock_out_accuracy_m integer;
alter table shift_logs add column if not exists clock_out_location_reviewed_by_user_id integer references users(id);
alter table shift_logs add column if not exists clock_out_location_reviewed_at timestamptz;

-- The caller's public IP as seen by nginx (X-Real-IP, set from
-- $remote_addr in /etc/nginx/sites-available/api-venurite), falling back to
-- the first X-Forwarded-For hop. PostgREST exposes request headers as the
-- request.headers GUC (lower-cased names).
create or replace function _caller_ip()
returns text
language sql
stable
as $$
  select nullif(trim(coalesce(
    current_setting('request.headers', true)::jsonb ->> 'x-real-ip',
    split_part(current_setting('request.headers', true)::jsonb ->> 'x-forwarded-for', ',', 1)
  )), '');
$$;

-- Great-circle distance in metres (haversine). Plain SQL, no PostGIS.
create or replace function _distance_m(lat1 double precision, lng1 double precision,
                                       lat2 double precision, lng2 double precision)
returns integer
language sql
immutable
as $$
  select round(2 * 6371000 * asin(sqrt(
    power(sin(radians(lat2 - lat1) / 2), 2)
    + cos(radians(lat1)) * cos(radians(lat2)) * power(sin(radians(lng2 - lng1) / 2), 2)
  )))::integer;
$$;

-- (status, distance_m) for a clock event at p_site_id. Null status means
-- the site hasn't turned the check on (nothing recorded, same as before).
create or replace function _clock_location_status(
  p_site_id integer,
  p_lat double precision,
  p_lng double precision,
  out status text,
  out distance_m integer
)
language plpgsql
stable
as $$
declare
  s record;
begin
  select clock_location_check_enabled, clock_latitude, clock_longitude,
         clock_radius_m, clock_network_ip
    into s from sites where id = p_site_id;
  if s is null or not s.clock_location_check_enabled then
    status := null;
    return;
  end if;

  if p_lat is not null and p_lng is not null
     and s.clock_latitude is not null and s.clock_longitude is not null then
    distance_m := _distance_m(s.clock_latitude, s.clock_longitude, p_lat, p_lng);
  end if;

  if s.clock_network_ip is not null and _caller_ip() = s.clock_network_ip then
    status := 'on_site_network';
  elsif distance_m is not null and distance_m <= s.clock_radius_m then
    status := 'on_site_gps';
  elsif distance_m is not null then
    status := 'off_site';
  else
    status := 'no_location';
  end if;
end;
$$;

-- === Clock-in/out RPCs gain optional location params ===
-- Old (2-arg) versions dropped so PostgREST has exactly one candidate; the
-- new params all default to null, so an older app build's call (site id +
-- photo path only) still resolves and records 'no_location' / network.
drop function if exists shift_clock_in(integer, text);
drop function if exists shift_clock_out(bigint, text);

create or replace function shift_clock_in(
  p_site_id integer,
  p_photo_path text default null,
  p_lat double precision default null,
  p_lng double precision default null,
  p_accuracy_m integer default null
)
returns setof shift_logs
language plpgsql
security definer
as $$
declare
  caller_local_user_id integer;
  loc record;
begin
  if not can_access_site(p_site_id) then
    return;
  end if;
  caller_local_user_id := nullif((current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'local_user_id'), '')::integer;
  if caller_local_user_id is null then
    return;
  end if;

  select * into loc from _clock_location_status(p_site_id, p_lat, p_lng);

  return query
    insert into shift_logs (user_id, site_id, clock_in_photo_path,
                            clock_in_location_status, clock_in_distance_m, clock_in_accuracy_m)
    values (caller_local_user_id, p_site_id, p_photo_path,
            loc.status, loc.distance_m,
            case when loc.status is null then null else p_accuracy_m end)
    returning *;
end;
$$;

create or replace function shift_clock_out(
  p_shift_log_id bigint,
  p_photo_path text default null,
  p_lat double precision default null,
  p_lng double precision default null,
  p_accuracy_m integer default null
)
returns setof shift_logs
language plpgsql
security definer
as $$
declare
  caller_local_user_id integer;
  target_user_id integer;
  target_site_id integer;
  loc record;
begin
  select user_id, site_id into target_user_id, target_site_id
    from shift_logs where id = p_shift_log_id;
  if target_site_id is null or not can_access_site(target_site_id) then
    return;
  end if;

  caller_local_user_id := nullif((current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'local_user_id'), '')::integer;
  if caller_local_user_id is null or caller_local_user_id <> target_user_id then
    return;
  end if;

  select * into loc from _clock_location_status(target_site_id, p_lat, p_lng);

  return query
    update shift_logs
    set clock_out_at = now(),
        clock_out_photo_path = p_photo_path,
        clock_out_location_status = loc.status,
        clock_out_distance_m = loc.distance_m,
        clock_out_accuracy_m = case when loc.status is null then null else p_accuracy_m end
    where id = p_shift_log_id
    returning *;
end;
$$;

-- Supervisor+ marks an off-site / no-location event as reviewed (e.g. "GPS
-- drifted, they were in the cellar"). Same caller-claim role check as
-- shift_verify_clock_event.
create or replace function shift_review_location(
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
      set clock_in_location_reviewed_by_user_id = caller_local_user_id,
          clock_in_location_reviewed_at = now()
      where id = p_shift_log_id
        and clock_in_location_status in ('off_site', 'no_location')
        and clock_in_location_reviewed_by_user_id is null
      returning *;
  else
    return query
      update shift_logs
      set clock_out_location_reviewed_by_user_id = caller_local_user_id,
          clock_out_location_reviewed_at = now()
      where id = p_shift_log_id
        and clock_out_location_status in ('off_site', 'no_location')
        and clock_out_location_reviewed_by_user_id is null
      returning *;
  end if;
end;
$$;

-- === Venue setup RPCs (venueManager+) ===
create or replace function set_site_clock_location(
  p_site_id integer,
  p_enabled boolean,
  p_lat double precision,
  p_lng double precision,
  p_radius_m integer
)
returns void
language plpgsql
security definer
as $$
declare
  caller_role_tier text;
begin
  if not can_access_site(p_site_id) then
    return;
  end if;
  caller_role_tier := current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier';
  if caller_role_tier is null or caller_role_tier not in ('venueManager', 'regional', 'executive') then
    return;
  end if;
  update sites
    set clock_location_check_enabled = p_enabled,
        clock_latitude = coalesce(p_lat, clock_latitude),
        clock_longitude = coalesce(p_lng, clock_longitude),
        clock_radius_m = coalesce(p_radius_m, clock_radius_m)
    where id = p_site_id;
end;
$$;

-- Records (or clears) the venue's internet connection, taken from the
-- manager's own request — so nobody ever has to look up or type an IP.
create or replace function set_site_clock_network(
  p_site_id integer,
  p_clear boolean default false
)
returns table (network_set boolean)
language plpgsql
security definer
as $$
declare
  caller_role_tier text;
  ip text;
begin
  if not can_access_site(p_site_id) then
    return;
  end if;
  caller_role_tier := current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier';
  if caller_role_tier is null or caller_role_tier not in ('venueManager', 'regional', 'executive') then
    return;
  end if;
  ip := case when p_clear then null else _caller_ip() end;
  update sites set clock_network_ip = ip where id = p_site_id;
  return query select ip is not null;
end;
$$;

revoke execute on function _caller_ip() from public, anon;
revoke execute on function _clock_location_status(integer, double precision, double precision) from public, anon;
grant execute on function shift_clock_in(integer, text, double precision, double precision, integer) to authenticated;
grant execute on function shift_clock_out(bigint, text, double precision, double precision, integer) to authenticated;
grant execute on function shift_review_location(bigint, text) to authenticated;
grant execute on function set_site_clock_location(integer, boolean, double precision, double precision, integer) to authenticated;
grant execute on function set_site_clock_network(integer, boolean) to authenticated;
