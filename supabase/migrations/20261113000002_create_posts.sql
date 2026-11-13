create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  content text not null check (char_length(content) <= 280),
  created_at timestamptz not null default now()
);
alter table public.posts enable row level security;
grant select, insert, update, delete on public.posts to authenticated;
create policy "posts: leer autenticados" on public.posts for select to authenticated using (true);
create policy "posts: crear los propios" on public.posts for insert to authenticated with check ((select auth.uid()) = profile_id);
create policy "posts: borrar los propios" on public.posts for delete to authenticated using ((select auth.uid()) = profile_id);