--KPI 01: Total Products Sold
SELECT COUNT(DISTINCT product_id) AS total_products_sold
FROM fact_sales;

--KPI 02: Revenue by Product Category
SELECT p.category,
ROUND(SUM(f.revenue),2) AS revenue
FROM fact_sales f
JOIN dim_products p
ON f.product_id=p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

--KPI 03: Top 15 Products by Revenue
SELECT p.sku,
p.category,
ROUND(SUM(f.revenue),2) AS revenue
FROM fact_sales f
JOIN dim_products p
ON f.product_id=p.product_id
GROUP BY p.sku,p.category
ORDER BY revenue DESC
LIMIT 15;

--KPI 04: Top Products by Quantity Sold
SELECT p.product_id,
p.sku,
SUM(f.quantity) AS units_sold
FROM fact_sales f
JOIN dim_products p
ON f.product_id=p.product_id
GROUP BY p.product_id,p.sku
ORDER BY units_sold DESC
LIMIT 15;

--KPI 05: Average Selling Price by Category
SELECT category,
ROUND(AVG(selling_price),2) AS avg_price
FROM dim_products
GROUP BY category
ORDER BY avg_price DESC;

--KPI 06: Product Revenue Ranking
WITH product_sales AS(
SELECT p.product_id,
p.sku,
p.category,
SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_products p
ON f.product_id=p.product_id
GROUP BY p.product_id,p.sku,p.category
)
SELECT sku,
category,
ROUND(revenue,2) AS revenue,
DENSE_RANK() OVER(ORDER BY revenue DESC) AS revenue_rank
FROM product_sales
ORDER BY revenue_rank
LIMIT 20;

--KPI 07: Category Contribution (%)
SELECT p.category,
ROUND(SUM(f.revenue),2) AS revenue,
ROUND(100.0*SUM(f.revenue)/SUM(SUM(f.revenue)) OVER(),2) 
AS revenue_percentage
FROM fact_sales f
JOIN dim_products p
ON f.product_id=p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

--KPI 08: Running Revenue by Month
SELECT d.year,
d.month,
ROUND(SUM(f.revenue),2) AS monthly_revenue,
ROUND(SUM(SUM(f.revenue)) 
OVER(ORDER BY d.year,d.month),2) AS cumulative_revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.year,d.month
ORDER BY d.year,d.month;

--KPI 09: Pareto Product Analysis
WITH product_sales AS(
SELECT p.sku,
SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_products p
ON f.product_id=p.product_id
GROUP BY p.sku
)
SELECT sku,
ROUND(revenue,2) AS revenue,
ROUND(SUM(revenue) OVER(ORDER BY revenue DESC,sku),2) 
AS cumulative_revenue
FROM product_sales
ORDER BY revenue DESC;

--KPI 10: Product Performance Segment
WITH product_sales AS(
SELECT p.sku,
SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_products p
ON f.product_id=p.product_id
GROUP BY p.sku
)
SELECT sku,
ROUND(revenue,2) AS revenue,
CASE
WHEN quartile=1 THEN 'High'
WHEN quartile IN(2,3) THEN 'Medium'
ELSE 'Low'
END AS performance_segment
FROM(
SELECT *,
NTILE(4) OVER(ORDER BY revenue DESC) AS quartile
FROM product_sales
)t
ORDER BY revenue DESC;


--KPI 11: Most Expensive Categories
SELECT category,
MAX(selling_price) AS highest_price,
MIN(selling_price) AS lowest_price,
ROUND(AVG(selling_price),2) AS average_price
FROM dim_products
GROUP BY category
ORDER BY highest_price DESC;

--KPI 12: Highest Freight Cost Products
SELECT p.sku,
p.category,
ROUND(SUM(f.freight_cost),2) AS freight_cost
FROM fact_sales f
JOIN dim_products p
ON f.product_id=p.product_id
GROUP BY p.sku,p.category
ORDER BY freight_cost DESC
LIMIT 20;