import { createClient } from '@/lib/supabase/server';
import { QuestionnaireSection, Question } from '@/types/questionnaire';

export async function getQuestionnaireSections(): Promise<QuestionnaireSection[]> {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('questionnaire_sections')
    .select('*')
    .order('sort_order', { ascending: true });

  if (error) {
    console.error('Error fetching questionnaire sections:', error);
    throw new Error('Failed to fetch questionnaire sections');
  }

  return data.map((row) => ({
    id: row.slug,
    slug: row.slug,
    name: row.name,
    description: row.description,
    sort_order: row.sort_order,
    estimated_questions: row.estimated_questions,
  }));
}

export async function getQuestionsBySectionId(sectionSlug: string): Promise<Question[]> {
  const supabase = await createClient();

  const { data: section, error: sectionError } = await supabase
    .from('questionnaire_sections')
    .select('id')
    .eq('slug', sectionSlug)
    .single();

  if (sectionError || !section) {
    console.error('Error finding section:', sectionError);
    return [];
  }

  const { data, error } = await supabase
    .from('questions')
    .select('*')
    .eq('section_id', section.id)
    .order('question_number', { ascending: true });

  if (error) {
    console.error('Error fetching questions:', error);
    return [];
  }

  return data.map((row) => ({
    id: row.id,
    section_id: sectionSlug,
    question_number: row.question_number,
    question_text: row.question_text,
    question_type: row.question_type,
    is_sensitive: row.is_sensitive,
    is_required: row.is_required,
    is_opt_in: row.is_opt_in,
    metadata: row.metadata || {},
  }));
}

export async function getAllQuestions(): Promise<{ sections: QuestionnaireSection[]; questionsBySection: Record<string, Question[]> }> {
  const sections = await getQuestionnaireSections();
  
  const questionsBySection: Record<string, Question[]> = {};
  for (const section of sections) {
    questionsBySection[section.id] = await getQuestionsBySectionId(section.id);
  }

  return { sections, questionsBySection };
}

export async function getQuestionnaireForSession() {
  const { sections, questionsBySection } = await getAllQuestions();
  
  const flatQuestions: Question[] = [];
  for (const section of sections) {
    flatQuestions.push(...questionsBySection[section.id]);
  }

  return {
    sections,
    questionsBySection,
    flatQuestions,
    totalQuestions: flatQuestions.length,
  };
}
