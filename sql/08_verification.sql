-- 08_verification.sql
-- Проверочные запросы для демонстрации работы модели

\echo ''
\echo '=========================================='
\echo 'ПРОВЕРКА ЦЕЛОСТНОСТИ ДАННЫХ'
\echo '=========================================='

-- 1. Счётчики по всем таблицам
\echo ''
\echo 'Количество записей в таблицах:'
SELECT 'staging_raw' AS table_name, COUNT(*) AS row_count FROM staging_raw
UNION ALL SELECT 'fact_sales', COUNT(*) FROM fact_sales
UNION ALL SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION ALL SELECT 'dim_product', COUNT(*) FROM dim_product
UNION ALL SELECT 'dim_store', COUNT(*) FROM dim_store
UNION ALL SELECT 'dim_supplier', COUNT(*) FROM dim_supplier
UNION ALL SELECT 'dim_seller', COUNT(*) FROM dim_seller
UNION ALL SELECT 'dim_country', COUNT(*) FROM dim_country
ORDER BY row_count DESC;

-- 2. Проверка внешних ключей (не должно быть сирот)
\echo ''
\echo ' Записи с нарушенными связями (должно быть 0):'
SELECT 'fact_sales → customer' AS check_name, COUNT(*) AS orphan_count
FROM fact_sales WHERE customer_id IS NULL
UNION ALL
SELECT 'fact_sales → product', COUNT(*) FROM fact_sales WHERE product_id IS NULL
UNION ALL
SELECT 'fact_sales → store', COUNT(*) FROM fact_sales WHERE store_id IS NULL
UNION ALL
SELECT 'fact_sales → seller', COUNT(*) FROM fact_sales WHERE seller_id IS NULL
UNION ALL
SELECT 'fact_sales → supplier', COUNT(*) FROM fact_sales WHERE supplier_id IS NULL
UNION ALL
SELECT 'dim_product → category', COUNT(*) FROM dim_product WHERE category_id IS NULL;

-- 3. Проверка дубликатов в измерениях
\echo ''
\echo 'Дубликаты в измерениях (должно быть 0):'
SELECT 'dim_customer.email' AS field, COUNT(*) - COUNT(DISTINCT email) AS duplicates 
FROM dim_customer WHERE email IS NOT NULL
UNION ALL
SELECT 'dim_seller.email', COUNT(*) - COUNT(DISTINCT email) FROM dim_seller WHERE email IS NOT NULL
UNION ALL
SELECT 'dim_product.source_id', COUNT(*) - COUNT(DISTINCT source_id) FROM dim_product;

\echo ''
\echo '=========================================='
\echo ' ПРИМЕРЫ АНАЛИТИЧЕСКИХ ЗАПРОСОВ'
\echo '=========================================='

-- 4. Выручка по категориям товаров (Snowflake: fact → product → category)
\echo ''
\echo 'Топ-5 категорий по выручке:'
SELECT 
    pc.category_name,
    COUNT(f.sale_id) AS transactions,
    SUM(f.quantity) AS items_sold,
    ROUND(SUM(f.total_price)::NUMERIC, 2) AS revenue
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
JOIN dim_product_category pc ON p.category_id = pc.category_id
GROUP BY pc.category_name
ORDER BY revenue DESC
LIMIT 5;

-- 5. Продажи по странам (нормализация через dim_country)
\echo ''
\echo 'Выручка по странам покупателей:'
SELECT 
    c.country_name,
    COUNT(DISTINCT f.sale_id) AS orders,
    ROUND(SUM(f.total_price)::NUMERIC, 2) AS revenue
FROM fact_sales f
JOIN dim_customer cu ON f.customer_id = cu.customer_id
JOIN dim_country c ON cu.country_id = c.country_id
GROUP BY c.country_name
ORDER BY revenue DESC
LIMIT 5;

-- 6. Snowflake-проверка: товар → категория → питомец
\echo ''
\echo 'Пример связи "снежинка" (товар → категории):'
SELECT 
    p.product_name,
    pc.category_name AS product_category,
    petcat.category_name AS pet_category
FROM dim_product p
JOIN dim_product_category pc ON p.category_id = pc.category_id
LEFT JOIN dim_pet_category petcat ON p.pet_category_id = petcat.pet_category_id
LIMIT 10;

-- 7. Аналитика по времени
\echo ''
\echo 'Динамика продаж по месяцам:'
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') AS month,
    COUNT(*) AS orders,
    ROUND(SUM(total_price)::NUMERIC, 2) AS revenue
FROM fact_sales
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY month;

-- 8. Топ товаров по продажам
\echo ''
\echo 'Топ-10 товаров по выручке:'
SELECT 
    p.product_name,
    p.brand,
    COUNT(f.sale_id) AS times_sold,
    ROUND(SUM(f.total_price)::NUMERIC, 2) AS revenue
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.brand
ORDER BY revenue DESC
LIMIT 10;

-- 9. Проверка нормализации стран (снежинка)
\echo ''
\echo 'Проверка нормализации (снежинка):'
SELECT 
    'customers' AS entity,
    COUNT(DISTINCT cu.country_id) AS unique_countries
FROM dim_customer cu
UNION ALL
SELECT 'sellers', COUNT(DISTINCT s.country_id) FROM dim_seller s
UNION ALL
SELECT 'stores', COUNT(DISTINCT ct.country_id) 
FROM dim_store st 
JOIN dim_city ct ON st.city_id = ct.city_id
UNION ALL
SELECT 'suppliers', COUNT(DISTINCT ct.country_id) 
FROM dim_supplier su 
JOIN dim_city ct ON su.city_id = ct.city_id;

\echo ''
\echo '=========================================='
\echo 'Проверка завершена успешно!'
\echo '=========================================='