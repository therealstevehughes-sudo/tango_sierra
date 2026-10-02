-- Account-management/admin tool extensions (2026-10-02) — three gaps
-- flagged against the original admin tool spec: payment status needs
-- last_payment_failed_at (not previously selected by the client, column
-- already existed), reported bugs/errors need a capture mechanism that
-- never existed anywhere in the app (ContactVenuRiteScreen is just a
-- mailto link, no ticketing system to surface), and service-provider
-- purchases need a superadmin write action to mark a fee actually billed
-- (the read side already works — service_provider_unlocks already has
-- superadmin_read_service_provider_unlocks from the original admin tool
-- migration).

-- Bug/error reports — any staff member can report a problem with the
-- app itself (distinct from Issues, which is for venue/operational
-- incidents like accidents or supply problems, not software bugs).
create table if not exists bug_reports (
  id bigint generated always as identity primary key,
  organisation_id integer not null references organisations(id),
  site_id integer references sites(id),
  reported_by_user_id integer references users(id),
  title text not null,
  description text not null,
  app_version text,
  platform text,
  status text not null default 'open' check (status in ('open', 'resolved')),
  created_at timestamptz not null default now(),
  resolved_at timestamptz,
  admin_note text
);

alter table bug_reports enable row level security;

-- Tenant-side: any authenticated member of the org can read/insert their
-- own org's reports (so leadership can see what's been reported too),
-- nobody tenant-side can update status — resolving is a VenuRite-side
-- action.
create policy "bug_reports_tenant_read" on bug_reports
  for select
  using (
    organisation_id = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer
  );

create policy "bug_reports_tenant_insert" on bug_reports
  for insert
  with check (
    organisation_id = (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'organisation_id')::integer
  );

create policy "superadmin_read_bug_reports" on bug_reports
  for select using (is_superadmin());

create or replace function admin_set_bug_report_status(
  p_bug_report_id bigint,
  p_resolved boolean,
  p_admin_note text default null
)
returns void
language plpgsql
security definer
as $$
begin
  if not is_superadmin() then
    raise exception 'not authorized';
  end if;
  update bug_reports
    set status = case when p_resolved then 'resolved' else 'open' end,
        resolved_at = case when p_resolved then now() else null end,
        admin_note = coalesce(p_admin_note, admin_note)
    where id = p_bug_report_id;
end;
$$;

-- Real payment collection for the unlock fee (2026-09-29's "recorded as
-- intent only" gap, closed 2026-10-02) — the `unlock-service-provider-billed`
-- Edge Function attempts a real one-off GoCardless payment immediately at
-- unlock time (an org's mandate is already set up for its main
-- subscription; a one-off Payment against the same mandate needs no new
-- mandate flow). Traceability column for the resulting GoCardless payment.
alter table service_provider_unlocks add column if not exists gocardless_payment_id text;

-- Service-provider-purchase tracking: manual "mark as billed" action,
-- same v1-manual convention as admin_set_subscription_restricted — real
-- GoCardless collection for this fee is wired separately (folded into
-- the existing roster-addon-billing recompute, see that function's own
-- updated doc comment), this RPC is only for a superadmin to correct a
-- row by hand if needed (e.g. a one-off manual invoice adjustment).
create or replace function admin_set_unlock_billed(
  p_unlock_id bigint,
  p_billed boolean
)
returns void
language plpgsql
security definer
as $$
begin
  if not is_superadmin() then
    raise exception 'not authorized';
  end if;
  update service_provider_unlocks
    set billed = p_billed
    where id = p_unlock_id;
end;
$$;
