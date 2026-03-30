import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://dnjqznvhetmemojhlvao.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRuanF6bnZoZXRtZW1vamhsdmFvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NDYyNDM3MSwiZXhwIjoyMDkwMjAwMzcxfQ.5tbTQFrvVddTBN2vf2unEmF62_ltzDO9mg4n-IUz19w'
);

(async () => {
  const { error } = await supabase.from('custom_evaluation_questions').select('id').limit(1);
  console.log('Error:', error);
})();
