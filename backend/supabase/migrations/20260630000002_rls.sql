-- Row Level Security: users access only their own data

alter table public.profiles enable row level security;
alter table public.tracks enable row level security;
alter table public.waypoints enable row level security;

-- Profiles
create policy "profiles: own read" on public.profiles
  for select using (auth.uid() = id);

create policy "profiles: own update" on public.profiles
  for update using (auth.uid() = id);

-- Tracks
create policy "tracks: own all" on public.tracks
  for all using (auth.uid() = user_id);

-- Waypoints
create policy "waypoints: own all" on public.waypoints
  for all using (auth.uid() = user_id);
