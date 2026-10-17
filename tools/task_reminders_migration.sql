-- Mid-shift notifications (2026-10-17, founder-approved plan 3).
--
-- While someone is clocked in, a push to their own phone when one of their
-- timed tasks opens ("Due now"), and again if its window closes undone
-- ("Overdue"). The `task-due-reminders` Edge Function calls
-- claim_due_task_reminders() every 5 minutes from cron; the log table
-- makes each reminder go out at most once, however often it runs.
--
-- Scope: timed tasks only (a window start, or "from start of shift"), on
-- daily / per-shift / 2x / 3x daily schedules. Times are UK local time —
-- venues have no time-zone setting yet (UK-only launch).
--
-- Shared venue tablets aren't anyone's personal phone, so they get a
-- "due now" count on each person's name instead (site_due_now_counts).

-- The app has always read/written users.preferred_locale (language
-- picker, end-of-shift summary), but the column was never created on the
-- server — so the end-of-shift summary query failed silently and was never
-- sent (found 2026-10-17).
alter table users add column if not exists preferred_locale text;

create table if not exists task_reminder_log (
  schedule_id integer not null,
  kind text not null check (kind in ('due', 'overdue')),
  for_date date not null,
  user_id integer,
  sent_at timestamptz not null default now(),
  primary key (schedule_id, kind, for_date)
);
alter table task_reminder_log enable row level security;
revoke all on task_reminder_log from anon, authenticated;

-- Timed schedules of people clocked in right now, with today's window in
-- minutes since local midnight and whether they've done it today.
create or replace function _timed_tasks_now()
returns table (
  schedule_id integer,
  user_id integer,
  site_id integer,
  template_group_id integer,
  start_m integer,
  end_m integer,
  now_m integer,
  today date,
  done_today boolean
)
language sql stable security definer as $$
  with clock as (
    select (now() at time zone 'Europe/London') as local_now
  ),
  open_shifts as (
    select distinct on (sl.user_id) sl.user_id,
           (sl.clock_in_at at time zone 'Europe/London') as clock_in_local
    from shift_logs sl
    where sl.clock_out_at is null and sl.clock_in_at > now() - interval '16 hours'
    order by sl.user_id, sl.clock_in_at desc
  )
  select s.id, s.assigned_user_id, s.site_id, s.task_template_group_id,
         case when s.window_starts_at_shift_start
              then (extract(hour from os.clock_in_local) * 60 + extract(minute from os.clock_in_local))::integer
              else s.window_start_minutes end,
         s.window_end_minutes_exclusive,
         (extract(hour from c.local_now) * 60 + extract(minute from c.local_now))::integer,
         c.local_now::date,
         exists (
           select 1 from task_submissions ts
           where ts.task_schedule_id = s.id
             and ts.status <> 'NOT_COMPLETED'
             and (ts.completed_at at time zone 'Europe/London')::date = c.local_now::date)
  from task_schedules s
  join open_shifts os on os.user_id = s.assigned_user_id
  cross join clock c
  where s.active
    and s.frequency in ('daily', 'perShift', 'twoXDaily', 'threeXDaily')
    and (s.window_start_minutes is not null or s.window_starts_at_shift_start)
$$;
revoke execute on function _timed_tasks_now() from public, anon, authenticated;

-- Called by the Edge Function with the service role. Returns only
-- reminders not sent before (and records them as sent).
create or replace function claim_due_task_reminders()
returns table (user_id integer, fcm_token text, locale text, kind text, task_title text)
language plpgsql security definer as $$
declare
  r record;
  k text;
begin
  for r in select * from _timed_tasks_now() t where not t.done_today loop
    k := null;
    if r.end_m is not null and r.now_m >= r.end_m and r.now_m < r.end_m + 30 then
      k := 'overdue';
    elsif r.start_m is not null and r.now_m >= r.start_m and r.now_m < r.start_m + 30
          and (r.end_m is null or r.now_m < r.end_m) then
      k := 'due';
    end if;
    continue when k is null;
    insert into task_reminder_log (schedule_id, kind, for_date, user_id)
      values (r.schedule_id, k, r.today, r.user_id)
      on conflict do nothing;
    continue when not found;
    return query
      select u.id, u.fcm_token, coalesce(u.preferred_locale, 'en'), k,
             (select tt.title from task_templates tt
              where tt.template_group_id = r.template_group_id
              order by tt.version_number desc limit 1)
      from users u where u.id = r.user_id and u.fcm_token is not null;
  end loop;
end;
$$;
revoke execute on function claim_due_task_reminders() from public, anon, authenticated;
grant execute on function claim_due_task_reminders() to service_role;

-- The shared tablet's name list: how many timed tasks are open and not
-- done right now, per clocked-in person at this venue.
create or replace function site_due_now_counts(p_site_id integer)
returns table (user_id integer, due_count integer)
language sql stable security definer as $$
  select t.user_id, count(*)::integer
  from _timed_tasks_now() t
  where t.site_id = p_site_id
    and can_access_site(p_site_id)
    and not t.done_today
    and t.start_m is not null and t.now_m >= t.start_m
  group by t.user_id
$$;
revoke execute on function site_due_now_counts(integer) from public, anon;
grant execute on function site_due_now_counts(integer) to authenticated;

-- Same counts for the device-login function (service role, called with a
-- valid venue setup code) — the tablet has no signed-in session before
-- someone picks their name.
create or replace function site_due_now_counts_for_device(p_site_id integer)
returns table (user_id integer, due_count integer)
language sql stable security definer as $$
  select t.user_id, count(*)::integer
  from _timed_tasks_now() t
  where t.site_id = p_site_id and not t.done_today
    and t.start_m is not null and t.now_m >= t.start_m
  group by t.user_id
$$;
revoke execute on function site_due_now_counts_for_device(integer) from public, anon, authenticated;
grant execute on function site_due_now_counts_for_device(integer) to service_role;
