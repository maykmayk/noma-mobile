-- Add missing fields to profiles
alter table public.profiles add column if not exists birth_date date;
alter table public.profiles add column if not exists avatar_number integer not null default 1
  check (avatar_number between 1 and 12);

-- Update trigger: nickname → username/display_name, birth_date, random avatar 1-12
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles(id, username, display_name, birth_date, avatar_number, avatar_url)
  values (
    new.id,
    new.raw_user_meta_data->>'nickname',
    coalesce(new.raw_user_meta_data->>'nickname', new.email),
    (new.raw_user_meta_data->>'birth_date')::date,
    floor(random() * 12 + 1)::int,
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$;
