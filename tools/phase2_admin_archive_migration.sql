-- Account-management/admin tool follow-up: archive companies (2026-10-01,
-- direct founder request after using the tool). Soft-archive only - never
-- a real delete, since this is real customer/compliance data. Archived
-- orgs are hidden from the default "All" view in the admin tool but
-- still fully queryable via the "Archived" filter.

alter table organisations add column if not exists archived_at timestamptz;

create or replace function admin_set_organisation_archived(
  p_organisation_id integer,
  p_archived boolean
)
returns void
language plpgsql
security definer
as $$
begin
  if not is_superadmin() then
    raise exception 'not authorized';
  end if;
  update organisations
    set archived_at = case when p_archived then now() else null end
    where id = p_organisation_id;
end;
$$;
