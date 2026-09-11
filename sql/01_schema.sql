-- Consumer Credit Risk Analytics Platform
-- Database schema

CREATE DATABASE IF NOT EXISTS consumer_credit_risk;

USE consumer_credit_risk;

CREATE TABLE IF NOT EXISTS loans (
    loan_id BIGINT PRIMARY KEY,
    loan_amnt DECIMAL(12,2),
    term VARCHAR(20),
    int_rate DECIMAL(6,2),
    installment DECIMAL(12,2),
    grade VARCHAR(5),
    sub_grade VARCHAR(5),
    emp_length VARCHAR(20),
    home_ownership VARCHAR(20),
    annual_inc DECIMAL(15,2),
    verification_status VARCHAR(30),
    issue_d VARCHAR(20),
    loan_status VARCHAR(50),
    purpose VARCHAR(50),
    addr_state VARCHAR(5),
    dti DECIMAL(10,2),
    fico_range_low DECIMAL(10,2),
    fico_range_high DECIMAL(10,2),
    open_acc DECIMAL(10,2),
    revol_bal DECIMAL(15,2),
    revol_util DECIMAL(10,2),
    total_acc DECIMAL(10,2),
    default_flag TINYINT
);

-- Load cleaned LendingClub loan data
LOAD DATA LOCAL INFILE '/Users/gei/Desktop/Consumer-Credit-Risk-Analytics-Platform-Project/data/loans_clean.csv'
INTO TABLE loans
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    loan_id,
    loan_amnt,
    term,
    int_rate,
    installment,
    grade,
    sub_grade,
    emp_length,
    home_ownership,
    annual_inc,
    verification_status,
    issue_d,
    loan_status,
    purpose,
    addr_state,
    @dti,
    fico_range_low,
    fico_range_high,
    open_acc,
    revol_bal,
    @revol_util,
    total_acc,
    default_flag
)
SET
    dti = NULLIF(@dti, ''),
    revol_util = NULLIF(@revol_util, '');