# Customer Churn Analysis Using MySQL 8.0

## Project Overview

Customer churn occurs when customers stop using a company's services. Understanding churn helps businesses identify high-risk customer groups and improve customer retention.

In this project, I used MySQL 8.0 to clean, validate, and analyze customer data, identify churn patterns, and generate business insights.

## Project Objectives

- Clean and validate customer data.
- Analyze customer churn and retention rates.
- Identify customer segments with high churn rates.
- Explore churn patterns based on contracts, payment methods, tenure, and services.
- Apply advanced MySQL techniques to compare customer segments.
- Recommend actions to improve customer retention.

## Tools Used

- MySQL 8.0
- MySQL Workbench

## Dataset Information

- **Dataset:** IBM Telco Customer Churn
- **Total Records:** 7,043
- **Total Columns:** 21
- **Target Column:** `Churn`

The dataset contains customer demographics, subscribed services, contract details, payment methods, tenure, charges, and churn status.

### Database Tables

| Table | Purpose |
|---|---|
| `raw_telco_churn` | Preserves the original imported data. |
| `cleaned_telco_churn` | Contains prepared data for analysis. |

## Data Cleaning and Validation

I used MySQL to prepare and validate the dataset before analysis.

- Preserved the original data in `raw_telco_churn`.
- Created `cleaned_telco_churn` for analysis.
- Converted numeric columns to appropriate data types.
- Converted blank `TotalCharges` values to `NULL`.
- Checked missing customer IDs and duplicate customer IDs.
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

The 11 missing `TotalCharges` values were retained as `NULL` because those customers have zero tenure. They were not replaced with arbitrary values.

## SQL Analysis

### 1. Overall Churn Analysis
- Calculated total, churned, and retained customers.
- Calculated the overall churn rate.

### 2. Customer Segmentation
- Analyzed churn by contract type and payment method.
- Compared churn by internet service, tenure, and senior-citizen status.
- Examined optional services, billing preferences, and customer demographics.

### 3. Charges Analysis
- Compared churn across monthly-charge ranges.
- Analyzed total-charge ranges while accounting for missing values.

### 4. Advanced SQL Analysis
- Used Common Table Expressions (CTEs).
- Applied `ROW_NUMBER()` and `DENSE_RANK()`.
- Compared segment churn rates with the overall churn rate.
- Identified high-churn combinations of contract type, payment method, and tenure.

## Key Findings

### Overall Churn

- **Total customers:** 7,043
- **Churned customers:** 1,869
- **Retained customers:** 5,174
- **Overall churn rate:** 26.54%

### Important Insights

1. **Contract type:** Month-to-month customers had a churn rate of 42.71%, compared with 11.27% for one-year contracts and 2.83% for two-year contracts.

2. **Payment method:** Customers using electronic checks had the highest payment-method churn rate at 45.29%.

3. **Customer tenure:** Customers with 0–12 months of tenure had a churn rate of 47.44%, compared with 9.51% for customers with 49–72 months of tenure.

4. **Internet service:** Fiber-optic customers had a churn rate of 41.89%, compared with 18.96% for DSL customers.

5. **Tech support:** Customers without tech support had a churn rate of 41.64%, compared with 15.17% for customers with tech support.

6. **High-risk segment:** Month-to-month customers using electronic checks with 0–12 months of tenure had a churn rate of 63.10% across 954 customers.

These findings show associations in the dataset; they do not prove that any individual factor directly causes churn.

## Business Recommendations

- Prioritize retention campaigns for new customers.
- Review the experience of month-to-month customers and explore suitable longer-term contract options.
- Investigate why electronic-check users have higher churn.
- Evaluate whether better access to technical support and online security services could improve retention.
- Monitor high-risk customer segments regularly.

## Project Structure

The repository will contain SQL scripts organized by project stage:

- `01_data_cleaning.sql`
- `02_data_validation.sql`
- `03_exploratory_analysis.sql`
- `04_advanced_analysis.sql`

These files should be added after the corresponding SQL scripts have been created and verified.

## How to Run

1. Install MySQL 8.0 and open MySQL Workbench.
2. Import the original dataset into a database.
3. Create and populate `raw_telco_churn`.
4. Run the cleaning queries to create `cleaned_telco_churn`.
5. Execute the validation and analysis scripts in order.
6. Compare the results with the findings documented above.

## Conclusion

This project demonstrates how MySQL can be used for data cleaning, data validation, exploratory analysis, and advanced SQL-based customer segmentation.

It strengthened my practical skills in MySQL queries, aggregation, CTEs, window functions, and business-oriented SQL analysis.

**Project Focus:** MySQL 8.0 | Data Cleaning | Data Validation | Exploratory Analysis | Advanced SQL
