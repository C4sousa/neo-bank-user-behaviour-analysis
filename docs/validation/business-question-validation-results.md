# Business Question Validation Results

## Purpose

This document records the validation performed for each business question before any data modelling or analysis begins.

The objective is to confirm that the available dataset contains the required tables, columns, and relationships needed to answer each business question.

Each question is classified as:

## Legend

### Validation Status

- 🟢 **Ready** – The required tables, columns and relationships exist. The business question can be answered.
- 🟡 **Partial** – Some required data exists, but important information is missing or requires assumptions.
- 🔴 **Not Ready** – Required data is missing, preventing the business question from being answered.

### Table Availability

| Symbol | Meaning |
|:------:|---------|
| 🟢 | Required table is used |
| ⚪ | Table is not required |
| 🟡 | Table exists but requires technical validation |

---

# Question 1

## Business Question

**Does transaction frequency influence user engagement?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 1 | Does transaction frequency influence user engagement? | 🟢 Yes | Transaction history measures engagement behaviour. | 🟢 | 🟢 | ⚪ | ⚪ | user_id<br>created_date<br>amount_usd<br>transactions_state | Engagement is measured using transaction behaviour because no direct engagement metric exists. | 🟢 Ready |

---

## Validation Evidence

### Tables Verified

- ✅ users
- ✅ transactions

### Columns Verified

#### users

- user_id
- created_date

#### transactions

- user_id
- created_date
- amount_usd
- transactions_state

---

## Validation Findings

The following checks were performed:

- Required tables exist.
- Required columns exist.
- Tables can be linked using **user_id**.
- Transaction frequency is measurable because users can have multiple transactions.
- Date fields exist, allowing behaviour to be analysed over time.

### Evidence

- Users: **19,430**
- Transactions: **2,740,075**
- Users with more than one transaction: **18,520**

---

## Decision

🟢 **Ready**

The available data supports analysis of transaction frequency as a behavioural measure of user engagement.

---

# Question 2

## Business Question

**Does Crypto adoption influence user engagement?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 2 | Does Crypto adoption influence user engagement? | 🟢 Yes | Crypto adoption can be compared with user transaction behaviour. | 🟢 | 🟢 | ⚪ | ⚪ | user_id<br>user_settings_crypto_unlocked<br>created_date | Crypto adoption is represented by a binary flag (`user_settings_crypto_unlocked`). Engagement is inferred from transaction behaviour rather than direct usage metrics. | 🟢 Ready |

---

## Validation Evidence

### Tables Verified

- ✅ users
- ✅ transactions

### Columns Verified

#### users

- user_id
- user_settings_crypto_unlocked
- created_date

#### transactions

- user_id
- created_date

---

## Validation Findings

The following checks were performed:

- Required tables exist.
- Required columns exist.
- Users can be classified according to crypto adoption.
- Transactions can be linked to users using **user_id**.
- User activity can be measured over time using **created_date**.

### Evidence

- Users with Crypto unlocked: **3,517**
- Users without Crypto unlocked: **15,913**
- Total transactions: **2,740,075**

---

## Decision

🟢 **Ready**

The available data supports comparison of engagement between users with and without Crypto enabled.

---

# Question 3

## Business Question

Does Premium plan adoption influence user engagement?

| # | Business Question | Can Answer | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|------------|-----|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 3 | Does Premium plan adoption influence user engagement? | 🟢 Yes | User subscription plan can be linked to transaction behaviour. | 🟢 | 🟢 | ⚪ | ⚪ | user_id, plan, created_date, amount_usd, transactions_state | Engagement is inferred from transaction behaviour rather than direct interaction metrics. | 🟢 Ready |

## Validation Evidence

### Tables verified

- ✅ users
- ✅ transactions

### Columns verified

Users

- user_id
- plan
- created_date

Transactions

- user_id
- created_date
- amount_usd
- transactions_state

### Validation queries executed

Required columns verified.

Users are classified into STANDARD and PREMIUM subscription plans.

Transactions are linked to users through **user_id**.

The relationship enables comparison of engagement behaviour across subscription plans.

### Decision

🟢 Ready

The available data supports analysis of whether Premium plan adoption influences user engagement.
---

# Question 4

## Business Question

Does notification frequency influence user engagement?

| # | Business Question | Can Answer | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|------------|-----|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 4 | Does notification frequency influence user engagement? | 🟡 Partial | Notification delivery history is available, but user interaction with notifications is not recorded. | ⚪ | 🟢 | 🟢 | ⚪ | user_id, created_date, reason, channel, status | Engagement with notifications cannot be measured because open and click events are unavailable. Notification frequency is based only on notifications sent. | 🟡 Partial |

## Validation Evidence

### Tables verified

- ✅ transactions
- ✅ notifications

### Columns verified

Notifications

- user_id
- created_date
- reason
- channel
- status

Transactions

- user_id
- created_date

### Validation queries executed

Required columns verified.

Notifications can be linked to users through **user_id**.

Notification history records when notifications were sent and why they were sent.

No notification interaction events (such as opens or clicks) are available.

### Decision

🟡 Partial

The available data supports analysis of notification frequency based on delivery history, but it cannot measure how users interacted with notifications.

---

---

# Question 5

## Business Question

Do merchant spending categories influence user engagement?

| # | Business Question | Can Answer | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|------------|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 5 | Do merchant spending categories influence user engagement? | 🟢 Yes | Merchant spending categories classify where users spend money, enabling behavioural analysis across different merchant types, enabling behavioural analysis by spending type. | ⚪ | 🟢 | ⚪ | ⚪ | user_id, ea_merchant_mcc, amount_usd, created_date | Merchant category is available for 57.71% of transactions, so analyses using this field will exclude transactions where the merchant category is missing. | 🟢 Ready |

## Validation Evidence

### Tables verified

- ✅ transactions

### Required columns

- user_id
- ea_merchant_mcc
- amount_usd
- created_date

### Validation queries executed

The required merchant category field exists.

The dataset contains **664 distinct merchant categories**.

Merchant category is populated for **1,581,417 of 2,740,075 transactions (57.71%)**, providing sufficient coverage for merchant-based behavioural analysis.

### Decision

🟢 Ready

Merchant category provides enough coverage and variation to analyse user spending behaviour across different merchant types.


---

---

# Question 6

## Business Question

**How does user engagement evolve over time across different countries?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 6 | How does user engagement evolve over time across different countries? | 🟢 Yes | User country and transaction history allow engagement to be analysed across countries over time. | 🟢 | 🟢 | ⚪ | ⚪ | user_id<br>country<br>created_date<br>transaction_id | Country is recorded at user level and is assumed to remain stable throughout the analysis period. User engagement is inferred from transaction behaviour. | 🟢 Ready |

---

## Validation Evidence

### Tables Verified

- ✅ users
- ✅ transactions

### Columns Verified

#### users

- user_id
- country
- created_date

#### transactions

- transaction_id
- user_id
- created_date

---

## Validation Findings

The following checks were performed:

- Required tables exist.
- Required columns exist.
- Users can be linked to transactions using **user_id**.
- Country is populated for users.
- Transaction dates allow engagement to be analysed over time.
- Transactions can be aggregated by country.

### Evidence

- Countries represented: **41**
- Largest country: **GB (6,315 users)**
- Total transaction period: **2018-01-01 to 2019-05-16**
- Users and transactions successfully joined by **user_id**.

---

## Decision

🟢 **Ready**

The available data supports analysing how user engagement evolves over time across different countries.

---

---

# Question 7

## Business Question

**Does device brand influence user engagement?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 7 | Does device brand influence user engagement? | 🟡 Partial | Device information exists but column names require validation before analysis. | ⚪ | 🟢 | ⚪ | 🟡 | string_field_0<br>string_field_1 | The device table appears to contain device brand and user_id, but the columns are unnamed and require confirmation during the staging phase. | 🟡 Partial |

---

## Validation Evidence

### Tables Verified

- ✅ devices
- ✅ transactions

### Columns Verified

#### devices

- string_field_0
- string_field_1

#### transactions

- user_id
- created_date

---

## Validation Findings

The following checks were performed:

- Required tables exist.
- Device records exist.
- Device table contains one record per user.
- Preview indicates **string_field_0** contains device brands.
- Preview indicates **string_field_1** contains user IDs.
- Column names require technical validation before modelling.

### Evidence

- Device records: **19,431**

---

## Decision

🟡 **Partial**

The available data appears sufficient to analyse device brand, but the device table should first be validated and renamed during the staging phase.

---

---

# Question 8

## Business Question

**Does transaction frequency influence user retention?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 8 | Does transaction frequency influence user retention? | 🟢 Yes | Transaction history allows users' activity to be measured over time. | 🟢 | 🟢 | ⚪ | ⚪ | user_id<br>created_date<br>amount_usd<br>transactions_state | Retention is inferred from continued transaction activity because no explicit retention flag exists. | 🟢 Ready |

---

## Validation Evidence

### Tables Verified

- ✅ users
- ✅ transactions

### Columns Verified

#### users

- user_id
- created_date

#### transactions

- user_id
- created_date
- amount_usd
- transactions_state

---

## Validation Findings

The following checks were performed:

- Required tables exist.
- Required columns exist.
- Users can be linked to their transactions.
- Users have activity spanning multiple days.
- Retention can be measured using the time between first and last transaction.

### Evidence

- Dataset observation period: **500 days**
- Users active for more than 30 days: **16,490**
- Longest observed activity span: **494 days**

---

## Decision

🟢 **Ready**

The available data supports measuring user retention using continued transaction activity over time.

---

---

# Question 9

## Business Question

**Does Crypto adoption influence user retention?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 9 | Does Crypto adoption influence user retention? | 🟢 Yes | Crypto adoption can be linked to users' transaction activity over time. | 🟢 | 🟢 | ⚪ | ⚪ | user_id<br>user_settings_crypto_unlocked<br>created_date | Retention is inferred from continued transaction activity because no explicit retention flag exists. Crypto adoption is represented by a binary flag. | 🟢 Ready |

---

## Validation Evidence

### Tables Verified

- ✅ users
- ✅ transactions

### Columns Verified

#### users

- user_id
- user_settings_crypto_unlocked
- created_date

#### transactions

- user_id
- created_date

---

## Validation Findings

The following checks were performed:

- Required tables exist.
- Required columns exist.
- Users can be classified by Crypto adoption.
- Crypto users can be linked to transaction history using **user_id**.
- Retention can be measured using the time between first and last transaction.

### Evidence

- Users with Crypto unlocked: **3,517**
- Users without Crypto unlocked: **15,913**
- Crypto users with transaction history: **3,479**
- Non-Crypto users with transaction history: **15,287**
- Average active days (Crypto): **263.4**
- Average active days (Non-Crypto): **203.7**

---

## Decision

🟢 **Ready**

The available data supports analysis of whether Crypto adoption influences user retention.

---

# Question 10

## Business Question

**Does Premium plan adoption influence user retention?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 10 | Does Premium plan adoption influence user retention? | 🟢 Yes | Subscription plan can be linked to users' transaction activity over time. | 🟢 | 🟢 | ⚪ | ⚪ | user_id<br>plan<br>created_date | Retention is inferred from continued transaction activity because no explicit retention flag exists. | 🟢 Ready |

---

## Validation Evidence

### Tables Verified

- ✅ users
- ✅ transactions

### Columns Verified

#### users

- user_id
- plan
- created_date

#### transactions

- user_id
- created_date

---

## Validation Findings

The following checks were performed:

- Required tables exist.
- Required columns exist.
- Users can be classified by subscription plan.
- Plans can be linked to transaction history using **user_id**.
- Retention can be measured using the time between first and last transaction.

### Evidence

- STANDARD users: **17,992**
- PREMIUM users: **865**
- METAL users: **507**
- Average active days (STANDARD): **209.6**
- Average active days (PREMIUM): **284.1**
- Average active days (METAL): **268.2**

---

## Decision

🟢 **Ready**

The available data supports analysis of whether Premium plan adoption influences user retention.

---


---

# Question 11

## Business Question

**Do referred users retain longer than non-referred users?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 11 | Do referred users retain longer than non-referred users? | 🔴 No | Referral fields exist but there are no successful referrals in the dataset. | 🟢 | 🟢 | ⚪ | ⚪ | user_id<br>num_successful_referrals<br>created_date | Because every user has zero successful referrals, no comparison between referred and non-referred users is possible. | 🔴 Not Ready |

---

## Validation Evidence

### Tables Verified

- ✅ users
- ✅ transactions

### Columns Verified

#### users

- user_id
- num_referrals
- num_successful_referrals
- created_date

#### transactions

- user_id
- created_date

---

## Validation Findings

The following checks were performed:

- Required tables exist.
- Required columns exist.
- User retention can be calculated from transaction history.
- Referral information exists.
- Every user has **0 successful referrals**, preventing comparison between referral groups.

### Evidence

- Total users: **19,430**
- Users with successful referrals: **0**

---

## Decision

🔴 **Not Ready**

The dataset does not contain successful referrals, so this business question cannot be answered.

---

# Question 12

## Business Question

**Does notification frequency influence user retention?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 12 | Does notification frequency influence user retention? | 🟢 Yes | Notification history can be linked to user retention behaviour. | ⚪ | 🟢 | 🟢 | ⚪ | user_id<br>created_date<br>reason<br>channel<br>status | Notification exposure is measured from notifications sent rather than user interactions. | 🟢 Ready |

---

## Validation Evidence

### Tables Verified

- ✅ notifications
- ✅ transactions

### Columns Verified

#### notifications

- user_id
- created_date
- reason
- channel
- status

#### transactions

- user_id
- created_date

---

## Validation Findings

The following checks were performed:

- Required tables exist.
- Required columns exist.
- Notifications can be linked to users.
- Retention can be calculated from transaction history.
- Notification frequency can be measured for each user.

### Evidence

- Total notifications: **121,813**
- Users receiving High notifications: **3,169**
- Users receiving Medium notifications: **8,867**
- Users receiving Low notifications: **6,301**

---

## Decision

🟢 **Ready**

The available data supports analysing whether notification frequency is associated with user retention.

---

# Question 13

## Business Question

**Do failed or declined transactions influence churn?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 13 | Do failed or declined transactions influence churn? | 🟢 Yes | Transaction states allow unsuccessful transactions to be identified and compared with user retention behaviour. | ⚪ | 🟢 | ⚪ | ⚪ | user_id<br>transactions_state<br>created_date | Churn is inferred from transaction inactivity because no explicit churn flag exists. | 🟢 Ready |

---

## Validation Evidence

### Tables Verified

- ✅ transactions

### Columns Verified

#### transactions

- user_id
- transactions_state
- created_date

---

## Validation Findings

The following checks were performed:

- Required table exists.
- Required columns exist.
- Failed, declined and other transaction states are available.
- Users can be grouped according to unsuccessful transaction history.
- Churn proxy can be calculated using transaction dates.

### Evidence

Transaction states include:

- COMPLETED
- DECLINED
- FAILED
- REVERTED
- PENDING
- CANCELLED

Users with failed or declined transactions can therefore be identified.

---

## Decision

🟢 **Ready**

The available data supports analysing whether unsuccessful transactions are associated with churn.

---

# Question 14

## Business Question

**Do specific transaction types influence churn?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 14 | Do specific transaction types influence churn? | 🔴 No | Transaction types exist, but no validated churn outcome currently exists. | ⚪ | 🟢 | ⚪ | ⚪ | user_id<br>transactions_type<br>created_date | Transaction types are available, but churn is only a proposed proxy and has not yet been defined or validated. | 🔴 Not Ready |

---

## Validation Evidence

### Tables Verified

- ✅ transactions

### Columns Verified

#### transactions

- user_id
- transactions_type
- created_date

---

## Validation Findings

The following checks were performed:

- Required table exists.
- Required columns exist.
- Multiple transaction types are available.
- Users can be grouped by transaction type.
- No validated churn variable currently exists.

### Evidence

Major transaction types include:

- CARD_PAYMENT
- TRANSFER
- TOPUP
- EXCHANGE
- ATM
- CASHBACK
- FEE
- CARD_REFUND
- REFUND
- TAX

---

## Decision

🔴 **Not Ready**

Transaction types are available, but a validated churn definition is required before this business question can be answered.

---

# Question 15

## Business Question

**Does country influence user churn?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 15 | Does country influence user churn? | 🟢 Yes | User country can be linked to transaction history to compare churn behaviour across markets. | 🟢 | 🟢 | ⚪ | ⚪ | user_id<br>country<br>created_date | Churn is inferred from transaction inactivity because no churn indicator exists. | 🟢 Ready |

---

## Validation Evidence

### Tables Verified

- ✅ users
- ✅ transactions

### Columns Verified

#### users

- user_id
- country
- created_date

#### transactions

- user_id
- created_date

---

## Validation Findings

The following checks were performed:

- Required tables exist.
- Required columns exist.
- Users can be grouped by country.
- Transactions can be linked using **user_id**.
- Retention and churn proxies can be calculated using transaction history.

### Evidence

- Countries represented: **41**
- Largest market: **GB (6,315 users)**
- Transaction history spans **500 days**, enabling cross-country behavioural comparisons.

---

## Decision

🟢 **Ready**

The available data supports analysing whether churn differs across countries.
