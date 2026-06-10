-- ============================================================
--  Tabla de RESULTADOS (marcadores reales, ingresados por Combuses)
--  Ejecuta este script UNA VEZ en Supabase:
--  Dashboard -> SQL Editor -> New query -> pega esto -> Run
--
--  Después, los resultados se ingresan a mano desde:
--  Table Editor -> resultados -> editar la fila del partido.
-- ============================================================

create table if not exists public.resultados (
  partido_id      int primary key,        -- 1..6 (los 6 partidos del Grupo K)
  descripcion     text,                   -- referencia legible del partido
  goles_local     int,                    -- marcador real del equipo local
  goles_visitante int,                    -- marcador real del equipo visitante
  finalizado      boolean not null default false,  -- marcar TRUE cuando el partido termine
  updated_at      timestamptz not null default now()
);

-- Pre-cargar las 6 filas del Grupo K (sin marcador todavía)
insert into public.resultados (partido_id, descripcion, finalizado) values
  (1, 'Portugal vs RD Congo',     false),
  (2, 'Uzbekistán vs Colombia',   false),
  (3, 'Portugal vs Uzbekistán',   false),
  (4, 'Colombia vs RD Congo',     false),
  (5, 'Colombia vs Portugal',     false),
  (6, 'RD Congo vs Uzbekistán',   false)
on conflict (partido_id) do nothing;

-- Seguridad: cualquiera puede LEER (la app lo necesita)...
alter table public.resultados enable row level security;
drop policy if exists "leer resultados" on public.resultados;
create policy "leer resultados"
  on public.resultados for select to anon using (true);

-- ...pero NADIE puede escribir con la clave pública.
-- Los marcadores solo se ingresan desde el panel de Supabase (Table Editor),
-- al que solo tiene acceso Combuses. Así nadie puede meter resultados falsos.
