-- ============================================================
-- 12b. ME CONOCES — SEED QUESTION BANK
-- ============================================================

INSERT INTO meconoces_questions (question_text, answer_prompt, question_type, dimension, options) VALUES
-- CONEXIÓN
('¿Qué tan seguido necesitas tiempo solo para recargar energía?', '¿Qué tan seguido necesitas tiempo solo para recargar energía?', 'LIKERT-5', 'conexion', NULL),
('¿Cuál es tu lenguaje del amor principal?', '¿Cuál es tu lenguaje del amor principal?', 'MULTIPLE_CHOICE', 'conexion', '[{"value":"palabras","label":"Palabras de afirmación"},{"value":"tiempo","label":"Tiempo de calidad"},{"value":"regalos","label":"Regalos"},{"value":"servicio","label":"Actos de servicio"},{"value":"tacto","label":"Contacto físico"}]'),
('¿Cuál es tu mayor miedo irracional?', '¿Cuál es tu mayor miedo irracional?', 'SHORT_TEXT', 'conexion', NULL),
('¿Qué tan importante es para ti que tu pareja conozca a tus amigos?', '¿Qué tan importante es para ti que tu pareja conozca a tus amigos?', 'LIKERT-5', 'conexion', NULL),
('¿Qué es lo que más valoras en una conversación profunda?', '¿Qué es lo que más valoras en una conversación profunda?', 'SHORT_TEXT', 'conexion', NULL),
('¿Prefieres pasar la noche en casa o salir?', '¿Prefieres pasar la noche en casa o salir?', 'MULTIPLE_CHOICE', 'conexion', '[{"value":"casa","label":"En casa, tranqui"},{"value":"salir","label":"Salir y planear algo"},{"value":"depende","label":"Depende del día"}]'),
('¿Qué tan seguido piensas en nuestro futuro juntos?', '¿Qué tan seguido piensas en nuestro futuro juntos?', 'LIKERT-5', 'conexion', NULL),
('¿Qué recuerdo nuestro te hace más feliz?', '¿Qué recuerdo nuestro te hace más feliz?', 'SHORT_TEXT', 'conexion', NULL),

-- CUIDADO
('¿Qué haces normalmente cuando estás estresado/a?', '¿Qué haces normalmente cuando estás estresado/a?', 'MULTIPLE_CHOICE', 'cuidado', '[{"value":"hablar","label":"Hablo con alguien"},{"value":"aislarme","label":"Me aíslo un rato"},{"value":"ejercicio","label":"Hago ejercicio"},{"value":"comer","label":"Como algo rico"},{"value":"dormir","label":"Duermo"}]'),
('¿Qué tan cómodo/a te sientes pidiendo ayuda?', '¿Qué tan cómodo/a te sientes pidiendo ayuda?', 'LIKERT-5', 'cuidado', NULL),
('¿Qué es lo que más te relaja después de un día difícil?', '¿Qué es lo que más te relaja después de un día difícil?', 'SHORT_TEXT', 'cuidado', NULL),
('Ordena de más a menos importante para tu bienestar:', 'Ordena de más a menos importante para tu bienestar:', 'RANK', 'cuidado', '[{"value":"salud","label":"Salud física"},{"value":"familia","label":"Familia"},{"value":"trabajo","label":"Trabajo"},{"value":"hobbies","label":"Hobbies"},{"value":"dinero","label":"Dinero"}]'),
('¿Qué tan seguido haces algo solo por tu bienestar?', '¿Qué tan seguido haces algo solo por tu bienestar?', 'LIKERT-5', 'cuidado', NULL),
('¿Qué te gustaría que tu pareja hiciera más por ti?', '¿Qué te gustaría que tu pareja hiciera más por ti?', 'SHORT_TEXT', 'cuidado', NULL),
('¿Cómo prefieres que te consuelen cuando estás triste?', '¿Cómo prefieres que te consuelen cuando estás triste?', 'MULTIPLE_CHOICE', 'cuidado', '[{"value":"abrazo","label":"Un abrazo"},{"value":"escuchar","label":"Que me escuchen"},{"value":"consejos","label":"Que me den consejos"},{"value":"espacio","label":"Que me den espacio"}]'),

-- CHOQUE
('¿Qué tan seguido evitas una conversación difícil?', '¿Qué tan seguido evitas una conversación difícil?', 'LIKERT-5', 'choque', NULL),
('Cuando estás enojado/a, ¿qué haces primero?', 'Cuando estás enojado/a, ¿qué haces primero?', 'MULTIPLE_CHOICE', 'choque', '[{"value":"hablar","label":"Lo hablo de inmediato"},{"value":"enfriar","label":"Necesito enfriarme primero"},{"value":"escribir","label":"Lo escribo o pienso"},{"value":"ignorar","label":"Intento ignorarlo"}]'),
('¿Cuál es tu mayor detonante en una discusión?', '¿Cuál es tu mayor detonante en una discusión?', 'SHORT_TEXT', 'choque', NULL),
('¿Qué tan importante es para ti tener la razón?', '¿Qué tan importante es para ti tener la razón?', 'LIKERT-5', 'choque', NULL),
('¿Cómo te sientes cuando tu pareja está de mal humor?', '¿Cómo te sientes cuando tu pareja está de mal humor?', 'SHORT_TEXT', 'choque', NULL),
('Ordena de más a menos lo que te molesta:', 'Ordena de más a menos lo que te molesta:', 'RANK', 'choque', '[{"value":"mentiras","label":"Mentiras"},{"value":"desorden","label":"Desorden"},{"value":"impuntualidad","label":"Impuntualidad"},{"value":"silencio","label":"Silencio prolongado"},{"value":"critica","label":"Críticas"}]'),

-- CAMINO
('¿Dónde te ves en 5 años?', '¿Dónde te ves en 5 años?', 'SHORT_TEXT', 'camino', NULL),
('¿Qué tan importante es para ti ahorrar para el futuro?', '¿Qué tan importante es para ti ahorrar para el futuro?', 'LIKERT-5', 'camino', NULL),
('¿Cuál es tu mayor meta personal ahora mismo?', '¿Cuál es tu mayor meta personal ahora mismo?', 'SHORT_TEXT', 'camino', NULL),
('Ordena de más a menos prioridad en tu vida:', 'Ordena de más a menos prioridad en tu vida:', 'RANK', 'camino', '[{"value":"familia","label":"Familia"},{"value":"carrera","label":"Carrera"},{"value":"salud","label":"Salud"},{"value":"crecimiento","label":"Crecimiento personal"},{"value":"diversion","label":"Diversión"}]'),
('¿Qué tan cómodo/a te sientes hablando de dinero?', '¿Qué tan cómodo/a te sientes hablando de dinero?', 'LIKERT-5', 'camino', NULL),
('¿Qué es lo que más te motiva en la vida?', '¿Qué es lo que más te motiva en la vida?', 'MULTIPLE_CHOICE', 'camino', '[{"value":"familia","label":"Mi familia"},{"value":"logro","label":"Lograr mis metas"},{"value":"ayudar","label":"Ayudar a otros"},{"value":"libertad","label":"Mi libertad"},{"value":"aprender","label":"Aprender cosas nuevas"}]'),
('¿Qué tradición te gustaría crear como pareja?', '¿Qué tradición te gustaría crear como pareja?', 'SHORT_TEXT', 'camino', NULL);
