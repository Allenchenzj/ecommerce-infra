CREATE OR REPLACE TABLE shipping_methods (
  method_id BIGINT,
  name VARCHAR,
  base_cost FLOAT,
  estimated_days BIGINT,
  is_active BOOLEAN,
  created_at TIMESTAMP_NTZ
);