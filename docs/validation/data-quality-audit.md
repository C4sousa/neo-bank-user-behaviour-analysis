# Data Quality Audit

This audit validates the integrity, completeness and usability of the raw NeoBank dataset before any SQL transformation or dbt modelling is performed.

---

## 1. Primary Key Uniqueness

### Objective

Verify that every table's primary key uniquely identifies each record.

### SQL Evidence

**Users**

- Total rows: **19,430**
- Unique `user_id`: **19,430**
- Duplicate keys: **0**

**Transactions**

- Total rows: **2,740,075**
- Unique `transaction_id`: **2,740,075**
- Duplicate keys: **0**

### Result

🟢 Pass

### Notes

No duplicate primary keys were identified in either table.

---

## 2. Foreign Key Integrity

### Objective

Verify that all foreign key relationships reference valid parent records.

### SQL Evidence

**Transactions → Users**

- Orphan records: **0**

**Notifications → Users**

- Orphan records: **0**

**Devices → Users**

Although the devices table does not expose a column named `user_id`, validation confirmed that `string_field_1` stores user identifiers. Joining `devices.string_field_1` to `users.user_id` returned **19,430 matching records** with no orphan records.

### Result

🟢 Pass

### Notes

- Transactions successfully reference existing users.
- Notifications successfully reference existing users.
- Devices successfully reference existing users through `string_field_1`, which functions as the user identifier.

---

## 3. Duplicate Records

### Objective

Verify that no duplicate rows exist within each dataset.

### SQL Evidence

**Users**

- Total rows: **19,430**
- Unique rows: **19,430**
- Duplicate rows: **0**

**Transactions**

- Total rows: **2,740,075**
- Unique rows: **2,740,075**
- Duplicate rows: **0**

**Notifications**

- Total rows: **121,813**
- Unique rows: **121,813**
- Duplicate rows: **0**

**Devices**

- Total rows: **19,431**
- Unique rows: **19,431**
- Duplicate rows: **0**

### Result

🟢 Pass

### Notes

No duplicate records were identified in any of the four tables. Every record is unique, indicating that the dataset does not contain duplicate rows that could bias aggregation, user-level analysis, or downstream modelling.

---

## 4. Required Column Validation

### Objective

Verify that every column required to answer the project's business questions exists in the dataset.

### SQL Evidence

**Users**

The required columns were verified, including:

- user_id
- created_date
- country
- plan
- user_settings_crypto_unlocked
- num_referrals
- num_successful_referrals
- attributes_notifications_marketing_push
- attributes_notifications_marketing_email

**Transactions**

The required columns were verified, including:

- transaction_id
- transactions_type
- transactions_currency
- amount_usd
- transactions_state
- ea_merchant_mcc
- ea_merchant_city
- ea_merchant_country

**Notifications**

The required columns were verified, including:

- user_id
- created_date
- reason
- channel
- status

**Devices**

The table currently contains two generic columns:

- string_field_0
- string_field_1

Validation confirmed that these fields represent **device brand** and **user identifier** respectively. Although the schema uses placeholder names, the required information is present and can be renamed during the staging phase to improve readability.

### Result

🟡 Partial

### Notes

All required columns for the **users**, **transactions** and **notifications** tables are present and support the planned business analyses. The **devices** table also contains the required information but uses generic placeholder column names, which should be standardised during data preparation.

---

## 5. Data Type Validation

### Objective

Verify that the required columns use appropriate data types for analysis.

### SQL Evidence

The data types of all required analytical fields were validated using `INFORMATION_SCHEMA.COLUMNS`.

Examples include:

| Table | Column | Data Type |
|--------|--------|-----------|
| users | user_id | STRING |
| users | created_date | TIMESTAMP |
| users | country | STRING |
| users | plan | STRING |
| users | user_settings_crypto_unlocked | INT64 |
| transactions | transaction_id | STRING |
| transactions | amount_usd | FLOAT64 |
| transactions | created_date | TIMESTAMP |
| transactions | transactions_state | STRING |
| transactions | transactions_type | STRING |
| notifications | user_id | STRING |
| notifications | created_date | TIMESTAMP |
| notifications | reason | STRING |
| notifications | channel | STRING |
| notifications | status | STRING |
| devices | string_field_0 | STRING |
| devices | string_field_1 | STRING |

### Result

🟢 Pass

### Notes

All required analytical fields use appropriate data types for their intended purpose. Identifiers are stored as `STRING`, dates as `TIMESTAMP`, numerical measures as `FLOAT64` or `INT64`, and categorical attributes as `STRING`. Although the **devices** table uses generic column names, their data types are valid and the table can be standardised during the staging phase.

---

## 6. Data Completeness

### Objective

Verify that the critical fields required for analysis do not contain missing values.

### SQL Evidence

**Users**

| Column | Missing Values |
|---------|---------------:|
| user_id | 0 |
| created_date | 0 |
| country | 0 |
| plan | 0 |
| user_settings_crypto_unlocked | 0 |

**Transactions**

| Column | Missing Values |
|---------|---------------:|
| transaction_id | 0 |
| user_id | 0 |
| created_date | 0 |
| amount_usd | 0 |
| transactions_state | 0 |
| transactions_type | 0 |
| ea_merchant_mcc | 1,158,658 |

**Notifications**

| Column | Missing Values |
|---------|---------------:|
| user_id | 0 |
| created_date | 0 |
| reason | 0 |
| channel | 0 |
| status | 0 |

**Devices**

| Column | Missing Values |
|---------|---------------:|
| string_field_0 | 0 |
| string_field_1 | 0 |

### Result

🟡 Warning

### Notes

All critical analytical fields are complete and contain no missing values. The only exception is **ea_merchant_mcc**, which is missing for **1,158,658 transactions (42.29%)**. Merchant Category Code (MCC) analyses will therefore only be possible for the **57.71%** of transactions where this field is populated.

---

## 7. Timestamp Format

### Objective

Verify that timestamp fields are complete, correctly stored as TIMESTAMP values, and cover a realistic observation period for analysis.

### SQL Evidence

| Table | Earliest Date | Latest Date | Missing Dates |
|--------|---------------|-------------|---------------:|
| Users | 2018-01-01 08:42:24 UTC | 2019-01-03 07:34:36 UTC | 0 |
| Transactions | 2018-01-01 08:51:10 UTC | 2019-05-16 18:22:16 UTC | 0 |
| Notifications | 2018-01-10 12:09:55 UTC | 2019-05-12 17:12:14 UTC | 0 |

### Result

🟢 Pass

### Notes

All timestamp fields are complete and stored using the TIMESTAMP data type. The observation period spans approximately 16 months, providing sufficient historical coverage to measure the project's defined engagement, retention and churn metrics.

---

## 8. Categorical Value Validation

### Objective

Verify that categorical fields contain valid, consistent and expected values for analysis.

### SQL Evidence

**Users**

| Column | Values |
|--------|--------|
| plan | STANDARD, PREMIUM, PREMIUM_FREE, PREMIUM_OFFER, METAL, METAL_FREE |
| country | 41 valid ISO-style two-letter country codes |
| user_settings_crypto_unlocked | 0, 1 |

**Transactions**

| Column | Values |
|--------|--------|
| transactions_state | COMPLETED, DECLINED, FAILED, PENDING, CANCELLED, REVERTED |
| transactions_type | ATM, CARD_PAYMENT, CARD_REFUND, CASHBACK, EXCHANGE, FEE, REFUND, TAX, TOPUP |

**Notifications**

| Column | Values |
|--------|--------|
| reason | Multiple notification campaign and event categories |
| channel | EMAIL, PUSH, SMS |
| status | SENT, FAILED |

### Result

🟢 Pass

### Notes

All categorical fields contain consistent and meaningful values with no unexpected categories identified. Country values use consistent ISO-style two-letter country codes, Crypto is represented as a binary flag (0/1), and transaction and notification fields contain well-defined business categories suitable for analysis.

---

## 9. Join Validation

### Objective

Verify that all project tables can be successfully joined using their relationship keys.

### SQL Evidence

| Relationship | Joined Rows |
|--------------|------------:|
| Transactions (`user_id`) → Users (`user_id`) | 2,740,075 |
| Notifications (`user_id`) → Users (`user_id`) | 121,813 |
| Devices (`string_field_1`) → Users (`user_id`) | 19,430 |

### Result

🟢 Pass

### Notes

All expected relationships joined successfully with no missing matches. Validation confirmed that `devices.string_field_1` stores the user identifier and joins successfully to `users.user_id`. This confirms that all project tables can be reliably combined for downstream analysis.

---

## 10. Cardinality Validation

### Objective

Verify that the relationships between tables match the expected data model cardinality.

### SQL Evidence

| Relationship | Minimum | Maximum | Average | Expected Cardinality |
|--------------|--------:|--------:|--------:|----------------------|
| Users (`user_id`) → Transactions (`user_id`) | 1 | 5,285 | 146.01 | One-to-Many (1:M) |
| Users (`user_id`) → Notifications (`user_id`) | 1 | 289 | 6.43 | One-to-Many (1:M) |
| Users (`user_id`) → Devices (`string_field_1`) | 1 | 1 | 1.00 | One-to-One (1:1) |

### Result

🟢 Pass

### Notes

The observed relationships match the expected data model. Each user can have multiple transactions and notifications, while each user is associated with exactly one device record. These relationships support reliable joins and aggregation throughout the analysis.
