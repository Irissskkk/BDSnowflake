-- 06_dml_load_main_dims.sql
-- Загрузка основных измерений

\echo 'Этап 6: Загрузка основных измерений...'

-- ========== ПОКУПАТЕЛИ ==========
INSERT INTO dim_customer (source_id, first_name, last_name, age, email, postal_code, country_id)
SELECT DISTINCT
    sr.id AS source_id,
    NULLIF(TRIM(sr.customer_first_name), '') AS first_name,
    NULLIF(TRIM(sr.customer_last_name), '') AS last_name,
    sr.customer_age AS age,
    NULLIF(TRIM(sr.customer_email), '') AS email,
    NULLIF(TRIM(sr.customer_postal_code), '') AS postal_code,
    dc.country_id
FROM staging_raw sr
LEFT JOIN dim_country dc 
    ON UPPER(TRIM(sr.customer_country)) = dc.country_name
WHERE sr.customer_email IS NOT NULL AND TRIM(sr.customer_email) != ''
ON CONFLICT (source_id) DO NOTHING;

-- ========== ПИТОМЦЫ ==========
INSERT INTO dim_pet (pet_type, pet_name, breed, pet_category_id)
SELECT DISTINCT
    NULLIF(TRIM(sr.customer_pet_type), '') AS pet_type,
    NULLIF(TRIM(sr.customer_pet_name), '') AS pet_name,
    NULLIF(TRIM(sr.customer_pet_breed), '') AS breed,
    dpc.pet_category_id
FROM staging_raw sr
LEFT JOIN dim_pet_category dpc 
    ON UPPER(TRIM(COALESCE(sr.pet_category, sr.customer_pet_type))) = dpc.category_name
WHERE sr.customer_pet_name IS NOT NULL AND TRIM(sr.customer_pet_name) != ''
ON CONFLICT DO NOTHING;

-- Связь клиент-питомец
INSERT INTO bridge_customer_pet (customer_id, pet_id)
SELECT DISTINCT
    dc.customer_id,
    dp.pet_id
FROM staging_raw sr
JOIN dim_customer dc ON sr.id = dc.source_id
JOIN dim_pet dp 
    ON NULLIF(TRIM(sr.customer_pet_name), '') = dp.pet_name
    AND NULLIF(TRIM(sr.customer_pet_breed), '') = dp.breed
WHERE sr.customer_pet_name IS NOT NULL
ON CONFLICT DO NOTHING;

-- ========== ПРОДАВЦЫ ==========
INSERT INTO dim_seller (source_id, first_name, last_name, email, postal_code, country_id)
SELECT DISTINCT
    sr.sale_seller_id AS source_id,
    NULLIF(TRIM(sr.seller_first_name), '') AS first_name,
    NULLIF(TRIM(sr.seller_last_name), '') AS last_name,
    NULLIF(TRIM(sr.seller_email), '') AS email,
    NULLIF(TRIM(sr.seller_postal_code), '') AS postal_code,
    dc.country_id
FROM staging_raw sr
LEFT JOIN dim_country dc 
    ON UPPER(TRIM(sr.seller_country)) = dc.country_name
WHERE sr.seller_email IS NOT NULL AND TRIM(sr.seller_email) != ''
ON CONFLICT (source_id) DO NOTHING;

-- ========== ТОВАРЫ ==========
INSERT INTO dim_product (
    source_id, product_name, price, weight, color, size, brand, material,
    description, rating, reviews, release_date, expiry_date,
    category_id, pet_category_id
)
SELECT DISTINCT
    sr.sale_product_id AS source_id,
    NULLIF(TRIM(sr.product_name), '') AS product_name,
    sr.product_price AS price,
    sr.product_weight AS weight,
    NULLIF(TRIM(sr.product_color), '') AS color,
    NULLIF(TRIM(sr.product_size), '') AS size,
    NULLIF(TRIM(sr.product_brand), '') AS brand,
    NULLIF(TRIM(sr.product_material), '') AS material,
    NULLIF(TRIM(sr.product_description), '') AS description,
    sr.product_rating AS rating,
    sr.product_reviews AS reviews,
    sr.product_release_date AS release_date,
    sr.product_expiry_date AS expiry_date,
    dpc.category_id,
    dpet.pet_category_id
FROM staging_raw sr
LEFT JOIN dim_product_category dpc 
    ON UPPER(TRIM(sr.product_category)) = dpc.category_name
LEFT JOIN dim_pet_category dpet 
    ON UPPER(TRIM(sr.pet_category)) = dpet.category_name
WHERE sr.product_name IS NOT NULL AND TRIM(sr.product_name) != ''
ON CONFLICT (source_id) DO NOTHING;

-- ========== МАГАЗИНЫ ==========
INSERT INTO dim_store (source_name, location_detail, phone, email, city_id)
SELECT DISTINCT
    NULLIF(TRIM(sr.store_name), '') AS source_name,
    NULLIF(TRIM(sr.store_location), '') AS location_detail,
    NULLIF(TRIM(sr.store_phone), '') AS phone,
    NULLIF(TRIM(sr.store_email), '') AS email,
    dct.city_id
FROM staging_raw sr
LEFT JOIN dim_city dct 
    ON UPPER(TRIM(sr.store_city)) = dct.city_name
    AND UPPER(TRIM(sr.store_state)) = dct.state
WHERE sr.store_name IS NOT NULL AND TRIM(sr.store_name) != ''
ON CONFLICT (source_name) DO NOTHING;

-- ========== ПОСТАВЩИКИ ==========
INSERT INTO dim_supplier (source_name, contact_person, email, phone, address, city_id)
SELECT DISTINCT
    NULLIF(TRIM(sr.supplier_name), '') AS source_name,
    NULLIF(TRIM(sr.supplier_contact), '') AS contact_person,
    NULLIF(TRIM(sr.supplier_email), '') AS email,
    NULLIF(TRIM(sr.supplier_phone), '') AS phone,
    NULLIF(TRIM(sr.supplier_address), '') AS address,
    dcs.city_id
FROM staging_raw sr
LEFT JOIN dim_city dcs 
    ON UPPER(TRIM(sr.supplier_city)) = dcs.city_name
WHERE sr.supplier_name IS NOT NULL AND TRIM(sr.supplier_name) != ''
ON CONFLICT (source_name) DO NOTHING;

-- Статистика
\echo 'Покупателей: ' || (SELECT COUNT(*) FROM dim_customer);
\echo 'Продавцов: ' || (SELECT COUNT(*) FROM dim_seller);
\echo 'Товаров: ' || (SELECT COUNT(*) FROM dim_product);
\echo 'Магазинов: ' || (SELECT COUNT(*) FROM dim_store);
\echo 'Поставщиков: ' || (SELECT COUNT(*) FROM dim_supplier);
\echo 'Питомцев: ' || (SELECT COUNT(*) FROM dim_pet);
\echo 'Основные измерения загружены'