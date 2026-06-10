-- ============================================================
--  Juego: Polla Mundialista — Grupo K (Mundial 2026)
--  Ejecuta este script en Supabase:
--  Dashboard -> SQL Editor -> New query -> pega esto -> Run
--
--  ⚠️ Este script BORRA la tabla anterior y la crea de nuevo
--     con el esquema del Grupo K (local / visitante).
-- ============================================================

drop table if exists public.predicciones;

create table public.predicciones (
  id              bigint generated always as identity primary key,
  cedula          text        not null,
  nombre          text        not null,
  partido_id      int         not null,         -- 1..6 (los 6 partidos del Grupo K)
  ganador         text        not null,         -- 'local' | 'empate' | 'visitante'
  goles_local     int,                          -- opcional (marcador exacto)
  goles_visitante int,                          -- opcional (marcador exacto)
  created_at      timestamptz not null default now(),
  -- una persona solo puede tener una predicción por partido
  unique (cedula, partido_id)
);

-- Seguridad a nivel de fila
alter table public.predicciones enable row level security;

-- Permitir INSERTAR predicciones con la clave publishable (anon)
drop policy if exists "permitir insertar predicciones" on public.predicciones;
create policy "permitir insertar predicciones"
  on public.predicciones for insert to anon with check (true);

-- Permitir LEER predicciones (estadísticas, ranking, ya-votó)
drop policy if exists "permitir leer predicciones" on public.predicciones;
create policy "permitir leer predicciones"
  on public.predicciones for select to anon using (true);
