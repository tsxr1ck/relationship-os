-- ============================================================
-- 13b. SINTONÍA — SEED DILEMMA BANK
-- ============================================================

INSERT INTO sintonia_dilemmas (scenario, option_a, option_b, category) VALUES
-- MORAL
('Encuentras una billetera con $5,000 y una identificación. ¿Qué haces?', 'La devuelves con todo el dinero', 'Te quedas el dinero y tiras la billetera', 'moral'),
('Tu mejor amigo te pide que le mientas a su pareja sobre dónde estuvo anoche.', 'Le mientes para protegerlo', 'Te niegas y le dices la verdad a su pareja', 'moral'),
('Descubres que tu pareja mintió sobre algo pequeño. ¿Se lo dices?', 'Se lo dices directamente', 'Lo dejas pasar para evitar conflicto', 'moral'),
('Un amigo te confiesa algo muy personal. Tu pareja te pregunta si pasó algo.', 'Le cuentas a tu pareja', 'Guardas el secreto de tu amigo', 'moral'),
('Ves a la pareja de un amigo siendo cariñosa con otra persona.', 'Se lo dices a tu amigo inmediatamente', 'No dices nada, no es tu problema', 'moral'),

-- PRACTICO
('Es sábado por la mañana. ¿Qué prefieren hacer?', 'Quedarse en cama hasta tarde', 'Levantarse temprano y hacer algo productivo', 'practico'),
('Tienen una hora libre inesperada. ¿Qué hacen?', 'Ver una película o serie', 'Salir a caminar o hacer ejercicio', 'practico'),
('Hay que limpiar la casa un domingo. ¿Cómo lo hacen?', 'Cada quien hace lo que le toca solo', 'Lo hacen juntos con música de fondo', 'practico'),
('Se acaba la luz en casa. ¿Cuál es tu primera reacción?', 'Buscar velas y hacer una noche romántica', 'Buscar cómo arreglarlo o llamar a alguien', 'practico'),
('Llueve todo el día y no pueden salir. ¿Qué hacen?', 'Cocinar algo elaborado juntos', 'Maratón de películas con snacks', 'practico'),

-- EMOCIONAL
('Tu pareja tuvo un día terrible en el trabajo. ¿Qué haces?', 'Escuchar sin dar consejos', 'Darle soluciones y consejos prácticos', 'emocional'),
('Estás muy enojado/a con tu pareja. ¿Cómo lo manejas?', 'Hablar del tema inmediatamente', 'Tomar espacio y hablar después de calmarte', 'emocional'),
('Tu pareja llora frente a ti por primera vez. ¿Qué haces?', 'Abrazarla sin decir nada', 'Preguntar qué pasa y cómo ayudar', 'emocional'),
('Recibes un cumplido de alguien que no es tu pareja.', 'Se lo cuentas a tu pareja con humor', 'No le dices nada para evitar celos', 'emocional'),
('Tu pareja quiere hablar de sentimientos pero tú no tienes ganas.', 'Haces el esfuerzo de escuchar', 'Le pides hablar en otro momento', 'emocional'),

-- FINANCIERO
('Les llega un bono inesperado de $10,000. ¿Qué hacen?', 'Lo ahorran o invierten', 'Se dan un gusto: viaje o compra especial', 'financiero'),
('Tu pareja quiere comprar algo caro que no necesitan.', 'Le dices que no es buena idea', 'Lo apoyas porque se lo merece', 'financiero'),
('Uno gana mucho más que el otro. ¿Cómo manejan las cuentas?', 'Cada quien paga lo suyo proporcionalmente', 'Todo va a una cuenta común sin importar cuánto gana cada quien', 'financiero'),
('Tu pareja quiere dejar su trabajo estable para emprender.', 'Lo apoyas aunque sea riesgoso', 'Le pides que tenga un plan más sólido primero', 'financiero'),
('Les ofrecen un trabajo en otra ciudad con mejor sueldo.', 'Se mudan sin dudarlo', 'Se quedan por su red de apoyo y comodidad', 'financiero'),

-- SOCIAL
('Los invitan a una fiesta pero ambos están cansados.', 'Van aunque sea un rato', 'Se quedan en casa y descansan', 'social'),
('En una cena, alguien dice algo ofensivo sin querer.', 'Lo confrontas ahí mismo', 'Lo ignoras y cambias de tema', 'social'),
('Tu pareja quiere ir a una fiesta donde no conoces a nadie.', 'Vas con entusiasmo a conocer gente', 'Vas pero te quedas cerca de tu pareja', 'social'),
('Un amigo de tu pareja te cae muy mal. Hay una reunión con ese amigo.', 'Vas y eres amable por tu pareja', 'Pones una excusa para no ir', 'social'),
('Te piden que organices la reunión familiar de tu pareja.', 'Lo haces con gusto', 'Le dices que prefieres que lo organice tu pareja', 'social'),

-- AVENTURA
('Les ofrecen un viaje sorpresa de fin de semana. No saben a dónde.', 'Aceptan sin preguntar nada', 'Piden al menos saber el destino', 'aventura'),
('Tu pareja quiere probar un deporte extremo (paracaídas, bungee).', 'Lo haces con entusiasmo', 'Lo apoyas pero tú no participas', 'aventura'),
('Podrían vivir en cualquier país del mundo por un año.', 'Eligen un lugar exótico y aventurero', 'Eligen un lugar cómodo y familiar', 'aventura'),
('Encuentran una actividad que nunca han hecho: ¿clase de baile o escape room?', 'Clase de baile', 'Escape room', 'aventura'),
('Es aniversario y tu pareja planea algo secreto.', 'Te emociona la sorpresa total', 'Prefieres que te dé una pista al menos', 'aventura'),

-- GENERAL
('Es su aniversario. ¿Qué prefieren?', 'Una cena íntima en casa', 'Salir a un restaurante especial', 'general'),
('Tu pareja olvida una fecha importante.', 'Lo haces sentir mal para que aprenda', 'Lo perdonas y le recuerdas con cariño', 'general'),
('Uno de los dos quiere tener hijos y el otro no está seguro.', 'Esperar y seguir conversando', 'Buscar terapia de pareja para decidir', 'general'),
('Tu pareja se muda por trabajo a otra ciudad por 6 meses.', 'La relación a distancia vale la pena', 'Uno de los dos debería ceder y mudarse también', 'general'),
('Descubren que tienen un lenguaje del amor completamente diferente.', 'Aprenden a hablar el del otro', 'Buscan un punto medio donde ambos se sientan amados', 'general');
