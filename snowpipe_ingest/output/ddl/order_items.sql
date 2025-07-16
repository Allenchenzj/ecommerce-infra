CREATE OR REPLACE TABLE order_items (
  order_item_id BIGINT,
  order_id BIGINT,
  product_id BIGINT,
  quantity BIGINT,
  unit_price FLOAT,
  total_price FLOAT,
  product_name VARCHAR,
  product_sku VARCHAR
);