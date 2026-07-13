--KPI 1: Executive Summary
SELECT
ROUND(SUM(revenue),2) AS total_revenue,
COUNT(DISTINCT order_id) AS total_orders,
COUNT(DISTINCT customer_id) AS total_customers,
SUM(quantity) AS units_sold
FROM fact_sales;


--KPI 2: Estimated Gross Profit
SELECT
ROUND(SUM(f.revenue-(p.unit_cost*f.quantity)),2) 
AS estimated_gross_profit
FROM fact_sales f
JOIN dim_products p
ON f.product_id=p.product_id;

--KPI 3: Gross Margin %
SELECT
ROUND(100.0*SUM(f.revenue-(p.unit_cost*f.quantity))/SUM(f.revenue),2) 
AS gross_margin_percent
FROM fact_sales f
JOIN dim_products p
ON f.product_id=p.product_id;

--KPI 4: Average Freight Cost per Order
SELECT ROUND(SUM(freight_cost)/COUNT(DISTINCT order_id),2) 
AS avg_freight_per_order
FROM fact_sales;

--KPI 5: Freight as % of Revenue
SELECT ROUND(100.0*SUM(freight_cost)/SUM(revenue),2) 
AS freight_percentage
FROM fact_sales;


--KPI 6: Revenue per Customer
SELECT ROUND(SUM(revenue)/COUNT(DISTINCT customer_id),2) 
AS revenue_per_customer
FROM fact_sales;

--KPI 7: Revenue per Warehouse
SELECT ROUND(SUM(revenue)/COUNT(DISTINCT warehouse_id),2) 
AS revenue_per_warehouse
FROM fact_sales;

--KPI 8: Average Selling Price
SELECT
ROUND(AVG(sales_price),2) AS average_selling_price
FROM fact_sales;

--KPI 9: Most Profitable Category
SELECT p.category,
ROUND(SUM(f.revenue-(p.unit_cost*f.quantity)),2) AS profit
FROM fact_sales f
JOIN dim_products p
ON f.product_id=p.product_id
GROUP BY p.category
ORDER BY profit DESC;

--KPI 10: Profit by Warehouse
SELECT w.warehouse_id,w.city,
ROUND(SUM(f.revenue-(p.unit_cost*f.quantity)),2) AS profit
FROM fact_sales f
JOIN dim_products p
ON f.product_id=p.product_id
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
GROUP BY w.warehouse_id,w.city
ORDER BY profit DESC;

--KPI 11: Highest Margin Products
SELECT p.sku,
ROUND(SUM(f.revenue-(p.unit_cost*f.quantity)),2) AS profit
FROM fact_sales f
JOIN dim_products p
ON f.product_id=p.product_id
GROUP BY p.sku
ORDER BY profit DESC
LIMIT 20;

--KPI 12: Executive KPI Summary (Single Query)
SELECT
ROUND(SUM(f.revenue),2) AS revenue,
COUNT(DISTINCT f.order_id) AS orders,
COUNT(DISTINCT f.customer_id) AS customers,
SUM(quantity) AS units,
ROUND(SUM(f.revenue-(p.unit_cost*f.quantity)),2) AS gross_profit,
ROUND(100.0*SUM(f.revenue-(p.unit_cost*f.quantity))
/SUM(f.revenue),2) AS gross_margin_percent,
ROUND(SUM(f.freight_cost)/COUNT(DISTINCT f.order_id),2) AS avg_freight_per_order
FROM fact_sales f
JOIN dim_products p
ON f.product_id=p.product_id;