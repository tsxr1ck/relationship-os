-- Create the history bucket if it doesn't exist
INSERT INTO storage.buckets (id, name, public) 
VALUES ('historia', 'historia', true)
ON CONFLICT (id) DO NOTHING;

-- Allow public read access to the bucket
CREATE POLICY "Public Read Access"
ON storage.objects FOR SELECT
USING (bucket_id = 'historia');

-- Allow authenticated users to upload files to the bucket
CREATE POLICY "Authenticated users can upload"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'historia' 
  AND auth.role() = 'authenticated'
);

-- Allow authenticated users to delete their own uploads
CREATE POLICY "Authenticated users can delete"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'historia' 
  AND auth.role() = 'authenticated'
);
