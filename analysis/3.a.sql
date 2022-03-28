-- 3.a. EXTRA CREDIT - Analyze how much money is spent per member
--      based on how many rides the rider averages per month

WITH [rides_per_rider] ([rides], [rider_id], [year], [month])
AS (
    SELECT COUNT(*) AS rides,
        t.[rider_id], [year], [month]
    FROM [fact_trips] t
    JOIN [riders] r
        ON t.[rider_id] = r.[rider_id]
    JOIN [dates] d
        ON t.[started_at] = d.[datetime]
    GROUP BY t.[rider_id], d.[year], d.[month]
)

SELECT SUM(p.[amount]) AS money_spent,
    AVG(rr.[rides]) AS avg_monthly_num_rides,
    rr.[rider_id]
FROM [fact_payments] p
JOIN [rides_per_rider] rr
    ON p.[rider_id] = rr.[rider_id]
GROUP BY rr.[rider_id]
ORDER BY money_spent DESC

-- Output
-- money_spent,avg_monthly_num_rides,rider_id
-- 19905.96,56,65089
-- 19210.80,5,11368
-- 19133.64,99,19270
-- 18970.56,25,38365
-- 18097.92,38,31552

-- ...

-- 5130.00,12,68664
-- 5130.00,6,69252
-- 5130.00,12,68323
-- 5130.00,2,32911
-- 5129.80,7,28994
