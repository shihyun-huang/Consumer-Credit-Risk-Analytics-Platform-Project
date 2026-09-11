USE consumer_credit_risk;

-- Query 1: Total Loans
-- How large is the loan portfolio?

SELECT
    COUNT(*) AS total_loans
FROM loans;

-- Query 2: Total Exposure
-- How much money is represented by the loan portfolio?

SELECT
    SUM(loan_amnt) AS total_exposure
FROM loans;

-- Query 3: Average Loan Amount
-- What is the typical loan size?

SELECT
    ROUND(AVG(loan_amnt), 2) AS avg_loan_amount
FROM loans;

-- Query 4: Default Rate
-- What percentage of loans defaulted?

SELECT
    COUNT(*) AS total_loans,
    SUM(default_flag) AS defaulted_loans,
    ROUND(AVG(default_flag) * 100, 2) AS default_rate_pct
FROM loans;

-- Query 5: Default Rate by Credit Score
-- How does default risk change across FICO score ranges?
-- Does default risk change across borrowers with different credit scores?

SELECT
    CASE
        WHEN (fico_range_low + fico_range_high) / 2 >= 750 THEN '750+'
        WHEN (fico_range_low + fico_range_high) / 2 >= 700 THEN '700-749'
        WHEN (fico_range_low + fico_range_high) / 2 >= 650 THEN '650-699'
        ELSE '<650'
    END AS fico_band,
    COUNT(*) AS total_loans,
    SUM(default_flag) AS defaulted_loans,
    ROUND(AVG(default_flag) * 100, 2) AS default_rate_pct
FROM loans
GROUP BY fico_band
ORDER BY
    CASE fico_band
        WHEN '750+' THEN 1
        WHEN '700-749' THEN 2
        WHEN '650-699' THEN 3
        WHEN '<650' THEN 4
    END;
    
-- Query 6: Default Rate by DTI
-- How does default risk change across debt-to-income levels?
-- Do borrowers with higher debt-to-income ratios have higher default rates? 

SELECT
    CASE
        WHEN dti IS NULL THEN 'Missing'
        WHEN dti < 15 THEN 'Low DTI'
        WHEN dti <= 30 THEN 'Medium DTI'
        ELSE 'High DTI'
    END AS dti_band,
    COUNT(*) AS total_loans,
    SUM(default_flag) AS defaulted_loans,
    ROUND(AVG(default_flag) * 100, 2) AS default_rate_pct
FROM loans
GROUP BY dti_band
ORDER BY
    CASE dti_band
        WHEN 'Low DTI' THEN 1
        WHEN 'Medium DTI' THEN 2
        WHEN 'High DTI' THEN 3
        WHEN 'Missing' THEN 4
    END;
    
-- Query 7: Default Rate by Income
-- How does default risk change across borrower income levels?
-- How does borrower income relate to default risk?

SELECT
    CASE
        WHEN annual_inc IS NULL THEN 'Missing'
        WHEN annual_inc < 40000 THEN '<40K'
        WHEN annual_inc < 80000 THEN '40K-79K'
        WHEN annual_inc < 120000 THEN '80K-119K'
        ELSE '120K+'
    END AS income_band,
    COUNT(*) AS total_loans,
    SUM(default_flag) AS defaulted_loans,
    ROUND(AVG(default_flag) * 100, 2) AS default_rate_pct
FROM loans
GROUP BY income_band
ORDER BY
    CASE income_band
        WHEN '<40K' THEN 1
        WHEN '40K-79K' THEN 2
        WHEN '80K-119K' THEN 3
        WHEN '120K+' THEN 4
        WHEN 'Missing' THEN 5
    END;
    
-- Query 8: Default Rate by Loan Purpose
-- Which loan purposes have the highest default risk?

SELECT
    purpose,
    COUNT(*) AS total_loans,
    SUM(default_flag) AS defaulted_loans,
    ROUND(AVG(default_flag) * 100, 2) AS default_rate_pct
FROM loans
GROUP BY purpose
ORDER BY default_rate_pct DESC;

-- Query 9: Default Rate by Interest Rate
-- How does default risk change across interest rate levels?
-- Do loans with higher interest rates have higher default rates?

SELECT
    CASE
        WHEN int_rate < 10 THEN '<10%'
        WHEN int_rate < 15 THEN '10%-14.99%'
        WHEN int_rate < 20 THEN '15%-19.99%'
        ELSE '20%+'
    END AS interest_rate_band,
    COUNT(*) AS total_loans,
    SUM(default_flag) AS defaulted_loans,
    ROUND(AVG(default_flag) * 100, 2) AS default_rate_pct
FROM loans
GROUP BY interest_rate_band
ORDER BY
    CASE interest_rate_band
        WHEN '<10%' THEN 1
        WHEN '10%-14.99%' THEN 2
        WHEN '15%-19.99%' THEN 3
        WHEN '20%+' THEN 4
    END;

-- Query 10: Risk Concentration
-- Which loan purposes contain the largest amount of exposure?

SELECT
    purpose,
    COUNT(*) AS total_loans,
    ROUND(SUM(loan_amnt), 2) AS total_exposure,
    SUM(default_flag) AS defaulted_loans,
    ROUND(AVG(default_flag) * 100, 2) AS default_rate_pct,
    ROUND(
        SUM(CASE WHEN default_flag = 1 THEN loan_amnt ELSE 0 END),
        2
    ) AS defaulted_exposure
FROM loans
GROUP BY purpose
ORDER BY total_exposure DESC;