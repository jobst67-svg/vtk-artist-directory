-- VTK Artist shared content foundation
-- Run once in the shared Supabase SQL Editor.

create table if not exists public.artist_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  slug text unique,
  display_name text not null default '',
  nickname text not null default '',
  bio text not null default '',
  avatar_url text,
  youtube_url text,
  spotify_url text,
  suno_url text,
  is_public boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.artist_songs (
  id uuid primary key default gen_random_uuid(),
  artist_user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text not null default '',
  audio_url text,
  youtube_url text,
  spotify_url text,
  suno_url text,
  is_public boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.artist_releases (
  id uuid primary key default gen_random_uuid(),
  artist_user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  release_type text not null default 'single',
  cover_url text,
  description text not null default '',
  spotify_url text,
  youtube_url text,
  suno_url text,
  is_public boolean not null default false,
  released_at date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.artist_profiles enable row level security;
alter table public.artist_songs enable row level security;
alter table public.artist_releases enable row level security;

drop policy if exists "Artist profiles public read" on public.artist_profiles;
create policy "Artist profiles public read" on public.artist_profiles for select to anon, authenticated using (is_public or user_id = auth.uid());
drop policy if exists "Artist profiles own write" on public.artist_profiles;
create policy "Artist profiles own write" on public.artist_profiles for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "Artist songs public read" on public.artist_songs;
create policy "Artist songs public read" on public.artist_songs for select to anon, authenticated using (is_public or artist_user_id = auth.uid());
drop policy if exists "Artist songs own write" on public.artist_songs;
create policy "Artist songs own write" on public.artist_songs for all to authenticated using (artist_user_id = auth.uid()) with check (artist_user_id = auth.uid());

drop policy if exists "Artist releases public read" on public.artist_releases;
create policy "Artist releases public read" on public.artist_releases for select to anon, authenticated using (is_public or artist_user_id = auth.uid());
drop policy if exists "Artist releases own write" on public.artist_releases;
create policy "Artist releases own write" on public.artist_releases for all to authenticated using (artist_user_id = auth.uid()) with check (artist_user_id = auth.uid());
