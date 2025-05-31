-- This is a real-world project for Data Analyst/ SQL Developer.
-- Date Exploration and Cleaning.

USE marketing_analytics_db;
GO

SELECT * FROM INFORMATION_SCHEMA.TABLES

SELECT TOP 10 * FROM dbo.customers;
SELECT COUNT(*) FROM dbo.customers;

-- Change datatype of customer_zip_code to INT
SELECT customer_zip_code_prefix FROM dbo.customers
ORDER BY customer_zip_code_prefix DESC;

ALTER TABLE dbo.customers
ALTER COLUMN customer_zip_code_prefix INT;


SELECT TOP 10 * FROM dbo.geo_location;
SELECT COUNT(*) FROM dbo.geo_location;
SELECT DISTINCT geolocation_city FROM dbo.geo_location;
SELECT DISTINCT geolocation_state FROM dbo.geo_location;

SELECT TOP 10 * FROM dbo.order_items;
-- Note: freight_value means overall value with transporatation.

-- Create two seperate columns of shipping_limit_date or simply keep it in DATETIME fromat.
SELECT 
	CONVERT(DATE, shipping_limit_date) AS order_date, 
	FORMAT(CAST(shipping_limit_date AS DATETIME), 'HH:mm') AS order_time
FROM dbo.order_items;

ALTER TABLE dbo.order_items
ALTER COLUMN shipping_limit_date DATETIME;

UPDATE dbo.order_items
SET shipping_limit_date = FORMAT(CAST(shipping_limit_date AS DATETIME), 'yyyy-MM-dd HH:mm')

SELECT
	YEAR(shipping_limit_date) AS year,
	ROUND(SUM(price), 2) AS overall_price,
	ROUND(SUM(freight_value) + SUM(price), 2) AS overall_price_with_transprotation
FROM dbo.order_items
GROUP BY YEAR(shipping_limit_date)
ORDER BY YEAR(shipping_limit_date);

SELECT TOP 10 * FROM dbo.order_payments;

SELECT DISTINCT payment_type FROM dbo.order_payments;

SELECT MAX(payment_installments) AS max_installment FROM dbo.order_payments;

SELECT ROUND(SUM(payment_value), 2) AS total_payment_amount FROM dbo.order_payments;

SELECT TOP 10 * FROM dbo.order_review_ratings;

-- review_score(1-5)
SELECT DISTINCT review_score FROM dbo.order_review_ratings
ORDER BY 1;

-- Checking for review_creation_date and review_answer_timestamp is in same month.
SELECT
	review_creation_date,
	review_answer_timestamp
FROM dbo.order_review_ratings
WHERE MONTH(review_creation_date) = MONTH(review_answer_timestamp);

-- Checked to see the difference.
SELECT
	COUNT(review_creation_date) AS count_of_review_creation_date,
	COUNT(review_answer_timestamp) AS count_of_review_answer_timestamp
FROM dbo.order_review_ratings;

SELECT
	COUNT(review_creation_date) AS count_of_review_creation_date,
	COUNT(review_answer_timestamp) AS count_of_review_answer_timestamp
FROM dbo.order_review_ratings
WHERE MONTH(review_creation_date) = MONTH(review_answer_timestamp);


SELECT TOP 10 * FROM dbo.orders;

SELECT TOP 10 * FROM dbo.products;

SELECT DISTINCT product_category_name FROM dbo.products;

UPDATE dbo.products
SET product_category_name = REPLACE(product_category_name, '_', ' ');

SELECT TOP 10 * FROM dbo.sellers;