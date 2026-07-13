import pandas as pd
from pathlib import Path
from scripts.etl.utils import (
    validate_primary_key,
    save_csv,
    dataframe_summary,
    log_step,
    fill_numeric_nulls,
)

ROOT = Path(__file__).resolve().parents[3]

RAW = ROOT / "data" / "raw" / "olist"

PROCESSED = ROOT / "data" / "processed"


def main():
    log_step("Building dim_products")
    products = pd.read_csv(RAW / "olist_products_dataset.csv")
    translation = pd.read_csv(RAW / "product_category_name_translation.csv")
    order_items = pd.read_csv(RAW / "olist_order_items_dataset.csv")

    # Merge category translation
    products = products.merge(
        translation,
        on="product_category_name",
        how="left"
    )

    # Average selling price
    avg_price = (
        order_items
        .groupby("product_id")["price"]
        .mean()
        .reset_index()
    )

    products = products.merge(
        avg_price,
        on="product_id",
        how="left"
    )

    # Rename columns
    products = products.rename(
        columns={
            "product_category_name_english": "category",
            "product_weight_g": "weight_g",
            "product_length_cm": "length_cm",
            "product_height_cm": "height_cm",
            "product_width_cm": "width_cm",
            "price": "selling_price",
        }
    )

    # Generate SKU
    products["sku"] = (
        "SKU-"
        + (products.index + 1).astype(str).str.zfill(6)
    )

    # Estimate unit cost
    products["unit_cost"] = (
        products["selling_price"] * 0.70
    )

    # Final dimension
    dim_products = products[
        [
            "product_id",
            "sku",
            "category",
            "weight_g",
            "length_cm",
            "height_cm",
            "width_cm",
            "unit_cost",
            "selling_price",
        ]
    ].copy()

    # Missing values
    dim_products["category"] = dim_products["category"].fillna("Unknown")

    numeric_cols = [
        "weight_g",
        "length_cm",
        "height_cm",
        "width_cm",
        "unit_cost",
        "selling_price",
    ]

    dim_products = fill_numeric_nulls(
        dim_products,
        numeric_cols
    )

    # Round values
    dim_products["unit_cost"] = dim_products["unit_cost"].round(2)
    dim_products["selling_price"] = dim_products["selling_price"].round(2)

    # Validation
    dataframe_summary(dim_products)

    validate_primary_key(
        dim_products,
        "product_id"
    )

    # Save
    save_csv(
        dim_products,
        PROCESSED / "dim_products.csv"
    )

    log_step("dim_products completed successfully")


if __name__ == "__main__":
    main()