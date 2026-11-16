# Data Cleaning & Preparation Poject

# Project 1

## Goal
Clean a raw orders dataset by handling missing values, duplicates and incorrect data.

## What I did
- I Found 309 missing CouponCode value and filled all with "No Coupon".
- I checked for duplicates, wrong formats,and incorrect values, none was found.
- Documented every decision in a cleaning lig

## Tools
Excel, Python (pandas), Jupyter Notebook

# Project 2: Exploratory Data Analysis

## Overview
An exploratory analysis of 1,200 e-commerce order (January 2023 to June 2025) to understand patterns, trends and distributions.

## Tools
Python, pandas, matplotlib, Jupyter Notebook

## What I did
1. Loaded and inspected the data (size, types, missing values, duplicates).
2. Calculated basic statistics (mean, median, count).
3. Plotted distributions of TotalPrice and UnitPrice.
4. Analyzed trends in monthly orders, monthly revenue and revenue by product.
5. Detected outliers using a boxplot and the IQR rule.

## Key Findings
- The mean order value (about 1,054) is higher than the meadian (about 824), so the date is right-skewed.
- Monthly orders and revenue fluctuate with no clear long-term trend.
- Chair earns the most revenue (about 195,620) and phone the least (about 151,722).
- About 41% of orders are Cancelled or Returned and only 19% ar Delivered.
- 8 outliers were found, all bulk purchases (Quantity = 5) and I kept them.

## Skills Shown
Data analysis, descriptive statistics, data visualization, analytical thinking 

# Project 3 

## Goal
Use SQL queries to extract insights from an e-commerce orders dataset

##Tools
MySQL Workbench(MySQL), GitHub

## About the data
- 1,200 orders from January 2023 to June 2025, one row per order
- 14 columns, including Product, Quantity, UnitPrice, TotalPrice, OrderStatus, PaymentMethod, CouponCode and ReferralSource
- 1,189 different customers, 7 products, 5 order statuses
- 309 orders have no coupon. These are stored as NUll, which is not an error.
- TotalPrice equals Quantity x UnitPrice on every row (checked)

##Important note: only orders with status Shipped or Delivered are treated as real revenue. Cancelled, Returned and Pending orders are excluded wherever the analysis says "Valid orders".

## Analysis

### 1. Overall numbers
**Question:** How big is the dataset in orders and value?

**Query:**
```sql
SELECT
	COUNT(*) AS total_orders,
    SUM(TotalPrice) AS total_revenue,
    AVG(TotalPrice) AS avg_order_value
FROM orders;
```

**Result**

| total_orders | total_revenue | avg_order_value |
| --- | --- | ----|
| 1200 | 1,264,761.96 | 1,053.97 |

**Insight:**
The dataset has 1,200 orders in total. It has orders worth about 1.26M in total, with an average order of about 1,054.

### 2. Order per status
**Question:** How many orders per status in the dataset?

**Query**
```sql
SELECT OrderStatus, COUNT(*) AS num_orders
FROM orders
GROUP BY OrderStatus;
```

**Result**

| OrderStatus | num_orders |
| --- | --- |
| Cancelled | 250 |
| Returned | 247 | 
| Pending | 237 |
| Shipped | 235 |
| Delivered | 231 |

**Insight:**
Orders are spread evenly across the five statuses. Only 466 orders (about 39%) were shipped or delivered. Cancelled, returned and orders pending make up about 61%.

### 3. Revenue from valid orders only

**Query:**
```sql
SELECT
  COUNT(*) AS valid_orders,
  SUM(TotalPrice) AS real_revenue,
  AVG(TotalPeice) AS avg_order_value
FROM orders
WHERE OrderStatus IN ('Shipped', 'Delivered');
```

**Result**

| valid_orders | real_revenue | avg_order_value |
| --- | --- | --- |
| 466 | 488,759.90 | 1,048.84 |

**insight:**
Valid orders earned about 489k, only 39% of the 1.26M headline total. Counting ever order would overstate revenue by roughly 2.6 times. The average order value barely changed (about 1,049 vs 1,054).

### 4. Revenue per product (all orders vs valid orders)

**Query:**
```sql
SELECT Product,
  SUM(TotalPrice) AS revenue_all_orders,
  SUM(CASE WHEN OrderStatus IN ("Shipped', 'Delivered')
    THEN TotalPrice ELSE 0 END) AS revenue_valid_orders
FROM orders
GROUP BY Product
ORDER BY revenue_valid_orders DESC;
```

**Result**
| Product | revenue_all_orders | revenue_valid_orders |
| --- | --- | --- |
| Printer | 195,612.61 | 82,452.14 |
| Laptop | 192,126.56 | 80.951.66 |
| Chair | 195,620.11 | 71,816.27 |
| Monitor | 175,651.41 | 66,924.44 |
| Tablet | 186,568.95 | 66,622.67 |
| Phone | 151,722.39 | 62,342.05 |
| Desk | 167,459.93 | 57,650.67 |

**Insight:**
Looking at all orders, Chair and Printer are tied for first (about 195.6k each). Once only valid orders count, Printer (82.5K) and Laptop (81.0K) lead, Chair falls to third and Desk ends up last (57.7K), about 30% below Printer. Choosing which orders to count changed the product ranking.

### 5. Cancelled and returned orders per product

**Query:**
```sql
SELECT Product,
  COUNT(*) AS total_orders,
  SUM(CASE WHEN OrderStatus IN ('Cancelled', 'Returned') THEN 1 ELSE 0 END) As failed_orders
FROM orders
GROUP BY Product
ORDER BY failled_orders DESC;
```

**Result**
| Product | total_orders | failed_orders |
| --- | --- | --- |
| Tablet | 179 | 77 |
| Laptop | 173 | 74 |
| Chair | 178 | 73 |
| Printer | 181 | 73 |
| Monitor | 163 | 71 |
| Desk | 170 | 67 |
| Phone | 156 | 62 |

**Insight:**
Failure rates are similar across products (39% to 44%), so no single product has a cancellation or return problem. Monitor has the highest rate (43.6%) and Desk the lowest (39.4%). Chair's drop in the valid-orders ranking is therefore not explained by cancellations and returns alone.

### 6. Average order value per payment method

**Query:**
```sql
SELECT PaymentMethod, AVG(TotalPrice) AS avg_order_value
FROM orders
GROUP BY PaymentMethod
ORDER BY avg_order_value DESC;
```

**Result**
| PaymentMethod | avg_order_value |
| --- | --- |
| Credit Card | 1,127.55 |
| Gift Card | 1,070.97 |
| Cash | 1,056.04 |
| Online | 1,017.22 |
| Debit Card | 1,001.56 |

**Insight:**
Credit Card orders have the highest average value(about 1,128), roughly 12% more than Debit Card orders (about 1,0002).

### 7. Orders per referral source

**Query:**
```sql
SELECT ReferralSource, COUNT(*) AS num_orders
FROM orders
GROUP BY ReferralSource
ORDER BY num_orders DESC;
```

**Result**
| ReferralSource | num_orders |
| --- | --- |
| Instagram | 259 |
| Email | 250 |
| Google | 241 |
| Facebook | 228 |
| Referral | 222 |

**Insight:**
Instagram brings the most orders(259), followed by Email(250) and Google(241). Referral is lowest at 222. The gaps are modest.

### 8. Coupon usage

**Query:**
```sql
SELECT 
  CouponCode,
  COUNT(*) AS num_orders,
  AVG(TotalPrice) AS avg_order_value
FROM orders
GROUP BY CouponCode;
```

**Result**
| CouponCode | num_orders | avg_order_value |
| --- | --- | --- |
| FREESHIP | 313 | 1,070.41 |
| SAVE10 | 286 | 1,065.87 |
| Null(no coupon) | 309 | 1,043.37 |
| WINTER15 | 292 | 1,035.90 |

**Insight:**
FREESHIP is the most used coupon(313 orders) and goes with the highest average order value (about 1,070). The difference between coupons are small (about 3% from highest to lowest), so coupons do not appear to change order size much.

### 9. Revenue per year (valid orders)

**Query:**
```sql
SELECT
  YEAR(`Date`) AS order_year,
  COUNT(*) AS orders,
  SUM(TotalPrice) AS revenue
FROM orders
WHERE OrderStatus IN ('Shipped', 'Delivered')
GROUP BY YEAR(`Date`)
ORDER BY order_year;
```

**Result**
| order_year | orders | revenue |
| --- | --- | --- |
| 2023 | 184 | 215,678.35 |
| 2024 | 197 | 199,378.60 |
| 2025(Jan to Jun only | 85 | 73,702.95 |

**Insight:**
2024 had more valid orders than 2023 (197 vs 184) but about 8% less revenue, because the average order value fell from about 1,172 to about 1,012. 2025 covers only six months, so it should not be compared directly with the full years.

## Key findings 
1. Only 39% of orders (466 0f 1,200) were shipped or delivered, so total revenue is about 489K, not the 1.26M headline figure.
2. Cancelled, Returned and Pending orders are spread evenly across all products(failure rates of 39% to 44%), so the issue is general, not tied to one product.
3. Printer and laptop leads on valid-order revenue and Desk is last.
4. Credit Card orders are the largest on average, and Instagram is the top referral source.
5. Revenue fell about 8% from 2023 to 2024 even though orders rose, because the average order value dropped.

