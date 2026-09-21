-- USCupo · el catálogo académico debe ser legible también sin sesión: el estudiante
-- elige su carrera en la pantalla de registro, antes de existir un usuario autenticado.
-- La política anterior solo permitía "to authenticated" y dejaba el picker vacío para
-- cualquiera que aún no hubiera iniciado sesión.

drop policy if exists "catalogo_lectura_carreras" on carreras;
drop policy if exists "catalogo_lectura_materias" on materias;
drop policy if exists "catalogo_lectura_bloques" on bloques_horario;

create policy "catalogo_lectura_carreras" on carreras for select to anon, authenticated using (true);
create policy "catalogo_lectura_materias" on materias for select to anon, authenticated using (true);
create policy "catalogo_lectura_bloques" on bloques_horario for select to anon, authenticated using (true);
