-- 03_q2_smallest_price_increases.sql
-- Q2: Which 10 grocery items had the smallest % increase (or a decrease)
--     in average annual price between 2019 and 2025?
-- Method: average price across all 12 months of each year.
-- Only items with prices for all 12 months in both years are included.

WITH year_2019 AS (
    SELECT ItemFull, AVG(Price) AS avg_2019
    FROM prices
    WHERE Date LIKE '2019%'
    GROUP BY ItemFull
    HAVING COUNT(*) = 12
),
year_2025 AS (
    SELECT ItemFull, AVG(Price) AS avg_2025
    FROM prices
    WHERE Date LIKE '2025%'
    GROUP BY ItemFull
    HAVING COUNT(*) = 12
)
SELECT
    a.ItemFull,
    ROUND(a.avg_2019, 2) AS avg_price_2019,
    ROUND(b.avg_2025, 2) AS avg_price_2025,
    ROUND((b.avg_2025 - a.avg_2019) * 100.0 / a.avg_2019, 1) AS pct_change
FROM year_2019 a
JOIN year_2025 b
    ON a.ItemFull = b.ItemFull
ORDER BY pct_change ASC
LIMIT 10;

