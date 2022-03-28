-- 1.a.1. Analyze how much time is spent per ride based on day of week

SELECT
    AVG(DATEDIFF(minute, [started_at], [ended_at])) AS avg_minutes
    ,day_of_week
FROM [fact_trips] t
JOIN [dates] d
    ON t.[started_at] = d.[datetime]
GROUP BY d.[day_of_week]

-- OUTPUT:
-- avg_minutes,day_of_week
-- 21,Friday
-- 28,Sunday
-- 18,Tuesday
-- 26,Saturday
-- 20,Monday
-- 18,Wednesday
-- 18,Thursday
