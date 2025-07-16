CREATE OR REPLACE TABLE categories (
  category_id BIGINT,
  name VARCHAR,
  description VARCHAR,
  parent_id BIGINT,
  is_active BOOLEAN,
  created_at TIMESTAMP_NTZ,
  updated_at TIMESTAMP_NTZ,
  cdc_op VARCHAR
);