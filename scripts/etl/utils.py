from pathlib import Path
import pandas as pd


def log_step(message: str):
    print(message)


def validate_primary_key(df: pd.DataFrame, column: str):

    if not df[column].is_unique:

        duplicates = df[column].duplicated().sum()

        raise ValueError(

            f"\nPrimary Key Validation Failed\n"
            f"Column : {column}\n"
            f"Duplicates : {duplicates}"

        )

    print(f"Primary Key Validation Passed ({column})")


def fill_numeric_nulls(df: pd.DataFrame, columns: list, value=0):

    df[columns] = df[columns].fillna(value)

    return df


def dataframe_summary(df: pd.DataFrame):

    print("\nShape")

    print(df.shape)

    print("\nMissing Values")

    print(df.isnull().sum())


def save_csv(df: pd.DataFrame, filepath: Path):

    filepath.parent.mkdir(parents=True, exist_ok=True)

    df.to_csv(filepath, index=False)

    print(f"\nSaved to\n{filepath}")
