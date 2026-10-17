-- Training quizzes (2026-10-17, founder-approved O/P/Q/R).
--
-- A green tick on a task = read the current guide + passed a 3-question
-- quiz (all 3 right). Questions are picked at random from the task's
-- 5-6, answers shuffled, and marked HERE — the app never receives the
-- right answers. A retry needs the guide read again first. Passes expire
-- after the venue's refresher period (3 months critical / 6 months other
-- by default) and lapse when the guide changes (guide_version).
--
-- Questions come from two places:
--   * standard: one bank per library task, keyed by task title (seeded
--     from tools/quiz/, reviewed by hand);
--   * venue: drafted by VenuRite's AI when a venue edits a guide or adds
--     its own task; only used once a manager approves them.

begin;

create table if not exists quiz_questions (
  id bigint generated always as identity primary key,
  -- standard questions: task_title set, site_id / template_group_id null
  task_title text,
  site_id integer references sites(id),
  template_group_id integer,
  question text not null,
  -- options[1] is the right answer as stored; the order is shuffled per
  -- attempt, so nothing about position gives it away.
  options text[] not null,
  status text not null default 'live'
    check (status in ('live', 'pending', 'retired')),
  source text not null default 'standard' check (source in ('standard', 'ai')),
  guide_version text,
  created_at timestamptz not null default now(),
  approved_by_user_id integer references users(id),
  approved_at timestamptz,
  check (array_length(options, 1) between 3 and 4),
  check ((site_id is null) = (template_group_id is null)),
  check (task_title is not null or site_id is not null)
);

create index if not exists quiz_questions_title_idx
  on quiz_questions (task_title) where site_id is null;
create index if not exists quiz_questions_venue_idx
  on quiz_questions (site_id, template_group_id);

-- Nobody reads this table directly (it holds the answers); everything goes
-- through the functions below.
alter table quiz_questions enable row level security;
revoke all on quiz_questions from anon, authenticated;

create table if not exists quiz_attempts (
  id bigint generated always as identity primary key,
  user_id integer not null references users(id),
  site_id integer not null references sites(id),
  template_group_id integer not null,
  guide_version text not null,
  question_ids bigint[] not null,
  -- per question, the shown position (1-based) of the right answer
  correct_positions smallint[] not null,
  answers smallint[],
  passed boolean,
  started_at timestamptz not null default now(),
  submitted_at timestamptz
);

create index if not exists quiz_attempts_user_idx
  on quiz_attempts (user_id, template_group_id, started_at desc);
create index if not exists quiz_attempts_site_idx
  on quiz_attempts (site_id, submitted_at);

alter table quiz_attempts enable row level security;
revoke all on quiz_attempts from anon, authenticated;

-- Results the app may read: who passed what, when (no answers).
create or replace view quiz_passes
with (security_invoker = true) as
  select user_id, site_id, template_group_id, guide_version,
         submitted_at as passed_at
  from quiz_attempts
  where passed;

-- The view runs as the caller, so it needs its own read path: a policy
-- that only ever exposes passed rows' identity columns via the view.
create policy "quiz_attempts_read_passes" on quiz_attempts
  for select using (passed and can_access_site(site_id));
grant select (user_id, site_id, template_group_id, guide_version, submitted_at, passed)
  on quiz_attempts to authenticated;
grant select on quiz_passes to authenticated;

-- Venue refresher periods (P).
alter table sites add column if not exists training_refresh_critical_months
  integer not null default 3 check (training_refresh_critical_months between 1 and 36);
alter table sites add column if not exists training_refresh_other_months
  integer not null default 6 check (training_refresh_other_months between 1 and 36);

commit;

-- Caller's own local user id (PIN sessions), or null for GoTrue sessions.
create or replace function quiz_caller_local_user_id() returns integer
language sql stable as $$
  select nullif(current_setting('request.jwt.claims', true)::jsonb
                -> 'app_metadata' ->> 'local_user_id', '')::integer
$$;

create or replace function quiz_caller_is_manager() returns boolean
language sql stable as $$
  select coalesce(current_setting('request.jwt.claims', true)::jsonb
                  -> 'app_metadata' ->> 'role_tier', '')
         in ('venueManager', 'regional', 'executive')
$$;

-- Start a quiz: 3 random questions, options shuffled, no answers sent.
-- Returns no rows when the task has no questions yet. Raises when a retry
-- is attempted without reading the guide again.
create or replace function start_task_quiz(
  p_site_id integer,
  p_template_group_id integer,
  p_task_title text,
  p_guide_version text,
  p_user_id integer
) returns table (
  attempt_id bigint,
  question_no integer,
  question text,
  options text[]
)
language plpgsql security definer as $$
declare
  caller integer := quiz_caller_local_user_id();
  last_fail timestamptz;
  last_read timestamptz;
  use_venue boolean;
  picked bigint[];
  positions smallint[] := '{}';
  shown text[][];
  q record;
  perm integer[];
  new_attempt bigint;
  i integer := 0;
begin
  if not can_access_site(p_site_id) then
    raise exception 'no access to this venue';
  end if;
  if caller is not null and caller <> p_user_id then
    raise exception 'you can only take your own quiz';
  end if;

  -- O: retry only after re-reading the guide.
  select max(submitted_at) into last_fail from quiz_attempts
    where user_id = p_user_id and template_group_id = p_template_group_id
      and site_id = p_site_id and passed = false;
  select max(acknowledged_at) into last_read from training_acknowledgements
    where user_id = p_user_id and template_group_id = p_template_group_id
      and guide_version = p_guide_version;
  if last_read is null then
    raise exception 'read the guide first';
  end if;
  if last_fail is not null and last_read < last_fail then
    raise exception 'read the guide again before retrying';
  end if;

  use_venue := exists (
    select 1 from quiz_questions
    where site_id = p_site_id and template_group_id = p_template_group_id
      and status = 'live');

  select array_agg(id) into picked from (
    select id from quiz_questions
    where status = 'live' and (
      (use_venue and site_id = p_site_id and template_group_id = p_template_group_id)
      or (not use_venue and site_id is null and task_title = p_task_title))
    order by random()
    limit 3
  ) s;

  if picked is null or array_length(picked, 1) < 3 then
    return;
  end if;

  -- Abandoned, unsubmitted attempts are simply superseded.
  insert into quiz_attempts (user_id, site_id, template_group_id, guide_version,
                             question_ids, correct_positions)
    values (p_user_id, p_site_id, p_template_group_id, p_guide_version,
            picked, '{}')
    returning id into new_attempt;

  for q in
    select qq.id, qq.question as qtext, qq.options as opts
    from unnest(picked) with ordinality as u(qid, ord)
    join quiz_questions qq on qq.id = u.qid
    order by u.ord
  loop
    i := i + 1;
    select array_agg(n order by random()) into perm
      from generate_series(1, array_length(q.opts, 1)) n;
    -- position where the right answer (stored first) ended up
    positions := positions || (array_position(perm, 1))::smallint;
    attempt_id := new_attempt;
    question_no := i;
    question := q.qtext;
    options := array(select q.opts[p] from unnest(perm) with ordinality as x(p, o) order by o);
    return next;
  end loop;

  update quiz_attempts set correct_positions = positions where id = new_attempt;
end;
$$;

-- Mark a quiz. p_answers = the chosen shown position (1-based) per
-- question, in question order. All must be right to pass.
create or replace function submit_task_quiz(p_attempt_id bigint, p_answers smallint[])
returns table (passed boolean, correct_count integer, total integer, wrong_questions integer[])
language plpgsql security definer as $$
declare
  a quiz_attempts;
  caller integer := quiz_caller_local_user_id();
  n integer;
  right_count integer := 0;
  wrong integer[] := '{}';
begin
  select * into a from quiz_attempts where id = p_attempt_id;
  if a.id is null or not can_access_site(a.site_id) then
    raise exception 'quiz not found';
  end if;
  if caller is not null and caller <> a.user_id then
    raise exception 'you can only submit your own quiz';
  end if;
  if a.submitted_at is not null then
    raise exception 'this quiz was already submitted';
  end if;
  if a.started_at < now() - interval '2 hours' then
    raise exception 'this quiz has expired - start again';
  end if;
  -- A newer attempt for the same task supersedes this one.
  if exists (select 1 from quiz_attempts
             where user_id = a.user_id and template_group_id = a.template_group_id
               and site_id = a.site_id and id > a.id) then
    raise exception 'this quiz has expired - start again';
  end if;

  n := array_length(a.question_ids, 1);
  if p_answers is null or array_length(p_answers, 1) <> n then
    raise exception 'answer every question';
  end if;
  for i in 1..n loop
    if p_answers[i] = a.correct_positions[i] then
      right_count := right_count + 1;
    else
      wrong := wrong || i;
    end if;
  end loop;

  update quiz_attempts
    set answers = p_answers, passed = (right_count = n), submitted_at = now()
    where id = a.id;

  passed := right_count = n;
  correct_count := right_count;
  total := n;
  wrong_questions := wrong;
  return next;
end;
$$;

-- How many live questions a task has, for the app to know whether a quiz
-- exists (venue-approved ones take over from the standard bank).
create or replace function task_quiz_availability(p_site_id integer)
returns table (template_group_id integer, task_title text, live_count integer, pending_count integer)
language sql stable security definer as $$
  select template_group_id, null::text, count(*) filter (where status = 'live')::integer,
         count(*) filter (where status = 'pending')::integer
    from quiz_questions
    where site_id = p_site_id and can_access_site(p_site_id)
    group by template_group_id
  union all
  select null::integer, task_title, count(*)::integer, 0
    from quiz_questions
    where site_id is null and status = 'live' and can_access_site(p_site_id)
    group by task_title
$$;

-- R: VenuRite's AI drafts questions when a venue edits a guide or adds a
-- task. Drafts are stored as 'pending' (replacing older pending ones) and
-- only go live when a manager approves them.
create or replace function save_task_quiz_drafts(
  p_site_id integer,
  p_template_group_id integer,
  p_guide_version text,
  p_questions jsonb  -- [{"question": "...", "options": ["right", "wrong", ...]}]
) returns table (saved integer)
language plpgsql security definer as $$
declare
  item jsonb;
  n integer := 0;
begin
  if not (can_access_site(p_site_id) and quiz_caller_is_manager()) then
    raise exception 'only a manager can draft quiz questions';
  end if;
  delete from quiz_questions
    where site_id = p_site_id and template_group_id = p_template_group_id
      and status = 'pending';
  for item in select * from jsonb_array_elements(p_questions) loop
    insert into quiz_questions (site_id, template_group_id, question, options,
                                status, source, guide_version)
      values (p_site_id, p_template_group_id, item ->> 'question',
              array(select jsonb_array_elements_text(item -> 'options')),
              'pending', 'ai', p_guide_version);
    n := n + 1;
  end loop;
  saved := n;
  return next;
end;
$$;

-- Managers see a venue's questions with the answers (to review them).
create or replace function list_task_quiz_questions(p_site_id integer, p_template_group_id integer)
returns table (id bigint, question text, options text[], status text, created_at timestamptz)
language plpgsql stable security definer as $$
begin
  if not (can_access_site(p_site_id) and quiz_caller_is_manager()) then
    raise exception 'only a manager can review quiz questions';
  end if;
  return query
    select q.id, q.question, q.options, q.status, q.created_at
    from quiz_questions q
    where q.site_id = p_site_id and q.template_group_id = p_template_group_id
      and q.status in ('live', 'pending')
    order by q.status, q.id;
end;
$$;

-- Approve: pending become live, the old live set is retired. Reject:
-- pending are deleted. p_question_ids (optional) limits approval to the
-- questions the manager kept; the rest of the pending set is deleted.
create or replace function decide_task_quiz_drafts(
  p_site_id integer,
  p_template_group_id integer,
  p_approve boolean,
  p_keep_ids bigint[] default null,
  p_user_id integer default null
) returns table (live_count integer)
language plpgsql security definer as $$
declare
  caller integer := quiz_caller_local_user_id();
begin
  if not (can_access_site(p_site_id) and quiz_caller_is_manager()) then
    raise exception 'only a manager can approve quiz questions';
  end if;
  if p_approve then
    if (select count(*) from quiz_questions
        where site_id = p_site_id and template_group_id = p_template_group_id
          and status = 'pending'
          and (p_keep_ids is null or id = any(p_keep_ids))) < 3 then
      raise exception 'keep at least 3 questions';
    end if;
    update quiz_questions set status = 'retired'
      where site_id = p_site_id and template_group_id = p_template_group_id
        and status = 'live';
    delete from quiz_questions
      where site_id = p_site_id and template_group_id = p_template_group_id
        and status = 'pending' and p_keep_ids is not null and not (id = any(p_keep_ids));
    update quiz_questions
      set status = 'live', approved_at = now(),
          approved_by_user_id = coalesce(caller, p_user_id)
      where site_id = p_site_id and template_group_id = p_template_group_id
        and status = 'pending';
  else
    delete from quiz_questions
      where site_id = p_site_id and template_group_id = p_template_group_id
        and status = 'pending';
  end if;
  return query select count(*)::integer from quiz_questions
    where site_id = p_site_id and template_group_id = p_template_group_id
      and status = 'live';
end;
$$;

-- P: the venue's refresher periods.
create or replace function set_training_refresh_months(
  p_site_id integer, p_critical integer, p_other integer
) returns void
language plpgsql security definer as $$
begin
  if not (can_access_site(p_site_id) and quiz_caller_is_manager()) then
    raise exception 'only a manager can change refresher periods';
  end if;
  update sites set training_refresh_critical_months = p_critical,
                   training_refresh_other_months = p_other
    where id = p_site_id;
end;
$$;

revoke execute on function start_task_quiz(integer, integer, text, text, integer) from public, anon;
revoke execute on function submit_task_quiz(bigint, smallint[]) from public, anon;
revoke execute on function task_quiz_availability(integer) from public, anon;
revoke execute on function save_task_quiz_drafts(integer, integer, text, jsonb) from public, anon;
revoke execute on function list_task_quiz_questions(integer, integer) from public, anon;
revoke execute on function decide_task_quiz_drafts(integer, integer, boolean, bigint[], integer) from public, anon;
revoke execute on function set_training_refresh_months(integer, integer, integer) from public, anon;
grant execute on function start_task_quiz(integer, integer, text, text, integer) to authenticated;
grant execute on function submit_task_quiz(bigint, smallint[]) to authenticated;
grant execute on function task_quiz_availability(integer) to authenticated;
grant execute on function save_task_quiz_drafts(integer, integer, text, jsonb) to authenticated;
grant execute on function list_task_quiz_questions(integer, integer) to authenticated;
grant execute on function decide_task_quiz_drafts(integer, integer, boolean, bigint[], integer) to authenticated;
grant execute on function set_training_refresh_months(integer, integer, integer) to authenticated;

-- Reading a guide again refreshes the record (2026-10-17). A retry after a
-- failed quiz, and a refresher, both need the guide read again; the table
-- keeps one row per (person, task, guide version), so re-reading moves its
-- time forward instead of adding a row.
create or replace function acknowledge_training_guide(
  p_site_id integer,
  p_template_group_id integer,
  p_guide_version text,
  p_user_id integer
) returns table (acknowledged_at timestamptz)
language plpgsql security definer as $$
declare
  caller integer := quiz_caller_local_user_id();
begin
  if not can_access_site(p_site_id) then
    raise exception 'no access to this venue';
  end if;
  if caller is not null and caller <> p_user_id then
    raise exception 'you can only record your own reading';
  end if;
  return query
    insert into training_acknowledgements as t
        (user_id, site_id, template_group_id, guide_version)
      values (p_user_id, p_site_id, p_template_group_id, p_guide_version)
    on conflict (user_id, template_group_id, guide_version)
      do update set acknowledged_at = now(), site_id = excluded.site_id
    returning t.acknowledged_at;
end;
$$;
revoke execute on function acknowledge_training_guide(integer, integer, text, integer) from public, anon;
grant execute on function acknowledge_training_guide(integer, integer, text, integer) to authenticated;
