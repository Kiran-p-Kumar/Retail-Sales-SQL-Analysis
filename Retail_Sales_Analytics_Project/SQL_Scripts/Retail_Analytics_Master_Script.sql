CREATE DATABASE IF NOT EXISTS RetailAnalytics;
USE RetailAnalytics;

-- 1. Add a new column for the correct date format
ALTER TABLE superstoreorders ADD COLUMN OrderDateClean DATE;
-- 2. convert and update the date format 
-- Run this single query to fill your new column
UPDATE superstoreorders 
SET OrderDateClean = STR_TO_DATE(REPLACE(order_date, '-', '/'), '%d/%m/%Y');
-- 3.Optional Remove the old text column
ALTER TABLE superstoreorders DROP COLUMN order_date;
-- Skip the ALTER TABLE and run ONLY this:
UPDATE superstoreorders 
SET OrderDateClean = STR_TO_DATE(REPLACE(order_date, '-', '/'), '%d/%m/%Y');
SELECT order_id, order_date, OrderDateClean 
FROM superstoreorders 
LIMIT 5;
DESCRIBE superstoreorders;
-- This renames the column so you don't have to deal with the strange characters
ALTER TABLE superstoreorders 
RENAME COLUMN `ï»¿order_id` TO order_id;
UPDATE superstoreorders 
SET OrderDateClean = STR_TO_DATE(REPLACE(order_date, '-', '/'), '%d/%m/%Y');
SELECT order_id, order_date, OrderDateClean 
FROM superstoreorders 
LIMIT 5;

SELECT 
    category, 
    product_name,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS return_count,
    ROUND((SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS return_rate_pct
FROM superstoreorders
GROUP BY category, product_name
HAVING total_orders > 3
ORDER BY return_rate_pct DESC
LIMIT 10;
USE RetailAnalytics;
WITH RFM_Base AS ( 
    SELECT 
        customer_name, 
        -- Fixed typo: OrdeDateClean -> OrderDateClean
        DATEDIFF((SELECT MAX(OrderDateClean) FROM superstoreorders), MAX(OrderDateClean)) AS Recency, 
        COUNT(DISTINCT order_id) AS Frequency, 
        SUM(sales) AS Monetary 
    FROM superstoreorders 
    GROUP BY customer_name 
), 
RFM_Score AS ( 
    SELECT  
        customer_name, -- Fixed typo: cutomer_name -> customer_name
        Recency, 
        Frequency, 
        Monetary, 
        NTILE(5) OVER (ORDER BY Recency ASC) AS R_Score, 
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score, 
        NTILE(5) OVER (ORDER BY Monetary ASC) AS M_Score -- Removed the extra comma here
    FROM RFM_Base 
) 
SELECT * FROM RFM_Score;
USE RetailAnalytics;
WITH RFM_Base AS (
    SELECT 
        customer_name,
        DATEDIFF((SELECT MAX(OrderDateClean) FROM superstoreorders), MAX(OrderDateClean)) AS Recency,
        COUNT(DISTINCT order_id) AS Frequency,
        SUM(sales) AS Monetary
    FROM superstoreorders
    GROUP BY customer_name
),
RFM_Scores AS (
    SELECT 
        customer_name,
        Recency, Frequency, Monetary,
        NTILE(5) OVER (ORDER BY Recency ASC) AS R,
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F,
        NTILE(5) OVER (ORDER BY Monetary ASC) AS M
    FROM RFM_Base
)
SELECT 
    customer_name,
    R, F, M,
    CASE 
        WHEN R >= 4 AND F >= 4 THEN 'Champions'
        WHEN R >= 3 AND F >= 3 THEN 'Loyal Customers'
        WHEN R >= 4 AND F <= 2 THEN 'Recent Customers'
        WHEN R <= 2 AND F >= 4 THEN 'At Risk'
        WHEN R <= 2 AND F <= 2 THEN 'Lost Customers'
        ELSE 'Potential Loyalist'
    END AS Customer_Segment
FROM RFM_Scores
ORDER BY Monetary DESC;

USE RetailAnalytics;

-- Query to calculate Customer Lifetime Value (CLV)
-- We calculate: Average Order Value * Purchase Frequency
SELECT 
    customer_name,
    ROUND(SUM(sales), 2) AS Total_Revenue,
    COUNT(DISTINCT order_id) AS Total_Orders,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS Avg_Order_Value,
    -- Simple CLV Estimate
    ROUND((SUM(sales) / COUNT(DISTINCT order_id)) * COUNT(DISTINCT order_id), 2) AS Lifetime_Value
FROM superstoreorders
GROUP BY customer_name
ORDER BY Lifetime_Value DESC
LIMIT 10;

