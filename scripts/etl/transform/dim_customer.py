import pandas as pd
from pathlib import Path

from scripts.etl.utils import (
    validate_primary_key,
    save_csv,
    dataframe_summary,
    log_step,
)

from scripts.etl.config import REGION_MAP

ROOT = Path(__file__).resolve().parents[3]

RAW = ROOT / "data" / "raw" / "olist"
PROCESSED = ROOT / "data" / "processed"


def main():

    log_step("Building dim_customer")

    customers = pd.read_csv(
        RAW / "olist_customers_dataset.csv"
    )

    customers = customers.rename(
        columns={
            "customer_zip_code_prefix": "zip_code_prefix",
            "customer_city": "city",
            "customer_state": "state"
        }
    )

    customers["customer_region"] = (
        customers["state"]
        .map(REGION_MAP)
        .fillna("Unknown")
    )

    dim_customer = customers[
        [
            "customer_id",
            "customer_unique_id",
            "zip_code_prefix",
            "city",
            "state",
            "customer_region"
        ]
    ].copy()

    dataframe_summary(dim_customer)

    validate_primary_key(
        dim_customer,
        "customer_id"
    )

    save_csv(
        dim_customer,
        PROCESSED / "dim_customer.csv"
    )

    log_step("dim_customer completed successfully")


if __name__ == "__main__":
    main()