-- 07_model_inputs_tomatoes.sql
-- Inputs for the Excel what-if pricing model (tomatoes).
-- 1) Seasonal index per calendar month, 2019-2025 (same method as Q5)
-- 2) Average shelf price in 2025 (used as the flat price)

WITH yearly AS (
    SELECT
        CAST(SUBSTR(Date, 1, 4) AS INTEGER) AS yr,
        AVG(Price) AS avg_price
    FROM prices
    WHERE ItemFull = 'Tomatoes, 1kg'
      AND Date BETWEEN '2019-01-01' AND '2025-12-01'
    GROUP BY yr
    HAVING COUNT(*) = 12
)
SELECT
    CAST(SUBSTR(p.Date, 6, 2) AS INTEGER)       AS month_no,
    ROUND(AVG(p.Price * 100.0 / y.avg_price), 1) AS seasonal_index
FROM prices p
JOIN yearly y
    ON CAST(SUBSTR(p.Date, 1, 4) AS INTEGER) = y.yr
WHERE p.ItemFull = 'Tomatoes, 1kg'
GROUP BY month_no
ORDER BY month_no;

-- Average shelf price in 2025
SELECT ROUND(AVG(Price), 2) AS avg_price_2025
FROM prices
WHERE ItemFull = 'Tomatoes, 1kg'
  AND Date LIKE '2025%';