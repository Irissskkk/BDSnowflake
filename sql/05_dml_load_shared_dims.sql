-- 05_dml_load_shared_dims.sql
-- Загрузка общих нормализованных справочников

INSERT INTO dim_country (country_name)
SELECT DISTINCT UPPER(TRIM(country_val)) AS country_name
FROM (
    SELECT customer_country AS country_val FROM staging_raw WHERE customer_country IS NOT NULL AND TRIM(customer_country) != ''
    UNION
    SELECT seller_country FROM staging_raw WHERE seller_country IS NOT NULL AND TRIM(seller_country) != ''
    UNION
    SELECT store_country FROM staging_raw WHERE store_country IS NOT NULL AND TRIM(store_country) != ''
    UNION
    SELECT supplier_country FROM staging_raw WHERE supplier_country IS NOT NULL AND TRIM(supplier_country) != ''
) AS countries
ON CONFLICT (country_name) DO NOTHING;

INSERT INTO dim_city (city_name, state, country_id)
SELECT DISTINCT
    UPPER(TRIM(sr.store_city)) AS city_name,
    NULLIF(UPPER(TRIM(sr.store_state)), '') AS state,
    dc.country_id
FROM staging_raw sr
JOIN dim_country dc 
    ON UPPER(TRIM(sr.store_country)) = dc.country_name
WHERE sr.store_city IS NOT NULL AND TRIM(sr.store_city) != ''
ON CONFLICT (city_name, state, country_id) DO NOTHING;

-- Категории товаров
INSERT INTO dim_product_category (category_name)
SELECT DISTINCT UPPER(TRIM(product_category))
FROM staging_raw
WHERE product_category IS NOT NULL AND TRIM(product_category) != ''
ON CONFLICT (category_name) DO NOTHING;

-- Категории питомцев 
INSERT INTO dim_pet_category (category_name)
SELECT DISTINCT UPPER(TRIM(cat_val))
FROM (
    SELECT pet_category AS cat_val FROM staging_raw WHERE pet_category IS NOT NULL AND TRIM(pet_category) != ''
    UNION
    SELECT customer_pet_type FROM staging_raw WHERE customer_pet_type IS NOT NULL AND TRIM(customer_pet_type) != ''
) AS pets
ON CONFLICT (category_name) DO NOTHING;

\echo 'Загружено стран: ' || (SELECT COUNT(*) FROM dim_country);
\echo 'Загружено городов: ' || (SELECT COUNT(*) FROM dim_city);
\echo 'Загружено категорий товаров: ' || (SELECT COUNT(*) FROM dim_product_category);
\echo 'Загружено категорий питомцев: ' || (SELECT COUNT(*) FROM dim_pet_category);
