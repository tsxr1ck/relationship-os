-- ============================================================================
-- Seed Questionnaire Data
-- Run in: Supabase SQL Editor
-- ============================================================================

-- Create questionnaire
INSERT INTO questionnaires (id, slug, name, description, version, is_active, estimated_duration_minutes)
VALUES (
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    'relationship-os-v1',
    'Relationship OS',
    'Cuestionario para parejas para descubrir y fortalecer su relación',
    '1.0.0',
    true,
    30
)
ON CONFLICT (slug) DO UPDATE SET name = EXCLUDED.name;

-- Create questionnaire sections with fixed UUIDs for consistent referencing
INSERT INTO questionnaire_sections (id, questionnaire_id, slug, name, description, sort_order, estimated_questions)
VALUES
(
    'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01',
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    'section-a',
    'Descubrimiento Personal',
    'Conoce mejor a ti mismo/a antes de comparar',
    1,
    12
),
(
    'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02',
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    'section-b',
    'Conocer a Tu Pareja',
    'Descubre cuánto conoces realmente a tu pareja',
    2,
    16
),
(
    'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03',
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    'section-c',
    'Relación y Dinámica',
    'Cómo funcionan juntos en cotidiano y presión',
    3,
    16
),
(
    'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a04',
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    'section-d',
    'Proyecto de Vida Compartido',
    'Hacia dónde van como pareja',
    4,
    8
)
ON CONFLICT (questionnaire_id, slug) DO NOTHING;

-- Section A: Descubrimiento Personal (12 questions)
INSERT INTO questions (section_id, question_number, question_text, question_type, is_sensitive, is_required, is_opt_in, metadata)
VALUES
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01', 1, '¿Con qué frecuencia necesitas tiempo para ti solo/a, sin tu pareja?', 'LIKERT-5', false, true, false, '{"options": [{"value": "1", "label": "Nunca", "order": 1}, {"value": "2", "label": "Rara vez", "order": 2}, {"value": "3", "label": "A veces", "order": 3}, {"value": "4", "label": "Frecuentemente", "order": 4}, {"value": "5", "label": "Siempre", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01', 2, 'Cuando tienes un problema emocional, ¿qué prefieres hacer primero?', 'FC', false, true, false, '{"options": [{"value": "A", "label": "Procesarlo solo/a antes de hablar", "order": 1}, {"value": "B", "label": "Hablar de inmediato con mi pareja", "order": 2}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01', 3, '¿Cuánto te cuesta iniciar una conversación difícil con tu pareja?', 'LIKERT-5', false, true, false, '{"options": [{"value": "1", "label": "Nada", "order": 1}, {"value": "2", "label": "Un poco", "order": 2}, {"value": "3", "label": "Moderadamente", "order": 3}, {"value": "4", "label": "Mucho", "order": 4}, {"value": "5", "label": "Extremadamente", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01', 4, 'Ordena de mayor a menor importancia cómo prefieres que te demuestren amor:', 'RANK', false, true, false, '{"ranks": ["Palabras", "Tiempo", "Actos", "Regalos", "Contacto físico"]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01', 5, 'Cuando discutes, ¿qué sueles hacer?', 'FC', false, true, false, '{"options": [{"value": "A", "label": "Persisto hasta resolver", "order": 1}, {"value": "B", "label": "Me alejo a calmarme", "order": 2}, {"value": "C", "label": "Me congelo y no sé qué decir", "order": 3}, {"value": "D", "label": "Cedo para terminar pronto", "order": 4}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01', 6, '¿Qué tan rápido sueles recuperarte emocionalmente después de una discusión?', 'LIKERT-5', false, true, false, '{"options": [{"value": "1", "label": "Inmediatamente", "order": 1}, {"value": "2", "label": "En unas horas", "order": 2}, {"value": "3", "label": "Al día siguiente", "order": 3}, {"value": "4", "label": "En varios días", "order": 4}, {"value": "5", "label": "Mucho tiempo", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01', 7, 'Si pudieras mejorar una sola cosa en cómo te comunicas con tu pareja, ¿qué sería?', 'ABIERTA', false, false, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01', 8, '¿Con qué frecuencia expresas verbalmente afecto o cariño a tu pareja?', 'LIKERT-5', false, true, false, '{"options": [{"value": "1", "label": "Nunca", "order": 1}, {"value": "2", "label": "Rara vez", "order": 2}, {"value": "3", "label": "A veces", "order": 3}, {"value": "4", "label": "Frecuentemente", "order": 4}, {"value": "5", "label": "Siempre", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01', 9, '¿Cuánto peso le das al dinero y la seguridad financiera en tu vida?', 'LIKERT-7', false, true, false, '{"options": [{"value": "1", "label": "Nada", "order": 1}, {"value": "2", "label": "Muy poco", "order": 2}, {"value": "3", "label": "Poco", "order": 3}, {"value": "4", "label": "Neutral", "order": 4}, {"value": "5", "label": "Bastante", "order": 5}, {"value": "6", "label": "Mucho", "order": 6}, {"value": "7", "label": "Extremadamente", "order": 7}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01', 10, 'Cuando tu pareja está triste o estresada, ¿qué es lo primero que haces?', 'FC', false, true, false, '{"options": [{"value": "A", "label": "Intento resolver el problema", "order": 1}, {"value": "B", "label": "Solo escucho y acompaño", "order": 2}, {"value": "C", "label": "La dejo sola si no me pide ayuda", "order": 3}, {"value": "D", "label": "Le pregunto qué necesita", "order": 4}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01', 11, '¿Cuánto disfrutas los rituales cotidianos (buenos días, abrazos de llegada, etc.)?', 'LIKERT-5', false, true, false, '{"options": [{"value": "1", "label": "Nada", "order": 1}, {"value": "2", "label": "Poco", "order": 2}, {"value": "3", "label": "Moderadamente", "order": 3}, {"value": "4", "label": "Mucho", "order": 4}, {"value": "5", "label": "Extremadamente", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a01', 12, '¿Qué tan alineados están tus planes de vida con los de tu pareja actualmente?', 'LIKERT-7', false, true, false, '{"options": [{"value": "1", "label": "Totalmente desalineados", "order": 1}, {"value": "2", "label": "Mayormente desalineados", "order": 2}, {"value": "3", "label": "Algo desalineados", "order": 3}, {"value": "4", "label": "Neutral", "order": 4}, {"value": "5", "label": "Algo alineados", "order": 5}, {"value": "6", "label": "Mayormente alineados", "order": 6}, {"value": "7", "label": "Totalmente alineados", "order": 7}]}');

-- Section B: Conocer a Tu Pareja (16 questions)
INSERT INTO questions (section_id, question_number, question_text, question_type, is_sensitive, is_required, is_opt_in, metadata)
VALUES
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 13, '¿Cuál es el color que más le gusta a tu pareja?', 'ABIERTA', false, true, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 14, '¿Cuál es la comida favorita de tu pareja? ¿Y la que definitivamente no come?', 'ABIERTA', false, true, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 15, '¿Qué género de música escucha tu pareja cuando está de buen humor? ¿Y cuando está triste?', 'ABIERTA', false, true, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 16, '¿Cuál es la película o serie que tu pareja podría ver una y otra vez?', 'ABIERTA', false, true, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 17, 'Si tu pareja tuviera un fin de semana libre y sin compromisos, ¿cómo lo usaría idealmente?', 'ESCENARIO', false, true, false, '{"scenario": "Fin de semana libre sin compromisos", "options": [{"value": "A", "label": "Lo pasaría durmiendo y descansando en casa", "order": 1}, {"value": "B", "label": "Viajaría a un lugar nuevo para explorar", "order": 2}, {"value": "C", "label": "Lo dedicaría a un hobby o proyecto personal", "order": 3}, {"value": "D", "label": "Lo pasaría con amigos o familia", "order": 4}, {"value": "E", "label": "Lo pasaría conmigo, haciendo algo especial", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 18, '¿Cuál es el olor, sabor o sensación física que tu pareja asocia con algo positivo o nostálgico?', 'ABIERTA', false, true, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 19, '¿Cuál crees que es el talento o habilidad que tu pareja menos reconoce en sí misma?', 'ABIERTA', false, true, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 20, '¿Cuál es la mayor fuente de estrés de tu pareja en su vida actual?', 'ABIERTA', false, true, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 21, '¿Cuál es el recuerdo de infancia que tu pareja menciona con más frecuencia o emoción?', 'ABIERTA', false, true, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 22, '¿Qué es lo que tu pareja más admira de sus propios padres o figuras de criado?', 'ABIERTA', false, true, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 23, 'Si tu pareja pudiera vivir en otro lugar del mundo, ¿cuál elegiría y por qué?', 'ABIERTA', false, true, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 24, '¿Cuál es el mayor miedo de tu pareja en la relación, aunque nunca lo diga abiertamente?', 'ABIERTA', true, false, true, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 25, '¿Qué sueño o proyecto personal de tu pareja crees que no está persiguiendo suficientemente?', 'ABIERTA', false, true, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 26, '¿Cuánto crees que tu pareja necesita sentirse reconocida o admirada por ti?', 'LIKERT-5', false, true, false, '{"options": [{"value": "1", "label": "Nada", "order": 1}, {"value": "2", "label": "Poco", "order": 2}, {"value": "3", "label": "Moderadamente", "order": 3}, {"value": "4", "label": "Mucho", "order": 4}, {"value": "5", "label": "Extremadamente", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 27, '¿Cuál es la forma en que tu pareja se recarga energéticamente?', 'FC', false, true, false, '{"options": [{"value": "A", "label": "Soledad y silencio", "order": 1}, {"value": "B", "label": "Tiempo contigo", "order": 2}, {"value": "C", "label": "Amigos y socializar", "order": 3}, {"value": "D", "label": "Actividad física", "order": 4}, {"value": "E", "label": "Creatividad o proyectos", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 28, '¿De qué tema importante todavía no han hablado como pareja, aunque ambos saben que deberían?', 'ABIERTA', true, false, false, '{}');

-- Section C: Relación y Dinámica (16 questions)
INSERT INTO questions (section_id, question_number, question_text, question_type, is_sensitive, is_required, is_opt_in, metadata)
VALUES
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 29, '¿Con qué frecuencia sienten que están realmente presentes el uno para el otro (sin pantallas ni distracciones)?', 'LIKERT-5', false, true, false, '{"options": [{"value": "1", "label": "Nunca", "order": 1}, {"value": "2", "label": "Rara vez", "order": 2}, {"value": "3", "label": "A veces", "order": 3}, {"value": "4", "label": "Frecuentemente", "order": 4}, {"value": "5", "label": "Siempre", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 30, '¿Qué tan satisfecho/a estás con la cantidad y calidad de conversaciones que tienen?', 'LIKERT-7', false, true, false, '{"options": [{"value": "1", "label": "Totalmente insatisfecho", "order": 1}, {"value": "2", "label": "Muy insatisfecho", "order": 2}, {"value": "3", "label": "Insatisfecho", "order": 3}, {"value": "4", "label": "Neutral", "order": 4}, {"value": "5", "label": "Satisfecho", "order": 5}, {"value": "6", "label": "Muy satisfecho", "order": 6}, {"value": "7", "label": "Totalmente satisfecho", "order": 7}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 31, '¿Tienes algún ritual o costumbre que hagas solo para mostrar amor a tu pareja? Descríbelo brevemente.', 'ABIERTA', false, false, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 32, '¿Con qué frecuencia hacen algo nuevo juntos (experiencias distintas, lugares nuevos)?', 'LIKERT-5', false, true, false, '{"options": [{"value": "1", "label": "Nunca", "order": 1}, {"value": "2", "label": "Rara vez", "order": 2}, {"value": "3", "label": "A veces", "order": 3}, {"value": "4", "label": "Frecuentemente", "order": 4}, {"value": "5", "label": "Siempre", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 33, '¿Sientes que tu pareja te conoce profundamente, más allá de tu rol en la relación?', 'LIKERT-7', false, true, false, '{"options": [{"value": "1", "label": "Nada en absoluto", "order": 1}, {"value": "2", "label": "Muy poco", "order": 2}, {"value": "3", "label": "Poco", "order": 3}, {"value": "4", "label": "Neutral", "order": 4}, {"value": "5", "label": "Bastante", "order": 5}, {"value": "6", "label": "Mucho", "order": 6}, {"value": "7", "label": "Totalmente", "order": 7}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 34, 'Cuando tienes un buen o mal día, ¿tu pareja lo nota sin que le digas nada?', 'LIKERT-5', false, true, false, '{"options": [{"value": "1", "label": "Nunca", "order": 1}, {"value": "2", "label": "Rara vez", "order": 2}, {"value": "3", "label": "A veces", "order": 3}, {"value": "4", "label": "Frecuentemente", "order": 4}, {"value": "5", "label": "Siempre", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 35, 'Cuando discuten, ¿cómo termina normalmente la conversación?', 'FC', false, true, false, '{"options": [{"value": "A", "label": "Resolvemos y cerramos bien", "order": 1}, {"value": "B", "label": "Uno cede sin resolver de verdad", "order": 2}, {"value": "C", "label": "Se interrumpe y se retoma después", "order": 3}, {"value": "D", "label": "Se abandona y no se vuelve a tocar", "order": 4}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 36, 'Valora qué tan seguido ocurren estas señales en sus discusiones:', 'SEMAFORO', true, true, false, '{"options": [{"value": "green", "label": "Nunca ocurre (Verde)", "order": 1}, {"value": "yellow", "label": "Ocasionalmente (Amarillo)", "order": 2}, {"value": "red", "label": "Frecuentemente (Rojo)", "order": 3}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 37, '¿Cuánto tiempo tardas normalmente en calmarte después de una pelea?', 'LIKERT-5', false, true, false, '{"options": [{"value": "1", "label": "Minutos", "order": 1}, {"value": "2", "label": "Una hora", "order": 2}, {"value": "3", "label": "Algunas horas", "order": 3}, {"value": "4", "label": "Un día", "order": 4}, {"value": "5", "label": "Más de un día", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 38, '¿Hay algún tema sobre el que siempre discuten sin llegar a ningún lado?', 'ABIERTA', true, false, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 39, 'Después de una pelea importante, ¿quién suele dar el primer paso de reconciliación?', 'FC', false, true, false, '{"options": [{"value": "A", "label": "Yo siempre", "order": 1}, {"value": "B", "label": "Mi pareja siempre", "order": 2}, {"value": "C", "label": "Depende de quién estuvo equivocado/a", "order": 3}, {"value": "D", "label": "Solemos hacerlo juntos al mismo tiempo", "order": 4}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 40, '¿Con qué frecuencia se tocan de manera cariñosa y no sexual (abrazos, tomarse de la mano, caricias)?', 'LIKERT-5', false, true, false, '{"options": [{"value": "1", "label": "Nunca", "order": 1}, {"value": "2", "label": "Rara vez", "order": 2}, {"value": "3", "label": "A veces", "order": 3}, {"value": "4", "label": "Frecuentemente", "order": 4}, {"value": "5", "label": "Siempre", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 41, '¿Sientes que la frecuencia de contacto físico con tu pareja es la que tú necesitas?', 'LIKERT-7', false, true, false, '{"options": [{"value": "1", "label": "Nada", "order": 1}, {"value": "2", "label": "Muy poco", "order": 2}, {"value": "3", "label": "Poco", "order": 3}, {"value": "4", "label": "Neutral", "order": 4}, {"value": "5", "label": "Suficiente", "order": 5}, {"value": "6", "label": "Bastante", "order": 6}, {"value": "7", "label": "Totalmente", "order": 7}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 42, '¿Qué tan cómodo/a te sientes diciendo abiertamente a tu pareja lo que necesitas físicamente?', 'LIKERT-5', true, true, true, '{"options": [{"value": "1", "label": "Nada cómodo", "order": 1}, {"value": "2", "label": "Poco cómodo", "order": 2}, {"value": "3", "label": "Neutral", "order": 3}, {"value": "4", "label": "Cómodo", "order": 4}, {"value": "5", "label": "Muy cómodo", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 43, '¿Considerarías que su vida íntima en este momento es:', 'SEMAFORO', true, true, true, '{"options": [{"value": "green", "label": "Muy satisfactoria (Verde)", "order": 1}, {"value": "yellow", "label": "Mejorable (Amarillo)", "order": 2}, {"value": "red", "label": "Necesita conversación urgente (Rojo)", "order": 3}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 44, '¿Con qué frecuencia habla sobre su vida íntima?', 'LIKERT-5', true, true, true, '{"options": [{"value": "1", "label": "Nunca", "order": 1}, {"value": "2", "label": "Rara vez", "order": 2}, {"value": "3", "label": "A veces", "order": 3}, {"value": "4", "label": "Frecuentemente", "order": 4}, {"value": "5", "label": "Siempre", "order": 5}]}');

-- Section D: Proyecto de Vida Compartido (8 questions)
INSERT INTO questions (section_id, question_number, question_text, question_type, is_sensitive, is_required, is_opt_in, metadata)
VALUES
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a04', 45, '¿Cuán alineados están en el tema de tener o no tener hijos (o más hijos)?', 'SEMAFORO', false, true, false, '{"options": [{"value": "green", "label": "Totalmente alineados (Verde)", "order": 1}, {"value": "yellow", "label": "Necesitamos hablar (Amarillo)", "order": 2}, {"value": "red", "label": "Totalmente diferentes (Rojo)", "order": 3}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a04', 46, '¿Cómo manejan actualmente sus finanzas como pareja? ¿Es el sistema justo para ambos?', 'LIKERT-7', false, true, false, '{"options": [{"value": "1", "label": "Muy injusto", "order": 1}, {"value": "2", "label": "Injusto", "order": 2}, {"value": "3", "label": "Algo injusto", "order": 3}, {"value": "4", "label": "Neutral", "order": 4}, {"value": "5", "label": "Justo", "order": 5}, {"value": "6", "label": "Muy justo", "order": 6}, {"value": "7", "label": "Totalmente justo", "order": 7}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a04', 47, '¿Sienten que están construyendo activamente algo juntos (casa, proyecto, negocio, familia)?', 'LIKERT-5', false, true, false, '{"options": [{"value": "1", "label": "Nada", "order": 1}, {"value": "2", "label": "Poco", "order": 2}, {"value": "3", "label": "Moderadamente", "order": 3}, {"value": "4", "label": "Bastante", "order": 4}, {"value": "5", "label": "Totalmente", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a04', 48, '¿Con qué frecuencia hablan de su futuro como pareja (a 5, 10 años)?', 'LIKERT-5', false, true, false, '{"options": [{"value": "1", "label": "Nunca", "order": 1}, {"value": "2", "label": "Rara vez", "order": 2}, {"value": "3", "label": "A veces", "order": 3}, {"value": "4", "label": "Frecuentemente", "order": 4}, {"value": "5", "label": "Siempre", "order": 5}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a04', 49, '¿Tienen acuerdos claros sobre límites con familia extendida y amistades?', 'SEMAFORO', false, true, false, '{"options": [{"value": "green", "label": "Sí, muy claros (Verde)", "order": 1}, {"value": "yellow", "label": "Algunos, pero no todos (Amarillo)", "order": 2}, {"value": "red", "label": "No tenemos acuerdos (Rojo)", "order": 3}]}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a04', 50, 'Si tuvieras que describir en una palabra el estado actual de su relación, ¿cuál sería?', 'ABIERTA', false, true, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a04', 51, '¿Qué es lo que más valoras de tu pareja que crees que no le dices suficientemente?', 'ABIERTA', false, false, false, '{}'),
('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a04', 52, '¿Qué una cosa concreta podría hacer tu pareja esta semana para que te sintieras más amado/a?', 'ABIERTA', false, true, false, '{}');

-- Verify data
SELECT 'Questionnaires' as table_name, COUNT(*) as count FROM questionnaires
UNION ALL
SELECT 'Sections', COUNT(*) FROM questionnaire_sections
UNION ALL
SELECT 'Questions', COUNT(*) FROM questions;
