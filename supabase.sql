-- ============================================================
--  Juego: Predicciones Colombia en el Mundial
--  Ejecuta este script una sola vez en Supabase:
--  Dashboard -> SQL Editor -> New query -> pega esto -> Run
-- ============================================================

create table if not exists public.predicciones (
  id             bigint generated always as identity primary key,
  cedula         text        not null,
  nombre         text        not null,
  partido_id     int         not null,
  ganador        text        not null,          -- 'colombia' | 'empate' | 'rival'
  goles_colombia int,                           -- opcional (puntos extra)
  goles_rival    int,                           -- opcional (puntos extra)
  created_at     timestamptz not null default now(),
  -- una persona solo puede tener una predicción por partido
  unique (cedula, partido_id)
);

-- Activar seguridad a nivel de fila
alter table public.predicciones enable row level security;

-- Permitir INSERTAR predicciones con la clave publishable (anon)
drop policy if exists "permitir insertar predicciones" on public.predicciones;
create policy "permitir insertar predicciones"
  on public.predicciones
  for insert
  to anon
  with check (true);

-- Permitir LEER predicciones (para detectar si una cédula ya votó)
drop policy if exists "permitir leer predicciones" on public.predicciones;
create policy "permitir leer predicciones"
  on public.predicciones
  for select
  to anon
  using (true);
