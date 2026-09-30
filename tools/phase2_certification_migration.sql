-- Phase 2, certification-expiry shift eligibility, part 1 (2026-09-30).
-- Run this on the live server (psql), then `docker restart supabase-rest`
-- so PostgREST picks up the new column, same standing rule as every prior
-- migration in tools/.

-- === Certificate document upload (TrainingRecords) ===
alter table training_records add column if not exists certificate_file_url text;

-- === Storage bucket for uploaded certificate photos/scans ===
-- Private (NOT public) — these are personal staff records. Create via
-- Supabase Studio > Storage > New bucket, name exactly
-- "certification-documents", "Public bucket" left OFF. Then run the RLS
-- policies below (Studio > Storage > Policies, or via this SQL).
--
-- Path convention written by the app: {site_id}/{user_id}/{timestamp}.{ext}
-- — mirrors this backend's existing can_access_site() tenant-isolation
-- check, applied here to the folder path's first segment.
insert into storage.buckets (id, name, public)
values ('certification-documents', 'certification-documents', false)
on conflict (id) do nothing;

drop policy if exists "certification_documents_tenant_isolation" on storage.objects;

create policy "certification_documents_tenant_isolation"
  on storage.objects
  for all
  using (
    bucket_id = 'certification-documents'
    and can_access_site((storage.foldername(name))[1]::integer)
  )
  with check (
    bucket_id = 'certification-documents'
    and can_access_site((storage.foldername(name))[1]::integer)
  );
