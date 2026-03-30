import { GoogleGenAI, Type, Schema } from '@google/genai';

export interface CustomQuestion {
  question_text: string;
  question_type: 'LIKERT-5' | 'LIKERT-7' | 'OPEN' | 'BOOLEAN';
  response_scale?: any;
}

export interface CustomEvaluationPayload {
  title: string;
  description: string;
  questions: CustomQuestion[];
}

export interface CustomInsightsPayload {
  ai_summary: string;
  ai_actions: string[];
}

export interface TopicSuggestion {
  title: string;
  subtitle: string;
  emoji: string;
}

export class CustomEvaluationAI {
  private ai: GoogleGenAI;

  constructor() {
    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) {
      throw new Error('GEMINI_API_KEY NO está configurada');
    }
    this.ai = new GoogleGenAI({ apiKey });
  }

  /**
   * Generates 3 engaging quiz topic suggestions for the couple.
   */
  async suggestConnectionTopics(coupleContext?: { duration?: string | null }): Promise<TopicSuggestion[]> {
    const prompt = `
Eres un creador de juegos de conexión para parejas (Relationship OS).
Necesitas proponer 3 temas variados e interesantes para que la pareja realice un "Quiz de Pareja".
Busca una mezcla: algo divertido/ligero, algo profundo/emocional, y algo práctico/visionario.
${coupleContext?.duration ? `La pareja lleva junta: ${coupleContext.duration}.` : ''}

Ejemplos de temas: "Nuestra infancia oculta", "¿Qué haríamos con un millón de dólares?", "Nuestros lenguajes del estrés".

Genera un JSON con EXACTAMENTE el siguiente esquema:
{
  "topics": [
    {
      "title": "Título corto y llamativo",
      "subtitle": "Breve frase invitándolos a jugar",
      "emoji": "Un solo emoji que represente el tema"
    }
  ]
}
`;

    const schema: Schema = {
      type: Type.OBJECT,
      properties: {
        topics: {
          type: Type.ARRAY,
          items: {
            type: Type.OBJECT,
            properties: {
              title: { type: Type.STRING },
              subtitle: { type: Type.STRING },
              emoji: { type: Type.STRING },
            },
            required: ['title', 'subtitle', 'emoji'],
          },
        },
      },
    };

    const response = await this.ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: {
        responseMimeType: 'application/json',
        responseSchema: schema,
        temperature: 0.8,
      },
    });

    if (!response.text) {
      throw new Error('Error generando temas sugeridos.');
    }

    const payload = JSON.parse(response.text);
    return payload.topics || [];
  }

  /**
   * Generates a 5-10 question evaluation tailored to the topic requested by the couple.
   */
  async generateEvaluation(
    topic: string,
    coupleContext?: { duration?: string | null; archetype?: string | null }
  ): Promise<CustomEvaluationPayload> {
    const prompt = `
Eres un psicoterapeuta de parejas experto diseñando "Micro-Evaluaciones" para Relationship OS.
La pareja desea explorar un tema específico: "${topic}".
${coupleContext?.duration ? `Llevan juntos: ${coupleContext.duration}.` : ''}

Tu tarea es generar una micro-evaluación (entre 5 y 8 preguntas) enfocada SOLAMENTE en "${topic}".
La evaluación debe sentirse empática, útil y clínicamente válida.

Genera un JSON con EXACTAMENTE el siguiente esquema:
{
  "title": "Un título corto y cálido, ej: 'Explorando nuestras finanzas'",
  "description": "1-2 oraciones explicando por qué es importante este tema y qué descubrirán.",
  "questions": [
    {
      "question_text": "Texto de la pregunta (si es escala, debe ser una afirmación 'Yo siento que...')",
      "question_type": "Debe ser 'LIKERT-5' o 'OPEN'"
    }
  ]
}

REGLAS DE PREGUNTAS:
- La mayoría de las preguntas deben ser 'LIKERT-5' (escala del 1 al 5 donde 1 es Totalmente en desacuerdo y 5 es Totalmente de acuerdo).
- Si el tema lo requiere, incluye 1 o 2 preguntas 'OPEN' al final para que puedan expresarse libremente (ej: "¿Cuál es tu mayor temor al tocar este tema?").
- Las afirmaciones deben estar redactadas en primera persona ("Siento que...", "Me es fácil...").
- Mantén el lenguaje accesible y libre de juicios.
`;

    const schema: Schema = {
      type: Type.OBJECT,
      properties: {
        title: { type: Type.STRING },
        description: { type: Type.STRING },
        questions: {
          type: Type.ARRAY,
          items: {
            type: Type.OBJECT,
            properties: {
              question_text: { type: Type.STRING },
              question_type: { type: Type.STRING, enum: ['LIKERT-5', 'OPEN'] },
            },
            required: ['question_text', 'question_type'],
          },
        },
      },
    };

    const response = await this.ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: {
        responseMimeType: 'application/json',
        temperature: 0.7,
      },
    });

    if (!response.text) {
      throw new Error('No se generó texto de la IA.');
    }

    let rawText = response.text;
    if (rawText.startsWith('```json')) {
      rawText = rawText.replace(/^```json\n/, '').replace(/\n```$/, '').trim();
    }
    const payload = JSON.parse(rawText) as CustomEvaluationPayload;

    // Validate and sanitize the payload
    if (!payload.title || !payload.questions || payload.questions.length === 0) {
      throw new Error('La IA retornó un esquema inválido o vacío.');
    }

    return payload;
  }

  /**
   * Generates coaching insights comparing both partners' answers to a custom evaluation.
   */
  async analyzeResults(
    topic: string,
    questions: { text: string; type: string }[],
    answersA: any[], // partner A's values mapped to questions array
    answersB: any[], // partner B's values mapped to questions array
    names: { a: string; b: string }
  ): Promise<CustomInsightsPayload> {
    const formattedData = questions.map((q, i) => {
      return `Q: ${q.text} (Tipo: ${q.type})
${names.a}: ${answersA[i]}
${names.b}: ${answersB[i]}
`;
    }).join('\n');

    const prompt = `
Eres un coach de relaciones para Relationship OS.
Acabas de recibir los resultados de una micro-evaluación sobre el tema "${topic}".

Datos de la evaluación:
${formattedData}

Analiza estas respuestas y genera un reporte constructivo.
Si las respuestas en escalas numéricas son muy distintas (ej. 1 y 5), hay una brecha de percepción. Si son cercanas, hay alineación.
Considera con empatía las respuestas abiertas.

Genera un JSON con EXACTAMENTE este esquema:
{
  "ai_summary": "Un resumen de 3-4 párrafos sobre el estado general de este tema para la pareja. Destaca puntos en común y divergencias importantes, usando sus nombres reales.",
  "ai_actions": [
    "Acción cálida y específica 1",
    "Acción reflexiva y específica 2",
    "Acción práctica 3"
  ]
}
`;

    const schema: Schema = {
      type: Type.OBJECT,
      properties: {
        ai_summary: { type: Type.STRING },
        ai_actions: {
          type: Type.ARRAY,
          items: { type: Type.STRING },
        },
      },
    };

    const response = await this.ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: {
        responseMimeType: 'application/json',
        temperature: 0.6,
      },
    });

    let rawText = response.text;
    if (!rawText) {
      throw new Error('Error al generar los insights de la evaluación.');
    }
    if (rawText.startsWith('```json')) {
      rawText = rawText.replace(/^```json\n/, '').replace(/\n```$/, '').trim();
    }
    
    return JSON.parse(rawText) as CustomInsightsPayload;
  }
}
