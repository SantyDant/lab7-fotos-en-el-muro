-- Script que se corrió en el SQL Editor del proyecto LAB7 (labs 5 y 6 + Lab 7)

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null,
  full_name text not null default ''
);
alter table public.profiles enable row level security;
grant select, insert, update on public.profiles to authenticated;
create policy "profiles: leer autenticados" on public.profiles for select to authenticated using (true);
create policy "profiles: crear el propio" on public.profiles for insert to authenticated with check ((select auth.uid()) = id);
create policy "profiles: editar el propio" on public.profiles for update to authenticated using ((select auth.uid()) = id) with check ((select auth.uid()) = id); create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  content text not null check (char_length(content) <= 280),
  created_at timestamptz not null default now()
);
alter table public.posts enable row level security;
grant select, insert, update, delete on public.posts to authenticated;
create policy "posts: leer autenticados" on public.posts for select to authenticated using (true);
create policy "posts: crear los propios" on public.posts for insert to authenticated with check ((select auth.uid()) = profile_id);
create policy "posts: borrar los propios" on public.posts for delete to authenticated using ((select auth.uid()) = profile_id); create table if not exists public.likes (
  post_id uuid not null references public.posts(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (post_id, profile_id)
);
alter table public.likes enable row level security;
grant select, insert, update, delete on public.likes to authenticated;
create policy "likes: leer autenticados" on public.likes for select to authenticated using (true);
create policy "likes: dar el propio" on public.likes for insert to authenticated with check ((select auth.uid()) = profile_id);
create policy "likes: cambiar el propio" on public.likes for update to authenticated using ((select auth.uid()) = profile_id) with check ((select auth.uid()) = profile_id);
create policy "likes: quitar el propio" on public.likes for delete to authenticated using ((select auth.uid()) = profile_id); alter table public.profiles add column avatar_path text;

create policy "avatars: usuarios autenticados"
on storage.objects for all to authenticated
using (bucket_id = 'avatars')
with check (bucket_id = 'avatars'); alter table public.posts add column image_path text;

create policy "post-images: usuarios autenticados"
on storage.objects for all to authenticated
using (bucket_id = 'post-images')
with check (bucket_id = 'post-images');