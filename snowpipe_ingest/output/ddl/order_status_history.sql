CREATE OR REPLACE TABLE order_status_history (
  history_id BIGINT,
  order_id BIGINT,
  old_status VARIANT,
  new_status VARCHAR,
  notes VARCHAR,
  changed_at TIMESTAMP_NTZ
);