import pandas as pd
from pathlib import Path
import holidays

from scripts.etl.utils import (
    validate_primary_key,
    save_csv,
    dataframe_summary,
    log_step,
)

ROOT = Path(__file__).resolve().parents[3]

RAW = ROOT / "data" / "raw" / "olist"
PROCESSED = ROOT / "data" / "processed"


def main():

    log_step("Building dim_date")

    orders = pd.read_csv(
        RAW / "olist_orders_dataset.csv"
    )

    orders["order_purchase_timestamp"] = pd.to_datetime(
        orders["order_purchase_timestamp"]
    )

    dates = (
        pd.DataFrame({
            "date_id":
            orders["order_purchase_timestamp"].dt.date.unique()
        })
        .sort_values("date_id")
        .reset_index(drop=True)
    )

    dates["date_id"] = pd.to_datetime(
        dates["date_id"]
    )

    dates["year"] = dates["date_id"].dt.year

    dates["quarter"] = dates["date_id"].dt.quarter

    dates["month"] = dates["date_id"].dt.month

    dates["month_name"] = (
        dates["date_id"]
        .dt.month_name()
    )

    dates["week"] = (
        dates["date_id"]
        .dt.isocalendar()
        .week
        .astype(int)
    )

    dates["day"] = dates["date_id"].dt.day

    dates["weekday"] = (
        dates["date_id"]
        .dt.day_name()
    )

    dates["is_weekend"] = (
        dates["date_id"]
        .dt.weekday >= 5
    )

    # ------------------------
    # Brazilian Holidays
    # ------------------------

    br_holidays = holidays.country_holidays("BR")

    dates["holiday_name"] = dates["date_id"].apply(
    lambda x: br_holidays.get(x)
    )

    dates["is_holiday"] = dates["holiday_name"].notna()

    dataframe_summary(dates)

    validate_primary_key(
        dates,
        "date_id"
    )

    save_csv(
        dates,
        PROCESSED / "dim_date.csv"
    )
    
    log_step(
        "dim_date completed successfully"
    )


if __name__ == "__main__":
    main()