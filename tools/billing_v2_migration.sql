-- Billing v2 (2026-10-17, founder-approved): staff-size bands per branch,
-- monthly or yearly billing, three single-use discount code types, and a
-- revenue-hole fix.
--
-- Bands (per branch per month, ex VAT) — keep in sync with
-- lib/shared/models/billing_pricing.dart and the website calculator:
--   Bistro (Small)            1–15 active staff  £39
--   Brasserie (Standard)     16–50              £59
--   Banquet (Large)          51–150             £89
--   Grand (Extra large)     151–300             £129
--   Empire (Enterprise)       300+              custom (billed at Grand
--                                               until a quote is agreed)
-- Head office: from 4 branches, +1 Bistro (£39).
-- Yearly = 11 × monthly (1 month free).
-- "Active staff" = staff who logged in at that branch in the month.
-- A branch moves UP a band only after 2 consecutive months over its
-- limit; it moves DOWN as soon as a month is under.

begin;

-- ===== Revenue-hole fix =====================================================
-- The old tenant_isolation policy let a customer's executive UPDATE/DELETE
-- their own subscriptions row through the public API — i.e. set
-- free_access_granted / founding_offer themselves and never pay. All writes
-- now go through service-role Edge Functions or SECURITY DEFINER admin RPCs.
drop policy if exists "tenant_isolation" on subscriptions;
create policy "subscriptions_read_own" on subscriptions
  for select
  using (
    (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier') = 'executive'
    and can_access_organisation(organisation_id)
  );
revoke insert, update, delete, truncate on subscriptions from anon, authenticated;
revoke all on subscriptions from anon;

-- ===== New subscription fields ==============================================
alter table subscriptions add column if not exists billing_interval text not null default 'monthly'
  check (billing_interval in ('monthly', 'yearly'));
alter table subscriptions add column if not exists discount_percent integer not null default 0
  check (discount_percent between 0 and 100);
alter table subscriptions add column if not exists discount_ends_at timestamptz;
alter table subscriptions add column if not exists current_price_pence integer;
-- Shown in the app: e.g. "Kitchen moves to Brasserie (£59) from 1 Dec".
alter table subscriptions add column if not exists billing_notice text;

-- Existing friends & family customers keep their deal: 50% for life.
update subscriptions set discount_percent = 50 where founding_offer and discount_percent = 0;

-- ===== Discount codes (single use) =========================================
alter table invite_codes add column if not exists code_type text not null default 'half_life'
  check (code_type in ('half_life', 'half_year', 'free_life'));
alter table invite_codes add column if not exists note text;
alter table invite_codes enable row level security;
revoke all on invite_codes from anon, authenticated;

-- ===== Monthly active staff per branch =====================================
create table if not exists site_monthly_activity (
  site_id integer not null references sites(id) on delete cascade,
  user_id integer not null references users(id) on delete cascade,
  month date not null,
  primary key (site_id, user_id, month)
);
alter table site_monthly_activity enable row level security;
create policy "site_monthly_activity_read" on site_monthly_activity
  for select using (can_access_site(site_id));
-- No client writes: recorded by pin-login (service role) only.
grant select on site_monthly_activity to authenticated;

-- ===== Band state per branch ===============================================
create table if not exists site_billing_bands (
  site_id integer primary key references sites(id) on delete cascade,
  band text not null default 'bistro'
    check (band in ('bistro', 'brasserie', 'banquet', 'grand', 'empire')),
  months_over integer not null default 0,
  last_active_count integer not null default 0,
  updated_at timestamptz not null default now()
);
alter table site_billing_bands enable row level security;
create policy "site_billing_bands_read" on site_billing_bands
  for select using (can_access_site(site_id));
grant select on site_billing_bands to authenticated;

-- ===== Pricing (single source of truth on the server) ======================
create or replace function band_for_staff(p_staff integer) returns text
language sql immutable as $$
  select case
    when p_staff <= 15 then 'bistro'
    when p_staff <= 50 then 'brasserie'
    when p_staff <= 150 then 'banquet'
    when p_staff <= 300 then 'grand'
    else 'empire' end;
$$;

create or replace function band_rank(p_band text) returns integer
language sql immutable as $$
  select case p_band when 'bistro' then 1 when 'brasserie' then 2
    when 'banquet' then 3 when 'grand' then 4 else 5 end;
$$;

create or replace function band_price_pence(p_band text) returns integer
language sql immutable as $$
  select case p_band when 'bistro' then 3900 when 'brasserie' then 5900
    when 'banquet' then 8900 else 12900 end;
$$;

-- Monthly total (pence, before discount) and a per-branch breakdown for an
-- organisation, from each branch's CURRENT stored band.
create or replace function org_billing_quote(p_org integer)
returns table (monthly_pence integer, branches integer, head_office boolean, breakdown jsonb)
language sql stable security definer as $$
  with s as (
    select st.id, st.name, coalesce(b.band, 'bistro') as band
    from sites st left join site_billing_bands b on b.site_id = st.id
    where st.organisation_id = p_org
  )
  select
    (coalesce(sum(band_price_pence(band)), 0)
      + case when count(*) >= 4 then 3900 else 0 end)::integer,
    count(*)::integer,
    count(*) >= 4,
    coalesce(jsonb_agg(jsonb_build_object('site_id', id, 'name', name, 'band', band,
      'price_pence', band_price_pence(band)) order by id), '[]'::jsonb)
  from s;
$$;
revoke execute on function org_billing_quote(integer) from public, anon;

-- The app's billing screen: the caller's own organisation only.
create or replace function my_billing_quote()
returns table (monthly_pence integer, branches integer, head_office boolean, breakdown jsonb)
language plpgsql stable security definer as $$
declare
  org integer := nullif(current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id', '')::integer;
begin
  if org is null or not can_access_organisation(org) then
    return;
  end if;
  return query select * from org_billing_quote(org);
end;
$$;
revoke execute on function my_billing_quote() from public, anon;
grant execute on function my_billing_quote() to authenticated;

-- ===== Admin: discount code generator ======================================
drop function if exists admin_generate_discount_code(text, text);
create or replace function admin_generate_discount_code(p_type text, p_note text default null)
returns table (code text)
language plpgsql security definer as $$
declare
  alphabet constant text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; -- no 0/O/1/I
  new_code text;
  i integer;
begin
  if not is_superadmin() then
    raise exception 'not authorized';
  end if;
  if p_type not in ('half_life', 'half_year', 'free_life') then
    raise exception 'unknown code type';
  end if;
  loop
    new_code := 'VR-';
    for i in 1..8 loop
      new_code := new_code || substr(alphabet, 1 + floor(random() * length(alphabet))::integer, 1);
      if i = 4 then new_code := new_code || '-'; end if;
    end loop;
    exit when not exists (select 1 from invite_codes c where c.code = new_code);
  end loop;
  insert into invite_codes (code, created_at, code_type, note, founding_offer)
    values (new_code, now(), p_type, nullif(trim(p_note), ''), p_type <> 'free_life');
  return query select new_code;
end;
$$;
revoke execute on function admin_generate_discount_code(text, text) from public, anon;
grant execute on function admin_generate_discount_code(text, text) to authenticated;

create or replace function admin_list_discount_codes()
returns table (code text, code_type text, note text, created_at timestamptz,
               used_at timestamptz, used_by_org_id integer, used_by_org_name text)
language plpgsql stable security definer as $$
begin
  if not is_superadmin() then
    raise exception 'not authorized';
  end if;
  return query
    select c.code, c.code_type, c.note, c.created_at, c.used_at, c.used_by_org_id, o.name
    from invite_codes c left join organisations o on o.id = c.used_by_org_id
    order by c.created_at desc nulls last;
end;
$$;
revoke execute on function admin_list_discount_codes() from public, anon;
grant execute on function admin_list_discount_codes() to authenticated;

commit;
