-- ==========================================================
-- KPI 01: Total Customers
-- Business Question:
-- How many unique customers have placed orders?
-- ==========================================================

SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM dim_customer;

-- ==========================================================
-- KPI 02: Customers by Region
-- ==========================================================

SELECT c.customer_region,
COUNT(DISTINCT c.customer_id) AS customers
FROM dim_customer c
GROUP BY c.customer_region
ORDER BY customers DESC;

-- ==========================================================
-- KPI 03: Revenue by Customer Region
-- ==========================================================

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

-- ==========================================================
-- KPI 04: Top Customers by Revenue
-- ==========================================================

SELECT c.customer_unique_id,
c.city,
c.state,
ROUND(SUM(f.revenue),2) AS revenue
FROM fact_sales f
JOIN dim_customer c
ON f.customer_id=c.customer_id
GROUP BY c.customer_unique_id,c.city,c.state
ORDER BY revenue DESC
LIMIT 10;

-- ==========================================================
-- KPI 05: Average Revenue per Customer
-- ==========================================================

SELECT
ROUND(
SUM(f.revenue)/
COUNT(DISTINCT c.customer_unique_id),
2
) AS avg_customer_value
FROM fact_sales f
JOIN dim_customer c
ON f.customer_id=c.customer_id;

-- ==========================================================
-- KPI 06: Repeat Customers
-- ==========================================================

SELECT
c.customer_unique_id,
COUNT(DISTINCT f.order_id) AS total_orders,
ROUND(SUM(f.revenue),2) AS lifetime_revenue
FROM fact_sales f
JOIN dim_customer c
ON f.customer_id = c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT f.order_id) > 1
ORDER BY total_orders DESC,lifetime_revenue DESC;


-- ==========================================================
-- KPI 07: Customer Lifetime Value

SELECT
c.customer_unique_id,
ROUND(SUM(f.revenue),2) AS customer_lifetime_value
FROM fact_sales f
JOIN dim_customer c
ON f.customer_id=c.customer_id
GROUP BY c.customer_unique_id
ORDER BY customer_lifetime_value DESC
LIMIT 20;

-- ==========================================================
-- KPI 08: Revenue by State
-- ==========================================================

SELECT c.state,
    ROUND(
        SUM(f.revenue),
        2
    ) AS revenue
FROM fact_sales f
JOIN dim_customer c
ON f.customer_id = c.customer_id
GROUP BY c.state
ORDER BY revenue DESC;

-- ==========================================================
-- KPI 09: Top Cities by Revenue
-- ==========================================================

SELECT c.city,
ROUND(
        SUM(f.revenue),
        2
    ) AS revenue
FROM fact_sales f
JOIN dim_customer c
ON f.customer_id = c.customer_id
GROUP BY c.city
ORDER BY revenue DESC
LIMIT 15;

-- ==========================================================
-- KPI 10: Customer Revenue Ranking
-- ==========================================================

SELECT
c.customer_unique_id,
ROUND(SUM(f.revenue),2) AS revenue,
RANK() OVER(ORDER BY SUM(f.revenue) DESC) AS revenue_rank
FROM fact_sales f
JOIN dim_customer c
ON f.customer_id=c.customer_id
GROUP BY c.customer_unique_id
ORDER BY revenue_rank
LIMIT 20;