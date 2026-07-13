"""
Run validation on all processed warehouse tables.
"""

from pathlib import Path
import sys
import pandas as pd

from scripts.validation.validator import DataValidator
from scripts.validation.rules import TABLE_RULES


ROOT = Path(__file__).resolve().parents[2]

PROCESSED = ROOT / "data" / "processed"

REPORTS = ROOT / "reports"

REPORTS.mkdir(parents=True, exist_ok=True)


def main():

    all_reports = []

    print("\n" + "=" * 80)
    print("RetailX Warehouse Validation")
    print("=" * 80)

    for table_name, rules in TABLE_RULES.items():

        print("\n" + "=" * 80)
        print(f"Validating : {table_name}")
        print("=" * 80)

        filepath = PROCESSED / f"{table_name}.csv"

        if not filepath.exists():

            print(f"ERROR : {filepath.name} not found.")

            continue

        df = pd.read_csv(filepath)

        validator = DataValidator(
            df,
            table_name
        )

        validator.summary()

        validator.validate_primary_key(
            rules["primary_key"]
        )

        validator.validate_duplicate_rows()

        validator.validate_not_null(
            rules["not_null"]
        )

        validator.validate_non_negative(
            rules["non_negative"]
        )

        for column, allowed_values in rules["allowed_values"].items():

            validator.validate_allowed_values(
                column,
                allowed_values
            )

        report = validator.report()

        all_reports.append(report)

    # -----------------------------------------------------
    # Merge reports
    # -----------------------------------------------------

    final_report = pd.concat(
        all_reports,
        ignore_index=True
    )

    report_path = REPORTS / "validation_report.csv"

    final_report.to_csv(
        report_path,
        index=False
    )

    # -----------------------------------------------------
    # Overall Summary
    # -----------------------------------------------------

    total_checks = len(final_report)

    passed = (
        final_report["status"] == "PASS"
    ).sum()

    failed = (
        final_report["status"] == "FAIL"
    ).sum()

    print("\n" + "=" * 80)
    print("Validation Summary")
    print("=" * 80)

    print(f"Tables Checked : {len(TABLE_RULES)}")
    print(f"Total Checks   : {total_checks}")
    print(f"Passed         : {passed}")
    print(f"Failed         : {failed}")

    print(f"\nDetailed Report Saved To:")

    print(report_path)

    if failed == 0:

        print("\nWarehouse is READY for PostgreSQL Loading.")

    else:

        print("\nWarehouse validation FAILED.")

        print("Fix validation errors before loading.")

        sys.exit(1)


if __name__ == "__main__":
    main()