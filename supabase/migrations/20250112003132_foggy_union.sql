-- Drop and recreate stores table with correct structure
CREATE TABLE IF NOT EXISTS stores (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  department_number text UNIQUE NOT NULL,
  name text NOT NULL,
  sleeves integer NOT NULL DEFAULT 0,
  caps integer NOT NULL DEFAULT 0,
  canvases integer NOT NULL DEFAULT 0,
  totes integer NOT NULL DEFAULT 0,
  hardlines_raw integer NOT NULL DEFAULT 0,
  softlines_raw integer NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;

-- Create policy for read access
CREATE POLICY "Allow authenticated read access"
  ON stores
  FOR SELECT
  TO authenticated
  USING (true);

-- Insert initial data
INSERT INTO stores (department_number, name, sleeves, caps, canvases, totes, hardlines_raw, softlines_raw)
VALUES
  ('9011', 'Tri-County', 40, 80, 12, 21, 20, 45),
  ('9012', 'Cheviot', 10, 20, 13, 12, 5, 5),
  ('9014', 'Independence', 11, 22, 11, 13, 10, 10),
  ('9015', 'Hamilton', 10, 20, 22, 22, 12, 12),
  ('9016', 'Oakley', 21, 42, 21, 34, 20, 20),
  ('9017', 'Lebanon', 20, 40, 34, 33, 17, 17),
  ('9018', 'Loveland', 30, 60, 32, 24, 20, 20),
  ('9019', 'Bellevue', 26, 52, 22, 26, 15, 15),
  ('9020', 'Harrison', 32, 64, 35, 55, 12, 12),
  ('9021', 'Florence', 34, 68, 54, 20, 20, 13),
  ('9023', 'Batesville', 32, 64, 38, 45, 12, 12),
  ('9024', 'Fairfield', 33, 66, 86, 12, 20, 20),
  ('9025', 'Mason', 46, 92, 54, 11, 6, 6),
  ('9026', 'Beechmont', 4, 8, 76, 25, 18, 18),
  ('9027', 'Mt. Washington', 3, 6, 54, 56, 6, 6),
  ('9029', 'Montgomery', 44, 88, 57, 47, 6, 6),
  ('9030', 'Oxford', 56, 112, 56, 56, 6, 6),
  ('9031', 'West Chester', 43, 86, 46, 37, 14, 14),
  ('9032', 'Lawrenceburg', 12, 24, 28, 38, 10, 10),
  ('9033', 'Deerfield', 45, 90, 51, 19, 20, 20);

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_stores_updated_at
  BEFORE UPDATE ON stores
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();