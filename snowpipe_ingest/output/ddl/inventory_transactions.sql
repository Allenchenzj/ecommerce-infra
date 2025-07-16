CREATE OR REPLACE TABLE inventory_transactions (
  transaction_id BIGINT,
  product_id BIGINT,
  transaction_type VARCHAR,
  quantity_change BIGINT,
  reference_type VARCHAR,
  reference_id BIGINT,
  notes VARCHAR,
  created_at TIMESTAMP_NTZ
);