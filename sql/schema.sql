-- ==========================================================
-- RetailX Data Warehouse Schema
-- ==========================================================

DROP TABLE IF EXISTS fact_sales CASCADE;
DROP TABLE IF EXISTS dim_products CASCADE;
DROP TABLE IF EXISTS dim_customer CASCADE;
DROP TABLE IF EXISTS dim_warehouse CASCADE;
DROP TABLE IF EXISTS dim_date CASCADE;


-- ==========================================================
-- PRODUCT DIMENSION
-- ==========================================================

CREATE TABLE dim_products (

    product_id VARCHAR(50) PRIMARY KEY,

    sku VARCHAR(50) NOT NULL,

    category VARCHAR(100) NOT NULL,

    weight_g INTEGER,

    length_cm INTEGER,

    height_cm INTEGER,

    width_cm INTEGER,

    unit_cost NUMERIC(10,2) CHECK(unit_cost >= 0),

    selling_price NUMERIC(10,2) CHECK(selling_price >= 0)

);


-- ==========================================================
-- CUSTOMER DIMENSION
-- ==========================================================

CREATE TABLE dim_customer (

    customer_id VARCHAR(50) PRIMARY KEY,

    customer_unique_id VARCHAR(50) NOT NULL,

    zip_code_prefix INTEGER,

    city VARCHAR(100) NOT NULL,

    state VARCHAR(10) NOT NULL,

    customer_region VARCHAR(30) NOT NULL

);


-- ==========================================================
-- WAREHOUSE DIMENSION
-- ==========================================================

CREATE TABLE dim_warehouse (

    warehouse_id VARCHAR(50) PRIMARY KEY,

    seller_id VARCHAR(50) NOT NULL,

    city VARCHAR(100) NOT NULL,

    state VARCHAR(10) NOT NULL,

    warehouse_region VARCHAR(30),

    warehouse_type VARCHAR(20),

    warehouse_capacity INTEGER CHECK(warehouse_capacity >= 0),

    storage_cost_per_unit NUMERIC(8,2)
        CHECK(storage_cost_per_unit >= 0)

);


-- ==========================================================
-- DATE DIMENSION
-- ==========================================================

CREATE TABLE dim_date(

date_id DATE PRIMARY KEY,

year INTEGER,

quarter INTEGER,

month INTEGER,

month_name VARCHAR(20),

week INTEGER,

day INTEGER,

weekday VARCHAR(20),

is_weekend BOOLEAN,

is_holiday BOOLEAN,

holiday_name VARCHAR(100)

);

-- ==========================================================
-- SALES FACT TABLE
-- ==========================================================

CREATE TABLE fact_sales (

    sale_id INTEGER PRIMARY KEY,

    order_id VARCHAR(50) NOT NULL,

    product_id VARCHAR(50) NOT NULL,

    customer_id VARCHAR(50) NOT NULL,

    warehouse_id VARCHAR(50) NOT NULL,

    date_id DATE NOT NULL,

    quantity INTEGER NOT NULL CHECK(quantity > 0),

    sales_price NUMERIC(10,2)
        CHECK(sales_price >= 0),

    freight_cost NUMERIC(10,2)
        CHECK(freight_cost >= 0),

    revenue NUMERIC(10,2)
        CHECK(revenue >= 0),

    CONSTRAINT fk_product
        FOREIGN KEY(product_id)
        REFERENCES dim_products(product_id),

    CONSTRAINT fk_customer
        FOREIGN KEY(customer_id)
        REFERENCES dim_customer(customer_id),

    CONSTRAINT fk_warehouse
        FOREIGN KEY(warehouse_id)
        REFERENCES dim_warehouse(warehouse_id),

    CONSTRAINT fk_date
        FOREIGN KEY(date_id)
        REFERENCES dim_date(date_id)

);