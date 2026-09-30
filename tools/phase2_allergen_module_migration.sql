-- Phase 2, Natasha's Law / allergen module, part 1 (2026-09-30) — data
-- model + RLS for the ingredient library, menu items, and their allergen
-- tags. Run the same way as every other migration in this folder: SSH in,
-- `docker exec -i supabase-db psql -U postgres -d postgres < this_file.sql`,
-- then `docker restart supabase-rest`.
--
-- Design (agreed with founder, 2026-09-30): any site-accessible staff
-- member can draft a dish and its ingredient list; only supervisor tier
-- and above can APPROVE a dish, which is the moment its allergen tags
-- actually get published. Enforced below by restricting who can set
-- menu_items.status = 'approved' and who can write
-- menu_item_allergen_tags at all (those tags only ever get written as
-- part of an approval).

create table if not exists ingredients (
  id bigint generated always as identity primary key,
  site_id integer not null references sites(id),
  name text not null,
  default_allergens text[] not null default '{}',
  created_at timestamptz not null default now(),
  unique (site_id, name)
);

alter table ingredients enable row level security;

create policy "ingredients_tenant_isolation" on ingredients
  for all
  using (can_access_site(site_id))
  with check (can_access_site(site_id));

create table if not exists menu_items (
  id bigint generated always as identity primary key,
  site_id integer not null references sites(id),
  name text not null,
  category text,
  status text not null default 'draft' check (status in ('draft', 'approved')),
  created_by_user_id integer not null references users(id),
  created_at timestamptz not null default now(),
  approved_by_user_id integer references users(id),
  approved_at timestamptz
);

alter table menu_items enable row level security;

create policy "menu_items_read" on menu_items
  for select
  using (can_access_site(site_id));

create policy "menu_items_insert" on menu_items
  for insert
  with check (can_access_site(site_id) and status = 'draft');

-- Anyone at the site can edit a draft item (name/category), or drop an
-- approved item back to draft (setIngredients does this) — but only
-- supervisor+ can set status TO 'approved'.
create policy "menu_items_update" on menu_items
  for update
  using (can_access_site(site_id))
  with check (
    can_access_site(site_id)
    and (
      status = 'draft'
      or (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
        in ('supervisor', 'venueManager', 'regional', 'executive')
    )
  );

create table if not exists menu_item_ingredients (
  id bigint generated always as identity primary key,
  menu_item_id bigint not null references menu_items(id) on delete cascade,
  ingredient_id bigint not null references ingredients(id)
);

alter table menu_item_ingredients enable row level security;

-- No own site_id column — join to the parent menu_item, same shape
-- issue_events already uses for its own parent-issue join (see
-- service_provider_directory_migration.sql's own precedent for this
-- kind of check).
create policy "menu_item_ingredients_tenant_isolation" on menu_item_ingredients
  for all
  using (
    exists (
      select 1 from menu_items mi
      where mi.id = menu_item_ingredients.menu_item_id
        and can_access_site(mi.site_id)
    )
  )
  with check (
    exists (
      select 1 from menu_items mi
      where mi.id = menu_item_ingredients.menu_item_id
        and can_access_site(mi.site_id)
    )
  );

create table if not exists menu_item_allergen_tags (
  id bigint generated always as identity primary key,
  menu_item_id bigint not null references menu_items(id) on delete cascade,
  allergen text not null,
  status text not null check (status in ('contains', 'may_contain'))
);

alter table menu_item_allergen_tags enable row level security;

create policy "menu_item_allergen_tags_read" on menu_item_allergen_tags
  for select
  using (
    exists (
      select 1 from menu_items mi
      where mi.id = menu_item_allergen_tags.menu_item_id
        and can_access_site(mi.site_id)
    )
  );

-- Write (insert/delete — these rows are always fully replaced together,
-- never individually updated, see MenuItemRepository.approve) restricted
-- to supervisor+, since this table only ever gets written as part of an
-- approval.
create policy "menu_item_allergen_tags_write" on menu_item_allergen_tags
  for insert
  with check (
    exists (
      select 1 from menu_items mi
      where mi.id = menu_item_allergen_tags.menu_item_id
        and can_access_site(mi.site_id)
    )
    and (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
      in ('supervisor', 'venueManager', 'regional', 'executive')
  );

create policy "menu_item_allergen_tags_delete" on menu_item_allergen_tags
  for delete
  using (
    exists (
      select 1 from menu_items mi
      where mi.id = menu_item_allergen_tags.menu_item_id
        and can_access_site(mi.site_id)
    )
    and (current_setting('request.jwt.claims', true)::jsonb -> 'app_metadata' ->> 'role_tier')
      in ('supervisor', 'venueManager', 'regional', 'executive')
  );
