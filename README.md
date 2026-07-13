# 📦 RetailX: Omni-Channel Supply Chain & Sales Analytics Platform

An end-to-end Retail Analytics project that simulates how modern e-commerce organizations build a centralized data warehouse, automate ETL pipelines, perform business analytics using SQL, and create executive dashboards with Power BI for strategic decision-making.

The project follows an industry-standard analytics workflow beginning with raw transactional data and ending with interactive business intelligence dashboards.

---

# Project Objectives

Retail businesses generate massive volumes of transactional data every day.

However, raw operational data is often:

- distributed across multiple systems
- difficult to analyze
- unsuitable for reporting

The objective of this project is to build a complete analytics platform capable of:

- Designing a dimensional data warehouse
- Building automated ETL pipelines
- Running business analytics using SQL
- Creating executive dashboards in Power BI
- Delivering actionable insights for supply chain and sales optimization

---

# Business Problems Solved

This project answers important business questions such as:

### Executive Analytics

- How much revenue has the business generated?
- Which product categories contribute the most revenue?
- Which regions generate maximum sales?
- What is the average order value?
- What is the overall gross profit?

---

### Customer Analytics

- Who are the highest-value customers?
- How many repeat customers does the business have?
- Which regions contain the most valuable customers?
- What are customer purchasing patterns over time?

---

### Supply Chain Analytics

- Which warehouses generate maximum revenue?
- What is warehouse utilization?
- Which warehouse incurs maximum inventory cost?
- How does freight cost change over time?
- Which suppliers contribute the highest revenue?

---

# Tech Stack

| Category | Technology |
|-----------|------------|
| Language | Python |
| Database | PostgreSQL |
| Data Processing | Pandas, NumPy |
| SQL | PostgreSQL SQL |
| Dashboard | Microsoft Power BI |
| Version Control | Git & GitHub |

---

# Project Architecture

```
                    Raw Olist Dataset
                           │
                           ▼
               Python ETL Pipeline
        (Extract → Transform → Validate)
                           │
                           ▼
               Processed CSV Warehouse
                           │
                           ▼
                PostgreSQL Data Warehouse
                           │
             Advanced SQL Business Queries
                           │
                           ▼
              Power BI Executive Dashboard
                           │
                           ▼
                  Business Decision Making
```

---

# Data Warehouse Design

The warehouse follows a **Star Schema** architecture.

### Dimension Tables

- Dim Customer
- Dim Product
- Dim Warehouse
- Dim Date

### Fact Table

- Fact Sales


---

# ETL Pipeline

The ETL pipeline was implemented completely in Python.

### Extract

Raw CSV files are loaded from the Olist dataset.

### Transform

Data cleaning and transformation include:

- Missing value handling
- Data type conversion
- Date normalization
- Product category translation
- Revenue calculation
- Freight cost calculation
- Warehouse mapping
- Customer region mapping
- Date dimension generation

### Validate

A custom validation framework checks:

- Duplicate primary keys
- Null values
- Invalid dates
- Missing foreign keys
- Invalid warehouse mappings

### Load

Validated warehouse tables are automatically loaded into PostgreSQL using SQLAlchemy.

---

# Dataset

Dataset used:

**Brazilian E-Commerce Public Dataset by Olist**

Contains information about:

- Customers
- Products
- Orders
- Sellers
- Payments
- Reviews
- Geolocation

The project transforms operational data into an analytics-ready warehouse.

---

# SQL Analytics

The project contains multiple SQL analysis scripts covering different business domains.

## Sales Performance

- Total Revenue
- Total Orders
- Average Order Value
- Revenue by Category
- Revenue by Region
- Top Selling Products

---

## Customer Analytics

- Repeat Customers
- Customer Lifetime Revenue
- Top Customers
- Average Revenue per Customer
- Regional Customer Distribution

---

## Product Analytics

- Product Category Performance
- Product Revenue Ranking
- Product Contribution

---

## Warehouse Analytics

- Warehouse Revenue
- Freight Cost Analysis
- Warehouse Utilization
- Inventory Cost Analysis

---

## Time Series Analytics

- Monthly Revenue
- Revenue Growth
- Monthly Order Trend
- Seasonal Analysis

---

# Power BI Dashboard

The dashboard consists of **three interactive pages**.

---

# Dashboard Features

✔ Dynamic Slicers

- Year
- Month
- Region
- Category

✔ Cross-filtering

✔ KPI Cards

✔ Interactive Visualizations

---

# DAX Measures

Examples include:

- Total Revenue
- Total Orders
- Total Customers
- Gross Margin %
- Gross Profit
- Average Order Value
- Average Freight
- Repeat Customers
- New Customers
- Warehouse Utilization %
- Inventory Cost
- Revenue per Customer

---


# Challenges Faced

During development several real-world data engineering challenges were encountered.

### Customer Identity

The Olist dataset assigns a different customer_id for each order.

This made repeat customer calculation incorrect.

Solution:

- Used customer_unique_id for customer analytics
- Preserved customer_id in the warehouse for relational integrity
- Modified SQL logic accordingly

---

### Warehouse Mapping

The original dataset does not contain warehouse information.

Solution:

Seller locations were transformed into warehouse entities using business rules to simulate warehouse operations.

---

### Product Pricing

The products dataset does not contain selling prices.

Solution:

Selling prices were derived from order item transactions.

---

### Inventory Simulation

Inventory quantities are unavailable in the original dataset.

Solution:

Synthetic warehouse capacities and inventory costs were generated using realistic assumptions.

---

### Dashboard Design

Designing a compact executive dashboard while maintaining readability required multiple layout iterations and visual optimization.

---

# Future Improvements

Possible future enhancements include:

- Incremental ETL pipeline
- Apache Airflow scheduling
- Docker containerization
- Azure Data Factory integration
- Snowflake data warehouse
- dbt transformations
- Forecasting using Prophet/XGBoost
- Weather API integration
- Demand forecasting
- Supplier risk scoring
- Inventory optimization
- Real-time streaming using Kafka
- CI/CD pipeline using GitHub Actions

---

# Folder Structure

```
RetailX/
│
├── dashboard/
│      RetailX Dashboard.pbix
│
├── data/
│      raw/
│      processed/
│
├── docs/
│
├── notebooks/
│
├── reports/
│
├── scripts/
│      database/
│      etl/
│      validation/
│
├── sql/
│
├── requirements.txt
│
└── README.md
```


---

# Screenshots

## Executive Dashboard

<img width="460" height="260" alt="image" src="https://github.com/user-attachments/assets/d552ef00-061d-4df5-a880-dfca393189bc" />

---

## Customer Analytics Dashboard

<img width="460" height="256" alt="image" src="https://github.com/user-attachments/assets/bca903bb-1ce7-4b3d-ab11-c80c30bd626c" />

---

## Supply Chain Dashboard

<img width="460" height="260" alt="image" src="https://github.com/user-attachments/assets/14fd168f-479c-4243-acca-c892c2718580" />

---

# Author

**Noyonika Mukherjee**

B.Tech Computer Science & Engineering

National Institute of Technology Agartala

GitHub: https://github.com/Noyonika16

---

# License

This project is licensed under the MIT License.
