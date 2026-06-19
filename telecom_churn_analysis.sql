CREATE TABLE telecom_churn (
    customerID VARCHAR(50),
    gender VARCHAR(20),
    SeniorCitizen INT,
    Partner VARCHAR(10),
    Dependents VARCHAR(10),
    tenure INT,
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(30),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTV VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(50),
    PaperlessBilling VARCHAR(10),
    PaymentMethod VARCHAR(100),
    MonthlyCharges NUMERIC,
    TotalCharges NUMERIC,
    Churn VARCHAR(10)
);

SELECT * FROM telecom_churn;

SELECT *
FROM telecom_churn
LIMIT 10;

-- Count Total Customers
SELECT COUNT(*)
FROM telecom_churn;

-- Customer Churn Distribution
SELECT Churn,
	COUNT(*) AS Customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS Percentage
FROM telecom_churn
GROUP BY Churn;

-- Analyze Contract Type
-- Which contract type has the most customers?
SELECT
Contract,
COUNT(*) AS Customers
FROM telecom_churn
GROUP BY Contract
ORDER BY Customers DESC;

-- Contract vs Churn
-- Which contract type loses the most customers?
SELECT
Contract,
COUNT(*) AS Total_Customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned
FROM telecom_churn
GROUP BY Contract;

-- Monthly Charges Analysis
SELECT
ROUND(AVG(MonthlyCharges),2) AS Avg_Monthly_Charge
FROM telecom_churn;

-- Churn by Internet Service
-- Which internet service customers leave most often?
SELECT InternetService,
COUNT(*) AS Customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned
FROM telecom_churn
GROUP BY InternetService;

-- Payment Method Analysis
SELECT PaymentMethod,
COUNT(*) AS Customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned
FROM telecom_churn
GROUP BY PaymentMethod
ORDER BY Churned DESC;

--Customer Tenure Analysis
SELECT
MIN(tenure) AS Min_Tenure,
MAX(tenure) AS Max_Tenure,
ROUND(AVG(tenure),2) AS Avg_Tenure
FROM telecom_churn;

-- Customers with the shortest and longest relationship
(
    SELECT 'Min Tenure' AS Type, CustomerID, tenure
    FROM telecom_churn
    ORDER BY tenure ASC
    LIMIT 1
)
UNION ALL
(
    SELECT 'Max Tenure' AS Type, CustomerID, tenure
    FROM telecom_churn
    ORDER BY tenure DESC
    LIMIT 1
);

-- Top 10 High Revenue Customers Who Churned
SELECT
customerID,
MonthlyCharges,
TotalCharges
FROM telecom_churn
WHERE Churn='Yes'
ORDER BY TotalCharges DESC
LIMIT 10;

-- Company's most valuable retained customers
SELECT
customerID,
MonthlyCharges,
TotalCharges
FROM telecom_churn
WHERE Churn='No'
ORDER BY TotalCharges DESC
LIMIT 10;

-- Churn Rate by Contract Type
SELECT
    Contract,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Churn_Rate
FROM telecom_churn
GROUP BY Contract
ORDER BY Churn_Rate DESC;

-- Churn Rate by Internet Service
SELECT
    InternetService,
    COUNT(*) AS Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Churn_Rate
FROM telecom_churn
GROUP BY InternetService
ORDER BY Churn_Rate DESC;

-- Revenue Lost Due to Churn
SELECT
    ROUND(SUM(TotalCharges::NUMERIC),2) AS Revenue_Lost
FROM telecom_churn
WHERE Churn='Yes';

-- Average Monthly Charges (Churn vs Non-Churn)
SELECT
    Churn,
    ROUND(AVG(MonthlyCharges),2) AS Avg_Monthly_Charge
FROM telecom_churn
GROUP BY Churn;

-- Tenure Groups Analysis
SELECT
CASE
    WHEN tenure <= 12 THEN '0-12 Months'
    WHEN tenure <= 24 THEN '13-24 Months'
    WHEN tenure <= 48 THEN '25-48 Months'
    ELSE '49+ Months'
END AS Tenure_Group,
COUNT(*) AS Customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned
FROM telecom_churn
GROUP BY Tenure_Group
ORDER BY Tenure_Group;

-- Senior Citizens Churn Analysis
SELECT
    SeniorCitizen,
    COUNT(*) AS Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned
FROM telecom_churn
GROUP BY SeniorCitizen;

-- Gender-wise Churn Rate
SELECT
    Gender,
    COUNT(*) AS Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Churn_Rate
FROM telecom_churn
GROUP BY Gender;

-- Top 5 Payment Methods with Highest Churn
SELECT
    PaymentMethod,
    COUNT(*) AS Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned
FROM telecom_churn
GROUP BY PaymentMethod
ORDER BY Churned DESC
LIMIT 5;

-- Customers at High Risk
SELECT
    customerID,
    tenure,
    MonthlyCharges,
    Contract
FROM telecom_churn
WHERE tenure < 12
AND MonthlyCharges > 70
AND Contract = 'Month-to-month';

-- Service-wise Churn Analysis
SELECT
    OnlineSecurity,
    COUNT(*) AS Customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned
FROM telecom_churn
GROUP BY OnlineSecurity;




