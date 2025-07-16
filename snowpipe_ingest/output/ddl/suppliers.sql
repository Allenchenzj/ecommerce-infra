CREATE OR REPLACE TABLE suppliers (
  supplier_id BIGINT,
  name VARCHAR,
  email VARCHAR,
  phone VARCHAR,
  address VARCHAR,
  is_active BOOLEAN,
  created_at TIMESTAMP_NTZ,
  updated_at TIMESTAMP_NTZ,
  cdc_op VARCHAR
);