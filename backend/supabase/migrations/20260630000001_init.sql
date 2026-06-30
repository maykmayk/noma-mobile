-- Enable PostGIS for geographic data
create extension if not exists postgis;

-- Profiles: user preferences and settings
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  username text unique,
  display_name text,
  avatar_url text,
  -- Units
  distance_unit text not null default 'km' check (distance_unit in ('km', 'mi')),
  speed_unit text not null default 'kmh' check (speed_unit in ('kmh', 'mph')),
  elevation_unit text not null default 'm' check (elevation_unit in ('m', 'ft')),
  -- Apple Health sync
  health_sync_enabled boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Tracks: metadata for each GPX track
create table public.tracks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references public.profiles(id) on delete cascade not null,
  name text not null,
  description text,
  sport_type text not null default 'cycling' check (
    sport_type in ('cycling', 'road_cycling', 'gravel', 'mtb', 'hiking', 'running')
  ),
  -- Stats (computed on upload)
  distance_m float,         -- metres
  elevation_gain_m float,   -- metres
  elevation_loss_m float,
  duration_s integer,       -- seconds
  avg_speed_ms float,       -- m/s
  max_speed_ms float,
  -- Bounds for map preview
  bbox geometry(Polygon, 4326),
  -- Storage reference
  gpx_file_path text,       -- path in Supabase Storage bucket
  -- Timestamps
  recorded_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Waypoints: custom points inside a route (for in-app route creation)
create table public.waypoints (
  id uuid primary key default gen_random_uuid(),
  track_id uuid references public.tracks(id) on delete cascade not null,
  user_id uuid references public.profiles(id) on delete cascade not null,
  name text,
  description text,
  location geometry(Point, 4326) not null,
  elevation_m float,
  "order" integer not null default 0,
  created_at timestamptz not null default now()
);

-- Indexes
create index tracks_user_id_idx on public.tracks(user_id);
create index tracks_recorded_at_idx on public.tracks(recorded_at desc);
create index waypoints_track_id_idx on public.waypoints(track_id);
create index tracks_bbox_idx on public.tracks using gist(bbox);

-- Auto-update updated_at
create or replace function public.handle_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_updated_at before update on public.profiles
  for each row execute function public.handle_updated_at();

create trigger tracks_updated_at before update on public.tracks
  for each row execute function public.handle_updated_at();

-- Auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles(id, display_name, avatar_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', new.email),
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$;

create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();
