CREATE OR REPLACE TABLE customers (
  customer_id BIGINT,
  email VARCHAR,
  password_hash VARCHAR,
  first_name VARCHAR,
  last_name VARCHAR,
  phone VARCHAR,
  is_active BOOLEAN,
  created_at TIMESTAMP_NTZ,
  updated_at TIMESTAMP_NTZ,
  cdc_op VARCHAR
)