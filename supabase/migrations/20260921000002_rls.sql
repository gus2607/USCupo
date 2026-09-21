-- USCupo · Row Level Security + funciones de dominio
-- El correo/WhatsApp de un estudiante nunca se expone por RLS directa: solo a través
-- de contacto_revelado(), que valida la relación dueño/interesado en el servidor.

alter table carreras enable row level security;
alter table materias enable row level security;
alter table bloques_horario enable row level security;
alter table profiles enable row level security;
alter table ofertas enable row level security;
alter table ofertas_busco enable row level security;
alter table notificaciones enable row level security;

-- Catálogo académico: lectura libre para cualquier estudiante autenticado, sin escritura
-- desde el cliente (se administra por migración/import, no por la app).
create policy "catalogo_lectura_carreras" on carreras for select to authenticated using (true);
create policy "catalogo_lectura_materias" on materias for select to authenticated using (true);
create policy "catalogo_lectura_bloques" on bloques_horario for select to authenticated using (true);

-- Perfiles: cada quien ve y edita solo el suyo. El resto de la app usa la vista
-- perfiles_publicos (sin correo/whatsapp) o contacto_revelado() para datos de contacto.
create policy "perfil_propio_select" on profiles for select to authenticated using (id = auth.uid());
create policy "perfil_propio_insert" on profiles for insert to authenticated with check (id = auth.uid());
create policy "perfil_propio_update" on profiles for update to authenticated using (id = auth.uid());

grant select on perfiles_publicos to authenticated;

-- Ofertas: visibles si están disponibles o en proceso (para verse opacas/deshabilitadas
-- en el feed de terceros), o si el usuario es dueño/interesado. Resueltas/expiradas solo
-- las ve su dueño (alimentan su historial).
create policy "ofertas_select" on ofertas for select to authenticated
  using (
    estado in ('disponible', 'en_proceso')
    or user_id = auth.uid()
    or interesado_id = auth.uid()
  );

create policy "ofertas_insert_propia" on ofertas for insert to authenticated
  with check (user_id = auth.uid());

create policy "ofertas_update_dueno" on ofertas for update to authenticated
  using (user_id = auth.uid());

create policy "ofertas_delete_dueno" on ofertas for delete to authenticated
  using (user_id = auth.uid());

create policy "ofertas_busco_select" on ofertas_busco for select to authenticated
  using (
    exists (
      select 1 from ofertas o
      where o.id = oferta_id
        and (o.estado in ('disponible', 'en_proceso') or o.user_id = auth.uid() or o.interesado_id = auth.uid())
    )
  );

create policy "ofertas_busco_insert_dueno" on ofertas_busco for insert to authenticated
  with check (exists (select 1 from ofertas o where o.id = oferta_id and o.user_id = auth.uid()));

create policy "ofertas_busco_delete_dueno" on ofertas_busco for delete to authenticated
  using (exists (select 1 from ofertas o where o.id = oferta_id and o.user_id = auth.uid()));

-- Notificaciones: cada quien ve y marca como leídas las suyas. No hay insert directo
-- desde el cliente: las crean las funciones de dominio (security definer) más abajo.
create policy "notificaciones_select" on notificaciones for select to authenticated
  using (user_id = auth.uid());

create policy "notificaciones_update_propia" on notificaciones for update to authenticated
  using (user_id = auth.uid());

-- ── Funciones de dominio (security definer: corren con los privilegios del owner,
--    pero cada una valida explícitamente quién puede llamarlas y sobre qué fila) ──

-- Un estudiante distinto al dueño marca "Me interesa" sobre una oferta disponible.
-- Deja la oferta en_proceso, arranca el plazo de 7 días y notifica al dueño.
create or replace function expresar_interes(p_oferta_id bigint)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_dueno uuid;
  v_estado oferta_estado;
begin
  select user_id, estado into v_dueno, v_estado from ofertas where id = p_oferta_id for update;

  if v_dueno is null then
    raise exception 'Oferta no encontrada';
  end if;
  if v_dueno = auth.uid() then
    raise exception 'No puedes marcar interés en tu propia oferta';
  end if;
  if v_estado <> 'disponible' then
    raise exception 'Esta oferta ya no está disponible';
  end if;

  update ofertas
    set estado = 'en_proceso',
        interesado_id = auth.uid(),
        interesado_at = now(),
        expires_at = now() + interval '7 days'
    where id = p_oferta_id;

  insert into notificaciones (user_id, oferta_id, tipo)
    values (v_dueno, p_oferta_id, 'interes_recibido');
end;
$$;

grant execute on function expresar_interes(bigint) to authenticated;

-- Devuelve los datos de contacto del otro estudiante en una oferta, respetando sus
-- preferencias de visibilidad. Solo responde si quien llama es el dueño o el interesado.
create or replace function contacto_revelado(p_oferta_id bigint)
returns table (
  perfil_id uuid,
  nombre_completo text,
  correo text,
  whatsapp text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_dueno uuid;
  v_interesado uuid;
  v_otro uuid;
begin
  select user_id, interesado_id into v_dueno, v_interesado from ofertas where id = p_oferta_id;

  if v_dueno is null then
    raise exception 'Oferta no encontrada';
  end if;
  if auth.uid() not in (v_dueno, v_interesado) then
    raise exception 'No tienes acceso al contacto de esta oferta';
  end if;

  v_otro := case when auth.uid() = v_dueno then v_interesado else v_dueno end;
  if v_otro is null then
    raise exception 'Todavía no hay un interesado en esta oferta';
  end if;

  return query
    select p.id, p.nombre_completo,
           case when p.mostrar_correo then p.correo else null end,
           case when p.mostrar_whatsapp then p.whatsapp else null end
    from profiles p
    where p.id = v_otro;
end;
$$;

grant execute on function contacto_revelado(bigint) to authenticated;

-- El dueño confirma que el cambio se concretó: la oferta pasa a resuelta y sale de la
-- bolsa activa (queda en su historial de Perfil).
create or replace function confirmar_cambio(p_oferta_id bigint)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update ofertas
    set estado = 'resuelta', resuelta_at = now()
    where id = p_oferta_id and user_id = auth.uid() and estado = 'en_proceso';

  if not found then
    raise exception 'No se pudo confirmar: la oferta no existe, no es tuya o no tiene un interesado activo';
  end if;

  insert into notificaciones (user_id, oferta_id, tipo)
    select interesado_id, p_oferta_id, 'cambio_confirmado'
    from ofertas where id = p_oferta_id and interesado_id is not null;
end;
$$;

grant execute on function confirmar_cambio(bigint) to authenticated;

-- Match recíproco: otras ofertas de la misma materia donde lo que el otro ofrece es algo
-- que yo busco, y lo que yo ofrezco es algo que el otro busca.
create or replace function buscar_matches(p_materia_id bigint, p_mi_bloque_actual bigint, p_mis_bloques_busco bigint[])
returns setof ofertas
language sql
security definer
set search_path = public
stable
as $$
  select o.*
  from ofertas o
  where o.materia_id = p_materia_id
    and o.estado = 'disponible'
    and o.user_id <> auth.uid()
    and o.bloque_actual_id = any(p_mis_bloques_busco)
    and exists (
      select 1 from ofertas_busco ob
      where ob.oferta_id = o.id and ob.bloque_id = p_mi_bloque_actual
    );
$$;

grant execute on function buscar_matches(bigint, bigint, bigint[]) to authenticated;
