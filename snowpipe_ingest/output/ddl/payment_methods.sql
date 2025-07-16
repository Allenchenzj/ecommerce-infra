CREATE OR REPLACE TABLE payment_methods (
  method_id BIGINT,
  name VARCHAR,
  code VARCHAR,
  is_active BOOLEAN,
  created_at TIMESTAMP_NTZ
);