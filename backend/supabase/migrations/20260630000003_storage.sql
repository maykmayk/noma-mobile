-- Storage buckets

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('gpx-files', 'gpx-files', false, 52428800, array['application/gpx+xml', 'application/xml', 'text/xml']),
  ('track-images', 'track-images', false, 10485760, array['image/jpeg', 'image/png', 'image/webp']);

-- GPX files: owner only
create policy "gpx: owner upload" on storage.objects
  for insert with check (
    bucket_id = 'gpx-files' and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "gpx: owner read" on storage.objects
  for select using (
    bucket_id = 'gpx-files' and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "gpx: owner delete" on storage.objects
  for delete using (
    bucket_id = 'gpx-files' and auth.uid()::text = (storage.foldername(name))[1]
  );

-- Track images: owner only
create policy "track-images: owner upload" on storage.objects
  for insert with check (
    bucket_id = 'track-images' and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "track-images: owner read" on storage.objects
  for select using (
    bucket_id = 'track-images' and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "track-images: owner delete" on storage.objects
  for delete using (
    bucket_id = 'track-images' and auth.uid()::text = (storage.foldername(name))[1]
  );
