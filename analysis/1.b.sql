-- 1.b. Analyze how much time is spent per ride based on which station is the starting and / or ending station
SELECT
    AVG(DATEDIFF(minute, [started_at], [ended_at])) AS avg_minutes
    ,s.[name]
FROM [fact_trips] t
JOIN [stations] s
    ON t.[start_station_id] = s.[station_id]
    OR t.[end_station_id] = s.[station_id]
GROUP BY s.[name]

-- OUTPUT
-- avg_minutes,name
-- 538,"""Throop St & 52nd St"""
-- 535,"""South Chicago Ave & Elliot Ave"""
-- 409,"""Wabash Ave & 83rd St"""
-- 353,"""Racine Ave & 65th St"""
-- 317,"""Central Ave & Harrison St"""
-- 308,"""Western Ave & 111th St"""
-- 285,"""Clyde Ave & 87th St"""
-- 283,"""Latrobe Ave & Chicago Ave"""
-- 280,"""Kenton Ave & Madison St"""
-- 266,"""Eberhart Ave & 131st St"""

-- ...

-- 7,"""Western Ave & Lake St"""
-- 2,"""Pawel Bialowas - Test- PBSC charging station"""
-- 1,"""WEST CHI-WATSON"""
-- 1,"""Hastings WH 2"""
-- 1,"""Fullerton & Monitor"""
-- 0,"""Lincoln Ave & Roscoe St - Charging"""
-- 0,"""Throop/Hastings Mobile Station"""
-- 0,"""Whipple St & Roosevelt Rd"""
