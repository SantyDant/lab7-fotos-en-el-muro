# Lab 7 · Pasos que debes correr en tu PC (dentro de Apps262Lab7)

El código de Dart (pasos 3-10 y 12-15) ya está hecho. Falta lo de Supabase, que necesita tu cuenta.

## 0. Preparación
1. En `lib/main.dart` pon la URL y la publishable key de TU proyecto (el de los labs 5 y 6).
2. Terminal:
```
flutter pub get
npx supabase login
npx supabase init
npx supabase link --project-ref TU_IDENTIFICADOR
npx supabase migration fetch --remote
```
3. Reemplaza TODO `supabase/config.toml` por esto (ya incluye los dos buckets):
```toml
project_id = "Apps262Lab7"

[auth]
enabled = true

[auth.email]
enable_signup = true
enable_confirmations = false

[storage]
enabled = true

[storage.buckets.avatars]
public = true
file_size_limit = "2MiB"
allowed_mime_types = ["image/jpeg", "image/png", "image/webp"]

[storage.buckets.post-images]
public = false
file_size_limit = "2MiB"
allowed_mime_types = ["image/jpeg", "image/png", "image/webp"]
```
4. `npx supabase migration list --remote` (las 3 migraciones en ambas columnas)

## 1. Buckets
```
npx supabase seed buckets --remote
```

## 2. Migración parte 1
```
npx supabase migration new create_avatars
```
Pega en el archivo creado:
```sql
alter table public.profiles add column avatar_path text;

create policy "avatars: usuarios autenticados"
on storage.objects for all to authenticated
using (bucket_id = 'avatars')
with check (bucket_id = 'avatars');
```

## 3. Migración parte 2
```
npx supabase migration new create_post_images
```
```sql
alter table public.posts add column image_path text;

create policy "post-images: usuarios autenticados"
on storage.objects for all to authenticated
using (bucket_id = 'post-images')
with check (bucket_id = 'post-images');
```

## 4. Aplicar y correr
```
npx supabase db push --remote
flutter run
```
