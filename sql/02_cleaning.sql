-- Data cleaning and transformation
USE consumer_credit_risk;

-- Check total number of rows
SELECT COUNT(*) AS total_rows
FROM loans;

-- Check missing values in key risk fields
SELECT
    SUM(dti IS NULL) AS missing_dti,
    SUM(revol_util IS NULL) AS missing_revol_util
FROM loans;

-- Check for duplicate loan IDs
SELECT
    loan_id,
    COUNT(*) AS duplicate_count
FROM loans
GROUP BY loan_id
HAVING COUNT(*) > 1;

-- Check for invalid numeric values
SELECT
    SUM(loan_amnt <= 0) AS invalid_loan_amnt,
    SUM(int_rate < 0) AS invalid_int_rate,
    SUM(annual_inc < 0) AS invalid_annual_inc,
    SUM(dti < 0) AS invalid_dti,
    SUM(fico_range_low < 300 OR fico_range_low > 850) AS invalid_fico_low,
    SUM(fico_range_high < 300 OR fico_range_high > 850) AS invalid_fico_high,
    SUM(default_flag NOT IN (0, 1)) AS invalid_default_flag
FROM loans;

-- Inspect invalid DTI records
SELECT
    loan_id,
    annual_inc,
    dti,
    fico_range_low,
    fico_range_high,
    loan_status,
    default_flag
FROM loans
WHERE dti < 0;

-- Replace invalid negative DTI values with NULL
UPDATE loans
SET dti = NULL
WHERE dti < 0;

-- Verify negative DTI values were removed
SELECT
    SUM(dti < 0) AS remaining_negative_dti,
    SUM(dti IS NULL) AS total_missing_dti
FROM loans;

-- Validate key categorical fields
SELECT DISTINCT grade
FROM loans
ORDER BY grade;

SELECT DISTINCT term
FROM loans
ORDER BY term;

SELECT DISTINCT home_ownership
FROM loans
ORDER BY home_ownership;

SELECT DISTINCT loan_status
FROM loans
ORDER BY loan_status;

-- Final validation after cleaning
SELECT
    COUNT(*) AS total_rows,
    SUM(dti IS NULL) AS missing_dti,
    SUM(revol_util IS NULL) AS missing_revol_util,
    SUM(dti < 0) AS invalid_dti,
    SUM(default_flag NOT IN (0, 1)) AS invalid_default_flag
FROM loans;