-- Shared task library on the live server (2026-10-16). Run BEFORE
-- tools/task_library_seed.sql.
--
-- Until now the server had 0 task templates, 0 equipment types and 1
-- (tenant-custom) venue type: the 213-task HORECA library only existed in
-- the app's local Drift seed, so a real backend sign-up got no tasks.

begin;

-- The shared library uses venue type ids 1-12 (matching a fresh local
-- seed). Tenant-custom venue types created so far sit on low ids too —
-- move any that collide to 1000+, repointing their site links.
do $$
declare
  r record;
  new_id integer;
begin
  for r in select id, name, organisation_id from venue_types
           where id <= 12 and organisation_id is not null loop
    new_id := 1000 + r.id;
    insert into venue_types (id, name, organisation_id) values (new_id, r.name, r.organisation_id);
    update site_venue_types set venue_type_id = new_id where venue_type_id = r.id;
    delete from venue_types where id = r.id;
  end loop;
end $$;

create table if not exists task_template_venue_types (
  task_template_group_id integer not null,
  venue_type_id integer not null references venue_types(id) on delete cascade,
  primary key (task_template_group_id, venue_type_id)
);

create table if not exists equipment_type_venue_types (
  equipment_type_id integer not null references equipment_types(id) on delete cascade,
  venue_type_id integer not null references venue_types(id) on delete cascade,
  primary key (equipment_type_id, venue_type_id)
);

-- Shared reference data: every signed-in user can read it; nobody writes
-- it through the API (only this seed, as the database owner).
alter table task_template_venue_types enable row level security;
alter table equipment_type_venue_types enable row level security;
drop policy if exists "task_template_venue_types_read" on task_template_venue_types;
create policy "task_template_venue_types_read" on task_template_venue_types
  for select to authenticated using (true);
drop policy if exists "equipment_type_venue_types_read" on equipment_type_venue_types;
create policy "equipment_type_venue_types_read" on equipment_type_venue_types
  for select to authenticated using (true);
grant select on task_template_venue_types, equipment_type_venue_types to authenticated;

commit;
