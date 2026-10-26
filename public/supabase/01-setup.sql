-- Two Edits: full setup for a NEW Supabase project. Run once in SQL Editor → New query → Run.

create table if not exists public.products (
  sku text primary key,
  name text not null,
  supplier text not null default '',
  cost numeric not null default 0,
  landed numeric not null default 0,
  price numeric not null default 0,
  stock jsonb not null default '{}'::jsonb,
  flag text not null default '',
  updated_at timestamptz not null default now()
);

create table if not exists public.sales (
  id text primary key,
  sku text not null,
  size text not null,
  qty integer not null default 1,
  price numeric not null default 0,
  cost numeric not null default 0,
  pay text not null default '',
  date date not null default current_date,
  note text not null default '',
  ts bigint,
  created_at timestamptz not null default now()
);
create index if not exists sales_date_idx on public.sales (date);
create index if not exists sales_sku_idx on public.sales (sku);

-- Only signed-in shop accounts can read or change anything
alter table public.products enable row level security;
alter table public.sales enable row level security;
revoke all on public.products, public.sales from anon;
grant select, insert, update, delete on public.products, public.sales to authenticated;

drop policy if exists "Shop accounts manage products" on public.products;
create policy "Shop accounts manage products" on public.products
  for all to authenticated using (true) with check (true);
drop policy if exists "Shop accounts manage sales" on public.sales;
create policy "Shop accounts manage sales" on public.sales
  for all to authenticated using (true) with check (true);

-- Live updates between phones
do $$ begin
  alter publication supabase_realtime add table public.products;
exception when duplicate_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.sales;
exception when duplicate_object then null; end $$;

-- Your current stock (from the Excel sheet)
insert into public.products (sku, name, supplier, cost, landed, price, stock, flag) values
  ('TE-001', 'Yellow', 'Bajaj Trends', 895, 1177.13, 2149, '{"M": 1, "L": 1, "XL": 1, "XXL": 1}'::jsonb, ''),
  ('TE-002', 'Grey 1', 'Bajaj Trends', 895, 1177.13, 2149, '{"M": 1, "L": 1, "XL": 1, "XXL": 1}'::jsonb, ''),
  ('TE-003', 'Blue', 'Bajaj Trends', 850, 1117.94, 2049, '{"L": 1, "XL": 1}'::jsonb, ''),
  ('TE-004', 'Orange', 'Bajaj Trends', 850, 1117.94, 2049, '{"M": 1, "XXL": 1}'::jsonb, ''),
  ('TE-005', 'Pink 1', 'Bajaj Trends', 850, 1117.94, 2049, '{"M": 1, "L": 1}'::jsonb, ''),
  ('TE-006', 'Pink 2', 'Bajaj Trends', 850, 1117.94, 2049, '{"M": 1, "L": 1, "XL": 1, "XXL": 1, "XXXL": 1}'::jsonb, 'Bill says 4 pcs but 5 entered. Recount.'),
  ('TE-007', 'Peach', 'Bajaj Trends', 685, 900.93, 1649, '{"XL": 1, "XXL": 1}'::jsonb, 'Bill says 1 pc but 2 entered. Recount.'),
  ('TE-008', 'White', 'Bajaj Trends', 685, 900.93, 1649, '{"L": 1, "XL": 1, "XXL": 1, "XXXL": 1}'::jsonb, ''),
  ('TE-009', 'Elephant', 'Bajaj Trends', 875, 1150.83, 2099, '{"M": 1, "L": 1, "XL": 1, "XXL": 1}'::jsonb, ''),
  ('TE-010', 'Blue', 'Bajaj Trends', 605, 795.71, 1449, '{}'::jsonb, 'Quantity not confirmed. Count and enter stock.'),
  ('TE-011', 'Red & Yellow', 'Bajaj Trends', 605, 795.71, 1449, '{"XXL": 2, "XXXL": 2}'::jsonb, ''),
  ('TE-012', 'Sky Blue', 'Bajaj Trends', 675, 887.78, 1649, '{"M": 1, "L": 1, "XL": 1, "XXL": 1}'::jsonb, ''),
  ('TE-013', 'Red', 'Bajaj Trends', 765, 1006.15, 1849, '{"M": 1, "XL": 1}'::jsonb, ''),
  ('TE-014', 'Pink', 'Bajaj Trends', 765, 1006.15, 1849, '{"L": 1, "XXL": 1}'::jsonb, ''),
  ('TE-015', 'Off White Co-ord', 'Bajaj Trends', 915, 1203.43, 1749, '{"M": 1, "L": 1, "XL": 1, "XXL": 1}'::jsonb, ''),
  ('TE-016', 'Yellow Co-ord', 'Bajaj Trends', 1250, 1644.04, 2349, '{"M": 1, "XL": 1, "XXL": 1, "XXXL": 1}'::jsonb, 'M was sold but not in opening stock. Recount.'),
  ('TE-017', 'Black Purple Co-ord', 'Bajaj Trends', 1195, 1571.7, 2449, '{"M": 1, "L": 1, "XL": 1, "XXL": 1}'::jsonb, ''),
  ('TE-018', 'White Co-ord', 'Bajaj Trends', 1095, 1440.18, 1849, '{"M": 1, "L": 1, "XL": 1, "XXL": 1}'::jsonb, ''),
  ('TE-019', 'Rust', 'Bajaj Trends', 765, 1006.15, 1849, '{"M": 1, "L": 1, "XL": 1, "XXL": 1}'::jsonb, ''),
  ('TE-020', 'Pink', 'Bajaj Trends', 935, 1229.74, 1999, '{"M": 1, "L": 1}'::jsonb, ''),
  ('TE-021', 'Red Bandhani', 'Bajaj Trends', 550, 723.38, 1349, '{}'::jsonb, 'Quantity not confirmed. Count and enter stock.'),
  ('TE-022', 'Orange Bandhani', 'Bajaj Trends', 550, 723.38, 1349, '{}'::jsonb, 'Quantity not confirmed. Count and enter stock.'),
  ('TE-023', 'Unicorn Green', 'Bajaj Trends', 1675, 2203.01, 2999, '{"M": 1, "L": 1, "XL": 1, "XXL": 1}'::jsonb, ''),
  ('TE-024', 'Jeans', 'Bajaj Trends', 1350, 1775.56, 2399, '{"M": 1, "L": 1, "XL": 1, "XXL": 1}'::jsonb, 'M was sold but not in opening stock. Recount.'),
  ('TE-025', 'Blue Green', 'Bajaj Trends', 690, 907.51, 1699, '{}'::jsonb, 'Quantity not confirmed. Count and enter stock.'),
  ('TE-026', 'Green', 'Bajaj Trends', 691, 908.82, 1699, '{}'::jsonb, 'Quantity not confirmed. Count and enter stock.'),
  ('TE-027', 'Black Co-ord', 'Bajaj Trends', 455, 598.43, 1099, '{"XL": 1, "XXL": 1, "XXXL": 1}'::jsonb, ''),
  ('TE-028', 'Brown Co-ord', 'Bajaj Trends', 990, 1302.08, 2399, '{}'::jsonb, 'Quantity not confirmed. Count and enter stock.'),
  ('TE-029', 'Pink Anarkali', 'Label Blessings', 2695, 3544.54, 4749, '{"XL": 1}'::jsonb, ''),
  ('TE-030', 'Black Anarkali', 'Label Blessings', 2695, 3544.54, 4749, '{"L": 1}'::jsonb, ''),
  ('TE-031', 'Pink', 'Label Blessings', 1795, 2360.84, 3549, '{"M": 1, "L": 1}'::jsonb, ''),
  ('TE-032', 'Ivory', 'Label Blessings', 1695, 2229.31, 3349, '{"M": 1, "L": 1}'::jsonb, ''),
  ('TE-033', 'Peach Cutwork', 'Label Blessings', 1695, 2229.31, 3199, '{"M": 1, "L": 1, "XL": 1, "XXL": 1}'::jsonb, ''),
  ('TE-034', 'Peach', 'Label Blessings', 2795, 3676.06, 4949, '{"M": 1, "XL": 1}'::jsonb, ''),
  ('TE-035', 'Lilac Purple', 'Label Blessings', 2695, 3544.54, 4749, '{"M": 1, "XL": 1}'::jsonb, ''),
  ('TE-036', 'Grey & Purple', 'Label Blessings', 2695, 3544.54, 4749, '{"M": 1, "L": 1}'::jsonb, ''),
  ('TE-037', 'Golden', 'Label Blessings', 1395, 1834.74, 2849, '{"L": 1, "XL": 1}'::jsonb, ''),
  ('TE-038', 'Blue & Peach', 'Label Blessings', 1695, 2229.31, 3099, '{"M": 1, "L": 1, "XL": 1, "XXL": 1}'::jsonb, ''),
  ('TE-039', 'Brown / Cream', 'Label Blessings', 1595, 2097.79, 2799, '{"M": 1, "L": 1, "XL": 1, "XXL": 1}'::jsonb, ''),
  ('TE-040', 'Rust', 'Label Blessings', 2795, 3676.06, 4949, '{"XXL": 1}'::jsonb, ''),
  ('TE-041', 'Ivory Brown', 'Label Blessings', 2395, 3149.97, 4949, '{"M": 1, "XL": 1}'::jsonb, ''),
  ('TE-042', 'Ivory', 'Label Blessings', 2695, 3544.54, 5499, '{"M": 1, "L": 1}'::jsonb, ''),
  ('TE-043', 'Copper', 'Label Blessings', 1295, 1703.22, 3099, '{"M": 1, "XL": 1}'::jsonb, ''),
  ('TE-044', 'Co-Set Green', 'Label Blessings', 995, 1308.65, 2399, '{}'::jsonb, 'Quantity not confirmed. Count and enter stock.'),
  ('TE-045', 'Ladies Top 6106 (1)', 'Vayolette Shirts', 320, 420.87, 649, '{"L": 2}'::jsonb, ''),
  ('TE-046', 'Ladies Top 6106 (2)', 'Vayolette Shirts', 305, 401.14, 599, '{"L": 3}'::jsonb, ''),
  ('TE-047', 'Ladies Top 6106 (3)', 'Vayolette Shirts', 320, 420.87, 649, '{"L": 3}'::jsonb, ''),
  ('TE-048', 'Ladies Top 6106 (4)', 'Vayolette Shirts', 300, 394.57, 649, '{"L": 2}'::jsonb, ''),
  ('TE-049', 'Ladies Top 6106 (5)', 'Vayolette Shirts', 290, 381.42, 549, '{"L": 6}'::jsonb, ''),
  ('TE-050', 'Ladies Top 6106 (6)', 'Vayolette Shirts', 270, 355.11, 549, '{"L": 3}'::jsonb, ''),
  ('TE-051', 'Ladies Top 6106 (7)', 'Vayolette Shirts', 260, 341.96, 549, '{"L": 4}'::jsonb, ''),
  ('TE-052', 'Ladies Top 6106 (8)', 'Vayolette Shirts', 335, 440.6, 699, '{"L": 3}'::jsonb, ''),
  ('TE-053', 'Ladies Top 6106 (9)', 'Vayolette Shirts', 365, 480.06, 749, '{"L": 3}'::jsonb, ''),
  ('TE-054', 'Blue Cord', 'Radhika', 1095, 1440.18, 2099, '{"M": 1, "L": 1, "XL": 1}'::jsonb, ''),
  ('TE-055', 'Pink Cord', 'Radhika', 1295, 1703.22, 2449, '{"M": 1, "L": 1}'::jsonb, ''),
  ('TE-056', 'Green Dress', 'Radhika', 1425, 1874.2, 2699, '{"M": 1, "L": 1}'::jsonb, ''),
  ('TE-057', 'Orange Dress', 'Radhika', 850, 1117.94, 1599, '{"L": 1, "XL": 1}'::jsonb, ''),
  ('TE-058', 'Mustard', 'Ridhi Sidhi', 1695, 2229.31, 3199, '{"4XL": 1}'::jsonb, ''),
  ('TE-059', 'Gota Work', 'No Name', 650, 854.9, 1449, '{"XL": 2, "XXL": 1}'::jsonb, '')
on conflict (sku) do nothing;

-- Your first 5 days of sales
insert into public.sales (id, sku, size, qty, price, cost, pay, date, note, ts) values
  ('xl01', 'TE-001', 'XXL', 1, 2149, 1177.13, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000001),
  ('xl02', 'TE-002', 'M', 1, 2149, 1177.13, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000002),
  ('xl03', 'TE-002', 'L', 1, 2149, 1177.13, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000003),
  ('xl04', 'TE-007', 'XXL', 1, 1649, 900.93, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000004),
  ('xl05', 'TE-008', 'XXL', 1, 1649, 900.93, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000005),
  ('xl06', 'TE-008', 'XXXL', 1, 1649, 900.93, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000006),
  ('xl07', 'TE-011', 'XXXL', 1, 1449, 795.71, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000007),
  ('xl08', 'TE-014', 'XXL', 1, 1849, 1006.15, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000008),
  ('xl09', 'TE-015', 'L', 1, 1749, 1203.43, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000009),
  ('xl10', 'TE-016', 'M', 1, 2349, 1644.04, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000010),
  ('xl11', 'TE-023', 'M', 1, 2999, 2203.01, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000011),
  ('xl12', 'TE-023', 'XXL', 1, 2999, 2203.01, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000012),
  ('xl13', 'TE-024', 'M', 1, 2399, 1775.56, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000013),
  ('xl14', 'TE-024', 'XXL', 1, 2399, 1775.56, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000014),
  ('xl15', 'TE-027', 'XXXL', 1, 1099, 598.43, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000015),
  ('xl16', 'TE-033', 'M', 1, 3199, 2229.31, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000016),
  ('xl17', 'TE-033', 'XXL', 1, 3199, 2229.31, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000017),
  ('xl18', 'TE-041', 'M', 1, 4949, 3149.97, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000018),
  ('xl19', 'TE-046', 'L', 1, 599, 401.14, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000019),
  ('xl20', 'TE-047', 'L', 1, 649, 420.87, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000020),
  ('xl21', 'TE-048', 'L', 1, 649, 394.57, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000021),
  ('xl22', 'TE-049', 'L', 3, 549, 381.42, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000022),
  ('xl23', 'TE-052', 'L', 1, 699, 440.6, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000023),
  ('xl24', 'TE-054', 'M', 1, 2099, 1440.18, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000024),
  ('xl25', 'TE-054', 'XL', 1, 2099, 1440.18, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000025),
  ('xl26', 'TE-058', '4XL', 1, 3199, 2229.31, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000026),
  ('xl27', 'TE-059', 'XL', 2, 1449, 854.9, '', '2026-10-23', 'From Excel (first 5 days)', 1761200000027)
on conflict (id) do nothing;


-- Photos (also in update-photos.sql)

-- 1. Products get a photo
alter table public.products add column if not exists photo text not null default '';

-- 2. A storage folder ("bucket") for product photos
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('shop', 'shop', true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public = true,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

-- 3. Only signed-in shop accounts can add, replace or delete photos
drop policy if exists "Shop accounts read photos" on storage.objects;
create policy "Shop accounts read photos" on storage.objects
  for select to authenticated using (bucket_id = 'shop');
drop policy if exists "Shop accounts add photos" on storage.objects;
create policy "Shop accounts add photos" on storage.objects
  for insert to authenticated with check (bucket_id = 'shop');
drop policy if exists "Shop accounts change photos" on storage.objects;
create policy "Shop accounts change photos" on storage.objects
  for update to authenticated using (bucket_id = 'shop') with check (bucket_id = 'shop');
drop policy if exists "Shop accounts delete photos" on storage.objects;
create policy "Shop accounts delete photos" on storage.objects
  for delete to authenticated using (bucket_id = 'shop');
