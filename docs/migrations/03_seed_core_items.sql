-- ============================================================================
-- RELATIONSHIP OS - 03_seed_core_items
-- RUN THIS IN YOUR SUPABASE SQL EDITOR
-- Seeds the `item_bank` with the 52 CORE questions for the V2 Assessment
-- Each item now includes its response_scale (answer options) as JSONB
-- ============================================================================

-- Clear any existing core items to avoid duplication on re-runs
DELETE FROM item_bank WHERE stage = 'core';

INSERT INTO item_bank (slug, stage, dimension_slug, construct_slug, question_text, question_type, response_scale)
VALUES 
-- ===============================
-- 🟢 CONEXIÓN (13 items)
-- ===============================
('con_1', 'core', 'conexion', 'emotional_intimacy', 'Siento que mi pareja realmente entiende mis emociones y me valora tal como soy.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('con_2', 'core', 'conexion', 'friendship', 'Disfrutamos genuinamente del tiempo que pasamos juntos, incluso sin hacer nada especial.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('con_3', 'core', 'conexion', 'physical_affection', 'Estoy satisfecho/a con la cantidad y la calidad de afecto físico en nuestra relación.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('con_4', 'core', 'conexion', 'sexual_connection', 'Nuestra intimidad sexual es satisfactoria y ambos nos sentimos cómodos expresando nuestros deseos.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('con_5', 'core', 'conexion', 'appreciation', 'A menudo le expreso a mi pareja mi aprecio y admiración por las cosas que hace.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('con_6', 'core', 'conexion', 'vulnerability', 'Me siento completamente seguro/a mostrándome vulnerable y compartiendo mis mayores miedos con mi pareja.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('con_7', 'core', 'conexion', 'fun_play', 'Todavía nos reímos juntos y encontramos momentos para ser juguetones y divertidos en la relación.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('con_8', 'core', 'conexion', 'quality_time', 'Pasamos tiempo de calidad juntos sin distracciones de la tecnología o el trabajo.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('con_9', 'core', 'conexion', 'active_listening', 'Cuando hablo sobre mi día, siento que mi pareja escucha con atención y responde con empatía.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('con_10', 'core', 'conexion', 'romantic_gestures', 'Aún tenemos detalles románticos o pequeñas sorpresas que nos demuestran interés continuo.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('con_11', 'core', 'conexion', 'shared_hobbies', 'Tenemos intereses o pasatiempos en común que disfrutamos explorar como equipo.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('con_12', 'core', 'conexion', 'emotional_validation', 'Cuando comparto una preocupación, mi pareja valida mis sentimientos antes de intentar "solucionar" el problema.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('con_13', 'core', 'conexion', 'presence', 'Estando juntos, siento que la atención de mi pareja está realmente allí, en el presente.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),

-- ===============================
-- 🔵 CUIDADO (13 items)
-- ===============================
('cui_1', 'core', 'cuidado', 'trust', 'Confío plenamente en la integridad de mi pareja y en su compromiso con nuestra relación.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cui_2', 'core', 'cuidado', 'support', 'Sé que mi pareja me apoyará incondicionalmente en mis peores momentos.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cui_3', 'core', 'cuidado', 'chores', 'La distribución de las tareas domésticas y responsabilidades diarias se siente justa para ambos.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cui_4', 'core', 'cuidado', 'boundaries', 'Respetamos los límites personales de cada uno (espacio, tiempo a solas, privacidad).', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cui_5', 'core', 'cuidado', 'mental_load', 'Yo siento que compartimos la carga mental de planificar y administrar nuestra vida juntos.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cui_6', 'core', 'cuidado', 'reliability', 'Cuando mi pareja dice que hará algo importante, sé que lo cumplirá.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('cui_7', 'core', 'cuidado', 'forgiveness', 'Podemos perdonarnos genuinamente por errores del pasado sin volver a utilizarlos como armas.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cui_8', 'core', 'cuidado', 'external_stress', 'Somos un refugio seguro cuando el otro enfrenta un alto nivel de estrés externo (trabajo, familia).', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cui_9', 'core', 'cuidado', 'respect', 'Nuestra comunicación cotidiana se mantiene en un tono de respeto, incluso si estamos cansados.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('cui_10', 'core', 'cuidado', 'independence', 'Siento que tengo espacio suficiente para fomentar mis propias amistades e individualidad.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cui_11', 'core', 'cuidado', 'health', 'Nos apoyamos y nos motivamos mutuamente a mantener estilos de vida saludables.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('cui_12', 'core', 'cuidado', 'financial_safety', 'Hablamos transparentemente sobre el dinero y manejamos nuestra economía como un equipo.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('cui_13', 'core', 'cuidado', 'transparency', 'No ocultamos información importante ni tomamos decisiones significativas de manera unilateral.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),

-- ===============================
-- 🔴 CHOQUE (13 items)
-- ===============================
('cho_1', 'core', 'choque', 'conflict_resolution', 'Nuestras discusiones normalmente terminan en acuerdos y resoluciones en lugar de quedar en el aire.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('cho_2', 'core', 'choque', 'communication_style', 'Durante una pelea, ambos evitamos insultos, sarcasmo hiriente o menosprecios.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cho_3', 'core', 'choque', 'deescalation', 'Si una discusión empieza a salirse de control, uno de los dos interviene para calmar la situación.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('cho_4', 'core', 'choque', 'defensiveness', 'Siento que mi pareja se pone constantemente a la defensiva cuando presento una pequeña queja.', 'LIKERT-5',
  '[{"value":"1","label":"Siempre","order":1},{"value":"2","label":"Frecuentemente","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Rara vez","order":4},{"value":"5","label":"Nunca","order":5}]'::jsonb),
('cho_5', 'core', 'choque', 'repair_attempts', 'Mi pareja es buena notando y aceptando mis intentos por arreglar las cosas durante un enojo.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cho_6', 'core', 'choque', 'stonewalling', 'A veces, durante los conflictos, mi pareja (o yo) "apaga" la comunicación y se aleja sin resolver nada.', 'LIKERT-5',
  '[{"value":"1","label":"Siempre","order":1},{"value":"2","label":"Frecuentemente","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Rara vez","order":4},{"value":"5","label":"Nunca","order":5}]'::jsonb),
('cho_7', 'core', 'choque', 'grudges', 'Siento que seguimos teniendo exactamente la misma discusión una y otra vez sin progreso.', 'LIKERT-5',
  '[{"value":"1","label":"Siempre","order":1},{"value":"2","label":"Frecuentemente","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Rara vez","order":4},{"value":"5","label":"Nunca","order":5}]'::jsonb),
('cho_8', 'core', 'choque', 'criticism', 'A menudo siento que recibo críticas sobre "quién soy", más que sobre lo que hago.', 'LIKERT-5',
  '[{"value":"1","label":"Siempre","order":1},{"value":"2","label":"Frecuentemente","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Rara vez","order":4},{"value":"5","label":"Nunca","order":5}]'::jsonb),
('cho_9', 'core', 'choque', 'apologies', 'Ambos sabemos cómo pedir disculpas sinceras cuando nos damos cuenta de que el otro salió lastimado.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cho_10', 'core', 'choque', 'compromise', 'Soy capaz de ceder y modificar mi punto de vista frente a argumentos válidos de mi pareja.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('cho_11', 'core', 'choque', 'temper', 'El mal humor de mi pareja, o mi propio mal humor, a menudo dicta la energía emocional de la casa.', 'LIKERT-5',
  '[{"value":"1","label":"Siempre","order":1},{"value":"2","label":"Frecuentemente","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Rara vez","order":4},{"value":"5","label":"Nunca","order":5}]'::jsonb),
('cho_12', 'core', 'choque', 'post_conflict', 'Después de una pelea, nos reconectamos y sanamos rápidamente en lugar de mantenernos distantes por días.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('cho_13', 'core', 'choque', 'trigger_awareness', 'Conocemos los "botones" emocionales del otro y evitamos presionarlos intencionadamente.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),

-- ===============================
-- 🟡 CAMINO (13 items)
-- ===============================
('cam_1', 'core', 'camino', 'life_goals', 'Siento que nuestros grandes planes a futuro (donde vivir, estilo de vida) están alineados.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cam_2', 'core', 'camino', 'values', 'Compartimos valores fundamentales y una ética similar sobre cómo vivir y relacionarnos.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cam_3', 'core', 'camino', 'parenting', 'Estamos de acuerdo en nuestros deseos hacia formar una familia y los estilos de crianza.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cam_4', 'core', 'camino', 'career_support', 'Siento que mi pareja realmente apoya e invierte en mis sueños profesionales o ambiciones personales.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cam_5', 'core', 'camino', 'financial_goals', 'Trabajamos juntos efectivamente para alcanzar nuestras metas financieras a largo plazo.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('cam_6', 'core', 'camino', 'spirituality', 'Nuestras creencias filosóficas o espirituales coexisten de manera armoniosa.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cam_7', 'core', 'camino', 'traditions', 'Disfrutamos construyendo nuestras propias tradiciones como pareja o familia.', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('cam_8', 'core', 'camino', 'legacy', 'A menudo hablamos sobre lo que queremos lograr juntos a largo plazo (el legado e impacto).', 'LIKERT-5',
  '[{"value":"1","label":"Nunca","order":1},{"value":"2","label":"Rara vez","order":2},{"value":"3","label":"A veces","order":3},{"value":"4","label":"Frecuentemente","order":4},{"value":"5","label":"Siempre","order":5}]'::jsonb),
('cam_9', 'core', 'camino', 'adaptability', 'Hemos demostrado que podemos adaptarnos exitosamente frente a grandes cambios de vida juntos.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cam_10', 'core', 'camino', 'growth', 'Ambos estamos activamente buscando crecer y evolucionar como personas dentro de la relación.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cam_11', 'core', 'camino', 'extended_family', 'Estamos de acuerdo en cómo manejar a nuestra familia extendida y sus influencias.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cam_12', 'core', 'camino', 'lifestyle', 'Tenemos expectativas compatibles sobre qué es una "buena vida" en el día a día.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb),
('cam_13', 'core', 'camino', 'partnership', 'Por encima de todo, nos consideramos genuinos compañeros de vida listos para la siguiente etapa.', 'LIKERT-5',
  '[{"value":"1","label":"Totalmente en desacuerdo","order":1},{"value":"2","label":"En desacuerdo","order":2},{"value":"3","label":"Neutral","order":3},{"value":"4","label":"De acuerdo","order":4},{"value":"5","label":"Totalmente de acuerdo","order":5}]'::jsonb);
