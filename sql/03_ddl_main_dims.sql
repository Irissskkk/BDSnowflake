-- 03_ddl_main_dims.sql
-- Основные измерения с нормализацией

\echo '🚀 Этап 3: Создание основных измерений...'

-- Покупатели
DROP TABLE IF EXISTS bridge_customer_pet CASCADE;
DROP TABLE IF EXISTS dim_pet CASCADE;
DROP TABLE IF EXISTS dim_customer CASCADE;

CREATE TABLE dim_customer (
    customer_id SERIAL PRIMARY KEY,
    source_id INT UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    age INT,
    email VARCHAR(150) UNIQUE,
    postal_code VARCHAR(20),
    country_id INT REFERENCES dim_country(country_id)
);
CREATE INDEX idx_dim_customer_country ON dim_customer(country_id);

-- Питомцы
CREATE TABLE dim_pet (
    pet_id SERIAL PRIMARY KEY,
    pet_type VARCHAR(50),
    pet_name VARCHAR(100),
    breed VARCHAR(100),
    pet_category_id INT REFERENCES dim_pet_category(pet_category_id)
);
CREATE INDEX idx_dim_pet_category ON dim_pet(pet_category_id);

-- Связь клиент-питомец (многие-ко-многим)
CREATE TABLE bridge_customer_pet (
    customer_id INT REFERENCES dim_customer(customer_id) ON DELETE CASCADE,
    pet_id INT REFERENCES dim_pet(pet_id) ON DELETE CASCADE,
    PRIMARY KEY (customer_id, pet_id)
);

-- Продавцы
DROP TABLE IF EXISTS dim_seller CASCADE;
CREATE TABLE dim_seller (
    seller_id SERIAL PRIMARY KEY,
    source_id INT UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    postal_code VARCHAR(20),
    country_id INT REFERENCES dim_country(country_id)
);
CREATE INDEX idx_dim_seller_country ON dim_seller(country_id);

-- Товары
DROP TABLE IF EXISTS dim_product CASCADE;
CREATE TABLE dim_product (
    product_id SERIAL PRIMARY KEY,
    source_id INT UNIQUE NOT NULL,
    product_name VARCHAR(200),
    price DECIMAL(10,2),
    weight DECIMAL(6,2),
    color VARCHAR(50),
    size VARCHAR(20),
    brand VARCHAR(100),
    material VARCHAR(100),
    description TEXT,
    rating DECIMAL(3,2),
    reviews INT,
    release_date DATE,
    expiry_date DATE,
    category_id INT REFERENCES dim_product_category(category_id),
    pet_category_id INT REFERENCES dim_pet_category(pet_category_id)
);
CREATE INDEX idx_dim_product_category ON dim_product(category_id);
CREATE INDEX idx_dim_product_pet_category ON dim_product(pet_category_id);

-- Магазины
DROP TABLE IF EXISTS dim_store CASCADE;
CREATE TABLE dim_store (
    store_id SERIAL PRIMARY KEY,
    source_name VARCHAR(150) UNIQUE NOT NULL,
    location_detail VARCHAR(200),
    phone VARCHAR(30),
    email VARCHAR(150),
    city_id INT REFERENCES dim_city(city_id)
);
CREATE INDEX idx_dim_store_city ON dim_store(city_id);

-- Поставщики
DROP TABLE IF EXISTS dim_supplier CASCADE;
CREATE TABLE dim_supplier (
    supplier_id SERIAL PRIMARY KEY,
    source_name VARCHAR(150) UNIQUE NOT NULL,
    contact_person VARCHAR(150),
    email VARCHAR(150),
    phone VARCHAR(30),
    address TEXT,
    city_id INT REFERENCES dim_city(city_id)
);
CREATE INDEX idx_dim_supplier_city ON dim_supplier(city_id);

\echo '✅ Основные измерения созданы (customer, pet, seller, product, store, supplier)'