CREATE DATABASE customer_churn_analysis;
USE customer_churn_analysis;
SHOW DATABASES;
SELECT DATABASE();

USE customer_churn_analysis;

CREATE TABLE raw_telco_churn (
    customerID VARCHAR(50),
    gender VARCHAR(50),
    SeniorCitizen VARCHAR(50),
    Partner VARCHAR(50),
    Dependents VARCHAR(50),
    tenure VARCHAR(50),
    PhoneService VARCHAR(50),
    MultipleLines VARCHAR(50),
    InternetService VARCHAR(50),
    OnlineSecurity VARCHAR(50),
    OnlineBackup VARCHAR(50),
    DeviceProtection VARCHAR(50),
    TechSupport VARCHAR(50),
    StreamingTV VARCHAR(50),
    StreamingMovies VARCHAR(50),
    Contract VARCHAR(100),
    PaperlessBilling VARCHAR(50),
    PaymentMethod VARCHAR(100),
    MonthlyCharges VARCHAR(50),
    TotalCharges VARCHAR(50),
    Churn VARCHAR(50)
);

SHOW TABLES;

DESCRIBE raw_telco_churn;

SELECT COUNT(*) AS total_rows
FROM raw_telco_churn;

SELECT COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'customer_churn_analysis'
  AND TABLE_NAME = 'raw_telco_churn';

SELECT *
FROM raw_telco_churn
LIMIT 10;

SELECT COUNT(*) AS missing_customer_ids
FROM raw_telco_churn
WHERE customerID IS NULL
   OR TRIM(customerID) = '';

SELECT
    customerID,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY customerID
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN TotalCharges IS NULL
              OR TRIM(TotalCharges) = ''
            THEN 1
            ELSE 0
        END
    ) AS blank_total_charges
FROM raw_telco_churn;

SELECT
    customerID,
    tenure,
    MonthlyCharges,
    TotalCharges,
    Contract,
    Churn
FROM raw_telco_churn
WHERE TotalCharges IS NULL
   OR TRIM(TotalCharges) = ''
ORDER BY tenure;

SELECT
    tenure,
    COUNT(*) AS affected_customers
FROM raw_telco_churn
WHERE TotalCharges IS NULL
   OR TRIM(TotalCharges) = ''
GROUP BY tenure
ORDER BY tenure;


SELECT
    Churn,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY Churn
ORDER BY Churn;


SELECT
    tenure,
    COUNT(*) AS record_count
FROM raw_telco_churn
WHERE tenure IS NULL
   OR TRIM(tenure) = ''
   OR TRIM(tenure) NOT REGEXP '^[0-9]+$'
   OR CAST(TRIM(tenure) AS UNSIGNED) > 72
GROUP BY tenure
ORDER BY tenure;


SELECT
    MonthlyCharges,
    COUNT(*) AS record_count
FROM raw_telco_churn
WHERE MonthlyCharges IS NULL
   OR TRIM(MonthlyCharges) = ''
   OR TRIM(MonthlyCharges) NOT REGEXP '^[0-9]+([.][0-9]+)?$'
   OR CAST(TRIM(MonthlyCharges) AS DECIMAL(10,2)) < 0
   OR CAST(TRIM(MonthlyCharges) AS DECIMAL(10,2)) > 200
GROUP BY MonthlyCharges
ORDER BY MonthlyCharges;


SELECT
    TotalCharges,
    COUNT(*) AS record_count
FROM raw_telco_churn
WHERE TotalCharges IS NOT NULL
  AND TRIM(TotalCharges) <> ''
  AND (
      TRIM(TotalCharges) NOT REGEXP '^[0-9]+([.][0-9]+)?$'
      OR CAST(TRIM(TotalCharges) AS DECIMAL(12,2)) < 0
  )
GROUP BY TotalCharges
ORDER BY TotalCharges;

SELECT
    SeniorCitizen,
    COUNT(*) AS record_count
FROM raw_telco_churn
WHERE SeniorCitizen IS NULL
   OR SeniorCitizen NOT IN (0, 1)
GROUP BY SeniorCitizen
ORDER BY SeniorCitizen;

SELECT
    gender,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY gender
ORDER BY gender;

SELECT
    Partner,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY Partner
ORDER BY Partner;

SELECT
    Dependents,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY Dependents
ORDER BY Dependents;

SELECT
    PhoneService,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY PhoneService
ORDER BY PhoneService;

SELECT
    MultipleLines,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY MultipleLines
ORDER BY MultipleLines;

SELECT
    InternetService,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY InternetService
ORDER BY InternetService;

SELECT
    OnlineSecurity,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY OnlineSecurity
ORDER BY OnlineSecurity;

SELECT
    OnlineBackup,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY OnlineBackup
ORDER BY OnlineBackup;

SELECT
    DeviceProtection,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY DeviceProtection
ORDER BY DeviceProtection;

SELECT
    TechSupport,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY TechSupport
ORDER BY TechSupport;

SELECT
    StreamingTV,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY StreamingTV
ORDER BY StreamingTV;

SELECT
    StreamingMovies,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY StreamingMovies
ORDER BY StreamingMovies;

SELECT
    Contract,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY Contract
ORDER BY Contract;

SELECT
    PaperlessBilling,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY PaperlessBilling
ORDER BY PaperlessBilling;

SELECT
    PaymentMethod,
    COUNT(*) AS record_count
FROM raw_telco_churn
GROUP BY PaymentMethod
ORDER BY PaymentMethod;

SELECT
    COUNT(*) AS total_rows,
    SUM(Churn IS NULL) AS null_churn,
    SUM(
        Churn IS NOT NULL
        AND Churn NOT IN ('Yes', 'No')
    ) AS unexpected_churn_values
FROM raw_telco_churn;

SELECT
    customerID,
    tenure,
    MonthlyCharges,
    TotalCharges
FROM raw_telco_churn
WHERE TotalCharges IS NULL
   OR TRIM(TotalCharges) = ''
ORDER BY tenure, customerID;

SELECT
    tenure,
    COUNT(*) AS total_records,
    SUM(
        TotalCharges IS NULL
        OR TRIM(TotalCharges) = ''
    ) AS blank_totalcharges
FROM raw_telco_churn
GROUP BY tenure
HAVING SUM(
    TotalCharges IS NULL
    OR TRIM(TotalCharges) = ''
) > 0
ORDER BY tenure;

SELECT
    COUNT(*) AS zero_tenure_customers,
    SUM(
        TotalCharges IS NULL
        OR TRIM(TotalCharges) = ''
    ) AS blank_totalcharges,
    SUM(
        TotalCharges IS NOT NULL
        AND TRIM(TotalCharges) <> ''
    ) AS populated_totalcharges
FROM raw_telco_churn
WHERE tenure = 0;

SHOW COLUMNS FROM raw_telco_churn
LIKE 'TotalCharges';

SHOW COLUMNS FROM raw_telco_churn
LIKE 'MonthlyCharges';

SELECT
    COUNT(*) AS total_records,
    SUM(
        TotalCharges IS NOT NULL
        AND TRIM(TotalCharges) <> ''
    ) AS nonblank_records,
    SUM(
        TotalCharges IS NOT NULL
        AND TRIM(TotalCharges) <> ''
        AND TRIM(TotalCharges) REGEXP '^[0-9]+([.][0-9]+)?$'
    ) AS valid_numeric_records
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(
        MonthlyCharges IS NOT NULL
        AND TRIM(MonthlyCharges) <> ''
    ) AS nonblank_records,
    SUM(
        MonthlyCharges IS NOT NULL
        AND TRIM(MonthlyCharges) <> ''
        AND TRIM(MonthlyCharges)
            REGEXP '^[0-9]+([.][0-9]+)?$'
    ) AS valid_numeric_records
FROM raw_telco_churn;

SELECT
    MIN(CAST(TRIM(MonthlyCharges) AS DECIMAL(12,2)))
        AS minimum_monthly_charges,
    MAX(CAST(TRIM(MonthlyCharges) AS DECIMAL(12,2)))
        AS maximum_monthly_charges
FROM raw_telco_churn;

SELECT
    MIN(CAST(TRIM(TotalCharges) AS DECIMAL(12,2)))
        AS minimum_total_charges,
    MAX(CAST(TRIM(TotalCharges) AS DECIMAL(12,2)))
        AS maximum_total_charges
FROM raw_telco_churn
WHERE TotalCharges IS NOT NULL
  AND TRIM(TotalCharges) <> '';
  
SELECT
    MIN(CAST(tenure AS SIGNED)) AS minimum_tenure,
    MAX(CAST(tenure AS SIGNED)) AS maximum_tenure,
    SUM(tenure = 0) AS zero_tenure_customers,
    SUM(tenure IS NULL) AS null_tenure_records
FROM raw_telco_churn;

SELECT
    customerID,
    COUNT(*) AS record_count
FROM raw_telco_churn
WHERE customerID IS NULL
   OR TRIM(customerID) = ''
   OR TRIM(customerID) NOT REGEXP '^[0-9]{4}-[A-Za-z0-9]{5}$'
GROUP BY customerID
ORDER BY customerID;

SELECT
    COUNT(*) AS total_records,
    SUM(PaperlessBilling IS NULL) AS null_records,
    SUM(
        PaperlessBilling IS NOT NULL
        AND PaperlessBilling NOT IN ('Yes', 'No')
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(Contract IS NULL) AS null_records,
    SUM(
        Contract IS NOT NULL
        AND Contract NOT IN (
            'Month-to-month',
            'One year',
            'Two year'
        )
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(PaymentMethod IS NULL) AS null_records,
    SUM(
        PaymentMethod IS NOT NULL
        AND PaymentMethod NOT IN (
            'Electronic check',
            'Mailed check',
            'Bank transfer (automatic)',
            'Credit card (automatic)'
        )
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(gender IS NULL) AS null_records,
    SUM(
        gender IS NOT NULL
        AND gender NOT IN ('Female', 'Male')
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(Partner IS NULL) AS null_records,
    SUM(
        Partner IS NOT NULL
        AND Partner NOT IN ('Yes', 'No')
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(Dependents IS NULL) AS null_records,
    SUM(
        Dependents IS NOT NULL
        AND Dependents NOT IN ('Yes', 'No')
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(PhoneService IS NULL) AS null_records,
    SUM(
        PhoneService IS NOT NULL
        AND PhoneService NOT IN ('Yes', 'No')
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(MultipleLines IS NULL) AS null_records,
    SUM(
        MultipleLines IS NOT NULL
        AND MultipleLines NOT IN (
            'Yes',
            'No',
            'No phone service'
        )
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(InternetService IS NULL) AS null_records,
    SUM(
        InternetService IS NOT NULL
        AND InternetService NOT IN (
            'DSL',
            'Fiber optic',
            'No'
        )
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(OnlineSecurity IS NULL) AS null_records,
    SUM(
        OnlineSecurity IS NOT NULL
        AND OnlineSecurity NOT IN (
            'Yes',
            'No',
            'No internet service'
        )
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(OnlineBackup IS NULL) AS null_records,
    SUM(
        OnlineBackup IS NOT NULL
        AND OnlineBackup NOT IN (
            'Yes',
            'No',
            'No internet service'
        )
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(DeviceProtection IS NULL) AS null_records,
    SUM(
        DeviceProtection IS NOT NULL
        AND DeviceProtection NOT IN (
            'Yes',
            'No',
            'No internet service'
        )
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(TechSupport IS NULL) AS null_records,
    SUM(
        TechSupport IS NOT NULL
        AND TechSupport NOT IN (
            'Yes',
            'No',
            'No internet service'
        )
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(StreamingTV IS NULL) AS null_records,
    SUM(
        StreamingTV IS NOT NULL
        AND StreamingTV NOT IN (
            'Yes',
            'No',
            'No internet service'
        )
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(StreamingMovies IS NULL) AS null_records,
    SUM(
        StreamingMovies IS NOT NULL
        AND StreamingMovies NOT IN (
            'Yes',
            'No',
            'No internet service'
        )
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(gender IS NULL) AS null_records,
    SUM(
        gender IS NOT NULL
        AND gender NOT IN ('Female', 'Male')
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(Partner IS NULL) AS null_records,
    SUM(
        Partner IS NOT NULL
        AND Partner NOT IN ('Yes', 'No')
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(Dependents IS NULL) AS null_records,
    SUM(
        Dependents IS NOT NULL
        AND Dependents NOT IN ('Yes', 'No')
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(PhoneService IS NULL) AS null_records,
    SUM(
        PhoneService IS NOT NULL
        AND PhoneService NOT IN ('Yes', 'No')
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(MultipleLines IS NULL) AS null_records,
    SUM(
        MultipleLines IS NOT NULL
        AND MultipleLines NOT IN (
            'Yes',
            'No',
            'No phone service'
        )
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(PaperlessBilling IS NULL) AS null_records,
    SUM(
        PaperlessBilling IS NOT NULL
        AND PaperlessBilling NOT IN ('Yes', 'No')
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(Contract IS NULL) AS null_records,
    SUM(
        Contract IS NOT NULL
        AND Contract NOT IN (
            'Month-to-month',
            'One year',
            'Two year'
        )
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(PaymentMethod IS NULL) AS null_records,
    SUM(
        PaymentMethod IS NOT NULL
        AND PaymentMethod NOT IN (
            'Electronic check',
            'Mailed check',
            'Bank transfer (automatic)',
            'Credit card (automatic)'
        )
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(SeniorCitizen IS NULL) AS null_records,
    SUM(
        SeniorCitizen IS NOT NULL
        AND SeniorCitizen NOT IN (0, 1)
    ) AS unexpected_values
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(tenure IS NULL) AS null_records,
    SUM(tenure < 0) AS negative_tenure_records
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    SUM(MonthlyCharges IS NULL) AS null_records,
    SUM(MonthlyCharges <= 0) AS non_positive_charges
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,

    SUM(TotalCharges IS NULL OR TRIM(TotalCharges) = '')
        AS blank_totalcharges,

    SUM(
        TRIM(TotalCharges) <> ''
        AND TRIM(TotalCharges) NOT REGEXP '^[0-9]+([.][0-9]+)?$'
    ) AS invalid_totalcharges,

    SUM(
        TRIM(TotalCharges) <> ''
        AND TRIM(TotalCharges) REGEXP '^[0-9]+([.][0-9]+)?$'
        AND CAST(TRIM(TotalCharges) AS DECIMAL(10,2)) < 0
    ) AS negative_totalcharges,

    SUM(MonthlyCharges IS NULL) AS missing_monthlycharges,

    SUM(
        MonthlyCharges IS NOT NULL
        AND MonthlyCharges <= 0
    ) AS non_positive_monthlycharges,

    SUM(tenure IS NULL) AS missing_tenure,

    SUM(tenure < 0) AS negative_tenure,

    SUM(Churn IS NULL) AS missing_churn,

    SUM(
        Churn IS NOT NULL
        AND Churn NOT IN ('Yes', 'No')
    ) AS invalid_churn

FROM raw_telco_churn;

SELECT
    COUNT(*) AS zero_tenure_customers,

    SUM(
        TotalCharges IS NULL
        OR TRIM(TotalCharges) = ''
    ) AS blank_totalcharges,

    SUM(
        TotalCharges IS NOT NULL
        AND TRIM(TotalCharges) <> ''
    ) AS populated_totalcharges

FROM raw_telco_churn
WHERE tenure = 0;


SELECT
    COUNT(*) AS total_records,

    /* Leading or trailing whitespace */
    SUM(
        COALESCE(customerID <> TRIM(customerID), 0) +
        COALESCE(gender <> TRIM(gender), 0) +
        COALESCE(Partner <> TRIM(Partner), 0) +
        COALESCE(Dependents <> TRIM(Dependents), 0) +
        COALESCE(PhoneService <> TRIM(PhoneService), 0) +
        COALESCE(MultipleLines <> TRIM(MultipleLines), 0) +
        COALESCE(InternetService <> TRIM(InternetService), 0) +
        COALESCE(OnlineSecurity <> TRIM(OnlineSecurity), 0) +
        COALESCE(OnlineBackup <> TRIM(OnlineBackup), 0) +
        COALESCE(DeviceProtection <> TRIM(DeviceProtection), 0) +
        COALESCE(TechSupport <> TRIM(TechSupport), 0) +
        COALESCE(StreamingTV <> TRIM(StreamingTV), 0) +
        COALESCE(StreamingMovies <> TRIM(StreamingMovies), 0) +
        COALESCE(Contract <> TRIM(Contract), 0) +
        COALESCE(PaperlessBilling <> TRIM(PaperlessBilling), 0) +
        COALESCE(PaymentMethod <> TRIM(PaymentMethod), 0) +
        COALESCE(Churn <> TRIM(Churn), 0)
    ) AS whitespace_issues,

    /* Blank categorical values */
    SUM(
        COALESCE(TRIM(gender) = '', 0) +
        COALESCE(TRIM(Partner) = '', 0) +
        COALESCE(TRIM(Dependents) = '', 0) +
        COALESCE(TRIM(PhoneService) = '', 0) +
        COALESCE(TRIM(MultipleLines) = '', 0) +
        COALESCE(TRIM(InternetService) = '', 0) +
        COALESCE(TRIM(OnlineSecurity) = '', 0) +
        COALESCE(TRIM(OnlineBackup) = '', 0) +
        COALESCE(TRIM(DeviceProtection) = '', 0) +
        COALESCE(TRIM(TechSupport) = '', 0) +
        COALESCE(TRIM(StreamingTV) = '', 0) +
        COALESCE(TRIM(StreamingMovies) = '', 0) +
        COALESCE(TRIM(Contract) = '', 0) +
        COALESCE(TRIM(PaperlessBilling) = '', 0) +
        COALESCE(TRIM(PaymentMethod) = '', 0) +
        COALESCE(TRIM(Churn) = '', 0)
    ) AS blank_categorical_values,

    /* Internet service consistency */
    SUM(
        InternetService IS NOT NULL
        AND (
            (
                InternetService = 'No'
                AND (
                    OnlineSecurity <> 'No internet service'
                    OR OnlineBackup <> 'No internet service'
                    OR DeviceProtection <> 'No internet service'
                    OR TechSupport <> 'No internet service'
                    OR StreamingTV <> 'No internet service'
                    OR StreamingMovies <> 'No internet service'
                )
            )
            OR
            (
                InternetService <> 'No'
                AND (
                    OnlineSecurity = 'No internet service'
                    OR OnlineBackup = 'No internet service'
                    OR DeviceProtection = 'No internet service'
                    OR TechSupport = 'No internet service'
                    OR StreamingTV = 'No internet service'
                    OR StreamingMovies = 'No internet service'
                )
            )
        )
    ) AS internet_service_inconsistencies,

    /* Phone service consistency */
    SUM(
        PhoneService IS NOT NULL
        AND MultipleLines IS NOT NULL
        AND (
            (PhoneService = 'No' AND MultipleLines <> 'No phone service')
            OR
            (PhoneService = 'Yes' AND MultipleLines = 'No phone service')
        )
    ) AS phone_service_inconsistencies

FROM raw_telco_churn;

DESCRIBE raw_telco_churn;

SELECT
    COUNT(*) AS total_records,

    SUM(
        SeniorCitizen IS NOT NULL
        AND TRIM(SeniorCitizen) NOT REGEXP '^[01]$'
    ) AS invalid_seniorcitizen_format,

    SUM(
        tenure IS NOT NULL
        AND TRIM(tenure) NOT REGEXP '^[0-9]+$'
    ) AS invalid_tenure_format,

    SUM(
        TRIM(tenure) REGEXP '^[0-9]+$'
        AND CAST(TRIM(tenure) AS UNSIGNED) > 72
    ) AS tenure_above_72

FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,

    SUM(
        TRIM(SeniorCitizen) REGEXP '^[01]$'
    ) AS convertible_seniorcitizen,

    SUM(
        TRIM(tenure) REGEXP '^[0-9]+$'
    ) AS convertible_tenure,

    SUM(
        TRIM(MonthlyCharges)
        REGEXP '^[0-9]+([.][0-9]+)?$'
    ) AS convertible_monthlycharges,

    SUM(
        TRIM(TotalCharges) = ''
        OR TotalCharges IS NULL
    ) AS blank_totalcharges_to_preserve,

    SUM(
        TRIM(TotalCharges)
        REGEXP '^[0-9]+([.][0-9]+)?$'
    ) AS convertible_totalcharges

FROM raw_telco_churn;


CREATE TABLE cleaned_telco_churn AS
SELECT
    customerID,
    gender,
    CAST(TRIM(SeniorCitizen) AS UNSIGNED) AS SeniorCitizen,
    Partner,
    Dependents,
    CAST(TRIM(tenure) AS UNSIGNED) AS tenure,
    PhoneService,
    MultipleLines,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies,
    Contract,
    PaperlessBilling,
    PaymentMethod,
    CAST(TRIM(MonthlyCharges) AS DECIMAL(10,2)) AS MonthlyCharges,
    CAST(
        NULLIF(TRIM(TotalCharges), '')
        AS DECIMAL(10,2)
    ) AS TotalCharges,
    Churn
FROM raw_telco_churn;

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT customerID) AS unique_customers,
    SUM(TotalCharges IS NULL) AS missing_totalcharges,
    SUM(tenure = 0) AS zero_tenure_customers
FROM cleaned_telco_churn;

DESCRIBE cleaned_telco_churn;

SELECT
    COUNT(*) AS total_records,

    COUNT(DISTINCT customerID) AS unique_customers,

    SUM(customerID IS NULL OR TRIM(customerID) = '')
        AS missing_customer_ids,

    SUM(TotalCharges IS NULL)
        AS missing_totalcharges,

    SUM(MonthlyCharges IS NULL)
        AS missing_monthlycharges,

    MIN(tenure) AS minimum_tenure,
    MAX(tenure) AS maximum_tenure,

    MIN(MonthlyCharges) AS minimum_monthlycharges,
    MAX(MonthlyCharges) AS maximum_monthlycharges,

    MIN(TotalCharges) AS minimum_totalcharges,
    MAX(TotalCharges) AS maximum_totalcharges,

    SUM(Churn = 'Yes') AS churned_customers,
    SUM(Churn = 'No') AS retained_customers

FROM cleaned_telco_churn;


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

SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT customerID) AS unique_customers,
    SUM(customerID IS NULL) AS missing_customer_ids,
    SUM(Churn = 'Yes') AS churned_customers,
    SUM(Churn = 'No') AS retained_customers,
    ROUND(
        SUM(Churn = 'Yes') * 100.0 / COUNT(*),
        2
    ) AS overall_churn_rate,
    SUM(TotalCharges IS NULL) AS missing_total_charges
FROM cleaned_telco_churn;