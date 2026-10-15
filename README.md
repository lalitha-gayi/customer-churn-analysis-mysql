# Customer Churn Analysis Using MySQL 8.0

Customer churn analysis using MySQL 8.0, including data cleaning, validation, and advanced SQL analysis.

## Project Overview

Customer churn occurs when customers stop using a company's services. Understanding why customers leave helps businesses identify high-risk customer groups and develop better retention strategies.

In this project, I used **MySQL 8.0** to clean, validate, and analyze customer data to identify churn patterns and generate actionable business insights.

## Project Objectives

- Clean and validate customer data using MySQL.
- Analyze overall customer churn and retention.
- Identify customer segments with higher churn rates.
- Explore relationships between churn, contract type, payment method, tenure, and services.
- Use advanced MySQL queries to compare customer segments.
- Recommend practical strategies to improve customer retention.

## Tools and Technologies

- **Database:** MySQL 8.0
- **SQL Environment:** MySQL Workbench
- **Techniques:** Data cleaning, data validation, aggregation, filtering, subqueries, Common Table Expressions (CTEs), and window functions.

## Dataset Information

- **Dataset:** IBM Telco Customer Churn
- **Total Records:** 7,043
- **Total Columns:** 21
- **Target Column:** `Churn`

The dataset contains customer demographics, subscribed services, contract details, payment methods, tenure, charges, and churn status.

### Database Tables

| Table | Purpose |
|---|---|
| `raw_telco_churn` | Stores the original imported data without cleaning modifications. |
| `cleaned_telco_churn` | Stores the prepared data used for analysis. |

## Data Cleaning and Validation

I prepared the data before performing the analysis.

- Preserved the original data in `raw_telco_churn`.
- Created `cleaned_telco_churn` for analysis.
- Converted numeric columns into appropriate data types.
- Handled blank `TotalCharges` values by converting them to `NULL`.
- Checked for missing customer IDs and duplicate customer IDs.
- Validated categorical values and service combinations.
- Verified record counts, numeric ranges, and churn totals.

### Data Quality Results

| Check | Result |
|---|---:|
| Total customer records | 7,043 |
| Unique customer IDs | 7,043 |
| Missing customer IDs | 0 |
| Duplicate customer IDs | 0 |
| Missing `MonthlyCharges` | 0 |
| Missing `TotalCharges` | 11 |

The 11 missing `TotalCharges` values were retained as `NULL` because these records have zero tenure. They were not arbitrarily replaced with zero or an estimated value.

## SQL Analysis Performed

### 1. Overall Churn Analysis
- Calculated total customers, churned customers, and retained customers.
- Calculated the overall churn rate.

### 2. Customer Segmentation
- Compared churn across contract types and payment methods.
- Analyzed churn by internet service, tenure, and senior-citizen status.
- Examined optional services, billing preferences, and customer demographics.

### 3. Charges Analysis
- Compared churn across monthly-charge ranges.
- Examined churn across total-charge ranges while considering missing values.

### 4. Advanced SQL Analysis
- Used CTEs to organize multi-step analysis.
- Used window functions such as `ROW_NUMBER()` and `DENSE_RANK()`.
- Compared segment churn rates with the overall churn rate.
- Identified high-churn combinations of contract type, payment method, and tenure.

## Key Findings

### Overall Churn

- **Total customers:** 7,043
- **Churned customers:** 1,869
- **Retained customers:** 5,174
- **Overall churn rate:** 26.54%

### Important Insights

1. **Contract type:** Month-to-month customers had a churn rate of **42.71%**, compared with 11.27% for one-year contracts and 2.83% for two-year contracts.

2. **Payment method:** Customers using electronic checks had a churn rate of **45.29%**, the highest among the four payment methods.

3. **Customer tenure:** Customers with 0–12 months of tenure had a churn rate of **47.44%**, compared with 9.51% for customers with 49–72 months of tenure.

4. **Internet service:** Fiber-optic customers had a churn rate of **41.89%**, compared with 18.96% for DSL customers.

5. **Support services:** Customers without tech support had a churn rate of **41.64%**, compared with 15.17% for customers with tech support.

6. **High-risk segment:** Month-to-month customers using electronic checks with 0–12 months of tenure had a churn rate of **63.10%** across 954 customers.

*These findings show associations in the dataset; they do not prove that any individual factor directly causes churn.*

## Business Recommendations

- Prioritize early engagement and retention campaigns for new customers.
- Review month-to-month customer experiences and explore suitable longer-term contract options.
- Investigate the reasons behind the high churn rate among electronic-check users.
- Evaluate whether better access to technical support and online security services could improve retention.
- Monitor high-risk customer segments regularly using updated data.

## Project Structure

```text
Customer-Churn-Analysis/
│
├── README.md
├── 01_data_cleaning.sql
├── 02_data_validation.sql
├── 03_exploratory_analysis.sql
└── 04_advanced_analysis.sql
```

*The filenames above are a suggested structure. Include these files only after creating them and verifying that they contain the corresponding SQL queries.*

## How to Run the Project

1. Install MySQL 8.0 and open MySQL Workbench.
2. Import the original dataset into a database.
3. Create and populate `raw_telco_churn`.
4. Run the data-cleaning queries to create `cleaned_telco_churn`.
5. Execute the validation, exploratory-analysis, and advanced-analysis scripts in order.
6. Compare the query results with the findings documented above.

## Conclusion

This project demonstrates how MySQL can be used to prepare data, validate data quality, analyze customer behavior, and identify customer segments with elevated churn rates.

It strengthened my practical skills in MySQL queries, data cleaning, aggregation, CTEs, window functions, and business-oriented SQL analysis.

**Project Focus:** MySQL 8.0 | Data Cleaning | Data Validation | Exploratory Analysis | Advanced SQL
