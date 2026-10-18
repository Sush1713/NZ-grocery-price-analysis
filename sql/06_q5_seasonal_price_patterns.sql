-- 06_q5_seasonal_price_patterns.sql
-- Q5: Which 10 grocery items have the strongest seasonal price pattern,
--     measured by the gap between their most expensive and cheapest month
--     (as a % of their annual average price), 2019-2025?
-- Method: each month's price is divided by that item's average price for the
-- same year (x 100), so inflation is removed. These monthly indexes are then
-- averaged across 2019-2025 for each calendar month.
-- Only items with full data (12 months) in all 7 years are included.

WITH yearly AS (
    SELECT
        ItemFull,
        CAST(SUBSTR(Date, 1, 4) AS INTEGER) AS yr,
        AVG(Price) AS avg_price
    FROM prices
    WHERE Date BETWEEN '2019-01-01' AND '2025-12-01'
    GROUP BY ItemFull, yr
    HAVING COUNT(*) = 12
),
full_items AS (
    SELECT ItemFull
    FROM yearly
    GROUP BY ItemFull
    HAVING COUNT(*) = 7
),
monthly AS (
    SELECT
        p.ItemFull,
        CAST(SUBSTR(p.Date, 6, 2) AS INTEGER) AS month_no,
        AVG(p.Price * 100.0 / y.avg_price)    AS month_index
    FROM prices p
    JOIN yearly y
        ON p.ItemFull = y.ItemFull
       AND CAST(SUBSTR(p.Date, 1, 4) AS INTEGER) = y.yr
    WHERE p.ItemFull IN (SELECT ItemFull FROM full_items)
    GROUP BY p.ItemFull, month_no
),
ranked AS (
    SELECT
        ItemFull,
        month_no,
        month_index,
        ROW_NUMBER() OVER (PARTITION BY ItemFull ORDER BY month_index DESC) AS high_rank,
        ROW_NUMBER() OVER (PARTITION BY ItemFull ORDER BY month_index ASC)  AS low_rank
    FROM monthly
)
SELECT
    h.ItemFull,
    h.month_no                          AS peak_month,
    ROUND(h.month_index, 1)             AS peak_index,
    l.month_no                          AS cheapest_month,
    ROUND(l.month_index, 1)             AS cheapest_index,
    ROUND(h.month_index - l.month_index, 1) AS seasonal_range
FROM ranked h
JOIN ranked l
    ON h.ItemFull = l.ItemFull
WHERE h.high_rank = 1
  AND l.low_rank = 1
ORDER BY seasonal_range DESC
LIMIT 10;