-- Pick specific columns
SELECT 
	OrderID,
    Product,
    Quantity,
    TotalPrice
FROM orders
LIMIT 10;

-- Only delivered orders
SELECT
	OrderID,
    Product,
    TotalPrice
FROM orders
WHERE OrderStatus = 'Delivered';

-- Delivered and over 2000
SELECT
	OrderID,
    Product,
    TotalPrice
FROM orders
WHERE OrderStatus = 'Delivered' AND TotalPrice > 2000;

-- Most expensive orders first
SELECT
	OrderID,
    Product,
    TotalPrice
FROM orders
ORDER BY TotalPrice DESC
LIMIT 10;

-- Delivered laptops, newest first
SELECT
	OrderID,
    `DATE`,
    TotalPrice
FROM orders
WHERE Product = 'Laptop' AND OrderStatus = 'Delivered'
ORDER BY `DATE` DESC;

-- Overall numbers
SELECT
	COUNT(*) AS total_orders,
    SUM(TotalPrice) AS total_revenue,
    AVG(TotalPrice) AS avg_order_value
FROM orders;

-- Orders per status
SELECT 
	OrderStatus,
    COUNT(*) AS num_orders
FROM orders
GROUP BY OrderStatus;

-- Revenue per product, biggest first
SELECT
	Product,
    SUM(TotalPrice) AS total_revenue
FROM orders
GROUP BY product
ORDER BY total_revenue DESC;

-- Average order value per paymemt method
SELECT 
	PaymentMethod,
    AVG(TotalPrice) AS avg_order_value
FROM orders
GROUP BY PaymentMethod
ORDER BY avg_order_value DESC;

-- Orders per referral source
SELECT
	ReferralSource,
    COUNT(*) AS num_orders
FROM orders
GROUP BY ReferralSource
ORDER BY num_orders DESC;

-- Revenue from orders that actually count
SELECT 
	COUNT(*) AS valid_orders,
    SUM(TotalPrice) AS real_revenue,
    AVG(TotalPrice) AS avg_order_value
FROM orders
WHERE OrderStatus IN ('Shipped', 'Delivered');

-- Revenue per product, valid orders only
SELECT
	Product,
    SUM(TotalPrice) AS total_revenue
FROM orders
WHERE OrderStatus IN ('Shipped', 'Delivered')
GROUP BY Product
ORDER BY total_revenue DESC;

-- Share of cancelled or returned orders per product
SELECT 
	Product,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN OrderStatus IN ('Cancelled', 'Returned') THEN 1 ELSE 0 END) AS failed_orders
FROM orders
GROUP BY Product
ORDER BY failed_orders DESC;

-- Revenue per year (valid orders)
SELECT 
	YEAR(`DATE`) AS order_year,
    COUNT(*) AS orders,
    SUM(TotalPrice) AS revenue
FROM orders
WHERE OrderStatus IN ('Shipped','Delivered')
GROUP BY YEAR(`DATE`)
ORDER BY order_year;

-- Coupon usage: which coupon is used most, and who used none
SELECT
	CouponCode,
    COUNT(*) AS num_orders,
    AVG(TotalPrice) AS avg_order_value
FROM orders
GROUP BY CouponCode;