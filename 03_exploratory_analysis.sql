-- Customer Churn Analysis | MySQL 8.0
-- EXPLORATORY ANALYSIS
-- Prerequisite: raw_telco_churn is populated and cleaned_telco_churn has been created.
-- Original SQL statements below are preserved as written.

USE customer_churn_analysis;

SELECT
    COUNT(*) AS total_customers,
    SUM(Churn = 'Yes') AS churned_customers,
    SUM(Churn = 'No') AS retained_customers,
    ROUND(
        SUM(Churn = 'Yes') * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM cleaned_telco_churn;

SELECT
    Contract,
    COUNT(*) AS total_customers,
    SUM(Churn = 'Yes') AS churned_customers,
    ROUND(
        SUM(Churn = 'Yes') * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM cleaned_telco_churn
GROUP BY Contract
ORDER BY churn_rate_percentage DESC;

SELECT
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(Churn = 'Yes') AS churned_customers,
    ROUND(
        SUM(Churn = 'Yes') * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM cleaned_telco_churn
GROUP BY PaymentMethod
ORDER BY churn_rate_percentage DESC;

SELECT
    InternetService,
    COUNT(*) AS total_customers,
    SUM(Churn = 'Yes') AS churned_customers,
    ROUND(
        SUM(Churn = 'Yes') * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM cleaned_telco_churn
GROUP BY InternetService
ORDER BY churn_rate_percentage DESC;

SELECT
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
        WHEN tenure BETWEEN 49 AND 72 THEN '49-72 months'
    END AS tenure_group,

    COUNT(*) AS total_customers,

    SUM(Churn = 'Yes') AS churned_customers,

    ROUND(
        SUM(Churn = 'Yes') * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM cleaned_telco_churn
GROUP BY tenure_group
ORDER BY MIN(tenure);

SELECT
    CASE
        WHEN SeniorCitizen = 1 THEN 'Senior Citizen'
        ELSE 'Non-Senior Citizen'
    END AS customer_group,

    COUNT(*) AS total_customers,

    SUM(Churn = 'Yes') AS churned_customers,

    ROUND(
        SUM(Churn = 'Yes') * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage

FROM cleaned_telco_churn
GROUP BY SeniorCitizen
ORDER BY churn_rate_percentage DESC;

SELECT
    TechSupport,
    COUNT(*) AS total_customers,
    SUM(Churn = 'Yes') AS churned_customers,
    ROUND(
        SUM(Churn = 'Yes') * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM cleaned_telco_churn
GROUP BY TechSupport
ORDER BY churn_rate_percentage DESC;

SELECT
    OnlineSecurity,
    COUNT(*) AS total_customers,
    SUM(Churn = 'Yes') AS churned_customers,
    ROUND(
        SUM(Churn = 'Yes') * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM cleaned_telco_churn
GROUP BY OnlineSecurity
ORDER BY churn_rate_percentage DESC;

SELECT
    PaperlessBilling,
    COUNT(*) AS total_customers,
    SUM(Churn = 'Yes') AS churned_customers,
    ROUND(
        SUM(Churn = 'Yes') * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM cleaned_telco_churn
GROUP BY PaperlessBilling
ORDER BY churn_rate_percentage DESC;

SELECT 'Gender' AS column_name,
       gender AS category,
       COUNT(*) AS total_customers,
       SUM(Churn = 'Yes') AS churned_customers,
       ROUND(SUM(Churn = 'Yes') * 100.0 / COUNT(*), 2) AS churn_rate_percentage
FROM cleaned_telco_churn
GROUP BY gender

UNION ALL

SELECT 'Partner', Partner, COUNT(*), SUM(Churn = 'Yes'),
       ROUND(SUM(Churn = 'Yes') * 100.0 / COUNT(*), 2)
FROM cleaned_telco_churn
GROUP BY Partner

UNION ALL

SELECT 'Dependents', Dependents, COUNT(*), SUM(Churn = 'Yes'),
       ROUND(SUM(Churn = 'Yes') * 100.0 / COUNT(*), 2)
FROM cleaned_telco_churn
GROUP BY Dependents

UNION ALL

SELECT 'PhoneService', PhoneService, COUNT(*), SUM(Churn = 'Yes'),
       ROUND(SUM(Churn = 'Yes') * 100.0 / COUNT(*), 2)
FROM cleaned_telco_churn
GROUP BY PhoneService

UNION ALL

SELECT 'MultipleLines', MultipleLines, COUNT(*), SUM(Churn = 'Yes'),
       ROUND(SUM(Churn = 'Yes') * 100.0 / COUNT(*), 2)
FROM cleaned_telco_churn
GROUP BY MultipleLines

UNION ALL

SELECT 'OnlineBackup', OnlineBackup, COUNT(*), SUM(Churn = 'Yes'),
       ROUND(SUM(Churn = 'Yes') * 100.0 / COUNT(*), 2)
FROM cleaned_telco_churn
GROUP BY OnlineBackup

UNION ALL

SELECT 'DeviceProtection', DeviceProtection, COUNT(*), SUM(Churn = 'Yes'),
       ROUND(SUM(Churn = 'Yes') * 100.0 / COUNT(*), 2)
FROM cleaned_telco_churn
GROUP BY DeviceProtection

UNION ALL

SELECT 'StreamingTV', StreamingTV, COUNT(*), SUM(Churn = 'Yes'),
       ROUND(SUM(Churn = 'Yes') * 100.0 / COUNT(*), 2)
FROM cleaned_telco_churn
GROUP BY StreamingTV

UNION ALL

SELECT 'StreamingMovies', StreamingMovies, COUNT(*), SUM(Churn = 'Yes'),
       ROUND(SUM(Churn = 'Yes') * 100.0 / COUNT(*), 2)
FROM cleaned_telco_churn
GROUP BY StreamingMovies

ORDER BY column_name, churn_rate_percentage DESC;

SELECT
    column_name,
    charge_group,
    total_customers,
    churned_customers,
    ROUND(
        churned_customers * 100.0 / total_customers,
        2
    ) AS churn_rate_percentage
FROM (
    SELECT
        'MonthlyCharges' AS column_name,
        CASE
            WHEN MonthlyCharges <= 35 THEN '01. 35 or less'
            WHEN MonthlyCharges <= 70 THEN '02. 35.01-70'
            WHEN MonthlyCharges <= 100 THEN '03. 70.01-100'
            ELSE '04. Above 100'
        END AS charge_group,
        COUNT(*) AS total_customers,
        SUM(Churn = 'Yes') AS churned_customers
    FROM cleaned_telco_churn
    GROUP BY charge_group

    UNION ALL

    SELECT
        'TotalCharges' AS column_name,
        CASE
            WHEN TotalCharges IS NULL THEN '05. Missing'
            WHEN TotalCharges <= 500 THEN '01. 500 or less'
            WHEN TotalCharges <= 1500 THEN '02. 500.01-1500'
            WHEN TotalCharges <= 3000 THEN '03. 1500.01-3000'
            ELSE '04. Above 3000'
        END AS charge_group,
        COUNT(*) AS total_customers,
        SUM(Churn = 'Yes') AS churned_customers
    FROM cleaned_telco_churn
    GROUP BY charge_group
) AS charge_analysis
ORDER BY column_name, charge_group;

SELECT
    Contract,
    CASE
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        ELSE '49-72 months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(Churn = 'Yes') AS churned_customers,
    ROUND(
        SUM(Churn = 'Yes') * 100.0 / COUNT(*),
        2
    ) AS churn_rate_percentage
FROM cleaned_telco_churn
GROUP BY
    Contract,
    CASE
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        ELSE '49-72 months'
    END
ORDER BY Contract, MIN(tenure);
