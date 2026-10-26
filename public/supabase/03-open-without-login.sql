-- Two Edits: let the app work WITHOUT a sign-in screen. Run once in SQL Editor → New query → Run.
-- After this, anyone who has your app link can view and change stock, sales and photos.
-- Keep the link private. To bring the login back, run 04 (see README).

grant select, insert, update, delete on public.products, public.sales to anon;

drop policy if exists "App without login manages products" on public.products;
create policy "App without login manages products" on public.products
  for all to anon using (true) with check (true);

drop policy if exists "App without login manages sales" on public.sales;
create policy "App without login manages sales" on public.sales
  for all to anon using (true) with check (true);

drop policy if exists "App without login reads photos" on storage.objects;
create policy "App without login reads photos" on storage.objects
  for select to anon using (bucket_id = 'shop');
drop policy if exists "App without login adds photos" on storage.objects;
create policy "App without login adds photos" on storage.objects
  for insert to anon with check (bucket_id = 'shop');
drop policy if exists "App without login changes photos" on storage.objects;
create policy "App without login changes photos" on storage.objects
  for update to anon using (bucket_id = 'shop') with check (bucket_id = 'shop');
drop policy if exists "App without login deletes photos" on storage.objects;
create policy "App without login deletes photos" on storage.objects
  for delete to anon using (bucket_id = 'shop');
