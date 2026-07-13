from pathlib import Path

import pandas as pd

from sqlalchemy import text

from scripts.database import get_engine


ROOT = Path(__file__).resolve().parents[2]

PROCESSED = ROOT / "data" / "processed"


TABLES = [

    "dim_products",

    "dim_customer",

    "dim_warehouse",

    "dim_date",

    "fact_sales"

]


def load_table(engine, table_name):

    filepath = PROCESSED / f"{table_name}.csv"

    df = pd.read_csv(filepath)

    print(f"\nLoading {table_name}")

    df.to_sql(

        table_name,

        engine,

        if_exists="append",

        index=False,

        method="multi"

    )

    print(

        f"{len(df)} rows inserted."

    )


def verify_table(engine, table_name):

    with engine.connect() as conn:

        result = conn.execute(

            text(

                f"SELECT COUNT(*) FROM {table_name}"

            )

        )

        count = result.scalar()

        print(

            f"{table_name}: {count} rows"

        )


def main():

    engine = get_engine()

    truncate_order = [
        "fact_sales",
        "dim_products",
        "dim_customer",
        "dim_warehouse",
        "dim_date"
    ]

    with engine.begin() as conn:

        for table in truncate_order:
            conn.execute(
                text(f"TRUNCATE TABLE {table} RESTART IDENTITY CASCADE;")
            )

    for table in TABLES:
        load_table(engine, table)

    print("Verifying Row Counts")
    

    for table in TABLES:
        verify_table(engine, table)

    print("\nWarehouse successfully loaded.")


if __name__ == "__main__":

    main()
