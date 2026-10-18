-- 01_data_checks.sql
-- Basic checks after importing Stats NZ Food Price Index data

-- 1. Total rows (should match Excel: 35,803)
SELECT COUNT(*) AS total_rows
FROM prices;

-- 2. Number of different food items
SELECT COUNT(DISTINCT ItemFull) AS number_of_items
FROM prices;

-- 3. Date range of the data
SELECT MIN(Date) AS first_month,
       MAX(Date) AS last_month
FROM prices;

-- 4. Price history of one item (example: oranges)
SELECT Date, Price
FROM prices
WHERE ItemFull = 'Oranges, 1kg'
ORDER BY Date;


