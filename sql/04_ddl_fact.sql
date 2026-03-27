-- 04_ddl_fact.sql
-- Таблица фактов продаж

\echo 'Этап 4: Создание таблицы фактов...'

DROP TABLE IF EXISTS fact_sales CASCADE;

CREATE TABLE fact_sales (
    sale_id BIGSERIAL PRIMARY KEY,
    sale_date DATE NOT NULL,
    
    -- Foreign Keys к измерениям
    customer_id INT REFERENCES dim_customer(customer_id),
    seller_id INT REFERENCES dim_seller(seller_id),
    product_id INT REFERENCES dim_product(product_id),
    store_id INT REFERENCES dim_store(store_id),
    supplier_id INT REFERENCES dim_supplier(supplier_id),
    
    -- Метрики
    quantity INT NOT NULL DEFAULT 1,
    total_price DECIMAL(12,2) NOT NULL
);

-- Индексы для аналитики
CREATE INDEX idx_fact_sales_date ON fact_sales(sale_date);
CREATE INDEX idx_fact_sales_customer ON fact_sales(customer_id);
CREATE INDEX idx_fact_sales_product ON fact_sales(product_id);
CREATE INDEX idx_fact_sales_store ON fact_sales(store_id);
CREATE INDEX idx_fact_sales_supplier ON fact_sales(supplier_id);
CREATE INDEX idx_fact_sales_date_product ON fact_sales(sale_date, product_id);

\echo 'Таблица фактов fact_sales создана'