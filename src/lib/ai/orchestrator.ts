import { createAdminClient } from '@/lib/supabase/admin';
import { GoogleGenAI } from '@google/genai';

const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });

interface GenerateOptions {
  coupleId: string;
}

export async function generateDynamicAssessment({ coupleId }: GenerateOptions) {
  const admin = createAdminClient();

  // 1. Fetch couple members
  const { data: membersRaw, error: membersError } = await admin
    .from('couple_members')
    .select('user_id, role')
    .eq('couple_id', coupleId);

  if (membersError || !membersRaw || membersRaw.length < 2) {
    console.error('Member lookup error:', membersError);
    throw new Error('Couple must have exactly 2 members to generate the assessment.');
  }

  const { data: profiles } = await admin
    .from('profiles')
    .select('id, full_name')
    .in('id', membersRaw.map(m => m.user_id));

  const members = membersRaw.map(m => ({
    ...m,
    profile: profiles?.find(p => p.id === m.user_id)
  }));

  const [partnerA, partnerB] = members;

  // 2. Fetch Onboarding Responses for both members
  const { data: sessionsA } = await admin
    .from('onboarding_sessions')
    .select('id, responses')
    .eq('user_id', partnerA.user_id)
    .single();

  const { data: sessionsB } = await admin
    .from('onboarding_sessions')
    .select('id, responses')
    .eq('user_id', partnerB.user_id)
    .single();

  if (!sessionsA || !sessionsB) {
    throw new Error('Both partners must have completed onboarding sessions.');
  }

  // 3. Fetch all active CORE items from the item bank
  const { data: availableItems, error: itemsError } = await admin
    .from('item_bank')
    .select('id, dimension_slug, question_text, construct_slug, question_type, response_scale')
    .eq('stage', 'core')
    .eq('active', true);

  if (itemsError || !availableItems || availableItems.length < 28) {
    throw new Error('Not enough active core items in the item bank (minimum 28 required).');
  }

  // 4. Construct the prompt for Gemini
  const prompt = `
Act as an expert relationship psychologist. You are designing a custom 28-question assessment for a specific couple based on their initial onboarding profiles.

COUPLE PROFILE:
Partner A (${partnerA.profile?.full_name || 'Partner A'}):
${JSON.stringify(sessionsA.responses, null, 2)}

Partner B (${partnerB.profile?.full_name || 'Partner B'}):
${JSON.stringify(sessionsB.responses, null, 2)}

YOUR TASK:
Analyze their onboarding answers to identify potential areas of conflict, distinct personality traits, or areas where they need deep exploration. 
Select exactly 28 items from the "AVAILABLE ITEM BANK" below. 
You must select roughly equal amounts of questions from the 4 main dimensions (conexion, cuidado, choque, camino) but you can favor certain dimensions or specific questions if their profiles indicate a specific risk or strength.

AVAILABLE ITEM BANK:
${JSON.stringify(availableItems.map(i => ({ id: i.id, text: i.question_text, dimension: i.dimension_slug })), null, 2)}

OUTPUT REQUIREMENT:
Return a JSON object with exactly 28 unique string IDs representing the chosen items. The key must be "selectedItemIds".
`;

  const responseSchema = {
    type: "OBJECT",
    properties: {
      selectedItemIds: {
        type: "ARRAY",
        items: {
          type: "STRING"
        },
        description: "Array of exactly 28 UUIDs corresponding to the selected items from the bank."
      }
    },
    required: ["selectedItemIds"],
  };

  let selectedItemIds: string[] = [];

  try {
    const response = await ai.models.generateContent({
      model: 'gemini-2.5-flash',
      contents: prompt,
      config: {
        responseMimeType: 'application/json',
        responseSchema,
        temperature: 0.2, // Low temp for more deterministic mapping
      }
    });

    if (response.text) {
      const parsed = JSON.parse(response.text);
      if (parsed.selectedItemIds && Array.isArray(parsed.selectedItemIds)) {
        selectedItemIds = parsed.selectedItemIds;
      }
    }
  } catch (err) {
    console.error('Gemini generation error, falling back to random baseline:', err);
  }

  // 5. Verification & Fallback
  // Ensure we have EXACTLY 28 unique valid items
  const uniqueSelected = Array.from(new Set(selectedItemIds));
  const validSelectedIds = uniqueSelected.filter(id => availableItems.some(i => i.id === id)).slice(0, 28);

  if (validSelectedIds.length < 28) {
    // Fill the rest with random items that aren't already selected
    const remainingToPick = 28 - validSelectedIds.length;
    const unpicked = availableItems.filter(i => !validSelectedIds.includes(i.id));
    const shuffled = unpicked.sort(() => 0.5 - Math.random());
    validSelectedIds.push(...shuffled.slice(0, remainingToPick).map(i => i.id));
  }

  // 6. Persistence
  // Insert into `generated_assessments`
  const { data: assessment, error: assessmentError } = await admin
    .from('generated_assessments')
    .insert({
      couple_id: coupleId,
      title: 'Evaluación Dinámica de Pareja',
      description: 'Generada éticamente por IA en base a sus perfiles de Onboarding',
      gemini_prompt_version: 'v1',
      status: 'published'
    })
    .select('id')
    .single();

  if (assessmentError || !assessment) {
    throw new Error('Failed to save the generated assessment master record.');
  }

  // Sort and prep items — carry over response_scale and actual question_type
  const DEFAULT_LIKERT_5 = [
    { value: '1', label: 'Totalmente en desacuerdo', order: 1 },
    { value: '2', label: 'En desacuerdo', order: 2 },
    { value: '3', label: 'Neutral', order: 3 },
    { value: '4', label: 'De acuerdo', order: 4 },
    { value: '5', label: 'Totalmente de acuerdo', order: 5 },
  ];

  const itemsToInsert = validSelectedIds.map((itemId, index) => {
    const originalItem = availableItems.find(i => i.id === itemId);
    if (!originalItem) throw new Error('Mismatched item ID');
    return {
      assessment_id: assessment.id,
      item_bank_id: itemId,
      category: 'core',
      question_text: originalItem.question_text,
      question_type: originalItem.question_type || 'LIKERT-5',
      response_scale: originalItem.response_scale || DEFAULT_LIKERT_5,
      sort_order: index + 1,
      target_dimension: originalItem.dimension_slug,
    };
  });

  // Insert items
  const { error: itemsInsertError } = await admin
    .from('generated_assessment_items')
    .insert(itemsToInsert);

  if (itemsInsertError) {
    throw new Error('Failed to save individual assessment items: ' + itemsInsertError.message);
  }

  return { assessmentId: assessment.id, itemsCount: itemsToInsert.length };
}
