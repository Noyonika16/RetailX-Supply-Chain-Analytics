"""
Validation rules for all RetailX warehouse tables.
"""

# ==========================================================
# dim_products
# ==========================================================

DIM_PRODUCTS_RULES = {

    "table_name": "dim_products",

    "primary_key": "product_id",

    "not_null": [
        "product_id",
        "sku",
        "category"
    ],

    "non_negative": [
        "weight_g",
        "length_cm",
        "height_cm",
        "width_cm",
        "unit_cost",
        "selling_price"
    ],

    "allowed_values": {}
}


# ==========================================================
# dim_customer
# ==========================================================

DIM_CUSTOMER_RULES = {

    "table_name": "dim_customer",

    "primary_key": "customer_id",

    "not_null": [
        "customer_id",
        "customer_unique_id",
        "city",
        "state",
        "customer_region"
    ],

    "non_negative": [
        "zip_code_prefix"
    ],

    "allowed_values": {

        "customer_region": [

            "North",

            "Northeast",

            "Central-West",

            "Southeast",

            "South",

            "Unknown"

        ]

    }

}


# ==========================================================
# dim_warehouse
# ==========================================================

DIM_WAREHOUSE_RULES = {

    "table_name": "dim_warehouse",

    "primary_key": "warehouse_id",

    "not_null": [

        "warehouse_id",

        "seller_id",

        "city",

        "state",

        "warehouse_region",

        "warehouse_type"

    ],

    "non_negative": [

        "warehouse_capacity",

        "storage_cost_per_unit"

    ],

    "allowed_values": {

        "warehouse_type": [

            "Mega",

            "Regional",

            "Local"

        ],

        "warehouse_region": [

            "North",

            "Northeast",

            "Central-West",

            "Southeast",

            "South",

            "Unknown"

        ]

    }

}


# ==========================================================
# dim_date
# ==========================================================

DIM_DATE_RULES = {

    "table_name": "dim_date",

    "primary_key": "date_id",

    "not_null": [

        "date_id",

        "year",

        "quarter",

        "month",

        "month_name",

        "week",

        "day",

        "weekday",

        "is_weekend"

    ],

    "non_negative": [

        "year",

        "quarter",

        "month",

        "week",

        "day"

    ],

    "allowed_values": {

        "quarter": [

            1,

            2,

            3,

            4

        ],

        "is_weekend": [

            True,

            False

        ]

    }

}


# ==========================================================
# fact_sales
# ==========================================================

FACT_SALES_RULES = {

    "table_name": "fact_sales",

    "primary_key": "sale_id",

    "not_null": [

        "sale_id",

        "order_id",

        "product_id",

        "customer_id",

        "warehouse_id",

        "date_id"

    ],

    "non_negative": [

        "quantity",

        "sales_price",

        "freight_cost",

        "revenue"

    ],

    "allowed_values": {}

}


# ==========================================================
# Master Dictionary
# ==========================================================

TABLE_RULES = {

    "dim_products": DIM_PRODUCTS_RULES,

    "dim_customer": DIM_CUSTOMER_RULES,

    "dim_warehouse": DIM_WAREHOUSE_RULES,

    "dim_date": DIM_DATE_RULES,

    "fact_sales": FACT_SALES_RULES

}