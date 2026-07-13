import pandas as pd
from pathlib import Path

from scripts.etl.utils import (
    dataframe_summary,
    save_csv,
    log_step,
)

ROOT = Path(__file__).resolve().parents[3]

RAW = ROOT / "data" / "raw" / "olist"
PROCESSED = ROOT / "data" / "processed"


def main():

    log_step("Building fact_sales")

    orders = pd.read_csv(
        RAW / "olist_orders_dataset.csv"
    )

    order_items = pd.read_csv(
        RAW / "olist_order_items_dataset.csv"
    )
    orders["order_purchase_timestamp"] = pd.to_datetime(
    orders["order_purchase_timestamp"]
    )
    orders = orders[
        [
            "order_id",
            "customer_id",
            "order_purchase_timestamp"
        ]
    ]

    order_items = order_items[
        [
            "order_id",
            "product_id",
            "seller_id",
            "price",
            "freight_value"
        ]
    ]

    fact_sales = order_items.merge(
        orders,
        on="order_id",
        how="left"
    )

    fact_sales = fact_sales.rename(
        columns={
            "seller_id": "warehouse_id",
            "price": "sales_price",
            "freight_value": "freight_cost"
        }
    )

    fact_sales["date_id"] = (
        fact_sales["order_purchase_timestamp"]
        .dt.date
    )

    fact_sales["quantity"] = 1

    fact_sales["revenue"] = fact_sales["sales_price"]

    fact_sales.insert(
        0,
        "sale_id",
        range(1, len(fact_sales) + 1)
    )

    fact_sales = fact_sales[
        [
            "sale_id",
            "order_id",
            "product_id",
            "customer_id",
            "warehouse_id",
            "date_id",
            "quantity",
            "sales_price",
            "freight_cost",
            "revenue"
        ]
    ]

    dataframe_summary(fact_sales)

    save_csv(
        fact_sales,
        PROCESSED / "fact_sales.csv"
    )

    log_step("fact_sales completed successfully")


if __name__ == "__main__":
    main()