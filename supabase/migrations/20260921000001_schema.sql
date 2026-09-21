-- USCupo · esquema base
-- Modelos: carreras, materias, bloques_horario, profiles, ofertas, ofertas_busco, notificaciones

create extension if not exists "pgcrypto";

create type carrera_tipo as enum ('pregrado', 'tecnico', 'posgrado');
create type oferta_estado as enum ('disponible', 'en_proceso', 'resuelta', 'expirada');

-- ── Catálogo académico ──────────────────────────────────────────────

create table carreras (
  id bigint generated always as identity primary key,
  nombre text not null,
  tipo carrera_tipo not null,
  facultad text not null,
  sede text not null default 'Cali',
  activa boolean not null default true
);

create table materias (
  id bigint generated always as identity primary key,
  carrera_id bigint not null references carreras (id) on delete cascade,
  nombre text not null,
  codigo text not null,
  semestre smallint,
  unique (carrera_id, codigo)
);

create index materias_carrera_id_idx on materias (carrera_id);

-- Catálogo fijo de franjas horarias seleccionables (no viene de un feed en vivo de la
-- universidad: Academusoft no expone horarios por grupo públicamente). El estudiante
-- elige de esta grilla al publicar; el número de grupo es texto libre informativo.
create table bloques_horario (
  id bigint generated always as identity primary key,
  dias text[] not null,
  hora_inicio time not null,
  hora_fin time not null,
  etiqueta text not null,
  unique (dias, hora_inicio, hora_fin)
);

-- ── Usuarios ─────────────────────────────────────────────────────────

create table profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  nombre_completo text not null,
  correo text not null unique,
  carrera_id bigint references carreras (id),
  whatsapp text,
  mostrar_correo boolean not null default true,
  mostrar_whatsapp boolean not null default true,
  created_at timestamptz not null default now()
);

-- Vista pública sin datos de contacto: lo único visible a cualquier estudiante
-- autenticado. El correo/WhatsApp solo se revela vía expresar_interes()/RPC.
create view perfiles_publicos with (security_invoker = true) as
  select id, nombre_completo, carrera_id
  from profiles;

-- ── Ofertas de cambio ────────────────────────────────────────────────

create table ofertas (
  id bigint generated always as identity primary key,
  user_id uuid not null references profiles (id) on delete cascade,
  materia_id bigint not null references materias (id),
  grupo text not null,
  bloque_actual_id bigint not null references bloques_horario (id),
  comentario text,
  estado oferta_estado not null default 'disponible',
  interesado_id uuid references profiles (id),
  interesado_at timestamptz,
  resuelta_at timestamptz,
  created_at timestamptz not null default now(),
  expires_at timestamptz
);

create index ofertas_materia_id_idx on ofertas (materia_id);
create index ofertas_user_id_idx on ofertas (user_id);
create index ofertas_estado_idx on ofertas (estado);

create table ofertas_busco (
  oferta_id bigint not null references ofertas (id) on delete cascade,
  bloque_id bigint not null references bloques_horario (id),
  primary key (oferta_id, bloque_id)
);

-- ── Notificaciones ───────────────────────────────────────────────────

create table notificaciones (
  id bigint generated always as identity primary key,
  user_id uuid not null references profiles (id) on delete cascade,
  oferta_id bigint references ofertas (id) on delete cascade,
  tipo text not null check (tipo in ('interes_recibido', 'cambio_confirmado', 'oferta_expirada')),
  leida boolean not null default false,
  created_at timestamptz not null default now()
);

create index notificaciones_user_id_idx on notificaciones (user_id, leida);
