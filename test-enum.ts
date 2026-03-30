import { GoogleGenAI, Type, Schema } from '@google/genai';
import fs from 'fs';

const envFile = fs.readFileSync('.env.local', 'utf8');
const match = envFile.match(/GEMINI_API_KEY="?([^"\n]+)"?/);
if (match) {
  process.env.GEMINI_API_KEY = match[1];
}

(async () => {
  try {
    const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });
    const prompt = `
Genera un JSON con EXACTAMENTE el siguiente esquema:
{
  "title": "Un título",
  "questions": [
    {
      "question_text": "Texto",
      "question_type": "LIKERT-5"
    }
  ]
}
`;
    // let's try without enum
    const schema = {
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
              question_type: { type: Type.STRING },
            },
            required: ['question_text', 'question_type'],
          },
        },
      },
    };

    console.log('Generating evaluation without enum...');
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: {
        responseMimeType: 'application/json',
        responseSchema: schema,
        temperature: 0.7,
      },
    });
    console.log('Result:', response.text);
  } catch (err) {
    console.error('Test error:', err);
  }
})();
