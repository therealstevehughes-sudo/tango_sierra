-- Department category + equipment model/serial number (2026-09-28, direct
-- founder request). See lib/shared/models/department.dart's own doc
-- comment for why category is independent of the existing free-text name
-- column (a venue can have two differently-named kitchens, both tagged
-- with the same "kitchen" category).
alter table departments add column if not exists category text;
alter table equipment_instances add column if not exists model text;
alter table equipment_instances add column if not exists serial_number text;
