-- BASIC ANALYSIS QUESTIONS.

USE marketing_analytics_db;

-- TOTAL FREIGHT, TOTAL PRICE AND TOTAL PAYMENTS.
WITH item_sales AS (
	SELECT
		order_id,
		SUM(freight_value)AS total_freight,
		SUM(price) AS total_price
	FROM dbo.order_items
	GROUP BY order_id
), payment_totals AS (
	SELECT
		order_id,
		SUM(payment_value) AS total_payment
	FROM dbo.order_payments
	GROUP BY order_id
)
SELECT
	i.order_id,
	i.total_freight AS total_freights,
	i.total_price AS total_prices,
	p.total_payment AS total_payments
FROM item_sales i
LEFT JOIN payment_totals p
ON i.order_id = p.order_id
ORDER BY i.total_freight DESC;

SELECT ROUND(SUM(payment_value), 2) AS total_payment 
FROM dbo.order_payments;

SELECT ROUND(SUM(freight_value), 2) AS total_freight_value
FROM dbo.order_items;

-- EACH SELLERS EARNINGS ACCORDING TO STATES, CITIES.
WITH total_earnings AS (
	SELECT
		seller_id,
		SUM(price) + SUM(freight_value) AS total_payment
	FROM dbo.order_items
	GROUP BY seller_id
), each_sellers AS (
	SELECT
		seller_id,
		seller_state,
		seller_city
	FROM dbo.sellers
	GROUP BY seller_id, seller_state, seller_city
)
SELECT
	s.seller_id,
	s.seller_state,
	s.seller_city,
	i.total_payment
FROM total_earnings i
LEFT JOIN each_sellers s
ON i.seller_id = s.seller_id
WHERE s.seller_state != '#N/A'
ORDER BY s.seller_state, s.seller_city DESC;

-- TOTAL SALES ACCORDING TO EACH CATEGORY (FILTERING ONLY 'HIGI' SALES CATEGORY).
WITH product_categories AS (
	SELECT
		product_id,
		product_category_name
	FROM dbo.products
),  total_earnings AS (
	SELECT
		product_id,
		SUM(price) + SUM(freight_value) AS total_sales
	FROM dbo.order_items
	GROUP BY product_id
)
SELECT
	p.product_category_name,
	ROUND(SUM(o.total_sales), 2) AS total_categorial_sales,
	CASE
		WHEN SUM(o.total_sales) > 1000000 THEN 'High'
		WHEN SUM(o.total_sales) < 500000 THEN 'Medium'
		ELSE 'Low'
	END AS sales_category
FROM product_categories p
LEFT JOIN total_earnings o
ON p.product_id = o.product_id
GROUP BY p.product_category_name
HAVING
	CASE
		WHEN SUM(o.total_sales) > 1000000 THEN 'High'
		WHEN SUM(o.total_sales) < 500000 THEN 'Medium'
		ELSE 'Low'
	END = 'High'
ORDER BY total_categorial_sales DESC;

-- WHICH STATE HAS MORE SALES.
WITH statewise_sales AS (
	SELECT
		seller_id,
		seller_state
	FROM dbo.sellers
), total_salse AS (
	SELECT
		seller_id,
		ROUND(SUM(price), 2) + ROUND(SUM(freight_value), 2) AS total_payments
	FROM dbo.order_items
	GROUP BY seller_id
)
SELECT
	s.seller_state,
	ROUND(SUM(o.total_payments), 2) AS total_sales
FROM statewise_sales s
LEFT JOIN total_salse o
ON s.seller_id = o.seller_id
GROUP BY s.seller_state
HAVING s.seller_state != '#N/A'
ORDER BY total_sales DESC;

-- WHICH TYPE OF PAYMENT METHOD IS MOSTLY PREFERRED.
SELECT
	payment_type,
	ROUND(SUM(payment_value), 2) AS total_payments
FROM dbo.order_payments
GROUP BY payment_type
ORDER BY total_payments DESC;

-- PRODUCTS WITH RATINGS AND COUNT
SELECT
	p.product_category_name,
	r.review_score,
	COUNT(r.review_score) AS total_review_count
FROM dbo.order_review_ratings r
LEFT JOIN dbo.order_items oi ON  r.order_id = oi.order_id
LEFT JOIN dbo.products p ON oi.product_id = p.product_id
WHERE p.product_category_name != 'NULL'
GROUP BY p.product_category_name, r.review_score
ORDER BY r.review_score DESC;