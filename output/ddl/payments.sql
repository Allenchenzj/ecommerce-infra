CREATE OR REPLACE TABLE payments (
  payment_id BIGINT,
  order_id BIGINT,
  method_id BIGINT,
  amount FLOAT,
  status VARCHAR,
  transaction_id VARCHAR,
  processed_at TIMESTAMP_NTZ,
  created_at TIMESTAMP_NTZ
)