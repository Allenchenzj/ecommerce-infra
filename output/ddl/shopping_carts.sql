CREATE OR REPLACE TABLE shopping_carts (
  cart_id BIGINT,
  customer_id FLOAT,
  session_id VARCHAR,
  product_id BIGINT,
  quantity BIGINT,
  created_at TIMESTAMP_NTZ,
  updated_at TIMESTAMP_NTZ
)