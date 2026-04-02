ALTER TABLE historia_entries DROP CONSTRAINT IF EXISTS historia_entries_content_type_check;
ALTER TABLE historia_entries ADD CONSTRAINT historia_entries_content_type_check CHECK (content_type IN ('text', 'photo', 'voice', 'conocernos_reveal', 'system_milestone', 'quote', 'milestone'));
