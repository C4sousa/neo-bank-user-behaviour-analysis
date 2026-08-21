# Hypotesis 11 — Failed / Declined Transactions and Churn

## 1. Business Question

### Business question

Do failed or declined transactions influence churn?

### Definition of failed / declined transactions

[To be defined]

### Definition of churn

[To be defined]

### Business relevance

[To be defined]

## 2. Hypothesis

### Hypothesis

Churn is associated with the frequency of failed or declined transactions.

### Expected relationship

[To be defined]

### Explanatory variable

`failed_declined_transactions_30d`

### Outcome variable

`churn_flag`

### Unit of analysis

One row per user.

## 3. Analytical Dataset

### Dataset

`mart_churn.csv`

### Data source

Local CSV exported from the BigQuery/dbt analytical mart.

### Grain

One row per user.

### Variables used

- `user_id`
- `failed_declined_transactions_30d`
- `churn_flag`
- `country`

### Analysis steps

1. Load the dataset.
2. Inspect the dataset shape.
3. Inspect column names.
4. Inspect data types.
5. Inspect the first rows.
6. Validate one row per user.
7. Check for duplicate users.
8. Check the completeness of the analytical variables.
9. Confirm the analytical population.


```python
# Import libraries required for the H11 analysis.
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
```


```python
# Load the H11 analytical dataset from the dbt mart.
df = pd.read_csv("../../data/marts/mart_churn.csv")

# Preview the first rows to confirm the dataset loaded correctly.
df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>user_id</th>
      <th>churn_flag</th>
      <th>failed_declined_transactions_30d</th>
      <th>country</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>user_8525</td>
      <td>False</td>
      <td>NaN</td>
      <td>AT</td>
    </tr>
    <tr>
      <th>1</th>
      <td>user_6756</td>
      <td>False</td>
      <td>NaN</td>
      <td>AT</td>
    </tr>
    <tr>
      <th>2</th>
      <td>user_7755</td>
      <td>False</td>
      <td>NaN</td>
      <td>AT</td>
    </tr>
    <tr>
      <th>3</th>
      <td>user_220</td>
      <td>False</td>
      <td>NaN</td>
      <td>AT</td>
    </tr>
    <tr>
      <th>4</th>
      <td>user_1272</td>
      <td>False</td>
      <td>NaN</td>
      <td>AU</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Check the number of rows and columns in the analytical dataset.
print("Shape:", df.shape)

# Inspect the available variables.
print("\nColumns:")
print(df.columns.tolist())
```

    Shape: (19430, 4)
    
    Columns:
    ['user_id', 'churn_flag', 'failed_declined_transactions_30d', 'country']



```python
# Inspect column data types and non-null counts.
# This helps confirm that variables were imported into Python as expected.
df.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 19430 entries, 0 to 19429
    Data columns (total 4 columns):
     #   Column                            Non-Null Count  Dtype  
    ---  ------                            --------------  -----  
     0   user_id                           19430 non-null  object 
     1   churn_flag                        19430 non-null  bool   
     2   failed_declined_transactions_30d  18766 non-null  float64
     3   country                           19430 non-null  object 
    dtypes: bool(1), float64(1), object(2)
    memory usage: 474.5+ KB



```python
# Validate that the dataset has one row per user.
# The number of unique users should equal the number of rows.
print("Unique users:", df["user_id"].nunique())
print("Rows:", len(df))

# Check for duplicate user IDs.
print("Duplicate user IDs:", df["user_id"].duplicated().sum())
```

    Unique users: 19430
    Rows: 19430
    Duplicate user IDs: 0



```python
# Inspect the distribution of the churn outcome, including missing values.
print("\nChurn flag:")
print(df["churn_flag"].value_counts(dropna=False))
```

    
    Churn flag:
    churn_flag
    False    14467
    True      4963
    Name: count, dtype: int64



```python
# Inspect the frequency distribution of failed/declined transactions,
# including missing values.
print("\nFailed / declined transactions:")
print(
    df["failed_declined_transactions_30d"]
    .value_counts(dropna=False)
    .sort_index()
)
```

    
    Failed / declined transactions:
    failed_declined_transactions_30d
    0.0      13972
    1.0       1779
    2.0        991
    3.0        591
    4.0        381
             ...  
    104.0        1
    130.0        1
    180.0        1
    206.0        1
    NaN        664
    Name: count, Length: 61, dtype: int64



```python
# Calculate descriptive statistics for failed/declined transaction frequency.
print("\nFailed / declined transaction statistics:")
print(df["failed_declined_transactions_30d"].describe())
```

    
    Failed / declined transaction statistics:
    count    18766.000000
    mean         0.984493
    std          3.939676
    min          0.000000
    25%          0.000000
    50%          0.000000
    75%          1.000000
    max        206.000000
    Name: failed_declined_transactions_30d, dtype: float64



```python
# Check the number and percentage of missing values in each analytical variable.
missing = pd.DataFrame({
    "missing_count": df[[
        "user_id",
        "churn_flag",
        "failed_declined_transactions_30d",
        "country"
    ]].isna().sum()
})

missing["missing_pct"] = (
    missing["missing_count"] / len(df) * 100
)

print(missing)
```

                                      missing_count  missing_pct
    user_id                                       0     0.000000
    churn_flag                                    0     0.000000
    failed_declined_transactions_30d            664     3.417396
    country                                       0     0.000000


### Population and eligibility validation

Before moving into data preparation and analysis, perform a final set of checks to confirm that the analytical population is appropriate for H11.

These checks are intended to identify issues that could materially affect the comparison between failed/declined transaction behaviour and churn.

The checks will:

1. Confirm the analytical population size.
2. Confirm that `churn_flag` contains only valid Boolean values.
3. Confirm that `failed_declined_transactions_30d` contains valid non-negative counts.
4. Check whether failed/declined transaction counts contain unexpected fractional values.
5. Check whether the explanatory variable contains extreme values that require investigation.
6. Check whether missing failed/declined transaction values are concentrated in one churn group.
7. Confirm that all users have a valid country value.
8. Confirm that the analytical variables have the expected one-row-per-user grain.
9. Identify any potential population imbalance that could affect the H11 comparison.

These checks are validation checks only. No cleaning or transformation decisions will be made until the results have been reviewed.


```python
# ============================================================
# Population and eligibility validation
# ============================================================

# 1. Confirm the analytical population size.
print("Analytical population:", len(df))

# 2. Confirm that churn_flag contains only valid Boolean values.
print("\nChurn flag unique values:")
print(df["churn_flag"].unique())

# 3. Check that failed/declined transactions are non-negative.
negative_failed_declined = (
    df["failed_declined_transactions_30d"] < 0
).sum()

print("\nNegative failed/declined transaction counts:",
      negative_failed_declined)

# 4. Check for fractional transaction counts.
# Transaction counts should be whole numbers.
non_integer_failed_declined = (
    df["failed_declined_transactions_30d"].dropna()
    % 1 != 0
).sum()

print("Non-integer failed/declined transaction counts:",
      non_integer_failed_declined)

# 5. Identify the highest failed/declined transaction counts.
print("\nHighest failed/declined transaction counts:")
print(
    df["failed_declined_transactions_30d"]
    .dropna()
    .sort_values(ascending=False)
    .head(10)
    .to_list()
)

# 6. Check whether missing failed/declined values are concentrated
# in churned or non-churned users.
print("\nMissing failed/declined transactions by churn status:")
print(
    pd.crosstab(
        df["churn_flag"],
        df["failed_declined_transactions_30d"].isna(),
        normalize="index"
    )
)

# 7. Confirm that country is populated for all users.
print("\nMissing country values:",
      df["country"].isna().sum())

# 8. Reconfirm one-row-per-user grain.
print("\nUnique users:", df["user_id"].nunique())
print("Rows:", len(df))
print("Duplicate user IDs:", df["user_id"].duplicated().sum())
```

    Analytical population: 19430
    
    Churn flag unique values:
    [False  True]
    
    Negative failed/declined transaction counts: 0
    Non-integer failed/declined transaction counts: 0
    
    Highest failed/declined transaction counts:
    [206.0, 180.0, 130.0, 104.0, 84.0, 76.0, 74.0, 71.0, 69.0, 64.0]
    
    Missing failed/declined transactions by churn status:
    failed_declined_transactions_30d     False     True 
    churn_flag                                          
    False                             0.954102  0.045898
    True                              1.000000  0.000000
    
    Missing country values: 0
    
    Unique users: 19430
    Rows: 19430
    Duplicate user IDs: 0


## 5. Exploratory Analysis

### Analysis steps

1. Describe the distribution of failed / declined transactions.
2. Calculate descriptive statistics:
   - Mean
   - Median
   - Standard deviation
   - Minimum
   - Maximum
   - Relevant percentiles
3. Examine skewness.
4. Visualize the distribution.
5. Identify potential extreme values or outliers.
6. Examine the initial relationship between failed / declined transactions and churn.

## 6. Churn Comparison

### Analysis steps

1. Compare the number of churned and non-churned users.
2. Compare mean failed / declined transaction frequency between churned and non-churned users.
3. Compare median failed / declined transaction frequency between churned and non-churned users.
4. Compare the distribution of failed / declined transactions between churn groups.
5. Compare the proportion of users with at least one failed / declined transaction.
6. If appropriate based on the observed distribution, create meaningful failed / declined transaction-frequency buckets.
7. Compare churn rates across the frequency buckets.

## 7. Statistical Analysis

### Analysis steps

1. Assess the distribution and assumptions relevant to the statistical analysis.
2. Select an appropriate statistical test based on the observed data.
3. Compare failed / declined transaction behaviour between churned and non-churned users.
4. Measure the strength of the observed relationship.
5. Calculate an appropriate effect size.
6. Assess statistical significance.
7. Interpret statistical significance alongside practical/business significance.

## 8. Robustness Checks

### Analysis steps

1. Test whether the result is sensitive to extreme transaction frequencies.
2. Test whether the result changes under reasonable frequency-bucket definitions.
3. Assess the impact of missing values.
4. Check whether the relationship is driven by a small number of users.
5. Where justified, examine whether the relationship differs across relevant user segments.
6. Document any additional robustness checks that become necessary based on the findings.

## 9. Findings

### Key findings

[To be completed after the analysis]

### Evidence

[To be completed after the analysis]

### Hypothesis status

[Supported / Partially supported / Not supported / Inconclusive]

### Business interpretation

[To be completed after the analysis]

## 10. Limitations

### Methodological limitations

[To be completed]

### Data limitations

[To be completed]

### Causality

[To be completed]

### Other limitations

[To be completed]

## 11. Conclusion

### Answer to the business question

[To be completed]

### Key evidence

[To be completed]

### Business implication

[To be completed]

### Final assessment of the hypothesis

[To be completed]


