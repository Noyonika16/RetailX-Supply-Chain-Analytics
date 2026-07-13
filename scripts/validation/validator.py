import pandas as pd


class DataValidator:

    def __init__(self, df: pd.DataFrame, table_name: str):

        self.df = df
        self.table_name = table_name

        self.results = []

  
    def _add_result(self, check, status, details):

        self.results.append(
            {
                "table": self.table_name,
                "check": check,
                "status": status,
                "details": details
            }
        )

    def summary(self):

        print("\n" + "=" * 70)
        print(f"TABLE : {self.table_name}")
        print("=" * 70)

        print(f"Rows    : {len(self.df)}")
        print(f"Columns : {len(self.df.columns)}")

        print("\nMissing Values")

        print(self.df.isnull().sum())

    
    def validate_primary_key(self, column):

        if column not in self.df.columns:

            self._add_result(
                "Primary Key",
                "FAIL",
                f"{column} does not exist"
            )

            return

        if self.df[column].isnull().any():

            self._add_result(
                "Primary Key",
                "FAIL",
                f"{column} contains NULL values"
            )

            return

        duplicates = self.df[column].duplicated().sum()

        if duplicates > 0:

            self._add_result(
                "Primary Key",
                "FAIL",
                f"{duplicates} duplicate values found in {column}"
            )

        else:

            self._add_result(
                "Primary Key",
                "PASS",
                f"{column} is unique"
            )


    def validate_duplicate_rows(self):

        duplicates = self.df.duplicated().sum()

        if duplicates > 0:

            self._add_result(
                "Duplicate Rows",
                "FAIL",
                f"{duplicates} duplicate rows found"
            )

        else:

            self._add_result(
                "Duplicate Rows",
                "PASS",
                "No duplicate rows"
            )


    def validate_not_null(self, columns):

        for col in columns:

            if col not in self.df.columns:

                self._add_result(
                    "Not Null",
                    "FAIL",
                    f"{col} does not exist"
                )

                continue

            missing = self.df[col].isnull().sum()

            if missing > 0:

                self._add_result(
                    "Not Null",
                    "FAIL",
                    f"{col} contains {missing} NULL values"
                )

            else:

                self._add_result(
                    "Not Null",
                    "PASS",
                    f"{col} contains no NULL values"
                )


    def validate_non_negative(self, columns):

        for col in columns:

            if col not in self.df.columns:

                self._add_result(
                    "Non Negative",
                    "FAIL",
                    f"{col} does not exist"
                )

                continue

            negatives = (self.df[col] < 0).sum()

            if negatives > 0:

                self._add_result(
                    "Non Negative",
                    "FAIL",
                    f"{col} contains {negatives} negative values"
                )

            else:

                self._add_result(
                    "Non Negative",
                    "PASS",
                    f"{col} contains no negative values"
                )

    def validate_allowed_values(self, column, allowed):

        if column not in self.df.columns:

            self._add_result(
                "Allowed Values",
                "FAIL",
                f"{column} does not exist"
            )

            return

        invalid = self.df[
            ~self.df[column].isin(allowed)
        ]

        if len(invalid):

            self._add_result(
                "Allowed Values",
                "FAIL",
                f"{column} contains {len(invalid)} invalid values"
            )

        else:

            self._add_result(
                "Allowed Values",
                "PASS",
                f"{column} contains only allowed values"
            )

   
    def report(self):

        report = pd.DataFrame(self.results)

        print("\nValidation Results\n")

        print(report)

        return report
