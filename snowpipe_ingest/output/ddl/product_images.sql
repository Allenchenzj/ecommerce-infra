CREATE OR REPLACE TABLE product_images (
  image_id BIGINT,
  product_id BIGINT,
  image_url VARCHAR,
  alt_text VARCHAR,
  is_primary BOOLEAN,
  created_at TIMESTAMP_NTZ
);