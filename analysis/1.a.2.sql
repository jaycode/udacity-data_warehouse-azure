-- 1.a.2. Analyze how much time is spent per ride based on time of day
SELECT
    AVG(DATEDIFF(minute, [started_at], [ended_at])) AS avg_minutes
    ,s.[name]
FROM [fact_trips] t
JOIN [stations] s
    ON t.[start_station_id] = s.[station_id]
GROUP BY s.[name]
ORDER BY avg_minutes DESC

-- OUTPUT:
-- avg_minutes,hour_of_day
-- 26,0
-- 29,1
-- 34,2
-- 33,3
-- 31,4
-- 13,5
-- 13,6
-- 13,7
-- 14,8
-- 18,9
-- 23,10
-- 23,11
-- 24,12
-- 25,13
-- 25,14
-- 24,15
-- 22,16
-- 20,17
-- 21,18
-- 22,19
-- 22,20
-- 23,21
-- 24,22
-- 26,23
