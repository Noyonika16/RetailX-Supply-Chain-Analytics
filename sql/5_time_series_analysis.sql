--KPI 1: Monthly Revenue Trend
SELECT d.year,d.month,d.month_name,
ROUND(SUM(f.revenue),2) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.year,d.month,d.month_name
ORDER BY d.year,d.month;


--KPI 2: Month-over-Month (MoM) Revenue Growth
WITH monthly_sales AS(
SELECT d.year,d.month,
SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.year,d.month
)
SELECT year,month,ROUND(revenue,2) AS revenue,
ROUND(LAG(revenue) OVER(ORDER BY year,month),2) AS previous_month,
ROUND(
    100.0*(revenue-LAG(revenue) 
    OVER(ORDER BY year,month))/NULLIF(LAG(revenue) OVER(ORDER BY year,month),0),2) AS mom_growth_percent
FROM monthly_sales
ORDER BY year,month;


--KPI 3: Running Revenue
SELECT d.year,d.month,
ROUND(SUM(f.revenue),2) AS monthly_revenue,
ROUND(SUM(SUM(f.revenue))OVER(ORDER BY d.year,d.month),2) 
AS cumulative_revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.year,d.month
ORDER BY d.year,d.month;


--KPI 4: 3-Month Moving Average
WITH monthly_sales AS(
SELECT d.year,d.month,SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.year,d.month
)
SELECT year, month,ROUND(revenue,2) AS revenue,
ROUND(AVG(revenue)OVER(ORDER BY year,month
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS moving_average_3m
FROM monthly_sales
ORDER BY year,month;


--KPI 5: Best Revenue Month
SELECT d.year,d.month,d.month_name,
ROUND(SUM(f.revenue),2) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.year,d.month,d.month_name
ORDER BY revenue DESC
LIMIT 1;


--KPI 6: Worst Revenue Month
SELECT d.year,d.month,d.month_name,
ROUND(SUM(f.revenue),2) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.year,d.month,d.month_name
ORDER BY revenue
LIMIT 1;


--KPI 7: Revenue by Quarter
SELECT year,quarter,
ROUND(SUM(f.revenue),2) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY year,quarter
ORDER BY year,quarter;


--KPI 8: Weekend vs Weekday Sales
SELECT
CASE
WHEN d.is_weekend THEN 'Weekend'
ELSE 'Weekday'
END AS day_type,
ROUND(SUM(f.revenue),2) AS revenue,
COUNT(DISTINCT f.order_id) AS orders
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY day_type;


--KPI 9: Monthly Revenue Ranking
WITH monthly_sales AS(
SELECT d.year,d.month,SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.year,d.month
)
SELECT year,month,ROUND(revenue,2) AS revenue,
DENSE_RANK() OVER(
ORDER BY revenue DESC) AS revenue_rank
FROM monthly_sales
ORDER BY revenue_rank;


--KPI 10: Revenue Contribution by Month
WITH monthly_sales AS(
SELECT d.year,d.month,SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.year, d.month
)
SELECT year, month,ROUND(revenue,2) AS revenue,
ROUND(100*revenue/SUM(revenue) OVER(),2) AS contribution_percent
FROM monthly_sales
ORDER BY year,month;

--KPI 11: Revenue Volatility
WITH monthly_sales AS(
SELECT d.year,d.month,SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.year,d.month
)
SELECT
ROUND(AVG(revenue),2) AS average_monthly_revenue,
ROUND(STDDEV(revenue),2) AS revenue_std_dev,
ROUND(VARIANCE(revenue),2) AS revenue_variance
FROM monthly_sales;


--KPI 12: Peak Sales Day of Week
SELECT d.weekday,ROUND(SUM(f.revenue),2) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.weekday
ORDER BY
CASE d.weekday
WHEN 'Monday' THEN 1
WHEN 'Tuesday' THEN 2
WHEN 'Wednesday' THEN 3
WHEN 'Thursday' THEN 4
WHEN 'Friday' THEN 5
WHEN 'Saturday' THEN 6
WHEN 'Sunday' THEN 7
END;

--KPI 13: Quarter-over-Quarter (QoQ) Revenue Growth
WITH quarterly_sales AS(
SELECT d.year,d.quarter,
SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.year,d.quarter
)
SELECT year,quarter,ROUND(revenue,2) AS revenue,
ROUND(LAG(revenue) OVER(ORDER BY year,quarter),2) AS previous_quarter,
ROUND(100.0*(revenue-LAG(revenue) OVER(ORDER BY year,quarter))
/NULLIF(LAG(revenue) OVER(ORDER BY year,quarter),0),2) 
AS qoq_growth_percent
FROM quarterly_sales
ORDER BY year,quarter;


--KPI 14: Year-over-Year (YoY) Revenue Growth
WITH yearly_sales AS(
SELECT d.year,SUM(f.revenue) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.year)
SELECT year, ROUND(revenue,2) AS revenue,
ROUND(LAG(revenue) OVER(ORDER BY year),2) AS previous_year,
ROUND(100.0*(revenue-LAG(revenue) OVER(ORDER BY year))
/NULLIF(LAG(revenue) OVER(ORDER BY year),0),2) 
AS yoy_growth_percent
FROM yearly_sales
ORDER BY year;


--KPI 15: Holiday vs Non-Holiday Sales 
SELECT
CASE
WHEN d.is_holiday THEN 'Holiday'
ELSE 'Non-Holiday'
END AS day_type,
COUNT(DISTINCT f.order_id) AS orders,
ROUND(SUM(f.revenue),2) AS revenue,
ROUND(AVG(f.revenue),2) AS avg_revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY day_type;

--KPI 16: Revenue by Holiday
SELECT holiday_name,
COUNT(DISTINCT f.order_id) AS orders,
ROUND(SUM(f.revenue),2) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
WHERE is_holiday=TRUE
GROUP BY holiday_name
ORDER BY revenue DESC;

--KPI 17: Best Quarter
SELECT d.year,d.quarter,
ROUND(SUM(f.revenue),2) AS revenue
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.year,d.quarter
ORDER BY revenue DESC
LIMIT 1;

--KPI 18: Revenue Heatmap Dataset
SELECT d.month_name,d.weekday,ROUND(SUM(f.revenue),2) AS revenue,
COUNT(DISTINCT f.order_id) AS orders
FROM fact_sales f
JOIN dim_date d
ON f.date_id=d.date_id
GROUP BY d.month,d.month_name,d.weekday
ORDER BY d.month,
CASE d.weekday
WHEN 'Monday' THEN 1
WHEN 'Tuesday' THEN 2
WHEN 'Wednesday' THEN 3
WHEN 'Thursday' THEN 4
WHEN 'Friday' THEN 5
WHEN 'Saturday' THEN 6
WHEN 'Sunday' THEN 7
END;