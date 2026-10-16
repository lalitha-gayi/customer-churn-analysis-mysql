-- Customer Churn Analysis | MySQL 8.0
-- DATA VALIDATION
-- Run after raw_telco_churn has been created and populated.
-- Some checks below validate cleaned_telco_churn, so run those after the cleaning step.
-- Original SQL statements below are preserved as written.

USE customer_churn_analysis;

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
