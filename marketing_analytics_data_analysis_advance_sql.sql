-- ADVANCE ANALYTICS QUESTION

USE marketing_analytics_db

GO

-- HOW MANY NEW CUSTOMERS ACQUIRED EVERY MONTH.
SELECT
	FORMAT(first_order, 'yyyy-MM') AS months_acquired,
	COUNT(*) AS new_customers
FROM (
	SELECT 
		customer_id,
		MIN(order_purchase_timestamp) AS first_order
	FROM dbo.orders
	GROUP BY customer_id
) AS first_orders
GROUP BY FORMAT(first_order, 'yyyy-MM')
HAVING FORMAT(first_order, 'yyyy-MM') IS NOT NULL
ORDER BY months_acquired DESC;

-- TOP 10 EXPENSIVE PRODUCTS
SELECT TOP 10
	product_id,
	MAX(price) AS max_price
FROM dbo.order_items
GROUP BY product_id
ORDER BY max_price DESC


-- POPULAR CATEGORIES BY STATE.
SELECT
	p.product_category_name,
	s.seller_state,
	COUNT(oi.order_id) AS total_orders
FROM dbo.products p
LEFT JOIN dbo.order_items oi ON oi.product_id = p.product_id
LEFT JOIN dbo.sellers s ON s.seller_id = oi.seller_id
GROUP BY p.product_category_name, s.seller_state
ORDER BY COUNT(oi.order_id) DESC;

-- POPULAR CATEGORIES BY STATE AND MONTH.
SELECT
	DATENAME(MONTH, o.order_purchase_timestamp) AS month,
	DATENAME(YEAR, o.order_purchase_timestamp) AS year,
	s.seller_state,
	p.product_category_name,
	COUNT(*) AS total_orders
FROM dbo.orders o
JOIN dbo.order_items oi ON o.order_id = oi.order_id
JOIN dbo.products p ON oi.product_id = p.product_id
JOIN dbo.sellers s ON oi.seller_id = s.seller_id
GROUP BY 
	DATENAME(MONTH, o.order_purchase_timestamp), 
	DATENAME(YEAR, o.order_purchase_timestamp), 
	s.seller_state, 
	p.product_category_name
HAVING s.seller_state != '#N/A'
ORDER BY 
	year,
	month,
	total_orders DESC;
