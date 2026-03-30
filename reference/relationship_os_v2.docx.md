

**RELATIONSHIP OS**

Especificación Técnica y de Producto — Ultra Detallada

*Versión 2.0 · Clave Studio*

| *"Descubre cómo se aman, dónde conectan, dónde chocan y cómo mejorar juntos."* |
| :---: |

# **1\. Visión General y Principios del Producto**

Relationship OS es una webapp para parejas donde cada persona responde de forma independiente a un cuestionario profundo. El sistema cruza esas respuestas y genera un diagnóstico narrativo que combina afinidades, contrastes, fricciones y acciones concretas de mejora. No es un test de compatibilidad binario: es un mapa vivo de la relación, construido sobre datos reales y actualizado semana a semana.

## **1.1 Framework de Cuatro Capas (Las 4 C)**

Todo el producto — branding, scoring, reportes, preguntas, arquetipos — orbita alrededor de cuatro macrocapas:

| Capa | Color / Acento | Metáfora | Qué mide |
| :---- | :---- | :---- | :---- |
| **Conexión** | Lilac · \#B8A6FF | Hilo | Intimidad emocional, rituales, humor, curiosidad mutua, tiempo juntos, juego, conversación. |
| **Cuidado** | Mint · \#9DDFC6 | Raíz | Lenguajes del afecto, apoyo, validación emocional, atención, reparación y reconocimiento. |
| **Choque** | Rose · \#E8A7B9 | Tormenta | Conflicto, límites, reactividad, evasión, celos, estilo de pelea, tolerancia y cierre. |
| **Camino** | Peach · \#FFBFA3 | Brújula | Metas, dinero, hijos, ciudad, carrera, convivencia, independencia, visión de futuro. |

## **1.2 Principios Rectores Ampliados**

* **Útil antes que viral:** El diagnóstico debe ayudar a actuar y conversar, no solo a presumir una captura de pantalla. Todo insight debe llevar a una acción concreta, una pregunta abierta o un ritual.

* **Seguro antes que invasivo:** La app maneja información altamente íntima. El principio de privacidad-por-diseño debe guiar cada decisión: RLS en Supabase, opt-in para temas sensibles, respuestas individuales nunca visibles directamente por la pareja.

* **Mobile-first real:** La ergonomía prioriza alcance de pulgar, claridad y velocidad. Bottom sheets en lugar de modales. Headers grandes arriba, CTAs accesibles abajo. Sesiones de 2-4 minutos.

* **Corto pero profundo:** La experiencia individual es ligera. El sistema completo es sofisticado. 8-12 preguntas por sesión. El usuario no debe sentir que está llenando un formulario.

* **Narrativo, no clínico:** Los reportes suenan cálidos, claros y humanos. Nunca como una evaluación psicológica formal. El lenguaje es probabilístico ('tienden a', 'suelen'), no determinístico ('son').

* **Acción, no solo diagnóstico:** Cada insight importante debe desembocar en: una microacción, una pregunta guiada, o un ritual semanal. El sistema no observa la relación: la entrena.

# **2\. Módulos del Sistema — Especificación Profunda**

Cada módulo tiene su propio banco de preguntas, dimensiones, tipos de output y microacciones. Todos alimentan el reporte compartido y el plan semanal de IA.

## **2.1 Personalidad Relacional**

Objetivo: generar un perfil de cómo cada persona ama, se comunica, regula emociones y reacciona bajo tensión. No es un MBTI romántico superficial. El output son rasgos accionables, por ejemplo: 'busca cercanía rápida', 'necesita procesar antes de hablar', 'valora acuerdos explícitos'.

Subdimensiones evaluadas:

* Apego ansioso / seguro / evitativo (no etiqueta, sino posición en espectro).

* **1** Regulación emocional: ¿procesa internamente o verbaliza primero?

* **2** Necesidad de validación: ¿necesita confirmar que la pareja está bien antes de hablar?

* **3** Tolerancia a la ambigüedad relacional.

* **4** Tendencia a asumir o verificar intenciones del otro.

* **5** Respuesta al estrés externo: ¿se aísla o busca apoyo activo?

## **2.2 Afinidades (estructurales vs. ligeras)**

El sistema distingue entre afinidades ligeras (gustos compartidos como música, comida, series) y afinidades estructurales (coincidencia en valores, ritmo de vida, manejo del tiempo, visión familiar). Las primeras crean feeling; las segundas predicen estabilidad a largo plazo.

| Afinidad | Tipo | Peso en scoring |
| :---- | :---- | :---- |
| Música, comida, hobbies, humor | Ligera | Bajo (aporta feeling, no estructura) |
| Ritmo de vida: madrugador vs. nocturno | Estructural media | Medio |
| Energía social: extroversión / introversión | Estructural media | Medio |
| Manejo del dinero: ahorrador vs. gastador | Estructural alta | Alto |
| Visión de familia, hijos, lugar de vida | Estructural alta | Muy alto |
| Orden vs. espontaneidad en el hogar | Estructural media | Medio-alto |
| Ambición / prioridad trabajo vs. descanso | Estructural alta | Alto |

## **2.3 Contrastes — Riesgo y Complementariedad**

Los contrastes no son necesariamente malos. El sistema los clasifica en tres tipos de impacto:

* Riesgo real: diferencia en valores estructurales o tolerancia al conflicto.

* **1** Complementario: diferencia que puede ser positiva si hay consciencia (ej. uno planea, el otro improvisa \= equipo).

* **2** Neutro: diferencia de estilo sin fricción real.

Por cada contraste detectado, el reporte muestra: (1) cómo lo vive cada uno, (2) el riesgo potencial, (3) el lado positivo posible, (4) una acción concreta.

## **2.4 Lenguajes del Afecto Expandido**

El sistema va más allá del modelo de 5 love languages de Chapman. Mide por separado:

* Preferencia de recibir afecto (qué te hace sentir amado/a).

* **1** Tendencia natural al expresar afecto (cómo demuestras amor sin pensarlo).

* **2** Desajuste percibido: ¿sientes que el otro te da amor de la forma que necesitas?

* **3** Frecuencia óptima por tipo de expresión (¿cuántas veces a la semana necesitas palabras de afirmación?).

| ⚡ Insight clave El desajuste más común en parejas no es falta de amor, sino lenguajes distintos. Persona A expresa amor con actos de servicio; Persona B interpreta amor como tiempo de calidad. Ambos se aman, pero ninguno se siente suficientemente amado. |
| :---- |

## **2.5 Comunicación — 8 Subdimensiones**

| Subdimensión | Riesgo si es baja | Señal saludable |
| :---- | :---- | :---- |
| Escucha activa | Malentendidos frecuentes, el otro se siente ignorado. | Parafraseo espontáneo, preguntas de seguimiento. |
| Claridad al expresar necesidades | Expectativas implícitas, frustraciones acumuladas. | Peticiones directas, sin adivinar. |
| Timing de conversaciones difíciles | Peleas en momentos de cansancio o hambre. | Acuerdo tácito sobre cuándo hablar de temas importantes. |
| Curiosidad mutua | La relación se estanca, falta novedad. | Preguntas genuinas sobre pensamientos y sueños del otro. |
| Defensividad | El otro se cierra, conversaciones estériles. | Capacidad de escuchar feedback sin ponerse a la defensiva. |
| Validación emocional | El otro se siente incomprendido o juzgado. | Reconocer emociones antes de resolver problemas. |
| Indirectas / pasivo-agresivo | Comunicación tóxica, resentimiento. | Expresión directa y respetuosa de molestias. |
| Facilidad para hablar de temas sensibles | Temas tabú acumulados, elefante en la habitación. | Apertura progresiva, espacio seguro percibido. |

## **2.6 Conflicto — Patrones y Reparación**

Este es el módulo con mayor impacto en retención y valor percibido. Las parejas que aprenden a pelear mejor no necesitan pelearse menos; necesitan salir más rápido de los conflictos y sin daño residual.

Patrones de conflicto detectables:

* Escalada: ambos suben el tono hasta explotar.

* **1** Evasión-persecución: uno busca resolver, el otro se cierra.

* **2** Congelamiento: ninguno habla, el silencio dura días.

* **3** Desbordamiento emocional: uno o ambos pierden perspectiva rápidamente.

* **4** Crítica vs. queja: diferencia entre atacar a la persona y expresar una molestia.

* **5** Defensividad crónica: toda retroalimentación se siente como ataque.

* **6** Desprecio (señal de alarma Gottman): sarcasmo, burla, ojo en blanco.

Outputs del módulo de conflicto:

* Patrón dominante de la pareja.

* **1** Capacidad de reparación (qué tan rápido vuelven a la normalidad).

* **2** Recomendación de 'señal de pausa' personalizada.

* **3** Ritual de reconciliación sugerido según perfil.

## **2.7 Intimidad y Conexión — Opt-in por Niveles**

Este módulo se divide en tres niveles de profundidad, y el usuario debe desbloquear explícitamente el siguiente:

* Nivel 1 (siempre activo): rituales cotidianos, humor compartido, atención y presencia.

* **1** Nivel 2 (opt-in): cercanía emocional profunda, vulnerabilidad, deseo de exploración.

* **2** Nivel 3 (premium, opt-in explícito): sexualidad, frecuencia, comunicación íntima, deseos y límites.

| 🔒 Regla de privacidad Las respuestas del Nivel 3 NUNCA se cruzan directamente. Solo generan patrones anonimizados de 'alineación alta / media / área de conversación' sin revelar respuestas individuales. |
| :---- |

## **2.8 Proyecto de Vida — El Módulo Premium**

Este módulo convierte el producto de una app de relación a una herramienta de construcción de vida en pareja. Áreas cubiertas:

* Hijos: ¿quieren? ¿cuándo? ¿cómo educarlos?

* **1** Dinero: ahorro, deuda, gastos compartidos, objetivos financieros.

* **2** Ciudad y hogar: ¿dónde vivir? ¿casa propia o renta?

* **3** Carreras y ambición: ¿cuánto pesa el trabajo en su identidad?

* **4** Tiempo libre: ¿juntos siempre o espacio individual?

* **5** Familia extendida: límites con padres, suegros, amistades.

* **6** Valores de crianza (si hay o habrá hijos).

* **7** Espiritualidad o religión si aplica.

# **3\. Cuestionario Base — Especificación Completa**

El cuestionario base se divide en cuatro bloques: Descubrimiento Personal (conocerte a ti mismo/a), Conocer a tu Pareja (lo que crees saber de ella), Relación y Dinámica (cómo funcionan juntos), y Proyecto Compartido (hacia dónde van). Cada bloque tiene entre 10-16 preguntas para un total de \~52 preguntas distribuidas en 5-6 sesiones.

## **3.1 Tipos de Pregunta Definidos**

| Código | Nombre | Descripción y cuándo usarlo |
| :---- | :---- | :---- |
| LIKERT-5 | Escala Likert 5pts | Hábitos y percepciones. 'Nunca → Siempre'. Para frecuencias y acuerdos moderados. |
| LIKERT-7 | Escala Likert 7pts | Preferencias intensas. 'Totalmente en desacuerdo → Totalmente de acuerdo'. Para valores y creencias. |
| FC | Elección forzada | Dos opciones opuestas sin escapatoria. Ideal para estilos afectivos, priorización y valores en conflicto. |
| ESCENARIO | Pregunta de escenario | Situación real y concreta. Reduce respuestas idealizadas. 'Si llegas cansado a casa y tu pareja quiere hablar, ¿qué haces?' |
| RANK | Ranking | Ordenar de 1 a N. Para necesidades, lenguajes del afecto, prioridades de vida. |
| SEMAFORO | Semáforo | Tres opciones: Verde (cómodo), Amarillo (depende/negociable), Rojo (incómodo). Para temas sensibles sin presión. |
| ABIERTA | Reflexión corta | Campo de texto libre opcional (máx. 100 palabras). Enriquece el reporte y lo hace personal. Nunca obligatoria. |
| SLIDER | Slider posicional | Deslizador entre dos polos. 'Prefiero estar solo — Prefiero estar acompañado'. Captura espectro continuo. |

| BLOQUE A · Descubrimiento Personal  (Sesión 1 — \~12 preguntas) |
| :---- |

Objetivo: que cada usuario se conozca mejor a sí mismo como pareja antes de comparar. Este bloque es estrictamente privado y no se cruza directamente con el otro.

| \# | Pregunta | Tipo | Dimensión | Notas |
| :---- | :---- | :---- | :---- | :---- |
| **1** | ¿Con qué frecuencia necesitas tiempo para ti solo/a, sin tu pareja? | LIKERT-5 | Autonomía |  |
| **2** | Cuando tienes un problema emocional, ¿qué prefieres hacer primero?  A) Procesarlo solo/a antes de hablar.  B) Hablar de inmediato con mi pareja. | FC | Regulación emocional |  |
| **3** | ¿Cuánto te cuesta iniciar una conversación difícil con tu pareja? | LIKERT-5 | Comunicación |  |
| **4** | Ordena de mayor a menor importancia cómo prefieres que te demuestren amor: Palabras / Tiempo / Actos / Regalos / Contacto físico | RANK | Lenguaje afecto |  |
| **5** | Cuando discutes, ¿qué sueles hacer? A) Persisto hasta resolver.  B) Me alejo a calmarme.  C) Me congelo y no sé qué decir.  D) Cedo para terminar pronto. | FC | Conflicto | 4 opciones |
| **6** | ¿Qué tan rápido sueles recuperarte emocionalmente después de una discusión? | LIKERT-5 | Reparación |  |
| **7** | Si pudieras mejorar una sola cosa en cómo te comunicas con tu pareja, ¿qué sería? | ABIERTA | Comunicación | Opcional |
| **8** | ¿Con qué frecuencia expresas verbalmente afecto o cariño a tu pareja? | LIKERT-5 | Expresión afecto |  |
| **9** | ¿Cuánto peso le das al dinero y la seguridad financiera en tu vida? | LIKERT-7 | Camino / Dinero |  |
| **10** | Cuando tu pareja está triste o estresada, ¿qué es lo primero que haces?  A) Intento resolver el problema.  B) Solo escucho y acompaño.  C) La dejo sola si no me pide ayuda.  D) Le pregunto qué necesita. | FC | Cuidado |  |
| **11** | ¿Cuánto disfrutas los rituales cotidianos (buenos días, abrazos de llegada, etc.)? | LIKERT-5 | Conexión / Rituales |  |
| **12** | ¿Qué tan alineados están tus planes de vida con los de tu pareja actualmente? | LIKERT-7 | Proyecto de vida | Self-assessed |

| BLOQUE B · Conocer a Tu Pareja — Descubrimiento Personal Profundo  (Sesión 2 — \~16 preguntas) |
| :---- |

Objetivo: explorar cuánto conoces realmente a tu pareja. Estas preguntas cubren gustos, preferencias cotidianas, historia personal, y sueños. Muchas parejas se sorprenden al cruzar las respuestas — incluso en relaciones de años.

| 💡 Por qué este bloque importa Las parejas confunden familiaridad con conocimiento profundo. Vivir juntos no garantiza saber cuál es la canción favorita de tu pareja en un mal día, su mayor miedo secreto, o qué es lo que más le enorgullece de sí misma. Este bloque cierra esa brecha. |
| :---- |

### **B.1 Gustos y Mundo Personal**

| \# | Pregunta | Tipo | Dimensión | Notas |
| :---- | :---- | :---- | :---- | :---- |
| **13** | ¿Cuál es el color que más le gusta a tu pareja? | ABIERTA | Conocimiento personal | Cross-check |
| **14** | ¿Cuál es la comida favorita de tu pareja? ¿Y la que definitivamente no come? | ABIERTA | Conocimiento personal | Dos partes |
| **15** | ¿Qué género de música escucha tu pareja cuando está de buen humor? ¿Y cuando está triste? | ABIERTA | Conocimiento personal | Dos estados |
| **16** | ¿Cuál es la película o serie que tu pareja podría ver una y otra vez? | ABIERTA | Conocimiento personal |  |
| **17** | Si tu pareja tuviera un fin de semana libre y sin compromisos, ¿cómo lo usaría idealmente? | ESCENARIO | Energía social / Ocio |  |
| **18** | ¿Cuál es el olor, sabor o sensación física que tu pareja asocia con algo positivo o nostálgico? | ABIERTA | Conocimiento profundo | Sensorial |
| **19** | ¿Cuál crees que es el talento o habilidad que tu pareja menos reconoce en sí misma? | ABIERTA | Autoestima / Conocimiento |  |
| **20** | ¿Cuál es la mayor fuente de estrés de tu pareja en su vida actual? | ABIERTA | Conocimiento emocional |  |

### **B.2 Historia, Sueños y Miedos**

| \# | Pregunta | Tipo | Dimensión | Notas |
| :---- | :---- | :---- | :---- | :---- |
| **21** | ¿Cuál es el recuerdo de infancia que tu pareja menciona con más frecuencia o emoción? | ABIERTA | Historia personal |  |
| **22** | ¿Qué es lo que tu pareja más admira de sus propios padres o figuras de crianza? | ABIERTA | Historia / Familia |  |
| **23** | Si tu pareja pudiera vivir en otro lugar del mundo, ¿cuál elegiría y por qué? | ABIERTA | Sueños / Camino |  |
| **24** | ¿Cuál es el mayor miedo de tu pareja en la relación, aunque nunca lo diga abiertamente? | ABIERTA | Vulnerabilidad | Sensible \- opt-in |
| **25** | ¿Qué sueño o proyecto personal de tu pareja crees que no está persiguiendo suficientemente? | ABIERTA | Camino / Identidad |  |
| **26** | ¿Cuánto crees que tu pareja necesita sentirse reconocida o admirada por ti? | LIKERT-5 | Necesidad de validación |  |
| **27** | ¿Cuál es la forma en que tu pareja se recarga energéticamente? A) Soledad y silencio.  B) Tiempo contigo.  C) Amigos y socializar.  D) Actividad física.  E) Creatividad o proyectos. | FC | Energía / Recarga | 5 opciones |
| **28** | ¿De qué tema importante todavía no han hablado como pareja, aunque ambos saben que deberían? | ABIERTA | Comunicación / Tabú | Cross-check importante |

| BLOQUE C · Relación y Dinámica  (Sesión 3 y 4 — \~16 preguntas) |
| :---- |

Objetivo: evaluar cómo funcionan juntos en la cotidianidad, bajo presión y en momentos especiales. Este es el bloque donde el cruce de respuestas produce los insights más poderosos.

### **C.1 Afecto y Conexión Cotidiana**

| \# | Pregunta | Tipo | Dimensión | Notas |
| :---- | :---- | :---- | :---- | :---- |
| **29** | ¿Con qué frecuencia sienten que están realmente presentes el uno para el otro (sin pantallas ni distracciones)? | LIKERT-5 | Conexión / Presencia |  |
| **30** | ¿Qué tan satisfecho/a estás con la cantidad y calidad de conversaciones que tienen? | LIKERT-7 | Comunicación |  |
| **31** | ¿Tienes algún ritual o costumbre que hagas solo para mostrar amor a tu pareja? Descríbelo brevemente. | ABIERTA | Rituales / Conexión | Opcional |
| **32** | ¿Con qué frecuencia hacen algo nuevo juntos (experiencias distintas, lugares nuevos)? | LIKERT-5 | Conexión / Novedad |  |
| **33** | ¿Sientes que tu pareja te conoce profundamente, más allá de tu rol en la relación? | LIKERT-7 | Intimidad emocional |  |
| **34** | Cuando tienes un buen o mal día, ¿tu pareja lo nota sin que le digas nada? | LIKERT-5 | Lectura emocional |  |

### **C.2 Comunicación bajo Presión**

| \# | Pregunta | Tipo | Dimensión | Notas |
| :---- | :---- | :---- | :---- | :---- |
| **35** | Cuando discuten, ¿cómo termina normalmente la conversación? A) Resolvemos y cerramos bien.  B) Uno cede sin resolver de verdad.  C) Se interrumpe y se retoma después.  D) Se abandona y no se vuelve a tocar. | FC | Conflicto / Cierre |  |
| **36** | Valora qué tan seguido ocurren estas señales en sus discusiones: gritos, insultos, sarcasmo, silencio castigador, recordar peleas pasadas. | SEMAFORO | Conflicto / Señales de alerta | Multi-item |
| **37** | ¿Cuánto tiempo tardas normalmente en calmarte después de una pelea? | LIKERT-5 | Regulación emocional |  |
| **38** | ¿Hay algún tema sobre el que siempre discuten sin llegar a ningún lado? | ABIERTA | Conflicto crónico | Opcional |
| **39** | Después de una pelea importante, ¿quién suele dar el primer paso de reconciliación?  A) Yo siempre.  B) Mi pareja siempre.  C) Depende de quién estuvo equivocado/a.  D) Solemos hacerlo juntos al mismo tiempo. | FC | Reparación |  |

### **C.3 Afecto Físico y Presencia**

| \# | Pregunta | Tipo | Dimensión | Notas |
| :---- | :---- | :---- | :---- | :---- |
| **40** | ¿Con qué frecuencia se tocan de manera cariñosa y no sexual (abrazos, tomarse de la mano, caricias)? | LIKERT-5 | Conexión física |  |
| **41** | ¿Sientes que la frecuencia de contacto físico con tu pareja es la que tú necesitas? | LIKERT-7 | Necesidad vs. realidad | Cross-check |
| **42** | ¿Qué tan cómodo/a te sientes diciendo abiertamente a tu pareja lo que necesitas físicamente? | LIKERT-5 | Comunicación íntima | Nivel 2 |
| **43** | ¿Considerarías que su vida íntima en este momento es: Muy satisfactoria / Satisfactoria / Mejorable / Necesita conversación urgente? | SEMAFORO | Intimidad | Nivel 2 opt-in |

| BLOQUE D · Proyecto de Vida Compartido  (Sesión 5 — \~8 preguntas) |
| :---- |

| \# | Pregunta | Tipo | Dimensión | Notas |
| :---- | :---- | :---- | :---- | :---- |
| **44** | ¿Cuán alineados están en el tema de tener o no tener hijos (o más hijos)? | SEMAFORO | Proyecto / Familia | Alta prioridad |
| **45** | ¿Cómo manejan actualmente sus finanzas como pareja? ¿Es el sistema justo para ambos? | LIKERT-7 | Dinero / Equidad |  |
| **46** | ¿Sienten que están construyendo activamente algo juntos (casa, proyecto, negocio, familia)? | LIKERT-5 | Proyecto compartido |  |
| **47** | ¿Con qué frecuencia hablan de su futuro como pareja (a 5, 10 años)? | LIKERT-5 | Visión de futuro |  |
| **48** | ¿Tienen acuerdos claros sobre límites con familia extendida y amistades? | SEMAFORO | Límites / Familia |  |
| **49** | Si tuvieras que describir en una palabra el estado actual de su relación, ¿cuál sería? | ABIERTA | Estado general | Muy revelador |
| **50** | ¿Qué es lo que más valoras de tu pareja que crees que no le dices suficientemente? | ABIERTA | Reconocimiento | Compartir al final |
| **51** | ¿Qué una cosa concreta podría hacer tu pareja esta semana para que te sintieras más amado/a? | ABIERTA | Acción concreta | → alimenta plan semanal |
| **52** | ¿Qué una cosa concreta podrías hacer tú esta semana para que tu pareja se sintiera más amada? | ABIERTA | Acción concreta | → alimenta plan semanal |

# **4\. Sistema de Scoring — Modelo Detallado**

El sistema evita un número único de compatibilidad. En cambio, genera cuatro salidas por dimensión que pintan una imagen mucho más útil y honesta de la relación.

## **4.1 Las Cuatro Métricas por Dimensión**

| Métrica | Cómo se calcula | Rango | Qué significa en el reporte |
| :---- | :---- | :---- | :---- |
| Afinidad | Distancia euclidiana normalizada entre puntuaciones de ambos en la dimensión. | 0.0 – 1.0 | Qué tan similares son en esta área. 1.0 \= idénticos. |
| Complementariedad | Fórmula inversa con peso de tolerancia mutua declarada. | 0.0 – 1.0 | Qué tan positiva puede ser la diferencia. Alta \= se complementan bien. |
| Fricción | Diferencia × (1 \- tolerancia\_a\_diferencia) × peso\_dimension. | 0.0 – 1.0 | Probabilidad de tensión activa. \>0.7 \= zona roja. |
| Potencial de mejora | (conciencia \+ apertura \+ hábito\_actual) × 0.33. | 0.0 – 1.0 | Cuánto puede mejorar esta área con práctica consciente. |

## **4.2 Etiquetas Semánticas (no porcentajes)**

Las métricas se traducen a chips o bandas semánticas para el frontend:

| Rango numérico | Etiqueta | Color sugerido |
| :---- | :---- | :---- |
| 0.85 – 1.0 | Muy alineados | Mint \#9DDFC6 |
| 0.65 – 0.84 | Bastante alineados | Blue \#7DA7FF |
| 0.45 – 0.64 | Complementarios | Lilac \#B8A6FF |
| 0.25 – 0.44 | Diferencia sensible | Peach \#FFBFA3 |
| 0.00 – 0.24 | Zona a trabajar | Rose muted \#E8A7B9 |

# **5\. Plan Semanal de Pareja — Estructura y Tabla**

El plan semanal es el corazón del loop de hábito. Se genera una vez a la semana mediante una única llamada a IA, usando el estado actual de la pareja como contexto. La tabla siguiente define la estructura del plan en la base de datos.

## **5.1 Tabla weekly\_plans (SQL extendido)**

Esta tabla almacena el plan semanal generado por IA para cada pareja. Cada fila representa la semana completa como JSON estructurado.

| Campo | Tipo SQL | Constraints | Descripción |
| :---- | :---- | :---- | :---- |
| **id** | uuid | PK, default gen\_random\_uuid() | Identificador único del plan. |
| **couple\_id** | uuid | FK → couples(id), NOT NULL | Pareja a la que pertenece este plan. |
| **week\_start** | date | NOT NULL | Lunes de la semana (inicio ISO). |
| **week\_end** | date | NOT NULL | Domingo de la semana. |
| **generated\_at** | timestamptz | default now() | Cuándo se generó el plan. |
| **couple\_status\_snapshot** | jsonb | NOT NULL | Snapshot del estado de la pareja al momento de generar: scores por dimensión, fricción activa, racha, última actividad. |
| **plan** | jsonb | NOT NULL | El plan semanal completo en JSON (ver estructura abajo). |
| **status** | text | default 'active' | active | completed | skipped | archived. |
| **completion\_rate** | numeric(4,2) | default 0, check 0-100 | % de actividades completadas al final de la semana. |
| **couple\_feedback** | jsonb | nullable | Retroalimentación libre de la pareja sobre el plan. |
| **ai\_model\_used** | text | NOT NULL | Qué modelo generó el plan (para auditoría y mejora). |
| **prompt\_version** | text | NOT NULL | Versión del prompt maestro usado (versionado semántico). |

## **5.2 Tabla weekly\_plan\_items (actividades diarias)**

Cada actividad del plan se almacena como fila separada para facilitar el seguimiento individual y las estadísticas.

| Campo | Tipo SQL | Constraints | Descripción |
| :---- | :---- | :---- | :---- |
| **id** | uuid | PK | ID único del ítem. |
| **plan\_id** | uuid | FK → weekly\_plans(id) | Plan al que pertenece. |
| **couple\_id** | uuid | FK → couples(id) | Pareja (para facilitar RLS directo). |
| **day\_of\_week** | int | 1-7 (1=Lunes) | Día al que corresponde la actividad. |
| **day\_label** | text | NOT NULL | Lunes, Martes… (idioma de la app). |
| **title** | text | NOT NULL | Título corto de la actividad. |
| **description** | text | NOT NULL | Descripción completa con instrucciones. |
| **dimension** | text | FK → dimension\_keys(slug) | Dimensión trabajada (conexion, cuidado, choque, camino). |
| **activity\_type** | text | NOT NULL | conversacion | ritual | reto | reflexion | microaccion. |
| **duration\_minutes** | int | NOT NULL | Duración estimada en minutos. |
| **difficulty** | text | default 'medium' | easy | medium | deep. |
| **requires\_both** | boolean | default true | ¿Necesita que ambos participen? |
| **assigned\_to** | text | nullable | null=ambos, user\_id\_a, user\_id\_b. |
| **status** | text | default 'pending' | pending | completed | skipped. |
| **completed\_at** | timestamptz | nullable | Cuándo se marcó como completada. |
| **notes** | text | nullable | Notas opcionales de la pareja al completar. |

## **5.3 Ejemplo visual del Plan Semanal**

Así se vería un plan semanal completo generado por IA para una pareja con fricción alta en 'comunicación bajo presión' y potencial de mejora alto:

| Día | Actividad / Reto | Dimensión | Tipo | Duración | Estado |
| :---- | :---- | :---- | :---- | :---- | :---- |
| Lunes | ✦ Pregunta de conexión: '¿Qué es lo mejor que te pasó hoy, aunque sea pequeño?' | Conexión | Ritual diario | 5 min | Ambos |
| Martes | Mensaje de reconocimiento: Escribe 3 cosas específicas que aprecias de tu pareja esta semana. | Cuidado | Microacción | 10 min | Individual |
| Miércoles | Conversación guiada: 'El tema que evitamos' — usando tarjeta de apertura del deck \#12. | Choque | Conversación | 20 min | Ambos |
| Jueves | Ritual de pausa: Acuerden una señal de pausa para usar en la próxima discusión. | Choque | Reto | 15 min | Ambos |
| Viernes | Noche de presencia: 1 hora sin teléfonos, actividad elegida por el/la que menos lo propone. | Conexión | Ritual | 60 min | Ambos |
| Sábado | Reflexión personal: ¿Qué hice esta semana para que mi pareja se sintiera amada? | Cuidado | Reflexión | 10 min | Individual |
| Domingo | Check-in semanal: 5 minutos respondiendo ¿Cómo estamos hoy? para actualizar estado. | Todas | Check-in | 5 min | Ambos |

# **6\. Master Prompt — Generación de Plan Semanal con IA**

Este es el prompt maestro que se ejecuta una vez por semana por pareja. Recibe el estado actual de la relación como contexto y devuelve un JSON estructurado listo para guardarse en la base de datos.

## **6.1 Contexto de la llamada**

* Una llamada al LLM por pareja por semana (modelo recomendado: claude-sonnet-4-20250514 o equivalente).

* **1** Input: snapshot del estado relacional de la pareja (scores, fricciones, respuestas clave de la semana anterior, feedback del plan anterior).

* **2** Output: JSON estructurado con el plan completo de 7 días.

* **3** Se guarda directamente en weekly\_plans.plan y se explotan las filas de weekly\_plan\_items.

* **4** El prompt usa temperatura 0.7 para balance entre creatividad y consistencia.

## **6.2 Prompt Maestro v1.0**

| 📋 Instrucciones de uso Reemplaza los bloques {{...}} con los datos reales del couple\_status\_snapshot antes de enviar. Este prompt debe versionarse (prompt\_version en la tabla) para poder comparar mejoras. |
| :---- |

| // SYSTEM PROMPT You are a compassionate relationship coach. Your task is to generate a structured 7-day couple activity plan in valid JSON. You MUST respond ONLY with the JSON object, no preamble, no explanation, no markdown code fences. The JSON must be parseable directly. // USER PROMPT Generate a personalized weekly couple plan for the following couple. \#\# COUPLE STATUS SNAPSHOT \- Couple ID: {{couple\_id}} \- Week start: {{week\_start}} (Monday ISO date) \- Relationship time: {{relationship\_months}} months together \- Last plan completion rate: {{last\_completion\_rate}}% \- Last plan feedback: {{last\_plan\_feedback}} \#\# DIMENSION SCORES (0.0 to 1.0) \- Conexion (affinity / complementarity / friction / growth\_potential): {{scores.conexion}} \- Cuidado: {{scores.cuidado}} \- Choque: {{scores.choque}} \- Camino: {{scores.camino}} \#\# ACTIVE FRICTIONS (dimensions with friction \> 0.6) {{active\_frictions\_list}} \#\# STRENGTHS (dimensions with affinity \> 0.75) {{strengths\_list}} \#\# KEY OPEN ANSWERS FROM THIS WEEK \- Partner A said they need: "{{partner\_a\_needs}}" \- Partner B said they need: "{{partner\_b\_needs}}" \- The topic they have been avoiding: "{{avoided\_topic}}" \#\# PLAN GENERATION RULES 1\. Generate exactly 7 daily activities (Monday to Sunday). 2\. Prioritize the active\_frictions dimensions: at least 2 activities must address them. 3\. Include at least 1 activity per macro-layer (Conexion, Cuidado, Choque, Camino). 4\. Mix activity types: at least 1 conversacion, 1 ritual, 1 microaccion, 1 reflexion, 1 reto. 5\. Keep most activities under 20 minutes. Friday or Saturday can be longer (up to 90 min). 6\. If last\_completion\_rate \< 50%, reduce difficulty to "easy" for at least 5 days. 7\. If avoided\_topic is meaningful, include a gentle conversacion activity for Wednesday. 8\. Sunday must always be a check-in activity (5 min, type: check\_in). 9\. Language: Spanish (Mexico). Warm, clear, non-clinical tone. 10\. Never repeat activities from the previous plan. |
| :---- |

## **6.3 JSON Schema de Respuesta Esperada**

| {   "week\_start": "2025-04-07",   "week\_end": "2025-04-13",   "plan\_title": "Semana de la Escucha",   "plan\_summary": "Esta semana se enfocan en construir un espacio más seguro para hablar de lo que importa. Tienen una fortaleza real en rituales y conexión cotidiana — la usamos como base para abrir conversaciones más profundas.",   "focus\_dimension": "choque",   "weekly\_intention": "Esta semana practicamos escucharnos antes de responder.",   "days": \[     {       "day\_of\_week": 1,       "day\_label": "Lunes",       "title": "Pregunta de conexión diaria",       "description": "Al final del día, uno de los dos pregunta: '¿Qué es lo mejor y lo más difícil que te pasó hoy?' El otro escucha sin interrumpir ni resolver. Solo escucha.",       "dimension": "conexion",       "activity\_type": "ritual",       "duration\_minutes": 10,       "difficulty": "easy",       "requires\_both": true,       "assigned\_to": null,       "tip": "El objetivo NO es resolver nada. Solo estar presentes."     },     {       "day\_of\_week": 2,       "day\_label": "Martes",       "title": "Mensaje de reconocimiento",       "description": "Escríbele a tu pareja un mensaje con 3 cosas específicas que aprecias de ella esta semana. No genéricas — específicas: 'Aprecio que hayas preparado el café sin que te lo pidiera.'",       "dimension": "cuidado",       "activity\_type": "microaccion",       "duration\_minutes": 10,       "difficulty": "easy",       "requires\_both": false,       "assigned\_to": "both\_individual",       "tip": "Puede ser por WhatsApp, nota física, o en persona."     }   \],   "weekly\_challenge": {     "title": "La semana sin suposiciones",     "description": "Esta semana, cada vez que asumas saber lo que tu pareja piensa o siente, detenme y pregúntale directamente.",     "dimension": "choque",     "difficulty": "medium"   },   "guided\_conversation": {     "title": "La conversación pendiente",     "prompt": "Elige un tema que ambos han evitado. Establezcan 15 minutos con la regla: quien habla, habla sin interrupciones. Luego cambien.",     "suggested\_day": 3,     "dimension": "choque"   },   "ai\_notes": "Plan generado con friction\_choque=0.71. Se priorizaron actividades de comunicación segura. Dificultad reducida en 5/7 días por completion\_rate de 42% la semana anterior." } |
| :---- |

## **6.4 Edge Function: generate\_weekly\_plan**

La generación del plan vive en una Supabase Edge Function. Así se protege la clave API del LLM y se puede auditar, versionar y reutilizar el proceso.

| Paso | Detalle |
| :---- | :---- |
| 1\. Trigger | Cron semanal (pg\_cron cada lunes 08:00 hora local de la pareja) O llamada manual desde el dashboard. |
| 2\. Leer snapshot | SELECT scores, friction, open\_answers, last\_plan\_feedback FROM couple\_status\_view WHERE couple\_id \= $1. |
| 3\. Construir prompt | Interpolar el template del Master Prompt con los datos del snapshot. |
| 4\. Llamar al LLM | POST a la API del modelo con temperatura 0.7, max\_tokens 2000, response\_format JSON. |
| 5\. Parsear y validar | JSON.parse() \+ validación Zod del schema. Si falla, reintentar max 2 veces. |
| 6\. Insertar plan | INSERT INTO weekly\_plans \+ 7 INSERT INTO weekly\_plan\_items dentro de una transacción. |
| 7\. Notificar | Push notification / email a ambos miembros: 'Tu plan de esta semana está listo'. |
| 8\. Audit log | Guardar prompt\_version, ai\_model\_used, tokens\_used en tabla ai\_audit\_log. |

# **7\. Modelo de Datos Completo (SQL Schema)**

Esquema SQL completo de la base de datos. Todas las tablas incluyen RLS. Las tablas más sensibles tienen políticas explícitas listadas.

## **7.1 Tablas Core de Identidad y Pareja**

* profiles: datos de cada usuario, incluyendo locale, timezone, avatar.

* **1** couples: la relación entre dos usuarios, con estado e invite\_code único.

* **2** couple\_members: tabla pivot con role (self / partner) y fecha de unión.

* **3** couple\_status\_view: vista materializada que agrega scores, racha, última actividad.

## **7.2 Tablas del Cuestionario**

* questionnaires: instancias del cuestionario (versioned, slug único).

* **1** questionnaire\_sections: bloques A, B, C, D con sort\_order y duración estimada.

* **2** questions: banco de preguntas con type, is\_sensitive, metadata jsonb.

* **3** answer\_options: opciones de respuesta para cada pregunta con weight para scoring.

* **4** dimension\_keys: catálogo de las 20 subdimensiones con su capa (conexion/cuidado/choque/camino).

* **5** question\_dimension\_map: asignación de peso entre pregunta y subdimensión (N:M).

## **7.3 Tablas de Respuestas y Reportes**

* response\_sessions: sesión de respuesta por usuario, con status y timestamps.

* **1** responses: cada respuesta individual, con answer\_value jsonb para flexibilidad.

* **2** personal\_reports: reporte individual generado post-cuestionario.

* **3** couple\_reports: reporte compartido de la pareja, con summary, dimensions, frictions, recommendations.

* **4** dimension\_scores: tabla normalizada de scores por dimensión por usuario para analytics.

## **7.4 Tablas de Plan Semanal**

* weekly\_plans: plan semanal completo con snapshot y JSON del plan.

* **1** weekly\_plan\_items: actividades diarias individuales con tracking de estado.

* **2** ai\_audit\_log: registro de cada llamada al LLM con prompt\_version, tokens, model.

## **7.5 Tablas de Contenido Accionable**

* guided\_conversations: biblioteca de conversaciones guiadas con difficulty y dimension.

* **1** weekly\_challenges: banco de retos semanales.

* **2** challenge\_assignments: asignación de reto activo a una pareja.

* **3** milestones: fechas especiales (aniversarios, logros, hitos).

# **8\. Loops de Producto y Retención**

## **8.1 Los Cuatro Loops**

| Loop | Frecuencia | Mecánica |
| :---- | :---- | :---- |
| Descubrimiento | Una vez (onboarding) | Completa el cuestionario → recibe perfil personal → desbloquea vista compartida. Recompensa inmediata: 'Descubriste esto de ti mismo/a.' |
| Conversación | Por insight desbloqueado | Cada resultado importante de la comparación abre una pregunta guiada. Desbloqueada solo cuando ambos completan el bloque relacionado. |
| Hábito semanal | Cada lunes | El plan semanal generado por IA llega cada semana con actividades específicas. Check-in del domingo alimenta el siguiente plan. |
| Progreso | Mensual / por racha | Actualización de dimensiones \+ 'esta semana mejoraron en…' \+ badges de racha. El histórico muestra la evolución de la relación. |

# **9\. Roadmap de Sprints**

| Sprint | Nombre | Entregables clave | Tiempo est. |
| :---- | :---- | :---- | :---- |
| S1 | Fundación | Auth (magic link \+ Google), perfiles, couples, invite flow, RLS base, design system tokens, AppShell, BottomNav. | 2 semanas |
| S2 | Cuestionario | Render engine de preguntas (todos los tipos), guardado de respuestas, progress tracking, sesiones, bloque A \+ B completos. | 2 semanas |
| S3 | Scoring y Reportes | Pipeline de scoring, reporte personal, reporte de pareja, Mapa de Conexión, RadarChart, frictions view. | 2 semanas |
| S4 | Plan Semanal con IA | Edge Function generate\_weekly\_plan, weekly\_plans schema, weekly\_plan\_items, Master Prompt v1, dashboard de plan, check-in dominical. | 1.5 semanas |
| S5 | Hábito y Engagement | Conversaciones guiadas, retos semanales, streaks, historial, notificaciones push, settings y privacidad. | 2 semanas |
| S6 | Monetización y Polish | Premium gating (Proyecto de vida, Intimidad L3, arquetipos shareables), mejoras UX, SEO landing, analytics, packs temáticos. | 2 semanas |

# **10\. Sistema de Arquetipos**

Los arquetipos dan nombre e identidad a patrones comunes de relación. Son memorables, sharable y guían el tono narrativo del reporte. Nunca sustituyen el análisis dimensional — siempre van acompañados de su desglose.

## **10.1 Arquetipos Individuales (6 perfiles base)**

| Arquetipo | Rasgos dominantes | Descripción |
| :---- | :---- | :---- |
| Cálido-Expresivo | Alta cercanía, expresión verbal, rituales | Busca conexión emocional constante. Expresa amor con palabras y gestos. Se siente amado/a con presencia y reconocimiento. |
| Protector-Práctico | Actos de servicio, planificación, seguridad | Demuestra amor haciendo. Prefiere acciones concretas. Puede tener dificultad para verbalizar emociones. |
| Independiente-Reflexivo | Alta autonomía, procesamiento interno, claridad | Necesita espacio para pensar antes de hablar. Ama profundamente pero de forma más discreta. Valora la honestidad directa. |
| Lúdico-Explorador | Novedad, humor, aventura, espontaneidad | La relación florece con experiencias nuevas y humor compartido. Puede tener baja tolerancia a la rutina. |
| Estable-Constructor | Constancia, proyectos, seguridad, compromiso | Prioriza la estabilidad y el proyecto de vida compartido. Muy comprometido pero puede ser percibido como rígido. |
| Sensible-Intuitivo | Alta empatía, lectura emocional, profundidad | Siente y percibe mucho. Necesita sentirse comprendido/a profundamente. Puede tener mayor sensibilidad al conflicto. |

## **10.2 Arquetipos de Pareja (6 perfiles combinados)**

| Arquetipo de Pareja | Descripción narrativa |
| :---- | :---- |
| Cálida-Exploradora | Alta conexión emocional con pasión por descubrir cosas juntos. Fuerte en Conexión y Cuidado. Pueden tener tensión en Camino si la exploración compite con la estabilidad. |
| Serena-Constante | Pareja estable, con rituales fuertes y bajo conflicto. Excelente en Cuidado y Camino. Riesgo: caer en rutina y perder la chispa de Conexión. |
| Magnética-Intensa | Alta química y presencia mutua, pero también mayor tendencia al conflicto. Conexión fuerte, Choque medio-alto. Necesitan herramientas de reparación. |
| Complementaria-Dinámica | Diferencias significativas que se convierten en fortaleza. Uno planea, el otro improvisa. Uno habla, el otro calma. Alto potencial si hay consciencia de los roles. |
| Tierna-Estratégica | Equilibrio entre afecto cotidiano y visión de futuro. Fuerte en Cuidado y Camino. Pueden descuidar el Choque si lo evitan en favor de la armonía. |
| Libre-Conectada | Autonomía individual alta, pero conexión real cuando están juntos. Ambos valoran el espacio. El reto es mantener rituales de reconexión frecuentes. |

# **11\. Seguridad y Privacidad — RLS Detallado**

Dado que la app maneja los datos más íntimos de una persona, la arquitectura de seguridad no puede ser opcional. Cada tabla tiene políticas de Row Level Security explícitas.

| Tabla | Operación | Política RLS |
| :---- | :---- | :---- |
| profiles | SELECT / UPDATE | WHERE id \= auth.uid() |
| couples | SELECT | WHERE id IN (SELECT couple\_id FROM couple\_members WHERE user\_id \= auth.uid()) |
| couple\_members | SELECT | WHERE user\_id \= auth.uid() OR couple\_id IN (couple\_ids del usuario) |
| responses | INSERT / SELECT / UPDATE | WHERE session\_id IN (SELECT id FROM response\_sessions WHERE user\_id \= auth.uid()) |
| response\_sessions | ALL | WHERE user\_id \= auth.uid() |
| personal\_reports | SELECT | WHERE user\_id \= auth.uid() |
| couple\_reports | SELECT | WHERE couple\_id IN (couple\_ids del usuario) |
| weekly\_plans | SELECT | WHERE couple\_id IN (couple\_ids del usuario) |
| weekly\_plan\_items | SELECT / UPDATE status | WHERE couple\_id IN (couple\_ids del usuario) |
| challenge\_assignments | SELECT / UPDATE | WHERE couple\_id IN (couple\_ids del usuario) |

| 🔐 Regla de oro de privacidad Las respuestas individuales del cuestionario NUNCA se exponen directamente al partner. Solo los reportes de pareja, generados server-side por la Edge Function de scoring, están visibles para ambos miembros. Esta regla es no negociable y debe estar en los ToS. |
| :---- |

**Relationship OS**

*Clave Studio · Especificación v2.0*

| Este documento contiene: 52 preguntas del cuestionario base, 2 tablas SQL de plan semanal, el Master Prompt de generación IA con JSON schema completo, sistema de scoring de 4 métricas, 12 arquetipos, RLS para 10 tablas, y roadmap de 6 sprints. |
| :---: |

