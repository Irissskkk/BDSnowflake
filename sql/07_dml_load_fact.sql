-- 07_dml_load_fact.sql
-- Загрузка таблицы фактов продаж

\echo '🚀 Этап 7: Загрузка таблицы фактов...'

INSERT INTO fact_sales (
    sale_date,
    customer_id,
    seller_id,
    product_id,
    store_id,
    supplier_id,
    quantity,
    total_price
)
SELECT 
    sr.sale_date,
    dc.customer_id,
    ds.seller_id,
    dp.product_id,
    dst.store_id,
    dsp.supplier_id,
    COALESCE(sr.sale_quantity, 1) AS quantity,
    COALESCE(sr.sale_total_price, 0) AS total_price
FROM staging_raw sr
JOIN dim_customer dc ON sr.sale_customer_id = dc.source_id
JOIN dim_seller ds ON sr.sale_seller_id = ds.source_id
JOIN dim_product dp ON sr.sale_product_id = dp.source_id
JOIN dim_store dst ON NULLIF(TRIM(sr.store_name), '') = dst.source_name
JOIN dim_supplier dsp ON NULLIF(TRIM(sr.supplier_name), '') = dsp.source_name
WHERE sr.sale_date IS NOT NULL
  AND sr.sale_total_price IS NOT NULL
  AND sr.sale_quantity > 0;

-- Статистика фактов
\echo '📊 Загружено продаж: ' || (SELECT COUNT(*) FROM fact_sales);
\echo '📅 Диапазон дат: ' || 
    (SELECT MIN(sale_date)::TEXT || ' — ' || MAX(sale_date)::TEXT FROM fact_sales);
\echo '💰 Общая выручка: ' || 
    (SELECT SUM(total_price)::TEXT || ' у.е.' FROM fact_sales);
\echo '✅ Таблица фактов загружена'