-- IF EXISTS (SELECT * FROM sys.tables WHERE name = 'fact_trips')
--     DROP TABLE [fact_trips]
-- GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'fact_trips')
    SELECT [trip_id]
    ,t.[rider_id]
    ,[start_station_id]
    ,[end_station_id]
    ,CONVERT(Datetime, SUBSTRING([started_at], 1, 19),120) AS [started_at]
    ,CONVERT(Datetime, SUBSTRING([ended_at], 1, 19),120) AS [ended_at]
    ,[rideable_type]
    ,DATEDIFF(year, r.birthday,
        CONVERT(Datetime, SUBSTRING([started_at], 1, 19),120)) AS [rider_age]
    INTO [fact_trips]
    FROM [dbo].[stage_trips] t
    JOIN [dbo].[stage_riders] r
        ON t.[rider_id] = r.[rider_id]
GO

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'dates')
    DROP TABLE [dates]
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dates')
    CREATE TABLE [dates] (
        [datetime] datetime,
        [day_of_week] varchar(10),
        [hour_of_day] int,
        [year] int,
        [month] int,
        [day] int,
        [quarter] int
    )

    -- Trip start and end datetimes
    INSERT INTO [dates]
    SELECT
        CONVERT(datetime, SUBSTRING([started_at], 1, 19),120) AS [datetime]
        ,DATENAME(weekday, CONVERT(datetime, SUBSTRING([started_at], 1, 19),120)) AS [day_of_week]
        ,DATEPART(hour, CONVERT(datetime, SUBSTRING([started_at], 1, 19),120)) AS [hour_of_day]
        ,DATEPART(year, CONVERT(datetime, SUBSTRING([started_at], 1, 19),120)) AS [year]
        ,DATEPART(month, CONVERT(datetime, SUBSTRING([started_at], 1, 19),120)) AS [month]
        ,DATEPART(day, CONVERT(datetime, SUBSTRING([started_at], 1, 19),120)) AS [day]
        ,DATEPART(quarter, CONVERT(datetime, SUBSTRING([started_at], 1, 19),120)) AS [quarter]
    FROM [dbo].[stage_trips]

    INSERT INTO [dates]
    SELECT
        CONVERT(datetime, SUBSTRING([ended_at], 1, 19),120) AS datetime
        ,DATENAME(dw, CONVERT(datetime, SUBSTRING([ended_at], 1, 19),120)) AS [day_of_week]
        ,DATEPART(hour, CONVERT(datetime, SUBSTRING([ended_at], 1, 19),120)) AS [hour_of_day]
        ,DATEPART(year, CONVERT(datetime, SUBSTRING([ended_at], 1, 19),120)) AS [year]
        ,DATEPART(month, CONVERT(datetime, SUBSTRING([ended_at], 1, 19),120)) AS [month]
        ,DATEPART(day, CONVERT(datetime, SUBSTRING([ended_at], 1, 19),120)) AS [day]
        ,DATEPART(quarter, CONVERT(datetime, SUBSTRING([ended_at], 1, 19),120)) AS [quarter]
    FROM [dbo].[stage_trips]

    -- Member start and end dates
    INSERT INTO [dates]
    SELECT
        CONVERT(datetime, SUBSTRING([start_date], 1, 19),120) AS [datetime]
        ,DATENAME(dw, CONVERT(datetime, SUBSTRING([start_date], 1, 19),120)) AS [day_of_week]
        ,DATEPART(hour, CONVERT(datetime, SUBSTRING([start_date], 1, 19),120)) AS [hour_of_day]
        ,DATEPART(year, CONVERT(datetime, SUBSTRING([start_date], 1, 19),120)) AS [year]
        ,DATEPART(month, CONVERT(datetime, SUBSTRING([start_date], 1, 19),120)) AS [month]
        ,DATEPART(day, CONVERT(datetime, SUBSTRING([start_date], 1, 19),120)) AS [day]
        ,DATEPART(quarter, CONVERT(datetime, SUBSTRING([start_date], 1, 19),120)) AS [quarter]
    FROM [dbo].[stage_riders]

    INSERT INTO [dates]
    SELECT
        CONVERT(datetime, SUBSTRING([end_date], 1, 19),120) AS datetime
        ,DATENAME(dw, CONVERT(datetime, SUBSTRING([end_date], 1, 19),120)) AS [day_of_week]
        ,DATEPART(hour, CONVERT(datetime, SUBSTRING([end_date], 1, 19),120)) AS [hour_of_day]
        ,DATEPART(year, CONVERT(datetime, SUBSTRING([end_date], 1, 19),120)) AS [year]
        ,DATEPART(month, CONVERT(datetime, SUBSTRING([end_date], 1, 19),120)) AS [month]
        ,DATEPART(day, CONVERT(datetime, SUBSTRING([end_date], 1, 19),120)) AS [day]
        ,DATEPART(quarter, CONVERT(datetime, SUBSTRING([end_date], 1, 19),120)) AS [quarter]
    FROM [dbo].[stage_riders]

    -- Payment dates
    INSERT INTO [dates]
    SELECT
        CONVERT(datetime, SUBSTRING([date], 1, 19),120) AS datetime
        ,DATENAME(dw, CONVERT(datetime, SUBSTRING([date], 1, 19),120)) AS [day_of_week]
        ,DATEPART(hour, CONVERT(datetime, SUBSTRING([date], 1, 19),120)) AS [hour_of_day]
        ,DATEPART(year, CONVERT(datetime, SUBSTRING([date], 1, 19),120)) AS [year]
        ,DATEPART(month, CONVERT(datetime, SUBSTRING([date], 1, 19),120)) AS [month]
        ,DATEPART(day, CONVERT(datetime, SUBSTRING([date], 1, 19),120)) AS [day]
        ,DATEPART(quarter, CONVERT(datetime, SUBSTRING([date], 1, 19),120)) AS [quarter]
    FROM [dbo].[stage_payments]
GO

-- IF EXISTS (SELECT * FROM sys.tables WHERE name = 'stations')
--     DROP TABLE [stations]
-- GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'stations')
    SELECT
        [station_id],
        [name],
        [latitude],
        [longitude]
    INTO [stations]
    FROM [dbo].[stage_stations]
GO

-- IF EXISTS (SELECT * FROM sys.tables WHERE name = 'riders')
--     DROP TABLE [riders]
-- GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'riders')
    SELECT
        [rider_id]
        ,[first]
        ,[last]
        ,[address]
        ,[birthday]
        ,[start_date] AS member_start_date
        ,[end_date] AS member_end_date
        ,[member]
    INTO [riders]
    FROM [dbo].[stage_riders]
GO

-- IF EXISTS (SELECT * FROM sys.tables WHERE name = 'fact_payments')
--     DROP TABLE [fact_payments]
-- GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'fact_payments')
    SELECT
    [payment_id]
    ,p.[rider_id]
    ,CONVERT(Datetime, SUBSTRING([date], 1, 19),120) AS [date]
    ,[amount]
    ,DATEDIFF(year, r.birthday,
        CONVERT(Datetime, SUBSTRING([start_date], 1, 19),120)) AS [rider_age]
    INTO [fact_payments]
    FROM [dbo].[stage_payments] p
    JOIN [dbo].[stage_riders] r
        ON p.[rider_id] = r.[rider_id]
GO
