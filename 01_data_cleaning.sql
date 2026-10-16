-- Customer Churn Analysis | MySQL 8.0
-- DATA SETUP AND CLEANING
-- IMPORTANT WORKFLOW:
-- 1. Run the setup statements through CREATE TABLE raw_telco_churn first.
-- 2. Import the IBM Telco Customer Churn data into raw_telco_churn using MySQL Workbench.
-- 3. Perform the raw-data validation checks in 02_data_validation.sql.
-- 4. Only then execute the CREATE TABLE cleaned_telco_churn statement near the end of this file.
--    Do not execute that final CREATE TABLE statement before importing the source data,
--    or cleaned_telco_churn will be created from an empty raw table.
-- Original SQL statements below are preserved as written.

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
