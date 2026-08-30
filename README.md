# NeoBank User Engagement Analysis

> Understanding user behaviour to improve engagement, retention, and reduce churn.

This project transforms raw banking data into analysis‑ready marts, evidence, and product recommendations using SQL, dbt, Python, and BI visuals. Documentation and decisions live in Notion; this repo holds the reproducible assets.

## Business Problem
The NeoBank wants to understand which customer behaviours drive engagement and retention to reduce churn. The objective is to analyse behavioural data and identify the strongest indicators of long‑term activity, then translate evidence into a validation‑first product plan.

## What's in this repo
- `data/raw` — source CSVs (users, transactions, notifications, devices)
- `data/marts` — final analysis‑ready tables (engagement, retention, churn, churn by transaction type)
- `dbt/` — staging/intermediate/marts models with tests and documentation
- `python/notebooks` — hypothesis analyses (H5, H6, H7, H10, H11)
- `images/` — ER diagram, dbt lineage diagram, final presentation PDFs

## How to reproduce
1) Place raw CSVs in `data/raw/`.
2) From the `dbt` folder, run: `dbt build` (creates intermediate and marts).
3) Open `python/notebooks/*.ipynb` to re‑run analyses and visuals.

## Tech Stack
- **Data Warehouse:** Google BigQuery
- **SQL:** BigQuery SQL
- **Data Modelling:** dbt
- **Analysis:** Python (notebooks), SQL, Power BI / Looker Studio
- **Visuals:** Power BI / Looker Studio (exports in `images/`), Python (image exports)
- **Version Control:** Git & GitHub
- **Documentation:** Notion (project home)

## Repository Structure
```text
neo-bank-user-behaviour-analysis/
├── data
│   ├── marts
│   └── raw
├── dbt
│   ├── dbt_project.yml
│   ├── README.md
│   └── models
│       ├── staging
│       ├── intermediate
│       └── marts
├── images
│   ├── Entity Relationship Diagram (ERD) - Neo Bank.png
│   ├── Lineage_Data Preparation Architecture (overview).png
│   ├── Presentation_H15_Country_Churn_5min.pptx
│   ├── Presentation_NeoBank_10min_Global_Analysis.pptx
│   └── Presentation_NeoBank_Final_Handover_10min.pdf
├── python
│   └── notebooks
│       ├── H5_merchant_category_engagement.ipynb
│       ├── H6_engagement_across_countries.ipynb
│       ├── H7_transaction_frequency_retention.ipynb
│       ├── H10_notification_frequency_retention.ipynb
│       └── H11_failed_declined_churn.ipynb
└── README.md
```

## Current Status
- ✅ **Completed:** data foundation, dbt models (staging/intermediate/marts), core analyses (H1 - H15), final presentation.

## Links
- **Notion project home (Phases 1–6):** https://app.notion.com/p/ricardodesousa/NeoBank-User-Engagement-Analysis-3bd5bf6d971f807ca0d6fdaec4c1ca74
- **Final presentation:** `images/Presentation_NeoBank_Final_Handover_10min.pdf`

## Author
**Ricardo de Sousa** — Product Manager | Data Analytics

## Acknowledgements
Anonymised banking dataset via Le Wagon Data Analytics programme.

## License
Educational/portfolio use.
