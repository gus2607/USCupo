-- USCupo · grilla fija de franjas horarias seleccionables (día(s) + hora inicio/fin).
-- No representa el horario real de ningún grupo; es el conjunto de opciones que el
-- estudiante puede elegir al publicar "lo que tengo" / "lo que busco".

with patrones_dias (dias) as (
  values
    (array['Lunes']), (array['Martes']), (array['Miércoles']), (array['Jueves']),
    (array['Viernes']), (array['Sábado']),
    (array['Lunes', 'Miércoles']), (array['Martes', 'Jueves'])
),
bloques_2h (hora_inicio, hora_fin) as (
  values
    ('06:00'::time, '08:00'::time), ('08:00', '10:00'), ('10:00', '12:00'),
    ('12:00', '14:00'), ('14:00', '16:00'), ('16:00', '18:00'),
    ('18:00', '20:00'), ('20:00', '22:00')
),
franjas as (
  select dias, hora_inicio, hora_fin from patrones_dias cross join bloques_2h
  union all
  -- franjas largas de sábado, como en el mockup (7–11 a.m., 8 a.m.–12 m.)
  select array['Sábado'], '07:00'::time, '11:00'::time
  union all
  select array['Sábado'], '08:00'::time, '12:00'::time
)
insert into bloques_horario (dias, hora_inicio, hora_fin, etiqueta)
select
  dias,
  hora_inicio,
  hora_fin,
  array_to_string(dias, ' y ') || ' · ' ||
    replace(replace(to_char(hora_inicio, 'HH12:MI AM'), 'AM', 'a.m.'), 'PM', 'p.m.') ||
    ' – ' ||
    (case
      when hora_fin = '12:00' then '12:00 m.'
      else replace(replace(to_char(hora_fin, 'HH12:MI AM'), 'AM', 'a.m.'), 'PM', 'p.m.')
    end)
from franjas;
