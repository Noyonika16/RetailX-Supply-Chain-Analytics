--1. Total revenue
SELECT
    ROUND(SUM(revenue),2) AS total_revenue
FROM fact_sales;

--2.Total Orders
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM fact_sales;

--3. Avg order value (AOV)
SELECT
    ROUND(
        SUM(revenue) /
        COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM fact_sales;

--4. Total Products Sold
SELECT
    SUM(quantity) AS total_units_sold
FROM fact_sales;

--5. Monthly Revenue Trend
SELECT
    d.year,
    d.month,
    d.month_name,
    ROUND(
        SUM(f.revenue),
        2
    ) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id = d.date_id
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;

--6. Monthly orders
SELECT d.year,d.month,
COUNT(DISTINCT f.order_id) AS orders
FROM fact_sales f
JOIN dim_date d
ON f.date_id = d.date_id
GROUP BY d.year,d.month
ORDER BY d.year,d.month;

--7. Revenue by Product Category
SELECT p.category,
    ROUND(
        SUM(f.revenue),
        2
    ) AS revenue
FROM fact_sales f
JOIN dim_products p
ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

--8. Top 10 Products by Revenue
SELECT p.sku, p.category,
    ROUND(
        SUM(f.revenue),
        2
    ) AS revenue
FROM fact_sales f
JOIN dim_products p
ON f.product_id = p.product_id
GROUP BY p.sku,p.category
ORDER BY revenue DESC
LIMIT 10;

--9.Revenue by Warehouse
SELECT w.warehouse_id,w.city,w.state,
ROUND(
        SUM(f.revenue),
        2
    ) AS revenue
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_id,w.city,w.state
ORDER BY revenue DESC;

--10. Revenue by Region
SELECT c.customer_region,
    ROUND(
        SUM(f.revenue),
        2
    ) AS revenue
FROM fact_sales f
JOIN dim_customer c
ON f.customer_id = c.customer_id
GROUP BY c.customer_region
ORDER BY revenue DESC;