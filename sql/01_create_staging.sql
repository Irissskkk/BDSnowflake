-- 01_create_staging.sql
-- Создание staging-таблицы + импорт всех 10 CSV-файлов БЕЗ объединения

\echo '🚀 Этап 1: Создание staging_raw и импорт данных...'

-- Удаляем таблицу если существует (для идемпотентности)
DROP TABLE IF EXISTS staging_raw CASCADE;

-- Создаём сырую таблицу с полной схемой (40+ колонок)
CREATE TABLE staging_raw (
    id INT,
    customer_first_name VARCHAR(100),
    customer_last_name VARCHAR(100),
    customer_age INT,
    customer_email VARCHAR(150),
    customer_country VARCHAR(100),
    customer_postal_code VARCHAR(20),
    customer_pet_type VARCHAR(50),
    customer_pet_name VARCHAR(100),
    customer_pet_breed VARCHAR(100),
    seller_first_name VARCHAR(100),
    seller_last_name VARCHAR(100),
    seller_email VARCHAR(150),
    seller_country VARCHAR(100),
    seller_postal_code VARCHAR(20),
    product_name VARCHAR(200),
    product_category VARCHAR(100),
    product_price DECIMAL(10,2),
    product_quantity INT,
    sale_date DATE,
    sale_customer_id INT,
    sale_seller_id INT,
    sale_product_id INT,
    sale_quantity INT,
    sale_total_price DECIMAL(12,2),
    store_name VARCHAR(150),
    store_location VARCHAR(200),
    store_city VARCHAR(100),
    store_state VARCHAR(100),
    store_country VARCHAR(100),
    store_phone VARCHAR(30),
    store_email VARCHAR(150),
    pet_category VARCHAR(100),
    product_weight DECIMAL(6,2),
    product_color VARCHAR(50),
    product_size VARCHAR(20),
    product_brand VARCHAR(100),
    product_material VARCHAR(100),
    product_description TEXT,
    product_rating DECIMAL(3,2),
    product_reviews INT,
    product_release_date DATE,
    product_expiry_date DATE,
    supplier_name VARCHAR(150),
    supplier_contact VARCHAR(150),
    supplier_email VARCHAR(150),
    supplier_phone VARCHAR(30),
    supplier_address TEXT,
    supplier_city VARCHAR(100),
    supplier_country VARCHAR(100)
);

-- Индексы для ускорения ETL-загрузки в DWH-таблицы
CREATE INDEX idx_staging_id ON staging_raw(id);
CREATE INDEX idx_staging_sale_customer_id ON staging_raw(sale_customer_id);
CREATE INDEX idx_staging_sale_seller_id ON staging_raw(sale_seller_id);
CREATE INDEX idx_staging_sale_product_id ON staging_raw(sale_product_id);
CREATE INDEX idx_staging_store_name ON staging_raw(store_name);
CREATE INDEX idx_staging_supplier_name ON staging_raw(supplier_name);

\echo '✅ Таблица staging_raw создана'

-- =====================================================
-- 📥 ИМПОРТ ВСЕХ 10 CSV-ФАЙЛОВ (без объединения!)
-- =====================================================
-- Пути указаны для docker-тома: /data_source/...
-- Файлы смонтированы через volumes в docker-compose.yml

\echo '📥 Начинаю импорт CSV-файлов...'

-- Файл 0: MOCK_DATA.csv
\echo '   → MOCK_DATA.csv'
COPY staging_raw FROM '/data_source/MOCK_DATA.csv' 
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    ENCODING 'UTF8',
    FORCE_NULL (
        customer_age, product_quantity, sale_quantity, product_reviews,
        product_weight, product_rating
    )
);

-- Файл 1: MOCK_DATA (1).csv
\echo '   → MOCK_DATA (1).csv'
COPY staging_raw FROM '/data_source/MOCK_DATA (1).csv' 
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    ENCODING 'UTF8',
    FORCE_NULL (
        customer_age, product_quantity, sale_quantity, product_reviews,
        product_weight, product_rating
    )
);

-- Файл 2: MOCK_DATA (2).csv
\echo '   → MOCK_DATA (2).csv'
COPY staging_raw FROM '/data_source/MOCK_DATA (2).csv' 
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    ENCODING 'UTF8',
    FORCE_NULL (
        customer_age, product_quantity, sale_quantity, product_reviews,
        product_weight, product_rating
    )
);

-- Файл 3: MOCK_DATA (3).csv
\echo '   → MOCK_DATA (3).csv'
COPY staging_raw FROM '/data_source/MOCK_DATA (3).csv' 
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    ENCODING 'UTF8',
    FORCE_NULL (
        customer_age, product_quantity, sale_quantity, product_reviews,
        product_weight, product_rating
    )
);

-- Файл 4: MOCK_DATA (4).csv
\echo '   → MOCK_DATA (4).csv'
COPY staging_raw FROM '/data_source/MOCK_DATA (4).csv' 
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    ENCODING 'UTF8',
    FORCE_NULL (
        customer_age, product_quantity, sale_quantity, product_reviews,
        product_weight, product_rating
    )
);

-- Файл 5: MOCK_DATA (5).csv
\echo '   → MOCK_DATA (5).csv'
COPY staging_raw FROM '/data_source/MOCK_DATA (5).csv' 
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    ENCODING 'UTF8',
    FORCE_NULL (
        customer_age, product_quantity, sale_quantity, product_reviews,
        product_weight, product_rating
    )
);

-- Файл 6: MOCK_DATA (6).csv
\echo '   → MOCK_DATA (6).csv'
COPY staging_raw FROM '/data_source/MOCK_DATA (6).csv' 
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    ENCODING 'UTF8',
    FORCE_NULL (
        customer_age, product_quantity, sale_quantity, product_reviews,
        product_weight, product_rating
    )
);

-- Файл 7: MOCK_DATA (7).csv
\echo '   → MOCK_DATA (7).csv'
COPY staging_raw FROM '/data_source/MOCK_DATA (7).csv' 
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    ENCODING 'UTF8',
    FORCE_NULL (
        customer_age, product_quantity, sale_quantity, product_reviews,
        product_weight, product_rating
    )
);

-- Файл 8: MOCK_DATA (8).csv
\echo '   → MOCK_DATA (8).csv'
COPY staging_raw FROM '/data_source/MOCK_DATA (8).csv' 
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    ENCODING 'UTF8',
    FORCE_NULL (
        customer_age, product_quantity, sale_quantity, product_reviews,
        product_weight, product_rating
    )
);

-- Файл 9: MOCK_DATA (9).csv
\echo '   → MOCK_DATA (9).csv'
COPY staging_raw FROM '/data_source/MOCK_DATA (9).csv' 
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    ENCODING 'UTF8',
    FORCE_NULL (
        customer_age, product_quantity, sale_quantity, product_reviews,
        product_weight, product_rating
    )
);

\echo '✅ Все 10 файлов импортированы'
-- =====================================================
-- 📊 ПРОВЕРКА ИМПОРТА (ИСПРАВЛЕНО)
-- =====================================================
\echo ''
\echo '📈 Статистика после импорта:'

-- Общее количество строк
SELECT '📦 Всего строк в staging_raw' AS metric, COUNT(*)::TEXT AS value FROM staging_raw
UNION ALL
-- Уникальные покупатели
SELECT '👥 Уникальные покупатели', COUNT(DISTINCT sale_customer_id)::TEXT FROM staging_raw
UNION ALL
-- Уникальные товары
SELECT '🛍️ Уникальные товары', COUNT(DISTINCT sale_product_id)::TEXT FROM staging_raw
UNION ALL
-- Уникальные магазины
SELECT '🏪 Уникальные магазины', COUNT(DISTINCT store_name)::TEXT FROM staging_raw
UNION ALL
-- Диапазон дат
SELECT '📅 Диапазон дат', MIN(sale_date)::TEXT || ' — ' || MAX(sale_date)::TEXT FROM staging_raw;

-- Проверка на дубликаты по первичному ключу id
\echo ''
\echo '🔍 Проверка на дубликаты по id:'
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT id) AS unique_ids,
    COUNT(*) - COUNT(DISTINCT id) AS duplicate_ids
FROM staging_raw;

-- Проверка NULL в критичных полях
\echo ''
\echo '⚠️  NULL в критичных полях:'
SELECT 
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS null_dates,
    COUNT(*) FILTER (WHERE sale_total_price IS NULL) AS null_prices,
    COUNT(*) FILTER (WHERE product_name IS NULL) AS null_products,
    COUNT(*) FILTER (WHERE customer_email IS NULL) AS null_customers
FROM staging_raw;

\echo ''
\echo '✅ Этап 1 завершён. Переходите к 02_ddl_shared_dims.sql'