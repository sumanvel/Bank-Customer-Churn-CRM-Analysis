# Bank Customer Churn Analysis & CRM Dashboard

Analytical CRM project built for **Newton School's Data Science Capstone**. Acting as a data analyst hired by a bank, this project analyzes 10,000 customers to identify why they churn and what the bank should do about it — using SQL, Excel, and Power BI.

---

## Problem Statement

The bank wants to understand which customers are leaving, why, and where to focus retention efforts. The brief called for:
- SQL-based analysis of structured business questions
- A consolidated, clean dataset ready for reporting
- An interactive Power BI dashboard with slicers
- A written report justifying every finding with data, plus strategic recommendations

## Dataset

10,000 customers across 7 linked tables:

| Table | Contents |
|---|---|
| Bank_Churn | Credit score, tenure, balance, products, credit card flag, active flag, exit flag |
| CustomerInfo | Age, gender, salary, geography, join date |
| Geography / Gender / ActiveCustomer / CreditCard / ExitCustomer | Lookup tables for the categorical fields above |

No missing values or duplicate IDs were found. One real data-quality issue was identified and documented: **735 customers are flagged "Active Member" despite having exited** — a logical inconsistency in the `IsActiveMember` field (the `Exited` field was independently confirmed accurate).

## Methodology

1. **Data consolidation** — joined all 7 tables into a single master dataset in Excel, with decoded labels, credit-score segments, and age brackets added for analysis
2. **SQL** — wrote and validated 15+ queries answering structured business questions: segmentation, ranking with window functions, correlated subqueries (joining data without a `JOIN`), and schema modification
3. **Power BI** — built custom DAX measures (churn rate%, retention rate%, active%, credit card usage%) and a 4-page interactive dashboard with cross-filtering slicers (geography, gender, active status, credit card ownership, exit status)

## Key Findings

- **Age is the strongest churn driver.** Customers 50+ churn at **44.6%** — over 6x the rate of 18-30 year-olds (7.5%)
- **Product count is a red flag, not a success metric.** Churn is 27.7% at 1 product, drops to 7.6% at 2 products, then spikes to **82.7% at 3 products and 100% at 4 products**
- **Germany is high-value and high-risk.** Germany shows the highest churn rate (32.4%) *and* the highest average customer balance (~120K) — the bank is losing its most valuable customers fastest in one specific market
- **Active membership nearly halves churn risk** — 14.3% for active members vs. 26.9% for inactive
- **Exited customers carried a higher average balance (~91K)** than retained customers (~73K) — the bank isn't just losing headcount, it's losing value

## Strategic Recommendations

1. Prioritize retention offers for the 50+ segment
2. Launch a Germany-specific retention program given its churn/balance combination
3. Investigate the root cause of the 3-4 product churn spike before further cross-selling
4. Re-engage inactive members with targeted campaigns
5. Correct the 735-record `IsActiveMember` data-quality issue before using that field in any further modeling

## Repository Contents

- `data/` — consolidated master workbook and raw lookup tables
- `sql/` — all SQL queries with schema, tested against the real dataset
- `docs/` — full written report (26 objective + 14 subjective questions, each with approach, insights, and recommendations)
- `presentation/` — stakeholder-facing PowerPoint summary
- `assets/dashboard_screenshots/` — static previews of each dashboard page (see NovyPro link above for the live, interactive version)

## Tools Used
SQL (MySQL), Microsoft Excel, Power BI (DAX, data modeling, interactive dashboards)
