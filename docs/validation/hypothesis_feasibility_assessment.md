# Hypothesis Feasibility Assessment

## Purpose

The purpose of this assessment is to determine whether each hypothesis can be meaningfully investigated using the available data before analysis begins.

Unlike the Data Quality Audit, which evaluates whether the dataset is reliable, this assessment evaluates whether each hypothesis is practically testable. It ensures that sufficient observations, meaningful group distributions and appropriate historical coverage exist before prioritising analytical work.

This assessment acts as the final quality gate before investigation prioritisation.

---

# Workflow

Business Questions
→ Business Question Validation
→ Hypotheses
→ Data Quality Audit
→ Hypothesis Feasibility Assessment
→ Investigation Backlog
→ SQL Analysis
→ Business Recommendations

---

# Assessment Structure

Each hypothesis is assessed using the following framework.

| Column | Description |
|---------|-------------|
| **Hypothesis** | The analytical hypothesis being evaluated. |
| **What is being validated?** | The aspect of the dataset that must be validated before analysis can begin. |
| **Validation Method** | The method used to evaluate whether sufficient data exists. |
| **Evidence** | Objective observations returned by the validation. Evidence should contain factual results only. |
| **Finding** | Interpretation of the evidence and its implications for the hypothesis. |
| **Decision** | Final decision regarding whether the hypothesis is suitable for investigation. |

---

# Documentation Guidelines

## Evidence

Evidence should contain only objective observations obtained from the validation.

Examples

- Android: 9,714 users
- Apple: 9,673 users
- Standard: 17,992 users
- Premium: 1,438 users
- 196,000 failed transactions across more than 15,000 users

Evidence should not contain interpretation.

---

## Findings

Findings interpret the evidence.

Each finding should explain whether the available data is sufficient to investigate the hypothesis.

Example

Evidence

Android: 9,714 users

Apple: 9,673 users

Finding

Device brands are sufficiently balanced to investigate whether engagement differs across device brands.

---

## Decisions

The following decision categories are used throughout the project.

| Decision | Meaning |
|----------|---------|
| ✅ Suitable | The hypothesis can be investigated with confidence. |
| ⚠️ Suitable with caution | Analysis is feasible but data limitations should be acknowledged. |
| ⏳ Pending validation | Additional validation is required before prioritisation. |
| ❌ Remove hypothesis | The hypothesis cannot be meaningfully investigated with the available data. |

---

# Assessment Results

| ID | Hypothesis | What is being validated? | Validation Method | Evidence | Finding | Decision |
|----|------------|--------------------------|-------------------|----------|----------|----------|
| H1 | User engagement differs according to transaction frequency. | Distribution of completed transactions per user. | Transaction frequency distribution. | 18,529 users with completed transactions. Distribution: 1 (803), 2–10 (3,355), 11–50 (5,127), 51–100 (3,106), 101–500 (5,118), 501–1000 (772), 1000+ (248). | Transaction frequency is well distributed across multiple activity levels, supporting meaningful comparison of engagement between user groups. | ✅ Suitable |
| H2 | User engagement differs between users with and without Crypto enabled. | Distribution of crypto-enabled users. | User count comparison. | Crypto Enabled: 3,517 users. Crypto Disabled: 15,913 users. | Both comparison groups contain sufficient observations to investigate differences in engagement. | ✅ Suitable |
| H3 | User engagement differs between Premium and Standard users. | Distribution of subscription plans. | User count comparison after grouping Premium plans. | Standard: 17,992 users. Premium: 1,438 users. | Premium users are substantially fewer than Standard users but remain sufficiently represented for comparison. Results should be interpreted with caution. | ⚠️ Suitable with caution |
| H4 | User engagement differs according to notification frequency. | Distribution of notification activity. | Notification frequency distribution. | 18,953 users. Distribution: 1 (681), 2–5 (8,296), 6–10 (7,690), 11–20 (2,139), 21–50 (135), 50+ (12). | Notification activity spans multiple frequency ranges, allowing meaningful comparison between engagement groups. | ✅ Suitable |
| H5 | User engagement differs across merchant spending categories. | Distribution of merchant categories. | Merchant category distribution. | More than 50 populated merchant categories with large transaction volumes across major MCC groups. | Merchant spending categories provide sufficient coverage to compare engagement across spending behaviour. | ✅ Suitable |
| H6 | User engagement evolves differently across countries over time. | Distribution of users across countries. | Country distribution. | 41 countries represented. Largest groups include GB (6,315), PL (2,306), FR (2,110), IE (1,214), RO (1,096). | Multiple countries contain sufficient user populations to support meaningful comparison over time. | ✅ Suitable |
| H7 | User engagement differs across device brands. | Distribution of device brands. | Device brand distribution. | Android: 9,714 users. Apple: 9,673 users. Unknown: 43 users. | Android and Apple users are almost perfectly balanced, providing an excellent basis for comparison. | ✅ Suitable |
| H8 | User retention differs according to transaction frequency. | Distribution of completed transactions per user. | Transaction frequency distribution. | Same evidence as H1. | Transaction frequency is well distributed across multiple activity levels, supporting meaningful comparison of retention between user groups. | ✅ Suitable |
| H9 | User retention differs between users with and without Crypto enabled. | Distribution of crypto-enabled users. | User count comparison. | Same evidence as H2. | Both comparison groups contain sufficient observations to investigate differences in retention. | ✅ Suitable |
| H10 | User retention differs between Premium and Standard users. | Distribution of subscription plans. | User count comparison after grouping Premium plans. | Same evidence as H3. | Premium users remain sufficiently represented for comparison, although the imbalance should be considered during interpretation. | ⚠️ Suitable with caution |
| H11 | User retention differs between referred and non-referred users. | Distribution of referred users. | Referral status distribution. | All 19,430 users have zero successful referrals. | No comparison group exists, making this hypothesis infeasible with the available data. | ❌ Remove hypothesis |
| H12 | User retention differs according to notification frequency. | Distribution of notification activity. | Notification frequency distribution. | Same evidence as H4. | Notification activity spans multiple frequency ranges, supporting comparison of retention across user groups. | ✅ Suitable |
| H13 | Churn differs according to the frequency of failed or declined transactions. | Distribution of failed or declined transactions. | Transaction state distribution. | Approximately 196,000 failed or declined transactions across more than 15,000 affected users. | Failed and declined transactions occur frequently enough to investigate their relationship with churn. | ✅ Suitable |
| H14 | Churn differs across dominant transaction types. | Distribution of transaction types. | Transaction type distribution. | Card Payment: 1,475,780; Transfer: 500,409; Top-up: 388,331; Exchange: 159,148; ATM: 93,675; Cashback: 82,789; Fee: 23,659; Card Refund: 11,962; Tax: 2,829; Refund: 1,493. | Multiple transaction types contain substantial transaction volumes, enabling meaningful comparison of churn across user behaviours. | ✅ Suitable |
| H15 | Churn differs across countries. | Distribution of users across countries. | Country distribution. | Same evidence as H6. | Multiple countries contain sufficient observations to investigate differences in churn. | ✅ Suitable |

---

# Summary

The Hypothesis Feasibility Assessment confirmed that 14 of the 15 hypotheses could be meaningfully investigated using the available data.

Only the referral hypothesis was excluded due to the absence of referred users within the dataset.

The remaining hypotheses demonstrated sufficient observations, category representation and behavioural variation to support subsequent SQL analysis and prioritisation.
