-- RPC: resolve username → email for login (security definer, no RLS bypass exposure)
-- Returns NULL if username not found (caller treats as invalid credentials).
create or replace function public.get_email_by_username(p_username text)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_email text;
begin
  select u.email into v_email
  from auth.users u
  join public.profiles p on p.id = u.id
  where lower(p.username) = lower(p_username)
  limit 1;
  return v_email;
end;
$$;
