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
    console.log('Generating topics...');
    const result = await ai.suggestConnectionTopics({ duration: '5 meses' });
    console.log('Result:', JSON.stringify(result, null, 2));
    process.exit(0);
  } catch (err) {
    console.error('Test error:', err);
    process.exit(1);
  }
})();
