-- 3.b. EXTRA CREDIT - Analyze how much money is spent per member
--      based on how many minutes the rider spends on a bike per month

WITH [minutes_per_rider] ([minutes_spent], [rider_id], [year], [month])
AS (
    SELECT SUM(DATEDIFF(minute, [started_at], [ended_at])) AS minutes_spent,
        t.[rider_id], [year], [month]
    FROM [fact_trips] t
    JOIN [riders] r
        ON t.[rider_id] = r.[rider_id]
    JOIN [dates] d
        ON t.[started_at] = d.[datetime]
    GROUP BY t.[rider_id], d.[year], d.[month]
)

SELECT SUM(p.[amount]) AS money_spent,
    SUM(mr.[minutes_spent]) AS minutes_spent,
    mr.[rider_id]
FROM [fact_payments] p
JOIN [minutes_per_rider] mr
    ON p.[rider_id] = mr.[rider_id]
GROUP BY mr.[rider_id]
ORDER BY money_spent DESC

-- Output:
-- money_spent,minutes_spent,rider_id
-- 19905.96,1885982,65089
-- 19210.80,129042,11368
-- 19133.64,1793230,19270
-- 18970.56,1176000,38365
-- 18097.92,726493,31552
-- 18087.00,132165,75860

-- ...

-- 5130.00,59679,34336
-- 5130.00,232731,68664
-- 5130.00,95304,69252
-- 5130.00,203718,68323
-- 5130.00,31692,32911
-- 5129.80,68211,28994
