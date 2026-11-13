create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null,
  full_name text not null default ''
);
alter table public.profiles enable row level security;
grant select, insert, update on public.profiles to authenticated;
create policy "profiles: leer autenticados" on public.profiles for select to authenticated using (true);
create policy "profiles: crear el propio" on public.profiles for insert to authenticated with check ((select auth.uid()) = id);
create policy "profiles: editar el propio" on public.profiles for update to authenticated using ((select auth.uid()) = id) with check ((select auth.uid()) = id);