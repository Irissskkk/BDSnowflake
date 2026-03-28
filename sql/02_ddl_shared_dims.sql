-- 02_ddl_shared_dims.sql
-- Общие нормализованные справочники, ядро снежинки

-- Страны
DROP TABLE IF EXISTS dim_country CASCADE;
CREATE TABLE dim_country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) UNIQUE NOT NULL
);
CREATE INDEX idx_dim_country_name ON dim_country(UPPER(country_name));

-- Города (привязаны к стране)
DROP TABLE IF EXISTS dim_city CASCADE;
CREATE TABLE dim_city (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    country_id INT REFERENCES dim_country(country_id),
    UNIQUE(city_name, state, country_id)
);
CREATE INDEX idx_dim_city_country ON dim_city(country_id);

-- Категории товаров
DROP TABLE IF EXISTS dim_product_category CASCADE;
CREATE TABLE dim_product_category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL
);

-- Категории питомцев
DROP TABLE IF EXISTS dim_pet_category CASCADE;
CREATE TABLE dim_pet_category (
    pet_category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL
);

\echo 'Общие измерения созданы (dim_country, dim_city, dim_product_category, dim_pet_category)'
