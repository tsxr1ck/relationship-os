// app/sintonia/resultado/[gameId]/actions.ts
"use server";

import { GoogleGenAI } from "@google/genai";

export type SintoniaInsightInput = {
    coupleNickname?: string | null;
    scorePct: number;
    matchCount: number;
    totalRounds: number;
    bestCategory?: string | null;
    hardestCategory?: string | null;
    longestMatchStreak: number;
    rounds: Array<{
        roundNumber: number;
        category: string;
        scenario: string;
        isMatch: boolean;
        userAVote: "A" | "B" | null;
        userBVote: "A" | "B" | null;
    }>;
};

export type SintoniaInsightResult = {
    headline: string;
    body: string;
};

function fallbackInsight(input: SintoniaInsightInput): SintoniaInsightResult {
    const score = input.scorePct;

    if (score >= 85) {
        return {
            headline: "Nivel telepatía desbloqueado",
            body: `Terminaron con ${score}% de sintonía (${input.matchCount}/${input.totalRounds}) y honestamente ya dan miedo, pero de la forma tierna. ${input.longestMatchStreak >= 3 ? `Hasta se aventaron una racha de ${input.longestMatchStreak} matches seguidos.` : "Se nota que se leen bastante bien."}`,
        };
    }

    if (score >= 60) {
        return {
            headline: "Muy bien, equipo",
            body: `Cerraron con ${score}% de sintonía (${input.matchCount}/${input.totalRounds}), o sea: bastante bien y con espacio para seguirse sorprendiendo. No fue caos, fue variedad con potencial romántico.`,
        };
    }

    return {
        headline: "Química con sazón",
        body: `Quedaron en ${score}% de sintonía (${input.matchCount}/${input.totalRounds}), así que sí hay conexión… solo que también hay plot twists. Básicamente: una pareja con cariño y opiniones bastante premium.`,
    };
}

export async function generateSintoniaInsight(
    input: SintoniaInsightInput,
): Promise<SintoniaInsightResult> {
    if (!process.env.GEMINI_API_KEY) {
        return fallbackInsight(input);
    }

    try {
        const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });

        const prompt = `
Eres el narrador de resultados de una app de pareja llamada Sintonia.

Quiero que respondas SOLO JSON válido:
{
  "headline": "máximo 6 palabras",
  "body": "máximo 2 frases, cálido, juguetón y ligeramente gracioso"
}

Reglas:
- Español natural.
- Tono amistoso, coqueto y ligero.
- Nada clínico, nada dramático, nada pasivo-agresivo.
- No uses "red flag", "toxico", "alma gemela" ni lenguaje terapéutico.
- Menciona el score (${input.scorePct}%).
- Menciona los matches (${input.matchCount}/${input.totalRounds}).
- Si ayuda, menciona la mejor categoría: ${input.bestCategory ?? "ninguna"}.
- Si ayuda, menciona la categoría más difícil: ${input.hardestCategory ?? "ninguna"}.
- Si ayuda, menciona la racha más larga de matches: ${input.longestMatchStreak}.
- Debe sonar cute, fresco y un poquito divertido.

Contexto del juego:
- Pareja/apodo: ${input.coupleNickname ?? "pareja"}
- Score: ${input.scorePct}%
- Matches: ${input.matchCount}/${input.totalRounds}
- Mejor categoría: ${input.bestCategory ?? "ninguna"}
- Categoría más difícil: ${input.hardestCategory ?? "ninguna"}
- Racha más larga: ${input.longestMatchStreak}

Rondas:
${input.rounds
                .map(
                    (r) =>
                        `R${r.roundNumber} | ${r.category} | ${r.isMatch ? "match" : "diferencia"} | ${r.scenario}`,
                )
                .join("\n")}
`;

        const result = await ai.models.generateContent({
            model: "gemini-2.5-flash",
            contents: prompt,
        });

        const text = result.text?.trim() ?? "";
        const jsonMatch = text.match(/\{[\s\S]*\}/);
        if (!jsonMatch) return fallbackInsight(input);

        const parsed = JSON.parse(jsonMatch[0]) as Partial<SintoniaInsightResult>;

        if (!parsed.headline || !parsed.body) {
            return fallbackInsight(input);
        }

        return {
            headline: parsed.headline,
            body: parsed.body,
        };
    } catch {
        return fallbackInsight(input);
    }
}