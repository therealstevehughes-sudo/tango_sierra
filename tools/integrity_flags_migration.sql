-- Stopping faked checks (2026-10-17, founder-approved plan items 1-8:
-- "let's try mitigate abuse... as much as possible").
--
-- The app reports facts (how long the check was open, a fingerprint of the
-- photo, and - for critical tasks - where the phone was). THE DATABASE
-- decides what looks wrong, in triggers the app can't skip:
--   too_fast        a check submitted faster than it can really be done
--   burst           10+ checks by one person inside a minute
--   reused_photo    the same photo already used for an earlier check
--   same_reading    the same number recorded 10 times in a row
--   round_numbers   20 readings in a row, all whole numbers
--   off_site        a critical check done away from the venue
--   check_mismatch  a manager went and looked, and it didn't match
-- Nobody is blocked. Staff are never told they were flagged (item 8);
-- managers see a pattern view per person, never a public score.
--
-- Location: raw coordinates are passed in for the check and cleared before
-- the row is stored - only on-site/off-site and the distance are kept
-- (same data-minimisation rule as clock-in, tools/clock_location_check_migration.sql).

begin;

alter table task_submissions add column if not exists duration_seconds integer
  check (duration_seconds is null or duration_seconds >= 0);
alter table task_submissions add column if not exists photo_hash text;
alter table task_submissions add column if not exists check_lat double precision;
alter table task_submissions add column if not exists check_lng double precision;
alter table task_submissions add column if not exists location_status text
  check (location_status in ('on_site_gps', 'on_site_network', 'off_site', 'no_location'));
alter table task_submissions add column if not exists location_distance_m integer;

create index if not exists task_submissions_photo_hash_idx
  on task_submissions (site_id, photo_hash) where photo_hash is not null;
create index if not exists task_submissions_user_time_idx
  on task_submissions (completed_by_user_id, completed_at desc);

create table if not exists integrity_flags (
  id bigint generated always as identity primary key,
  site_id integer not null references sites(id),
  user_id integer references users(id),
  task_submission_id integer references task_submissions(id) on delete cascade,
  kind text not null check (kind in ('too_fast', 'burst', 'reused_photo', 'same_reading',
                                     'round_numbers', 'off_site', 'check_mismatch')),
  detail text,
  created_at timestamptz not null default now(),
  reviewed_at timestamptz,
  reviewed_by_user_id integer references users(id),
  review_note text
);
create index if not exists integrity_flags_site_idx on integrity_flags (site_id, created_at desc);
create index if not exists integrity_flags_user_idx on integrity_flags (user_id, created_at desc);

create table if not exists manager_spot_verifications (
  id bigint generated always as identity primary key,
  site_id integer not null references sites(id),
  task_submission_id integer not null references task_submissions(id) on delete cascade,
  checked_by_user_id integer not null references users(id),
  result text not null check (result in ('matches', 'mismatch')),
  note text,
  created_at timestamptz not null default now()
);

alter table integrity_flags enable row level security;
alter table manager_spot_verifications enable row level security;

-- Managers only (venue manager and above) - supervisors and staff never
-- see flags, so nobody can tip anyone off.
create or replace function integrity_caller_is_manager() returns boolean
language sql stable as $$
  select coalesce(current_setting('request.jwt.claims', true)::jsonb
                  -> 'app_metadata' ->> 'role_tier', '')
         in ('venueManager', 'regional', 'executive')
$$;

drop policy if exists "integrity_flags_read" on integrity_flags;
create policy "integrity_flags_read" on integrity_flags
  for select using (can_access_site(site_id) and integrity_caller_is_manager());
drop policy if exists "integrity_flags_review" on integrity_flags;
create policy "integrity_flags_review" on integrity_flags
  for update using (can_access_site(site_id) and integrity_caller_is_manager());
drop policy if exists "spot_verifications_read" on manager_spot_verifications;
create policy "spot_verifications_read" on manager_spot_verifications
  for select using (can_access_site(site_id) and integrity_caller_is_manager());

revoke all on integrity_flags from anon, authenticated;
grant select on integrity_flags to authenticated;
grant update (reviewed_at, reviewed_by_user_id, review_note) on integrity_flags to authenticated;
revoke all on manager_spot_verifications from anon, authenticated;
grant select on manager_spot_verifications to authenticated;

commit;

-- Before the row is stored: turn the phone's position into on-site /
-- off-site, then forget the position.
create or replace function integrity_before_submission() returns trigger
language plpgsql security definer as $$
declare
  loc record;
begin
  if new.check_lat is not null and new.check_lng is not null then
    select * into loc from _clock_location_status(new.site_id, new.check_lat, new.check_lng);
    new.location_status := loc.status;
    new.location_distance_m := loc.distance_m;
  end if;
  new.check_lat := null;
  new.check_lng := null;
  return new;
end;
$$;

drop trigger if exists task_submissions_integrity_before on task_submissions;
create trigger task_submissions_integrity_before
  before insert on task_submissions
  for each row execute function integrity_before_submission();

-- After the row is stored: raise any flags.
create or replace function integrity_after_submission() returns trigger
language plpgsql security definer as $$
declare
  min_secs integer;
  recent integer;
  uid integer := new.completed_by_user_id;
  same_count integer;
  distinct_count integer;
begin
  -- 1/2. Too fast: under the minimum for that kind of check. Readings and
  -- photos can't honestly be done in under 5 seconds; a plain tick in 2.
  if new.duration_seconds is not null then
    min_secs := case when new.numeric_value is not null or new.photo_attached then 5 else 2 end;
    if new.duration_seconds < min_secs then
      insert into integrity_flags (site_id, user_id, task_submission_id, kind, detail)
        values (new.site_id, uid, new.id, 'too_fast',
                format('%s done in %s seconds', new.task_title, new.duration_seconds));
    end if;
  end if;

  -- 2. Burst: 10+ checks by one person inside a minute (one flag per burst).
  if uid is not null then
    select count(*) into recent from task_submissions
      where completed_by_user_id = uid
        and completed_at between new.completed_at - interval '60 seconds' and new.completed_at;
    if recent >= 10 and not exists (
        select 1 from integrity_flags
        where user_id = uid and kind = 'burst' and created_at > now() - interval '10 minutes') then
      insert into integrity_flags (site_id, user_id, task_submission_id, kind, detail)
        values (new.site_id, uid, new.id, 'burst', format('%s checks submitted within one minute', recent));
    end if;
  end if;

  -- 3. Reused photo: the exact same picture already used at this venue.
  if new.photo_hash is not null and exists (
      select 1 from task_submissions
      where site_id = new.site_id and photo_hash = new.photo_hash and id <> new.id
        and completed_at > now() - interval '180 days') then
    insert into integrity_flags (site_id, user_id, task_submission_id, kind, detail)
      values (new.site_id, uid, new.id, 'reused_photo',
              format('%s: this photo was already used for an earlier check', new.task_title));
  end if;

  -- 4a. Same reading 10 times in a row on the same check and equipment.
  if new.numeric_value is not null then
    select count(*), count(distinct numeric_value) into same_count, distinct_count from (
      select numeric_value from task_submissions
      where site_id = new.site_id
        and task_template_group_id is not distinct from new.task_template_group_id
        and equipment_instance_id is not distinct from new.equipment_instance_id
        and numeric_value is not null
      order by completed_at desc
      limit 10
    ) last10;
    if same_count = 10 and distinct_count = 1 and not exists (
        select 1 from integrity_flags f join task_submissions s on s.id = f.task_submission_id
        where f.kind = 'same_reading' and f.site_id = new.site_id
          and s.task_template_group_id is not distinct from new.task_template_group_id
          and s.equipment_instance_id is not distinct from new.equipment_instance_id
          and f.created_at > now() - interval '7 days') then
      insert into integrity_flags (site_id, user_id, task_submission_id, kind, detail)
        values (new.site_id, uid, new.id, 'same_reading',
                format('%s: exactly %s recorded 10 times in a row', new.task_title, new.numeric_value));
    end if;

    -- 4b. Always round: a person's last 20 readings all whole numbers.
    if uid is not null then
      select count(*), count(*) filter (where numeric_value ~ '^-?[0-9]+(\.0+)?$')
        into same_count, distinct_count from (
        select numeric_value from task_submissions
        where completed_by_user_id = uid and numeric_value is not null
        order by completed_at desc
        limit 20
      ) last20;
      if same_count = 20 and distinct_count = 20 and not exists (
          select 1 from integrity_flags
          where user_id = uid and kind = 'round_numbers' and created_at > now() - interval '7 days') then
        insert into integrity_flags (site_id, user_id, task_submission_id, kind, detail)
          values (new.site_id, uid, new.id, 'round_numbers', 'Last 20 readings were all whole numbers');
      end if;
    end if;
  end if;

  -- 6. Off-site: a critical check done away from the venue.
  if new.location_status = 'off_site' then
    insert into integrity_flags (site_id, user_id, task_submission_id, kind, detail)
      values (new.site_id, uid, new.id, 'off_site',
              format('%s submitted about %sm from the venue', new.task_title, new.location_distance_m));
  end if;
  return new;
end;
$$;

drop trigger if exists task_submissions_integrity_after on task_submissions;
create trigger task_submissions_integrity_after
  after insert on task_submissions
  for each row execute function integrity_after_submission();

-- 5. Spot-checks go up for anyone with an open flag in the last 14 days.
-- Returns only a rate, never the flags themselves.
create or replace function my_spot_check_rate(p_user_id integer)
returns table (rate numeric)
language plpgsql stable security definer as $$
declare
  caller integer := nullif(current_setting('request.jwt.claims', true)::jsonb
                           -> 'app_metadata' ->> 'local_user_id', '')::integer;
begin
  if caller is not null and caller <> p_user_id then
    return query select 0.2::numeric;
    return;
  end if;
  return query select case when exists (
      select 1 from integrity_flags
      where user_id = p_user_id and reviewed_at is null
        and created_at > now() - interval '14 days')
    then 0.5::numeric else 0.2::numeric end;
end;
$$;

-- 7. "Check this one": the manager physically checked a submission.
create or replace function record_spot_verification(
  p_submission_id integer, p_result text, p_note text default null,
  p_user_id integer default null
) returns void
language plpgsql security definer as $$
declare
  s task_submissions;
  me integer := nullif(current_setting('request.jwt.claims', true)::jsonb
                       -> 'app_metadata' ->> 'local_user_id', '')::integer;
  who integer;
begin
  select * into s from task_submissions where id = p_submission_id;
  if s.id is null or not (can_access_site(s.site_id) and integrity_caller_is_manager()) then
    raise exception 'only a manager can record a check';
  end if;
  if p_result not in ('matches', 'mismatch') then
    raise exception 'result must be matches or mismatch';
  end if;
  -- The checking manager: their PIN session's own id, else their
  -- leadership login's linked user row.
  who := coalesce(me,
                  (select id from users where supabase_user_id::text = auth.uid()::text limit 1),
                  p_user_id);
  if who is null then
    raise exception 'could not tell who is checking';
  end if;
  insert into manager_spot_verifications (site_id, task_submission_id, checked_by_user_id, result, note)
    values (s.site_id, s.id, who, p_result, p_note);
  if p_result = 'mismatch' then
    insert into integrity_flags (site_id, user_id, task_submission_id, kind, detail)
      values (s.site_id, s.completed_by_user_id, s.id, 'check_mismatch',
              format('%s: manager checked and it did not match%s', s.task_title,
                     case when p_note is null or p_note = '' then '' else ' - ' || p_note end));
  end if;
end;
$$;

revoke execute on function my_spot_check_rate(integer) from public, anon;
revoke execute on function record_spot_verification(integer, text, text, integer) from public, anon;
grant execute on function my_spot_check_rate(integer) to authenticated;
grant execute on function record_spot_verification(integer, text, text, integer) to authenticated;
