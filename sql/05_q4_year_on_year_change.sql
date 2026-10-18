-- 05_q4_year_on_year_change.sql
-- Q4: In which year between 2010 and 2025 did grocery prices rise the most,
--     based on the average year-on-year % change across items?
-- Method: average annual price per item (full years only, 12 months),
-- compared with the previous year, then averaged across items for each year.
-- 2009 is used only as the base year for 2010.
-- 2026 is excluded because it is not a full year (data ends August 2026).

WITH yearly AS (
    SELECT
        ItemFull,
        CAST(SUBSTR(Date, 1, 4) AS INTEGER) AS yr,
        AVG(Price) AS avg_price
    FROM prices
    WHERE Date BETWEEN '2009-01-01' AND '2025-12-01'
    GROUP BY ItemFull, yr
    HAVING COUNT(*) = 12
),
yoy AS (
    SELECT
        cur.yr,
        cur.ItemFull,
        (cur.avg_price - prev.avg_price) * 100.0 / prev.avg_price AS pct_change
    FROM yearly cur
    JOIN yearly prev
        ON cur.ItemFull = prev.ItemFull
       AND cur.yr = prev.yr + 1
)
SELECT
    yr                                              AS year,
    COUNT(*)                                        AS items_compared,
    ROUND(AVG(pct_change), 1)                       AS avg_yoy_pct_change,
    SUM(CASE WHEN pct_change > 0 THEN 1 ELSE 0 END) AS items_increased
FROM yoy
GROUP BY yr
ORDER BY yr;