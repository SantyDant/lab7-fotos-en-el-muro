create table if not exists public.likes (
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
create policy "likes: quitar el propio" on public.likes for delete to authenticated using ((select auth.uid()) = profile_id);