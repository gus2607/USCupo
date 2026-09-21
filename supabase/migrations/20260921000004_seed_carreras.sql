-- USCupo · catálogo de carreras (fuente: usc.edu.co/pregrados, usc.edu.co/posgrados-usc,
-- consultado 2026-09-21). Nombres tal como los publica la universidad.

insert into carreras (nombre, tipo, facultad, sede) values
  -- Facultad de Ingeniería · pregrado
  ('Ingeniería de Sistemas', 'pregrado', 'Ingeniería', 'Cali'),
  ('Ingeniería de Sistemas - Virtual', 'pregrado', 'Ingeniería', 'Cali'),
  ('Ingeniería Industrial', 'pregrado', 'Ingeniería', 'Cali'),
  ('Ingeniería Civil', 'pregrado', 'Ingeniería', 'Cali'),
  ('Ingeniería Electrónica', 'pregrado', 'Ingeniería', 'Cali'),
  ('Ingeniería Química', 'pregrado', 'Ingeniería', 'Cali'),
  ('Ingeniería en Energías', 'pregrado', 'Ingeniería', 'Cali'),
  ('Bioingeniería', 'pregrado', 'Ingeniería', 'Cali'),
  ('Ingeniería en Desarrollo de Videojuegos', 'pregrado', 'Ingeniería', 'Cali'),
  -- Facultad de Ingeniería · técnico/tecnológico
  ('Tecnología en Desarrollo de Sistemas de Información y Software', 'tecnico', 'Ingeniería', 'Cali'),
  ('Tecnología en Gestión de Procesos Industriales', 'tecnico', 'Ingeniería', 'Cali'),

  -- Facultad de Ciencias Económicas y Empresariales · pregrado
  ('Administración de Empresas', 'pregrado', 'Ciencias Económicas y Empresariales', 'Cali'),
  ('Administración de Empresas - Virtual', 'pregrado', 'Ciencias Económicas y Empresariales', 'Cali'),
  ('Administración de Empresas', 'pregrado', 'Ciencias Económicas y Empresariales', 'Palmira'),
  ('Mercadeo', 'pregrado', 'Ciencias Económicas y Empresariales', 'Cali'),
  ('Mercadeo y Publicidad', 'pregrado', 'Ciencias Económicas y Empresariales', 'Cali'),
  ('Economía', 'pregrado', 'Ciencias Económicas y Empresariales', 'Cali'),
  ('Contaduría Pública', 'pregrado', 'Ciencias Económicas y Empresariales', 'Cali'),
  ('Contaduría Pública - Virtual', 'pregrado', 'Ciencias Económicas y Empresariales', 'Cali'),
  ('Finanzas y Negocios Internacionales', 'pregrado', 'Ciencias Económicas y Empresariales', 'Cali'),

  -- Facultad de Salud · pregrado
  ('Medicina', 'pregrado', 'Salud', 'Cali'),
  ('Medicina', 'pregrado', 'Salud', 'Palmira'),
  ('Enfermería', 'pregrado', 'Salud', 'Cali'),
  ('Enfermería', 'pregrado', 'Salud', 'Palmira'),
  ('Fisioterapia', 'pregrado', 'Salud', 'Cali'),
  ('Fisioterapia', 'pregrado', 'Salud', 'Palmira'),
  ('Odontología', 'pregrado', 'Salud', 'Cali'),
  ('Psicología', 'pregrado', 'Salud', 'Cali'),
  ('Fonoaudiología', 'pregrado', 'Salud', 'Cali'),
  ('Terapia Respiratoria', 'pregrado', 'Salud', 'Cali'),
  ('Instrumentación Quirúrgica', 'pregrado', 'Salud', 'Cali'),
  -- Facultad de Salud · técnico/tecnológico
  ('Tecnología en Mecánica Dental', 'tecnico', 'Salud', 'Cali'),
  ('Tecnología en Regencia de Farmacia', 'tecnico', 'Salud', 'Cali'),
  ('Tecnología en Atención Prehospitalaria', 'tecnico', 'Salud', 'Cali'),

  -- Facultad de Ciencias Básicas · pregrado
  ('Microbiología', 'pregrado', 'Ciencias Básicas', 'Cali'),
  ('Química Farmacéutica', 'pregrado', 'Ciencias Básicas', 'Cali'),
  ('Química', 'pregrado', 'Ciencias Básicas', 'Cali'),
  ('Medicina Veterinaria', 'pregrado', 'Ciencias Básicas', 'Cali'),

  -- Facultad de Humanidades y Artes · pregrado
  ('Comunicación Social', 'pregrado', 'Humanidades y Artes', 'Cali'),
  ('Publicidad', 'pregrado', 'Humanidades y Artes', 'Cali'),
  ('Trabajo Social', 'pregrado', 'Humanidades y Artes', 'Cali'),
  -- Facultad de Humanidades y Artes · técnico/tecnológico
  ('Tecnología en Producción Transmedia', 'tecnico', 'Humanidades y Artes', 'Cali'),

  -- Facultad de Derecho · pregrado
  ('Derecho', 'pregrado', 'Derecho', 'Cali'),
  ('Derecho - Virtual', 'pregrado', 'Derecho', 'Cali'),
  ('Derecho', 'pregrado', 'Derecho', 'Palmira'),
  ('Ciencia Política', 'pregrado', 'Derecho', 'Cali'),

  -- Facultad de Educación · pregrado
  ('Licenciatura en Educación Infantil', 'pregrado', 'Educación', 'Cali'),
  ('Licenciatura en Educación Física y Deportes', 'pregrado', 'Educación', 'Cali'),
  ('Licenciatura en Lenguas Extranjeras con Énfasis en Inglés-Francés', 'pregrado', 'Educación', 'Cali'),
  ('Licenciatura en Lenguas Extranjeras con Énfasis en Inglés', 'pregrado', 'Educación', 'Palmira'),

  -- Posgrados · Salud
  ('Doctorado en Ciencias de la Salud', 'posgrado', 'Salud', 'Cali'),
  ('Especialización en Medicina Interna', 'posgrado', 'Salud', 'Cali'),
  ('Especialización en Seguridad y Salud en el Trabajo', 'posgrado', 'Salud', 'Cali'),
  ('Especialización en Auditoria en Salud', 'posgrado', 'Salud', 'Cali'),

  -- Posgrados · Educación
  ('Doctorado en Educación', 'posgrado', 'Educación', 'Cali'),
  ('Maestría en Educación Ambiental y Desarrollo Sostenible', 'posgrado', 'Educación', 'Cali'),
  ('Maestría en Educación', 'posgrado', 'Educación', 'Cali'),
  ('Especialización en Pedagogía Infantil', 'posgrado', 'Educación', 'Cali'),

  -- Posgrados · Ciencias Básicas
  ('Doctorado en Ciencias Aplicadas', 'posgrado', 'Ciencias Básicas', 'Cali'),
  ('Maestría en Química Industrial', 'posgrado', 'Ciencias Básicas', 'Cali'),

  -- Posgrados · Ciencias Económicas y Empresariales
  ('Doctorado en Administración', 'posgrado', 'Ciencias Económicas y Empresariales', 'Cali'),
  ('Maestría en Gestión Pública', 'posgrado', 'Ciencias Económicas y Empresariales', 'Cali'),
  ('Maestría en Dirección Empresarial', 'posgrado', 'Ciencias Económicas y Empresariales', 'Cali'),
  ('Especialización en Gestión Tributaria', 'posgrado', 'Ciencias Económicas y Empresariales', 'Cali'),
  ('Especialización en Gerencia Financiera', 'posgrado', 'Ciencias Económicas y Empresariales', 'Cali'),
  ('Especialización en Revisoría Fiscal y Auditoría', 'posgrado', 'Ciencias Económicas y Empresariales', 'Cali'),
  ('Especialización en Marketing Digital', 'posgrado', 'Ciencias Económicas y Empresariales', 'Cali'),
  ('Especialización en Desarrollo Humano y Organizacional', 'posgrado', 'Ciencias Económicas y Empresariales', 'Cali'),

  -- Posgrados · Derecho
  ('Doctorado en Derecho', 'posgrado', 'Derecho', 'Cali'),
  ('Maestría en Derecho Médico', 'posgrado', 'Derecho', 'Cali'),
  ('Maestría en Derecho', 'posgrado', 'Derecho', 'Cali'),
  ('Especialización en Derecho Disciplinario', 'posgrado', 'Derecho', 'Cali'),
  ('Especialización en Derecho Laboral y Seguridad Social', 'posgrado', 'Derecho', 'Cali'),
  ('Especialización en Derecho Constitucional', 'posgrado', 'Derecho', 'Cali'),
  ('Especialización en Derecho Administrativo', 'posgrado', 'Derecho', 'Cali'),
  ('Especialización en Derecho Penal', 'posgrado', 'Derecho', 'Cali'),
  ('Especialización en Contratación Estatal', 'posgrado', 'Derecho', 'Cali'),
  ('Especialización en Derechos Humanos y DIH', 'posgrado', 'Derecho', 'Cali'),
  ('Especialización en Derecho de Familia', 'posgrado', 'Derecho', 'Cali'),

  -- Posgrados · Ingeniería
  ('Maestría en Arquitectura de Sistemas de Información', 'posgrado', 'Ingeniería', 'Cali'),
  ('Especialización en Gestión Ambiental Empresarial', 'posgrado', 'Ingeniería', 'Cali'),
  ('Especialización en Control de la Contaminación Ambiental', 'posgrado', 'Ingeniería', 'Cali'),
  ('Especialización en Aplicación y Tecnología de Drones', 'posgrado', 'Ingeniería', 'Cali'),
  ('Especialización en Gerencia de Operaciones', 'posgrado', 'Ingeniería', 'Cali'),
  ('Especialización en Sistemas de Información Geográfica', 'posgrado', 'Ingeniería', 'Cali'),
  ('Especialización en Gerencia de Logística Integral', 'posgrado', 'Ingeniería', 'Cali'),
  ('Especialización en Gerencia Estratégica de Tecnología en Informática', 'posgrado', 'Ingeniería', 'Cali'),
  ('Especialización en Gerencia Ambiental y Desarrollo Sostenible Empresarial', 'posgrado', 'Ingeniería', 'Cali'),

  -- Posgrados · Humanidades y Artes
  ('Maestría en Comunicación Estratégica', 'posgrado', 'Humanidades y Artes', 'Cali');
