<div align="center">

# noma

**GPS cycling app for iOS & Android**

GPS tracking · GPX import/export · Offline maps · Apple Health sync

![Flutter](https://img.shields.io/badge/Flutter-3.11+-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=flat-square&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-2.9-3ECF8E?style=flat-square&logo=supabase&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)

</div>

---

## Repository

```
noma-mobile/
├── mobile/          Flutter app (iOS + Android)
└── backend/
    └── supabase/    Migrations · Edge Functions · Config
```

---

## Frontend

### Tech Stack

![Riverpod](https://img.shields.io/badge/Riverpod-2.6-764ABC?style=flat-square)
![GoRouter](https://img.shields.io/badge/go__router-15.1-blue?style=flat-square)
![FlutterMap](https://img.shields.io/badge/flutter__map-7.0-green?style=flat-square)
![Geolocator](https://img.shields.io/badge/geolocator-13.0-orange?style=flat-square)

### Project Structure

```
mobile/lib/
├── core/
│   ├── config/        AppConfig, flavors (dev / production)
│   ├── routing/       GoRouter + auth redirect guard
│   └── theme/         Colors, typography (OpenRunde)
├── features/
│   ├── auth/          Login · Register · AppUser model
│   ├── profile/       UserProfile model · ProfileRepository
│   └── home/          HomeScreen
└── shared/
    ├── utils/         avatarAssetPath()
    └── widgets/       AppButton · AppTextField · UserAvatar · …
```

### Key Providers

| Provider | Returns | Source |
|---|---|---|
| `currentUserProvider` | `AppUser?` | Auth session |
| `currentProfileProvider` | `UserProfile?` | Supabase `profiles` |
| `authNotifierProvider` | `AsyncValue<void>` | Auth actions |

### Run

```bash
# Create mobile/.env.local with your credentials (never committed)
SUPABASE_URL=https://<project>.supabase.co
SUPABASE_ANON_KEY=sb_publishable_...
```

```bash
cd mobile
./run_dev.sh                    # dev flavor, reads .env.local
./run_dev.sh -d "iPhone 16"     # specific device
./run_dev.sh --release          # release build
```

---

## Backend

### Tech Stack

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-4169E1?style=flat-square&logo=postgresql&logoColor=white)
![Supabase Auth](https://img.shields.io/badge/Supabase_Auth-enabled-3ECF8E?style=flat-square&logo=supabase&logoColor=white)
![PostGIS](https://img.shields.io/badge/PostGIS-enabled-4CAF50?style=flat-square)
![RLS](https://img.shields.io/badge/RLS-enabled-red?style=flat-square)

### Schema

| Table | Description |
|---|---|
| `profiles` | username, display_name, birth_date, avatar_number (1–12) |
| `tracks` | GPX track metadata, stats, bounding box |
| `waypoints` | Custom points inside a route |

### Cloud Setup

> Do this once on [app.supabase.com](https://app.supabase.com) → your project.

**1 — Disable email confirmation**

Authentication → Providers → Email → disable **Confirm email**

**2 — Run migrations** (SQL Editor, one at a time)

<details>
<summary>Migration 4 — profiles: birth_date + avatar_number</summary>

```sql
alter table public.profiles add column if not exists birth_date date;
alter table public.profiles add column if not exists avatar_number integer not null default 1
  check (avatar_number between 1 and 12);

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
```

</details>

<details>
<summary>Migration 5 — username login RPC</summary>

```sql
create or replace function public.get_email_by_username(p_username text)
returns text language plpgsql security definer set search_path = public as $$
declare
  v_email text;
begin
  select u.email into v_email
  from auth.users u join public.profiles p on p.id = u.id
  where lower(p.username) = lower(p_username)
  limit 1;
  return v_email;
end;
$$;
```

</details>

---

## Auth Flow

| Action | Detail |
|---|---|
| Register | nickname · email · password · birth date → auto sign-in |
| Login | email **or** username + password |
| Profile | Created via DB trigger on signup with random avatar (1–12) |
| Logout | App bar button on HomeScreen |

---

## Avatars

12 avatar images in `assets/avatars/Avatar_01.png` → `Avatar_12.png`.
Assigned randomly at signup. Use anywhere with:

```dart
UserAvatar(avatarNumber: profile.avatarNumber)
UserAvatar(avatarNumber: profile.avatarNumber, size: 48)
```
