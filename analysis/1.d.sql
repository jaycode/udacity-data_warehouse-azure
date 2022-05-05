-- 1.d. Analyze how much time is spent per ride based on day of week
--      based on whether the rider is a member or a casual rider
SELECT
    AVG([duration_seconds] / 60.0) AS avg_minutes,
    [member]
FROM [fact_trips] t
JOIN [riders] r
    ON t.[rider_id] = r.[rider_id]
GROUP BY [member]

-- OUTPUT:
-- avg_minutes,member
-- 21,True
-- 21,False
