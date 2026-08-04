# Business Question Validation Results

## Purpose

This document records the validation performed for each business question before any data modelling or analysis begins.

The objective is to confirm that the available dataset contains the required tables, columns, and relationships needed to answer each business question.

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
| 2 | Does Crypto adoption influence user engagement? | 🟢 Yes | Crypto adoption can be compared with user transaction behaviour. | 🟢 | 🟢 | ⚪ | ⚪ | user_id<br>user_settings_crypto_unlocked<br>created_date | Crypto adoption is represented by the binary field user_settings_crypto_unlocked. The dataset indicates whether Crypto has been unlocked but does not record actual Crypto feature usage. Engagement is measured using the project's definition of regular transaction behaviour. | 🟢 Ready |

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
| 3 | Does Premium plan adoption influence user engagement? | 🟢 Yes | User subscription plan can be linked to transaction behaviour. | 🟢 | 🟢 | ⚪ | ⚪ | user_id, plan, created_date, amount_usd, transactions_state | Engagement is measured using the project's definition of regular transaction behaviour. | 🟢 Ready |

## Validation Evidence

### Tables Verified

- ✅ users
- ✅ transactions

### Columns Verified

Users

- user_id
- plan
- created_date

Transactions

- user_id
- created_date
- amount_usd
- transactions_state

## Validation Findings

The following checks were performed:

- Required columns verified.
- Users can be classified by subscription plan.
- Transactions are linked to users through **user_id**.
- The relationship enables comparison of engagement behaviour across subscription plans.

### Decision

🟢 Ready

The available data supports analysis of whether Premium plan adoption influences user engagement.
---

# Question 4

## Business Question

**Does notification frequency influence user engagement?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 4 | Does notification frequency influence user engagement? | 🟡 Partial | Notification delivery history can be linked to transaction behaviour, but user interaction with notifications is not recorded. | ⚪ | 🟢 | 🟢 | ⚪ | user_id<br>created_date<br>reason<br>channel<br>status | Engagement with notifications cannot be measured because open and click events are unavailable. Notification exposure is measured using notifications sent because the dataset does not contain notification interaction events (opens or clicks). | 🟡 Partial |

---

## Validation Evidence

### Tables Verified

- ✅ transactions
- ✅ notifications

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

- Required columns verified.
- Notifications can be linked to users through **user_id**.
- Notification history records when notifications were sent and why they were sent.
- Notification frequency can be calculated for each user.
- No notification interaction events (such as opens or clicks) are available.

### Evidence

- Users receiving notifications: **18,953**
- Average notifications per user: **6.43**
- Minimum notifications per user: **1**
- Maximum notifications per user: **289**

---

## Decision

🟡 **Partial**

The available data supports analysing notification frequency as a measure of notification exposure, but it cannot determine whether users engaged with those notifications.

---

---

# Question 5

## Business Question

Do merchant spending categories influence user engagement?

| # | Business Question | Can Answer | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|------------|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 5 | Do merchant spending categories influence user engagement? | 🟢 Yes | Merchant spending categories classify where users spend money, enabling behavioural analysis across different merchant types. | ⚪ | 🟢 | ⚪ | ⚪ | user_id, ea_merchant_mcc, amount_usd, created_date | Merchant category is available for 57.71% of transactions, so analyses using this field will exclude transactions where the merchant category is missing. | 🟢 Ready |

## Validation Evidence

### Tables Verified

- ✅ transactions

### Required columns

- user_id
- ea_merchant_mcc
- amount_usd
- created_date

## Validation Findings

The following checks were performed:

- The required merchant category field exists.
- The dataset contains **664 distinct merchant categories**.
- Merchant category is populated for **1,581,417 of 2,740,075 transactions (57.71%)**, providing sufficient coverage for merchant-based behavioural analysis.

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
| 6 | How does user engagement evolve over time across different countries? | 🟢 Yes | User country and transaction history allow engagement to be analysed across countries over time. | 🟢 | 🟢 | ⚪ | ⚪ | user_id<br>country<br>created_date<br>transaction_id | Country is recorded at user level and is assumed to remain stable throughout the analysis period. User engagement is measured using the project's definition of regular transaction behaviour. | 🟢 Ready |

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
| 7 | Does device brand influence user engagement? | 🟢 Yes | Device brand can be linked to transaction behaviour through user_id. | ⚪ | 🟢 | ⚪ | 🟢 | string_field_0<br>string_field_1<br>user_id<br>created_date | The devices table uses generic column names (string_field_0, string_field_1), but validation confirmed these represent device brand and user identifier. The fields will be renamed during staging. | 🟢 Ready |

---

## Validation Evidence

### Tables Verified

- ✅ devices
- ✅ transactions

### Columns Verified

#### devices

- string_field_0 (device brand)
- string_field_1 (user_id)

#### transactions

- user_id
- created_date

---

## Validation Findings

The following checks were performed:

- Required tables exist.
- Device brands are populated.
- Device records can be linked to transactions using **user_id**.
- Device brand distribution has been validated.

### Evidence

- Android: **9,714**
- Apple: **9,673**
- Unknown: **43**
- Header row imported as data: **1** (to be removed during staging)

---

## Decision

🟢 **Ready**

The available data supports analysing whether user engagement differs between device brands after standard staging removes the imported header row.

---

---

# Question 8

## Business Question

**Does transaction frequency influence user retention?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 8 | Does transaction frequency influence user retention? | 🟢 Yes | Transaction history allows users' activity to be measured over time. | 🟢 | 🟢 | ⚪ | ⚪ | user_id<br>created_date<br>amount_usd<br>transactions_state | Retention is measured using the project's definition of continued transaction activity over time. The dataset does not contain an explicit retention label. | 🟢 Ready |

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
| 9 | Does Crypto adoption influence user retention? | 🟢 Yes | Crypto adoption can be linked to users' transaction activity over time. | 🟢 | 🟢 | ⚪ | ⚪ | user_id<br>user_settings_crypto_unlocked<br>created_date | Retention is measured using the project's definition of continued transaction activity over time. The dataset does not contain an explicit retention label. Crypto adoption is represented by a binary flag. | 🟢 Ready |

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
| 10 | Does Premium plan adoption influence user retention? | 🟢 Yes | Subscription plan can be linked to users' transaction activity over time. | 🟢 | 🟢 | ⚪ | ⚪ | user_id<br>plan<br>created_date | Retention is measured using the project's definition of continued transaction activity over time. The dataset does not contain an explicit retention label. | 🟢 Ready |

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
| 12 | Does notification frequency influence user retention? | 🟢 Yes | Notification history can be linked to user retention behaviour. | ⚪ | 🟢 | 🟢 | ⚪ | user_id<br>created_date<br>reason<br>channel<br>status | Notification exposure is measured from notifications sent rather than user interactions. Retention is measured using the project's definition of continued transaction activity over time. | 🟢 Ready |

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
- Notification frequency can be calculated for each user.

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
| 13 | Do failed or declined transactions influence churn? | 🟢 Yes | Transaction states allow unsuccessful transactions to be identified and compared against the project's churn definition based on transaction inactivity. | ⚪ | 🟢 | ⚪ | ⚪ | user_id<br>transactions_state<br>created_date | Churn is measured using the project's definition of transaction inactivity during the observation period. The dataset does not contain an explicit churn label. The dataset does not contain an explicit churn label. | 🟢 Ready |

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
- The project's churn metric can be measured using each user's transaction history.

### Evidence

Transaction states include:

- COMPLETED
- DECLINED
- FAILED
- REVERTED
- PENDING
- CANCELLED

Additional validation:

- Users with transaction history: **18,766**
- Average transactions per active user: **146.0**
- Minimum transactions per user: **1**
- Maximum transactions per user: **5,285**

---

## Decision

🟢 **Ready**

The available data supports analysing whether unsuccessful transaction history is associated with higher churn risk using the project's churn definition.

---

---


# Question 14

## Business Question

**Do specific transaction types influence churn?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 14 | Do specific transaction types influence churn? | 🟢 Yes | Transaction types can be linked to users' transaction history to evaluate their relationship with the project's defined churn metric. | ⚪ | 🟢 | ⚪ | ⚪ | user_id<br>transactions_type<br>created_date | Churn is measured using the project's definition of transaction inactivity during the observation period. | 🟢 Ready |

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
- Transaction history contains the information required to calculate the project's defined churn metric.

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

Additional validation:

- Users with transaction history: **18,766**
- Average transactions per active user: **146.0**
- Maximum transactions observed: **5,285**

---

## Decision

🟢 **Ready**

The available data supports analysing whether different transaction types are associated with higher churn risk using the project's defined churn metric.

---

---


# Question 15

## Business Question

**Does country influence user churn?**

| # | Business Question | Can Answer? | Why | Users | Transactions | Notifications | Devices | Key Columns | Assumptions & Limitations | Conclusion |
|---|-------------------|:-----------:|------|:-----:|:------------:|:-------------:|:-------:|-------------|---------------------------|------------|
| 15 | Does country influence user churn? | 🟢 Yes | User country can be linked to transaction history to compare the project's churn metric across countries. | 🟢 | 🟢 | ⚪ | ⚪ | user_id<br>country<br>created_date | Churn is measured using the project's definition of transaction inactivity during the observation period. The dataset does not contain an explicit churn label. Country is assumed to remain stable throughout the observation period. | 🟢 Ready |

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
- The project's churn metric can be calculated using transaction history.

### Evidence

- Countries represented: **41**
- Largest market: **GB (6,315 users)**
- Transaction period: **2018-01-01 to 2019-05-16 (500 days)**
- Users with transaction history: **18,766**
- Average transactions per active user: **146.0**

---

## Decision

🟢 **Ready**

The available data supports analysing whether churn differs across countries using the project's defined churn metric.
