-- AI assistant app-guide category (2026-10-16). The 2026-10-04 entry
-- assumed no schema change was needed, but compliance_chunks has a CHECK
-- limiting source_category to legislation/guidance — found when the first
-- real embed run was rejected (transaction rolled back, nothing written).
alter table compliance_chunks drop constraint if exists compliance_chunks_source_category_check;
alter table compliance_chunks add constraint compliance_chunks_source_category_check
  check (source_category in ('legislation', 'guidance', 'app_guide'));
