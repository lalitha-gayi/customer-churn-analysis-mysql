-- Customer Churn Analysis | MySQL 8.0
-- ADVANCED ANALYSIS
-- Includes CTEs, DENSE_RANK(), ROW_NUMBER(), and segment comparisons.
-- Prerequisite: cleaned_telco_churn has been created and validated.
-- Original SQL statements below are preserved as written.

USE customer_churn_analysis;

WITH overall_churn AS (
    SELECT
        SUM(Churn = 'Yes') * 100.0 / COUNT(*) AS overall_churn_rate
    FROM cleaned_telco_churn
),
segment_analysis AS (
    SELECT
        Contract,
        PaymentMethod,
        COUNT(*) AS total_customers,
        SUM(Churn = 'Yes') AS churned_customers,
        ROUND(
            SUM(Churn = 'Yes') * 100.0 / COUNT(*),
            2
        ) AS segment_churn_rate
    FROM cleaned_telco_churn
    GROUP BY Contract, PaymentMethod
)
SELECT
    s.Contract,
    s.PaymentMethod,
    s.total_customers,
    s.churned_customers,
    s.segment_churn_rate,
    ROUND(o.overall_churn_rate, 2) AS overall_churn_rate
FROM segment_analysis AS s
CROSS JOIN overall_churn AS o
WHERE s.segment_churn_rate > o.overall_churn_rate
ORDER BY s.segment_churn_rate DESC;

WITH segment_analysis AS (
    SELECT
        Contract,
        PaymentMethod,
        COUNT(*) AS total_customers,
        SUM(Churn = 'Yes') AS churned_customers,
        ROUND(
            SUM(Churn = 'Yes') * 100.0 / COUNT(*),
            2
        ) AS churn_rate
    FROM cleaned_telco_churn
    GROUP BY Contract, PaymentMethod
),
ranked_segments AS (
    SELECT
        Contract,
        PaymentMethod,
        total_customers,
        churned_customers,
        churn_rate,
        DENSE_RANK() OVER (
            ORDER BY churn_rate DESC
        ) AS churn_rank
    FROM segment_analysis
)
SELECT
    churn_rank,
    Contract,
    PaymentMethod,
    total_customers,
    churned_customers,
    churn_rate
FROM ranked_segments
WHERE churn_rank <= 10
ORDER BY churn_rank, Contract, PaymentMethod;

WITH payment_analysis AS (
    SELECT
        Contract,
        PaymentMethod,
        COUNT(*) AS total_customers,
        SUM(Churn = 'Yes') AS churned_customers,
        ROUND(
            SUM(Churn = 'Yes') * 100.0 / COUNT(*),
            2
        ) AS churn_rate
    FROM cleaned_telco_churn
    GROUP BY Contract, PaymentMethod
),
ranked_payments AS (
    SELECT
        Contract,
        PaymentMethod,
        total_customers,
        churned_customers,
        churn_rate,
        ROW_NUMBER() OVER (
            PARTITION BY Contract
            ORDER BY churn_rate DESC
        ) AS row_num
    FROM payment_analysis
)
SELECT
    Contract,
    PaymentMethod,
    total_customers,
    churned_customers,
    churn_rate
FROM ranked_payments
WHERE row_num = 1
ORDER BY churn_rate DESC;

WITH payment_analysis AS (
    SELECT
        Contract,
        PaymentMethod,
        COUNT(*) AS total_customers,
        SUM(Churn = 'Yes') AS churned_customers,
        ROUND(
            SUM(Churn = 'Yes') * 100.0 / COUNT(*),
            2
        ) AS churn_rate
    FROM cleaned_telco_churn
    GROUP BY Contract, PaymentMethod
),
contract_comparison AS (
    SELECT
        Contract,
        PaymentMethod,
        total_customers,
        churned_customers,
        churn_rate,
        ROUND(
            AVG(churn_rate) OVER (
                PARTITION BY Contract
            ),
            2
        ) AS contract_average_churn_rate
    FROM payment_analysis
)
SELECT
    Contract,
    PaymentMethod,
    total_customers,
    churned_customers,
    churn_rate,
    contract_average_churn_rate
FROM contract_comparison
WHERE churn_rate > contract_average_churn_rate
ORDER BY Contract, churn_rate DESC;

WITH segment_analysis AS (
    SELECT
        Contract,
        PaymentMethod,
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
        ) AS churn_rate
    FROM cleaned_telco_churn
    GROUP BY
        Contract,
        PaymentMethod,
        CASE
            WHEN tenure <= 12 THEN '0-12 months'
            WHEN tenure <= 24 THEN '13-24 months'
            WHEN tenure <= 48 THEN '25-48 months'
            ELSE '49-72 months'
        END
),
ranked_segments AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY churn_rate DESC, total_customers DESC
        ) AS segment_rank
    FROM segment_analysis
)
SELECT
    segment_rank,
    Contract,
    PaymentMethod,
    tenure_group,
    total_customers,
    churned_customers,
    churn_rate
FROM ranked_segments
WHERE segment_rank <= 5
ORDER BY segment_rank;

WITH overall_churn AS (
    SELECT
        SUM(Churn = 'Yes') * 100.0 / COUNT(*) AS overall_rate
    FROM cleaned_telco_churn
),
segment_analysis AS (
    SELECT
        Contract,
        PaymentMethod,
        CASE
            WHEN tenure <= 12 THEN '0-12 months'
            WHEN tenure <= 24 THEN '13-24 months'
            WHEN tenure <= 48 THEN '25-48 months'
            ELSE '49-72 months'
        END AS tenure_group,
        COUNT(*) AS total_customers,
        SUM(Churn = 'Yes') AS churned_customers,
        SUM(Churn = 'Yes') * 100.0 / COUNT(*) AS segment_rate
    FROM cleaned_telco_churn
    GROUP BY
        Contract,
        PaymentMethod,
        CASE
            WHEN tenure <= 12 THEN '0-12 months'
            WHEN tenure <= 24 THEN '13-24 months'
            WHEN tenure <= 48 THEN '25-48 months'
            ELSE '49-72 months'
        END
)
SELECT
    s.Contract,
    s.PaymentMethod,
    s.tenure_group,
    s.total_customers,
    s.churned_customers,
    ROUND(s.segment_rate, 2) AS segment_churn_rate,
    ROUND(o.overall_rate, 2) AS overall_churn_rate,
    ROUND(s.segment_rate - o.overall_rate, 2) AS difference_percentage_points
FROM segment_analysis AS s
CROSS JOIN overall_churn AS o
WHERE s.total_customers >= 100
ORDER BY difference_percentage_points DESC
LIMIT 10;
