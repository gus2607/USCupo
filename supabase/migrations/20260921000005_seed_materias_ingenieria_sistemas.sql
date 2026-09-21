-- USCupo · pénsum de Ingeniería de Sistemas (fuente: usc.edu.co/ingenieria-de-sistemas,
-- consultado 2026-09-21; 10 semestres, 154 créditos). La USC no publica códigos internos
-- de materia, así que se generan códigos propios (IS-<semestre><orden>) solo para
-- búsqueda/autocompletado, no son códigos oficiales SNIES.
--
-- El resto de carreras del catálogo aún no tienen pénsum cargado: la app debe manejar
-- ese caso ("materias próximamente para tu programa") en vez de asumir que siempre hay datos.

with carrera as (
  select id from carreras where nombre = 'Ingeniería de Sistemas' and sede = 'Cali' limit 1
),
pensum (semestre, nombre) as (
  values
    (1, 'Matemáticas Fundamentales'), (1, 'Introducción a la Ingeniería'), (1, 'Pensamiento Sistémico'),
    (1, 'Matemáticas Discretas'), (1, 'Algoritmos y Programación I'),

    (2, 'Cálculo I'), (2, 'Física y Laboratorio I'), (2, 'Algoritmos y Programación II'),
    (2, 'Álgebra Lineal'), (2, 'Estadística y Probabilidad'),

    (3, 'Inglés I'), (3, 'Cálculo II'), (3, 'Física y Laboratorio II'),
    (3, 'Fundamentos de Sistemas de Información'), (3, 'Estructura de Datos'),

    (4, 'Inglés II'), (4, 'Ecuaciones Diferenciales'), (4, 'Proyecto Integrador Básico'),
    (4, 'Bases de Datos'), (4, 'Análisis de Algoritmos'),

    (5, 'Inglés III'), (5, 'Electiva de Área I'), (5, 'Autómatas y Lenguajes Formales'),
    (5, 'Ingeniería de Software I'), (5, 'Arquitectura de Tecnología Informática'),

    (6, 'Inglés IV'), (6, 'Razonamiento Cuantitativo'), (6, 'Constitución Política'),
    (6, 'Redes y Comunicaciones'), (6, 'Ingeniería de Software II'), (6, 'Arquitectura de Computadores'),

    (7, 'Lenguajes de Programación'), (7, 'Sistemas Operativos'), (7, 'Inteligencia Artificial'),
    (7, 'Redes Inalámbricas'), (7, 'Arquitectura de Software'), (7, 'Gestión de Proyectos de TI'),

    (8, 'Proyecto Integrador Profesional'), (8, 'Investigación de Operaciones'), (8, 'Computación Móvil'),
    (8, 'Programación Orientada a la Web'), (8, 'Gobierno y Servicios de TI'),

    (9, 'Electiva de Profundización I'), (9, 'Electiva de Profundización II'), (9, 'Seguridad en Redes'),
    (9, 'Electiva de Profundización III'), (9, 'Arquitectura Empresarial'),

    (10, 'Electiva de Profundización IV'), (10, 'Electiva de Profundización V'),
    (10, 'Electiva de Profundización VI'), (10, 'Proyecto Integrador de Grado')
),
numerado as (
  select semestre, nombre,
         row_number() over (partition by semestre order by nombre) as orden
  from pensum
)
insert into materias (carrera_id, nombre, codigo, semestre)
select carrera.id, numerado.nombre,
       'IS-' || numerado.semestre || lpad(numerado.orden::text, 2, '0'),
       numerado.semestre
from numerado, carrera;
