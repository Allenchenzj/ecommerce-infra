CREATE OR REPLACE TABLE orders (
  order_id BIGINT,
  order_number VARCHAR,
  customer_id FLOAT,
  email VARCHAR,
  status VARCHAR,
  subtotal FLOAT,
  tax_amount FLOAT,
  shipping_amount FLOAT,
  total_amount FLOAT,
  billing_address VARCHAR,
  shipping_address VARCHAR,
  created_at TIMESTAMP_NTZ,
  updated_at TIMESTAMP_NTZ
)