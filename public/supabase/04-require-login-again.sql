-- Two Edits: OPTIONAL. Undo 03 and require a sign-in again.
-- Only run this together with an app version that has the sign-in screen.

drop policy if exists "App without login manages products" on public.products;
drop policy if exists "App without login manages sales" on public.sales;
drop policy if exists "App without login reads photos" on storage.objects;
drop policy if exists "App without login adds photos" on storage.objects;
drop policy if exists "App without login changes photos" on storage.objects;
drop policy if exists "App without login deletes photos" on storage.objects;
revoke all on public.products, public.sales from anon;
