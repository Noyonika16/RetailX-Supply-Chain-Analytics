import pandas as pd
from pathlib import Path

from scripts.etl.utils import (
    validate_primary_key,
    save_csv,
    dataframe_summary,
    log_step,
)
from scripts.etl.config import (
    REGION_MAP,
    MEGA_CITIES,
    REGIONAL_CITIES
    ,WAREHOUSE_CAPACITY
    ,STORAGE_COST)
ROOT = Path(__file__).resolve().parents[3]

RAW = ROOT / "data" / "raw" / "olist"
PROCESSED = ROOT / "data" / "processed"

def warehouse_type(city):
    city = str(city).lower()
    if city in MEGA_CITIES:
        return "Mega"
    elif city in REGIONAL_CITIES:
        return "Regional"
    return "Local"

def main():

    log_step("Building dim_warehouse")

    sellers = pd.read_csv(
        RAW / "olist_sellers_dataset.csv"
    )

    sellers = sellers.rename(
        columns={
            "seller_city":"city",
            "seller_state":"state"
        }
    )

    sellers["warehouse_id"] = sellers["seller_id"]

    sellers["warehouse_region"] = (
        sellers["state"]
        .map(REGION_MAP)
        .fillna("Unknown")
    )
    sellers["warehouse_type"] = (
    sellers["city"]
    .apply(warehouse_type)
    )
    
    sellers["warehouse_capacity"] = (
        sellers["warehouse_type"]
        .map(WAREHOUSE_CAPACITY)
    )
    sellers["storage_cost_per_unit"] = (
    sellers["warehouse_type"]
    .map(STORAGE_COST)
    )

    dim_warehouse = sellers[
    [
        "warehouse_id",
        "seller_id",
        "city",
        "state",
        "warehouse_region",
        "warehouse_type",
        "warehouse_capacity",
        "storage_cost_per_unit"
    ]
].copy()
    dataframe_summary(dim_warehouse)

    validate_primary_key(
    dim_warehouse,
    "warehouse_id"
)
    save_csv(
    dim_warehouse,
    PROCESSED / "dim_warehouse.csv"
)
    log_step("dim_warehouse completed successfully")


if __name__ == "__main__":
    main()

