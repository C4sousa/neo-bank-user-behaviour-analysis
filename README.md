# NeoBank User Engagement Analysis

> Understanding user engagement to improve retention and reduce churn.

---

## Project Overview

This project investigates user behaviour within an anonymised digital bank to identify the factors that drive user engagement, retention, and churn.

Following a modern analytics engineering workflow, the project transforms raw operational data into analytical models, business insights, and evidence-based product recommendations using SQL, dbt, Python, and business intelligence tools.

---

## Business Problem

The NeoBank wants to understand which customer behaviours drive engagement and retention in order to reduce churn.

Rather than relying on assumptions, the objective is to analyse behavioural data and identify the strongest indicators of long-term user activity.

---

## Project Objectives

- Identify the drivers of user engagement
- Identify the drivers of user retention
- Understand churn behaviour
- Produce evidence-based product recommendations

---

## Dataset

The project analyses an anonymised digital banking dataset containing user, transaction, notification, and device data.

The dataset is based on real-world banking data and has been anonymised for privacy. It was made available through an educational partnership, allowing analysis without exposing commercially sensitive information.

### Tables

- users
- transactions
- notifications
- devices

---

## Tech Stack

| Category------------| Technology----------------|
|---------------------|---------------------------|
| Data Warehouse      | Google BigQuery           |
| SQL                 | BigQuery SQL              |
| Data Modelling      | dbt                       |
| Data Validation     | dbt Tests                 |
| Documentation       | dbt Documentation         |
| Analysis            | Python                    |
| Dashboard           | Looker Studio *(planned)* |
| Version Control     | Git & GitHub              |
| Design              | Figma                     |

---

## Analytics Workflow

```
Business Discovery
        │
        ▼
Data Understanding
        │
        ▼
Business Question Validation
        │
        ▼
Data Quality Audit
        │
        ▼
Investigation Prioritisation
        │
        ▼
Data Architecture
        │
        ▼
dbt Models
        │
        ▼
SQL Analysis
        │
        ▼
Python Analysis
        │
        ▼
Business Findings
        │
        ▼
Dashboard
        │
        ▼
Business Recommendations
```

---

## Data Pipeline

```
RAW

users
transactions
notifications
devices

        │
        ▼

STAGING

stg_users
stg_transactions
stg_notifications
stg_devices

        │
        ▼

INTERMEDIATE

int_user_transactions

int_user_notifications

int_user_engagement

        │
        ▼

MARTS

mart_engagement

mart_retention

mart_churn

        │
        ▼

Python Analysis

        │
        ▼

Looker Studio Dashboard
```

---

## dbt Development Workflow

Every dbt model follows the same development process.

```
Create Model
      │
      ▼
Create Schema YAML
      │
      ▼
Add Documentation
      │
      ▼
Run Tests
      │
      ▼
Validate Results
      │
      ▼
Commit Changes
```

Each model includes:

- SQL transformation
- Documentation
- Column descriptions
- Built-in dbt tests
- Relationship tests
- Accepted values tests
- Version-controlled SQL

---

## Repository Structure

```
neo-bank-user-behaviour-analysis/

README.md
CHANGELOG.md
LICENSE
.gitignore

docs/
├── analysis-plan/
├── business/
├── data-understanding/
├── findings/
└── references/

sql/
├── exploration/
├── validation/
├── analysis/
└── archive/

dbt/
├── analyses/
├── documentation/
├── macros/
├── models/
│   ├── staging/
│   ├── intermediate/
│   └── marts/
├── seeds/
├── snapshots/
└── tests/

python/
├── notebooks/
├── statistics/
├── visualisations/
└── utilities/

dashboard/
├── assets/
├── exports/
└── looker-studio/

images/
├── architecture/
├── charts/
├── dashboard/
├── er-diagram/
└── presentation/

presentation/

data/
├── raw/
├── external/
└── sample/
```

---

## Current Status

### ✅ Completed

- Business Foundation
- Business Context
- Business Questions
- Data Overview
- Data Model
- Data Dictionary
- Repository Structure

### 🚧 In Progress

- Business Question Validation
- Data Quality Audit
- Investigation Prioritisation
- Data Architecture

### ⏳ Planned

- dbt Models
- SQL Analysis
- Python Analysis
- Dashboard Development
- Business Recommendations

---

## Future Improvements

Potential future enhancements will be identified after completing the analysis and validating the project findings.

---

## Author

**Ricardo de Sousa**

Product Manager | Data Analytics

Currently transitioning into Product Management while expanding expertise in Analytics Engineering, SQL, dbt, Python, and Business Intelligence.

---

## Acknowledgements

This project uses an anonymised banking dataset made available through the Le Wagon Data Analytics programme.

---

## License

This repository is intended for portfolio and educational purposes.
