-- Trusted Service Provider directory, phase 1 (2026-09-29, direct founder
-- request — full design agreed over several turns, see DECISIONS_LOG.md).
-- Backend-only, like Roster: this is inherently a cross-tenant feature (a
-- venue browsing OTHER organisations' shared contacts), which has no
-- meaningful offline/local-only form, so no Drift mirror is attempted —
-- same precedent as Roster's own schema.
--
-- Cross-tenant by design, a genuine exception to this app's usual
-- per-organisation RLS isolation: the base `service_providers` table
-- stays strictly owner-only (RLS below), but browsing OTHER orgs' shared
-- listings goes exclusively through `list_shared_service_providers()`,
-- a SECURITY DEFINER function that masks name/phone/email server-side
-- unless the calling org owns the listing or has paid to unlock it. This
-- is the ONLY sanctioned path to see another org's data anywhere in this
-- backend — never exposed via a plain table SELECT.

create table if not exists service_providers (
  id bigint generated always as identity primary key,
  organisation_id integer not null references organisations(id),
  created_by_user_id integer references users(id),
  name text not null,
  phone text,
  email text,
  category text not null,
  notes text,
  -- Opt-in flag (2026-09-29): a provider added to your own contacts stays
  -- private until you explicitly choose to make it visible (blurred) to
  -- other venues. Off by default — matches this app's "defaults not
  -- lockouts, but never opt OUT of privacy by default" convention.
  shared boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists service_provider_ratings (
  id bigint generated always as identity primary key,
  service_provider_id bigint not null references service_providers(id) on delete cascade,
  rated_by_user_id integer references users(id),
  site_id integer references sites(id),
  price_rating smallint not null check (price_rating between 1 and 5),
  punctuality_rating smallint not null check (punctuality_rating between 1 and 5),
  quality_rating smallint not null check (quality_rating between 1 and 5),
  availability_rating smallint not null check (availability_rating between 1 and 5),
  -- Review text screening (2026-09-29, agreed with the founder): a REGEX
  -- pass for phone/email/URLs happens client-side before this ever
  -- reaches the server (rejected with "please remove contact details"
  -- before submission is even attempted) — an LLM pass to also catch a
  -- business NAME mentioned in free text was agreed as worth doing but
  -- deliberately NOT built this pass (needs wiring into the existing
  -- ai-assistant OpenAI setup as its own small piece of work).
  review_text text,
  created_at timestamptz not null default now()
);

create table if not exists service_provider_unlocks (
  id bigint generated always as identity primary key,
  service_provider_id bigint not null references service_providers(id) on delete cascade,
  unlocking_organisation_id integer not null references organisations(id),
  unlocked_by_user_id integer references users(id),
  -- Seeker-side micro-fee (2026-09-29, agreed with the founder): recorded
  -- here but NOT YET actually collected — no GoCardless charge wired up
  -- this pass. A real, disclosed gap: this column exists so the real
  -- billing integration (added to the org's next payment run, per the
  -- founder's own "impulse-buy, forgotten by next invoice" reasoning)
  -- has something to bill against once built, without a second migration.
  fee_pence integer not null default 79,
  billed boolean not null default false,
  unlocked_at timestamptz not null default now(),
  unique (service_provider_id, unlocking_organisation_id)
);

alter table service_providers enable row level security;
alter table service_provider_ratings enable row level security;
alter table service_provider_unlocks enable row level security;

-- Owner-only direct access — the ONLY way anyone sees another org's row
-- is via list_shared_service_providers() below, never this policy.
drop policy if exists "owner_only" on service_providers;
create policy "owner_only" on service_providers
  using (
    organisation_id = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer
  )
  with check (
    organisation_id = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer
  );

-- Ratings: only the OWNING org of the target provider may insert/read
-- directly (their own experience with their own contact) — cross-org
-- review text is surfaced only via list_provider_reviews() below.
drop policy if exists "owner_only" on service_provider_ratings;
create policy "owner_only" on service_provider_ratings
  using (
    exists (
      select 1 from service_providers sp
      where sp.id = service_provider_id
        and sp.organisation_id = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer
    )
  )
  with check (
    exists (
      select 1 from service_providers sp
      where sp.id = service_provider_id
        and sp.organisation_id = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer
    )
  );

-- Unlocks: an org may only ever see/create its OWN unlock records —
-- never another org's.
drop policy if exists "own_unlocks_only" on service_provider_unlocks;
create policy "own_unlocks_only" on service_provider_unlocks
  using (
    unlocking_organisation_id = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer
  )
  with check (
    unlocking_organisation_id = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer
  );

-- The one sanctioned cross-tenant read in this whole backend. Masks
-- name/phone/email to null unless the calling org owns the listing or
-- has an unlock record for it. Geographic scoping deliberately NOT
-- implemented this pass (disclosed gap) — sites don't carry lat/long
-- today, so "nearby" isn't computable yet; this returns every shared
-- listing platform-wide regardless of organisation.
create or replace function list_shared_service_providers()
returns table (
  id bigint,
  category text,
  name text,
  phone text,
  email text,
  avg_price numeric,
  avg_punctuality numeric,
  avg_quality numeric,
  avg_availability numeric,
  review_count bigint,
  is_own boolean,
  is_unlocked boolean
)
language sql
security definer
set search_path = public
as $$
  select
    sp.id,
    sp.category,
    case when reveal.can_see then sp.name else null end as name,
    case when reveal.can_see then sp.phone else null end as phone,
    case when reveal.can_see then sp.email else null end as email,
    round(avg(r.price_rating), 1) as avg_price,
    round(avg(r.punctuality_rating), 1) as avg_punctuality,
    round(avg(r.quality_rating), 1) as avg_quality,
    round(avg(r.availability_rating), 1) as avg_availability,
    count(r.id) as review_count,
    reveal.is_own,
    reveal.is_unlocked
  from service_providers sp
  left join service_provider_ratings r on r.service_provider_id = sp.id
  cross join lateral (
    select
      (sp.organisation_id = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer) as is_own,
      exists (
        select 1 from service_provider_unlocks u
        where u.service_provider_id = sp.id
          and u.unlocking_organisation_id = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer
      ) as is_unlocked,
      (
        sp.organisation_id = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer
        or exists (
          select 1 from service_provider_unlocks u
          where u.service_provider_id = sp.id
            and u.unlocking_organisation_id = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer
        )
      ) as can_see
  ) reveal
  where sp.shared = true
  group by sp.id, reveal.is_own, reveal.is_unlocked, reveal.can_see
  -- Deterministic, category-grouped ordering (2026-09-29, direct founder
  -- follow-up — "is Find a Provider grouped by type?") so the client can
  -- just render a category header whenever it changes, no client-side
  -- sort needed.
  order by sp.category, sp.id;
$$;

-- Records (or confirms) that the calling org has unlocked a provider's
-- contact details. Idempotent — calling it twice for the same provider
-- is a no-op the second time, never a duplicate charge record.
create or replace function unlock_service_provider(p_provider_id bigint)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  calling_org integer;
begin
  calling_org := (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer;
  if calling_org is null then
    return;
  end if;
  if not exists (select 1 from service_providers where id = p_provider_id and shared = true) then
    return;
  end if;
  insert into service_provider_unlocks (service_provider_id, unlocking_organisation_id, unlocked_by_user_id)
  values (
    p_provider_id,
    calling_org,
    nullif((current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'local_user_id'), '')::integer
  )
  on conflict (service_provider_id, unlocking_organisation_id) do nothing;
end;
$$;

-- Review text for a provider, cross-org visible (star ratings + text)
-- whenever the provider itself is shared — no reviewer identity exposed,
-- matching the "reviews are external, not vetted by VenuRite" framing.
create or replace function list_provider_reviews(p_provider_id bigint)
returns table (
  price_rating smallint,
  punctuality_rating smallint,
  quality_rating smallint,
  availability_rating smallint,
  review_text text,
  created_at timestamptz
)
language sql
security definer
set search_path = public
as $$
  select r.price_rating, r.punctuality_rating, r.quality_rating, r.availability_rating, r.review_text, r.created_at
  from service_provider_ratings r
  join service_providers sp on sp.id = r.service_provider_id
  where r.service_provider_id = p_provider_id
    and (
      sp.shared = true
      or sp.organisation_id = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer
    )
  order by r.created_at desc;
$$;

-- How many contacts the calling org has unlocked in the current billing
-- month — the "3 unlocked this month" running total shown on the
-- directory screen itself (agreed placement: on the screen it's about,
-- not buried in Settings/Account).
-- Returns a one-row table (not a bare scalar) so this reads through the
-- SAME BackendRestClient.rpc() helper as every other RPC in this app,
-- which decodes a JSON array/list — not a raw scalar value.
create or replace function count_unlocks_this_month()
returns table (unlock_count bigint)
language sql
security definer
set search_path = public
as $$
  select count(*)
  from service_provider_unlocks
  where unlocking_organisation_id = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer
    and unlocked_at >= date_trunc('month', now());
$$;

grant execute on function list_shared_service_providers() to authenticated;
grant execute on function unlock_service_provider(bigint) to authenticated;
grant execute on function list_provider_reviews(bigint) to authenticated;
grant execute on function count_unlocks_this_month() to authenticated;
