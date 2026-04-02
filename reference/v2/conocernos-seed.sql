-- ============================================================
-- MIGRATION: Add timezone to couples + Seed Conocernos Questions
-- Run in Supabase SQL Editor
-- ============================================================

-- 1. Add timezone column to couples table
ALTER TABLE couples ADD COLUMN IF NOT EXISTS timezone TEXT DEFAULT 'America/Mexico_City';

-- 2. Seed 60+ questions for Conocernos
-- Clearing existing seeds to avoid duplicates (safe for fresh installs)
-- If you have existing questions you want to keep, comment out the DELETE line
-- DELETE FROM conocernos_questions WHERE author = 'seed';

INSERT INTO conocernos_questions (question_text, dimension, tone, author) VALUES

-- ═══ LIGHT / GENERAL (15) ═══
('¿Cuál sería tu cena perfecta esta noche?', 'general', 'light', 'seed'),
('¿Qué canción te describe esta semana?', 'general', 'light', 'seed'),
('¿Qué harías si tuvieras un día completamente para ti?', 'general', 'light', 'seed'),
('¿Cuál es tu lugar favorito en el mundo hasta ahora?', 'general', 'light', 'seed'),
('¿Qué película podrías ver en bucle sin cansarte?', 'general', 'light', 'seed'),
('Si pudieras aprender algo nuevo de la noche a la mañana, ¿qué sería?', 'general', 'light', 'seed'),
('¿Cuál es tu snack favorito a las 3am?', 'general', 'light', 'seed'),
('¿Qué serie estás viendo o te gustaría empezar?', 'general', 'light', 'seed'),
('¿Cuál es tu estación del año favorita y por qué?', 'general', 'light', 'seed'),
('¿Qué es lo primero que haces al despertar?', 'general', 'light', 'seed'),
('¿Cuál fue el mejor regalo que recibiste?', 'general', 'light', 'seed'),
('¿Qué comida te recuerda a tu infancia?', 'general', 'light', 'seed'),
('Si pudieras cenar con cualquier persona, ¿quién sería?', 'general', 'light', 'seed'),
('¿Cuál es tu forma favorita de relajarte?', 'general', 'light', 'seed'),
('¿Qué es algo pequeño que te hace inmensamente feliz?', 'general', 'light', 'seed'),

-- ═══ REFLECTIVE / CONEXIÓN (15) ═══
('¿Qué momento de esta semana no quisieras olvidar?', 'conexion', 'reflective', 'seed'),
('¿Qué es algo que te cuesta trabajo pedir, aunque lo necesitas?', 'conexion', 'reflective', 'seed'),
('¿Qué te hace sentir más visto/a?', 'conexion', 'reflective', 'seed'),
('¿Cuándo fue la última vez que te sentiste profundamente agradecido/a?', 'conexion', 'reflective', 'seed'),
('¿Qué es algo que siempre quisiste decirme pero no has encontrado el momento?', 'conexion', 'reflective', 'seed'),
('¿Cuál es tu recuerdo favorito de nosotros?', 'conexion', 'reflective', 'seed'),
('¿Qué es lo que más valoras de nuestra relación?', 'conexion', 'reflective', 'seed'),
('¿Hay algo que hayas aprendido de mí sin que yo lo sepa?', 'conexion', 'reflective', 'seed'),
('¿En qué momento del día piensas más en mí?', 'conexion', 'reflective', 'seed'),
('¿Qué te da paz?', 'conexion', 'reflective', 'seed'),
('¿Cuándo te sentiste más conectado/a conmigo últimamente?', 'conexion', 'reflective', 'seed'),
('¿Qué necesitas más de mí en este momento de tu vida?', 'cuidado', 'reflective', 'seed'),
('¿Hay algo que te preocupe y no me hayas dicho?', 'cuidado', 'reflective', 'seed'),
('¿Qué es algo que hago que te hace sentir cuidado/a?', 'cuidado', 'reflective', 'seed'),
('¿Cuál fue un momento difícil que superamos bien juntos?', 'choque', 'reflective', 'seed'),

-- ═══ VISIONARY / CAMINO (15) ═══
('¿A dónde te gustaría viajar antes de los 40?', 'camino', 'visionary', 'seed'),
('¿Cómo imaginas un martes cualquiera en 10 años?', 'camino', 'visionary', 'seed'),
('¿Qué proyecto personal tienes guardado en la cabeza?', 'camino', 'visionary', 'seed'),
('Si pudiéramos vivir en cualquier país por un año, ¿cuál elegirías?', 'camino', 'visionary', 'seed'),
('¿Cómo te gustaría que fuera nuestra casa en 5 años?', 'camino', 'visionary', 'seed'),
('¿Hay algo que quieras lograr este año que no me hayas contado?', 'camino', 'visionary', 'seed'),
('¿Qué tradición te gustaría que empezáramos juntos?', 'conexion', 'visionary', 'seed'),
('¿Cómo te imaginas nuestra vida cuando tengamos 60?', 'camino', 'visionary', 'seed'),
('¿Qué habilidad quisieras dominar algún día?', 'camino', 'visionary', 'seed'),
('Si pudiéramos empezar un negocio juntos, ¿de qué sería?', 'camino', 'visionary', 'seed'),
('¿Qué es algo que sueñas hacer pero te da miedo intentar?', 'camino', 'visionary', 'seed'),
('¿Cómo te gustaría celebrar nuestro próximo aniversario?', 'conexion', 'visionary', 'seed'),
('¿Qué tipo de vacaciones soñadas tenemos pendientes?', 'camino', 'visionary', 'seed'),
('Si el dinero no fuera problema, ¿qué harías mañana?', 'camino', 'visionary', 'seed'),
('¿Cuál es un sueño loco que nunca le has dicho a nadie?', 'camino', 'visionary', 'seed'),

-- ═══ PLAYFUL / GENERAL (15) ═══
('¿Cuál sería tu superpoder ideal?', 'general', 'playful', 'seed'),
('Si fueras un personaje de serie, ¿quién serías?', 'general', 'playful', 'seed'),
('¿Cuál es tu orden de tacos perfecta?', 'general', 'playful', 'seed'),
('Si tu vida fuera una película, ¿de qué género sería?', 'general', 'playful', 'seed'),
('¿Qué animal serías y por qué?', 'general', 'playful', 'seed'),
('¿Cuál es la cosa más rara que te da miedo?', 'general', 'playful', 'seed'),
('Si pudieras teletransportarte ahora mismo, ¿a dónde irías?', 'general', 'playful', 'seed'),
('¿Cuál es tu guilty pleasure más secreto?', 'general', 'playful', 'seed'),
('¿Qué harías si fueras invisible por un día?', 'general', 'playful', 'seed'),
('Si tuvieras que comer la misma comida toda tu vida, ¿cuál?', 'general', 'playful', 'seed'),
('¿Cuál es el meme que más te representa?', 'general', 'playful', 'seed'),
('¿Qué canción pondrías en el karaoke sin pensarlo?', 'general', 'playful', 'seed'),
('Si tuvieras una máquina del tiempo, ¿a qué época irías?', 'general', 'playful', 'seed'),
('¿Cuál es tu emoji más usado y por qué?', 'general', 'playful', 'seed'),
('¿Pizza con piña sí o no, y por qué tienes esa opinión tan fuerte?', 'general', 'playful', 'seed')

ON CONFLICT DO NOTHING;
