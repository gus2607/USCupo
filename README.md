# USCupo

App móvil (iOS + Android, un solo código base con Expo/React Native) para que estudiantes
de la Universidad Santiago de Cali intercambien horarios/cupos de materias entre sí.
USCupo solo conecta estudiantes: el trámite del cambio se hace directamente en la
universidad.

## Stack

- **Frontend:** React Native + Expo (Expo Router, SDK 57)
- **Backend/BD:** Supabase (Postgres, Auth, Row Level Security, Edge Functions)
- **Auth:** correo institucional `@usc.edu.co` + contraseña, o Google OAuth restringido al
  mismo dominio

## Estructura

```
app/                   Vistas (Expo Router)
  (auth)/login.tsx      Registro / inicio de sesión
  (tabs)/               Inicio, Buscar, Publicar, Mis cambios, Perfil
src/
  models/               Tipos + queries a Supabase por tabla
  controllers/           Lógica de negocio (auth.ts; matching/notificaciones/expiración llegan
                          con sus pantallas)
  components/            Componentes del design system (Button, TextField, CarreraPicker…)
  theme/                 Tokens de color/tipografía/espaciado tomados del mockup oficial
  lib/                   Cliente de Supabase + contexto de sesión
supabase/
  migrations/            Esquema, RLS, funciones de dominio y datos semilla
  functions/expirar-ofertas/  Edge Function que vence ofertas sin confirmar a los 7 días
```

## Puesta en marcha

### 1. Crear el proyecto en Supabase

1. Crea un proyecto en [supabase.com](https://supabase.com).
2. Copia `.env.example` a `.env` y completa `EXPO_PUBLIC_SUPABASE_URL` y
   `EXPO_PUBLIC_SUPABASE_ANON_KEY` (Project Settings → API).

### 2. Aplicar el esquema

Con la [Supabase CLI](https://supabase.com/docs/guides/cli) enlazada al proyecto:

```bash
supabase link --project-ref <tu-project-ref>
supabase db push
```

O, si prefieres no instalar la CLI todavía, pega el contenido de cada archivo en
`supabase/migrations/` (en orden) en el SQL Editor del dashboard de Supabase.

Esto crea las tablas, las políticas de RLS, las funciones (`expresar_interes`,
`contacto_revelado`, `confirmar_cambio`, `buscar_matches`) y los datos semilla: el
catálogo completo de carreras de la USC (pregrado/técnico/posgrado, tomado de
usc.edu.co) y el pénsum completo de Ingeniería de Sistemas. Las demás carreras quedan
sin materias hasta que se carguen sus pénsums (ver nota en
`20260921000005_seed_materias_ingenieria_sistemas.sql`).

### 3. Configurar autenticación

- **Email:** Authentication → Providers → Email. Se recomienda dejar la confirmación de
  correo activada (el trigger de base de datos ya rechaza cualquier dominio distinto a
  `@usc.edu.co`, así que solo estudiantes reales llegan a confirmar).
- **Google:** Authentication → Providers → Google. Si la USC tiene Google Workspace en
  `@usc.edu.co`, restringe el consentimiento a ese dominio (el `hd` param del lado del
  cliente ya lo sugiere, pero la validación real está en el trigger `handle_new_user`).
- **Redirect URL** para OAuth: agrega el scheme `uscupo://auth/callback`.

### 4. Programar la expiración automática

```bash
supabase functions deploy expirar-ofertas
```

Luego crea un cron job (Database → Cron Jobs en el dashboard, o `pg_cron` + `pg_net`) que
llame a la función una vez al día.

### 5. Correr la app

```bash
npm install
npm start
```

Escanea el QR con Expo Go, o `npm run ios` / `npm run android` con un simulador.

## Estado actual

Funcional: registro/login (email+contraseña y Google), validación de dominio
institucional, selección de carrera con búsqueda. Las pantallas de Inicio, Buscar,
Publicar, Mis cambios están en construcción — se implementan pantalla por pantalla sobre
este mismo esquema y estos mismos componentes.
