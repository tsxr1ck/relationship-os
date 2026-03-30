import { CustomEvaluationAI } from './src/lib/ai/CustomEvaluationAI.ts';
import fs from 'fs';

const envFile = fs.readFileSync('.env.local', 'utf8');
const match = envFile.match(/GEMINI_API_KEY="?([^"\n]+)"?/);
if (match) {
  process.env.GEMINI_API_KEY = match[1];
}

(async () => {
  try {
    const ai = new CustomEvaluationAI();
    console.log('Generating evaluation...');
    const result = await ai.generateEvaluation('finanzas');
    console.log('Result:', JSON.stringify(result, null, 2));
  } catch (err) {
    console.error('Test error:', err);
  }
})();
