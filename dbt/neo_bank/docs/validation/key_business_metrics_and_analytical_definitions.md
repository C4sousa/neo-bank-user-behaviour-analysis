# Key Business Metrics & Analytical Definitions

## Purpose

This document defines the business concepts and analytical rules used throughout the NeoBank User Behaviour Analysis project.

Before designing the intermediate data models, all key behavioural metrics were formalised to ensure they are:

- Business-relevant
- Specific
- Measurable
- Reproducible
- Time-bounded

These definitions act as the project's analytical source of truth and ensure all downstream SQL models, dashboards and business recommendations use consistent logic.

---

| Analytical Concept | Business Definition | Analytical Definition | Problem Identified | Rationale | Status |
|--------------------|---------------------|-----------------------|-------------------|-----------|--------|
| Successful Transaction | A transaction completed successfully by a user. | Any transaction whose status equals **COMPLETED**. | Behavioural metrics depended on this concept but it had never been formally defined. | Establishes the fundamental event used throughout the project. | Approved |
| User Activation | User starts using the banking product. | User completes their first successful transaction. | Activation point was previously undefined. | Creates a consistent starting point for lifecycle analysis. | Approved |
| User Engagement | A user actively and consistently uses the banking product. | User completes at least one successful transaction in **3 of the previous 4 weeks** before the analysis date. | Previous definition did not distinguish engaged users from occasional users. | Identifies habitual rather than occasional users. | Approved |
| User Retention | User continues using the banking product over time. | User completes at least one successful transaction in every calendar month after activation. | Continued activity was not previously defined. | Aligns retention measurement with monthly banking behaviour. | Approved |
| User Churn | User stops using the banking product. | User records no successful transactions for **90 consecutive days** after their last successful transaction, provided the observation window allows confirmation. | No objective inactivity threshold existed. | Creates a measurable churn definition aligned with retention. | Approved |
| Transaction Frequency | Number of successful transactions performed by a user. | Count of successful transactions during the **30 days** before the analysis date. | Frequency window had not been defined. | Provides a reproducible measure of activity intensity. | Approved |
| Failed / Declined Transactions | Transactions that were unsuccessful. | Count of transactions whose status equals **FAILED** or **DECLINED** during the previous 30 days. | Failure states and observation period were undefined. | Standardises unsuccessful transaction measurement. | Approved |
| Notification Frequency | Number of notifications received by a user. | Count of successfully delivered notifications during the previous 30 days. | Delivery status and observation period were undefined. | Provides a consistent measure of communication exposure. | Approved |
| Merchant Spending Category | User's primary spending category. | Merchant Category Code (MCC) with the highest total transaction amount during the previous 30 days. | "Primary category" could have been interpreted in different ways. | Assigns one objective spending category per user. | Approved |
| Transaction Type | Type of financial transaction performed. | Transaction type is taken directly from the dataset without additional grouping. | It was unclear whether grouped or raw values should be analysed. | Ensures consistent classification across analyses. | Approved |
| Crypto Adoption | Crypto feature is enabled for the user. | `crypto_enabled = TRUE` at the time of analysis. | "Enabled" could refer to historical or current status. | Defines a single reproducible snapshot. | Approved |
| Premium Plan | User subscribes to a premium banking plan. | User's current plan equals **Premium**; all remaining plans are treated as Standard. | Historical versus current subscription status was undefined. | Produces one consistent segmentation variable. | Approved |

---

## Notes

These definitions were agreed before designing the intermediate dbt models.

The intermediate layer is responsible for transforming the cleaned staging data into reusable behavioural features that implement the analytical definitions documented above.
