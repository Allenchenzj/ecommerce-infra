CREATE OR REPLACE TABLE products (
  product_id BIGINT,
  name VARCHAR,
  description VARCHAR,
  category_id BIGINT,
  price FLOAT,
  compare_price FLOAT,
  sku VARCHAR,
  stock_quantity BIGINT,
  is_active BOOLEAN,
  created_at TIMESTAMP_NTZ,
  updated_at TIMESTAMP_NTZ,
  cdc_op VARCHAR
)