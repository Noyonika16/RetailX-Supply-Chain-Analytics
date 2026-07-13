--KPI 1: Total Warehouses
SELECT COUNT(*) AS total_warehouses
FROM dim_warehouse;

--KPI 2: Revenue by Warehouse
SELECT w.warehouse_id,w.city,w.state,
ROUND(SUM(f.revenue),2) AS revenue
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
GROUP BY w.warehouse_id,w.city,w.state
ORDER BY revenue DESC;

--KPI 3: Warehouse Revenue Ranking
SELECT warehouse_id,city,state,revenue,
RANK() OVER(ORDER BY revenue DESC) AS warehouse_rank
FROM(
SELECT w.warehouse_id,w.city,w.state,
SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
GROUP BY w.warehouse_id,w.city,w.state
)t
ORDER BY warehouse_rank;


--KPI 4: Revenue by Warehouse Region
SELECT warehouse_region,
ROUND(SUM(f.revenue),2) AS revenue
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
GROUP BY warehouse_region
ORDER BY revenue DESC;

--KPI 5: Orders Processed per Warehouse
SELECT w.warehouse_id,
COUNT(DISTINCT f.order_id) AS total_orders
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
GROUP BY w.warehouse_id
ORDER BY total_orders DESC;

--KPI 6: Average Order Value by Warehouse
SELECT w.warehouse_id,
ROUND(SUM(f.revenue)/COUNT(DISTINCT f.order_id),2) 
AS avg_order_value
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
GROUP BY w.warehouse_id
ORDER BY avg_order_value DESC;

--KPI 7: Freight Cost Percentage
SELECT w.warehouse_id,
ROUND(SUM(f.freight_cost),2) AS freight_cost,
ROUND(SUM(f.revenue),2) AS revenue,
ROUND(100*SUM(f.freight_cost)/SUM(f.revenue),2)
AS freight_percentage
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
GROUP BY w.warehouse_id
ORDER BY freight_percentage DESC;

--KPI 8: Warehouse Revenue Contribution
SELECT warehouse_id, ROUND(revenue,2) AS revenue,
ROUND(100*revenue/SUM(revenue) OVER(),2) 
AS contribution_percent
FROM(
SELECT
w.warehouse_id, SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
GROUP BY w.warehouse_id
)t
ORDER BY contribution_percent DESC;

--KPI 9: Warehouse Performance Segment
WITH warehouse_sales AS(
SELECT
w.warehouse_id,SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
GROUP BY w.warehouse_id
)
SELECT warehouse_id,ROUND(revenue,2) AS revenue,
CASE
WHEN quartile=1 THEN 'High'
WHEN quartile IN(2,3) THEN 'Medium'
ELSE 'Low'
END AS performance_segment
FROM(
SELECT *,
NTILE(4) OVER(ORDER BY revenue DESC) AS quartile
FROM warehouse_sales
)t
ORDER BY revenue DESC;

--KPI 10: Monthly Warehouse Revenue Trend
SELECT w.warehouse_id,d.year,d.month,
ROUND(SUM(f.revenue),2) AS monthly_revenue
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY w.warehouse_id,d.year,d.month
ORDER BY w.warehouse_id,d.year,d.month;


--KPI 11: Running Warehouse Revenue
SELECT warehouse_id,year,month,monthly_revenue,
ROUND(SUM(monthly_revenue) OVER(PARTITION BY warehouse_id
ORDER BY year,month),2) AS cumulative_revenue
FROM(
SELECT w.warehouse_id,d.year,d.month,
SUM(f.revenue) AS monthly_revenue
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY w.warehouse_id,d.year,d.month
)t
ORDER BY warehouse_id,year,month;


--KPI 12: Warehouse Capacity Utilization (Simulated)
SELECT w.warehouse_id,w.warehouse_capacity,
SUM(f.quantity) AS units_processed,
ROUND(100.0*SUM(f.quantity)/w.warehouse_capacity,2) 
AS utilization_percent
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
GROUP BY w.warehouse_id,w.warehouse_capacity
ORDER BY utilization_percent DESC;

--KPI 13: Units shipped
SELECT
    warehouse_id,
    SUM(quantity) AS units_shipped
FROM fact_sales
GROUP BY warehouse_id
ORDER BY units_shipped DESC;

--KPI 14:Revenue per Capacity Unit
SELECT warehouse_id, ROUND(SUM(revenue)
/warehouse_capacity,2) AS revenue_per_capacity
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
GROUP BY warehouse_id, warehouse_capacity
ORDER BY revenue_per_capacity DESC;

--KPI 15: Warehouse Type Performance
SELECT warehouse_type,
COUNT(DISTINCT warehouse_id) AS warehouses,
ROUND(SUM(revenue),2) AS revenue
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
GROUP BY warehouse_type
ORDER BY revenue DESC;

--KPI 16: Storage Cost Estimate
SELECT warehouse_id,storage_cost_per_unit,SUM(quantity) AS units,
ROUND(SUM(quantity)*storage_cost_per_unit,2)
AS estimated_storage_cost
FROM fact_sales f
JOIN dim_warehouse w
ON f.warehouse_id=w.warehouse_id
GROUP BY warehouse_id, storage_cost_per_unit
ORDER BY estimated_storage_cost DESC;

--KPI 17: Warehouse Efficiency Score
SELECT warehouse_id,
ROUND(SUM(revenue)/SUM(quantity),2) AS revenue_per_unit
FROM fact_sales
GROUP BY warehouse_id
ORDER BY revenue_per_unit DESC;