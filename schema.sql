-- Run this once in Supabase: SQL Editor > New query > paste > Run
create table regions (id serial primary key, name text not null unique, sort_order int default 0);
create table varieties (id serial primary key, name text not null unique);
create table prices (
  id bigserial primary key,
  region_id int not null references regions(id) on delete cascade,
  variety_id int not null references varieties(id) on delete cascade,
  price_per_kg numeric(8,2) not null check (price_per_kg > 0),
  date date not null,
  source text,
  unique (region_id, variety_id, date)
);
create table admins (user_id uuid primary key references auth.users(id) on delete cascade);

insert into regions (name, sort_order) values
('NCR - National Capital Region',1),('CAR - Cordillera',2),('Region I - Ilocos',3),('Region II - Cagayan Valley',4),
('Region III - Central Luzon',5),('Region IV-A - CALABARZON',6),('MIMAROPA',7),('Region V - Bicol',8),
('Region VI - Western Visayas',9),('Region VII - Central Visayas',10),('Region VIII - Eastern Visayas',11),
('Region IX - Zamboanga Peninsula',12),('Region X - Northern Mindanao',13),('Region XI - Davao',14),
('Region XII - SOCCSKSARGEN',15),('Region XIII - Caraga',16),('BARMM',17);
insert into varieties (name) values ('Regular milled'),('Well milled'),('Premium'),('Special'),('Jasmine / aromatic'),('Glutinous (malagkit)');

-- Who is an admin? (security definer so the check works even though admins is locked)
create function is_admin() returns boolean language sql security definer set search_path = public as
$$ select exists (select 1 from admins where user_id = auth.uid()) $$;
grant execute on function is_admin() to authenticated;

alter table regions enable row level security;
alter table varieties enable row level security;
alter table prices enable row level security;
alter table admins enable row level security;  -- no policies = nobody can read it from the browser

-- Everyone can read
create policy "public read" on regions for select using (true);
create policy "public read" on varieties for select using (true);
create policy "public read" on prices for select using (true);
-- Only admins can change anything
create policy "admin write" on regions for all to authenticated using (is_admin()) with check (is_admin());
create policy "admin write" on varieties for all to authenticated using (is_admin()) with check (is_admin());
create policy "admin write" on prices for all to authenticated using (is_admin()) with check (is_admin());

-- AFTER creating your admin user (Authentication > Users > Add user), run this with your email:
-- insert into admins select id from auth.users where email = 'you@example.com';
