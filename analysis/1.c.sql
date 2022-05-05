-- 1.c. Analyze how much time is spent per ride based on day of week
--      based on age of the rider at time of the ride
SELECT
    AVG([duration_seconds] / 60.0) AS avg_minutes
    ,[rider_age]
FROM [fact_trips] t
JOIN [riders] r
    ON t.[rider_id] = r.[rider_id]
GROUP BY [rider_age]
ORDER BY [rider_age]

-- OUTPUT
-- avg_minutes,rider_age
-- 22,15
-- 21,16
-- 21,17
-- 21,18
-- 22,19
-- 21,20
-- 22,21
-- 22,22
-- 21,23
-- 21,24
-- 22,25
-- 21,26
-- 21,27
-- 22,28
-- 21,29
-- 21,30
-- 22,31
-- 22,32
-- 21,33
-- 22,34
-- 22,35
-- 21,36
-- 21,37
-- 21,38
-- 21,39
-- 22,40
-- 21,41
-- 21,42
-- 21,43
-- 22,44
-- 20,45
-- 21,46
-- 20,47
-- 19,48
-- 22,49
-- 20,50
-- 21,51
-- 20,52
-- 21,53
-- 19,54
-- 23,55
-- 21,56
-- 26,57
-- 18,58
-- 23,59
-- 19,60
-- 21,61
-- 19,62
-- 20,63
-- 21,64
-- 20,65
-- 26,66
-- 22,67
-- 34,68
-- 20,69
-- 21,70
-- 20,71
-- 18,72
-- 18,73
-- 20,74
-- 27,75
-- 8,76
