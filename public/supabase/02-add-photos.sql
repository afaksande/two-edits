-- Two Edits: ONLY if your project was set up before photos existed. Run once in SQL Editor.

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
