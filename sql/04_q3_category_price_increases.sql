-- 04_q3_category_price_increases.sql
-- Q3: Which food category had the highest average % price increase
--     between 2019 and 2025?
-- Method: % change in average annual price for each item (2019 vs 2025),
-- then averaged within each Stats NZ FPI category.
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
),
item_change AS (
    SELECT
        a.ItemFull,
        (b.avg_2025 - a.avg_2019) * 100.0 / a.avg_2019 AS pct_change
    FROM year_2019 a
    JOIN year_2025 b
        ON a.ItemFull = b.ItemFull
)
SELECT
    c.Category,
    COUNT(*)                     AS items_compared,
    ROUND(AVG(i.pct_change), 1)  AS avg_pct_change,
    ROUND(MIN(i.pct_change), 1)  AS lowest_item_change,
    ROUND(MAX(i.pct_change), 1)  AS highest_item_change
FROM item_change i
JOIN category_lookup c
    ON i.ItemFull = c.ItemFull
GROUP BY c.Category
ORDER BY avg_pct_change DESC;