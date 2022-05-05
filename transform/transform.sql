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
    -- ,DATEDIFF(year, r.birthday,
    --     CONVERT(Datetime, SUBSTRING([started_at], 1, 19),120)) AS [rider_age]
    -- The above DATEDIFF method does not return correct age when the year is
    -- incomplete. For example, when dob is '2000/02/29' and started_at is
    -- '2001/01/25', the result is 1 although it should be 0. The below method
    -- correctly deals with non-full years such as this.
    ,(DATEDIFF(year, r.birthday,
        CONVERT(Datetime, SUBSTRING([started_at], 1, 19),120)) - (
            CASE WHEN MONTH(r.birthday) > MONTH(CONVERT(Datetime, SUBSTRING([started_at], 1, 19),120))
            OR MONTH(r.birthday) =
                MONTH(CONVERT(Datetime, SUBSTRING([started_at], 1, 19),120))
            AND DAY(r.birthday) >
                DAY(CONVERT(Datetime, SUBSTRING([started_at], 1, 19),120))
            THEN 1 ELSE 0 END
        )) AS [rider_age]
    ,DATEDIFF(SS, CONVERT(Datetime, SUBSTRING([started_at], 1, 19),120),
                  CONVERT(Datetime, SUBSTRING([ended_at], 1, 19),120))
        AS [duration_seconds]
    INTO [fact_trips]
    FROM [dbo].[stage_trips] t
    JOIN [dbo].[stage_riders] r
        ON t.[rider_id] = r.[rider_id]
GO

-- IF EXISTS (SELECT * FROM sys.tables WHERE name = 'dates')
--     DROP TABLE [dates]
-- GO

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
    -- INSERT INTO [dates]
    -- SELECT
    --     CONVERT(datetime, SUBSTRING([started_at], 1, 19),120) AS [datetime]
    --     ,DATENAME(weekday, CONVERT(datetime, SUBSTRING([started_at], 1, 19),120)) AS [day_of_week]
    --     ,DATEPART(hour, CONVERT(datetime, SUBSTRING([started_at], 1, 19),120)) AS [hour_of_day]
    --     ,DATEPART(year, CONVERT(datetime, SUBSTRING([started_at], 1, 19),120)) AS [year]
    --     ,DATEPART(month, CONVERT(datetime, SUBSTRING([started_at], 1, 19),120)) AS [month]
    --     ,DATEPART(day, CONVERT(datetime, SUBSTRING([started_at], 1, 19),120)) AS [day]
    --     ,DATEPART(quarter, CONVERT(datetime, SUBSTRING([started_at], 1, 19),120)) AS [quarter]
    -- FROM [dbo].[stage_trips]
    --
    -- INSERT INTO [dates]
    -- SELECT
    --     CONVERT(datetime, SUBSTRING([ended_at], 1, 19),120) AS datetime
    --     ,DATENAME(dw, CONVERT(datetime, SUBSTRING([ended_at], 1, 19),120)) AS [day_of_week]
    --     ,DATEPART(hour, CONVERT(datetime, SUBSTRING([ended_at], 1, 19),120)) AS [hour_of_day]
    --     ,DATEPART(year, CONVERT(datetime, SUBSTRING([ended_at], 1, 19),120)) AS [year]
    --     ,DATEPART(month, CONVERT(datetime, SUBSTRING([ended_at], 1, 19),120)) AS [month]
    --     ,DATEPART(day, CONVERT(datetime, SUBSTRING([ended_at], 1, 19),120)) AS [day]
    --     ,DATEPART(quarter, CONVERT(datetime, SUBSTRING([ended_at], 1, 19),120)) AS [quarter]
    -- FROM [dbo].[stage_trips]
    --
    -- -- Member start and end dates
    -- INSERT INTO [dates]
    -- SELECT
    --     CONVERT(datetime, SUBSTRING([start_date], 1, 19),120) AS [datetime]
    --     ,DATENAME(dw, CONVERT(datetime, SUBSTRING([start_date], 1, 19),120)) AS [day_of_week]
    --     ,DATEPART(hour, CONVERT(datetime, SUBSTRING([start_date], 1, 19),120)) AS [hour_of_day]
    --     ,DATEPART(year, CONVERT(datetime, SUBSTRING([start_date], 1, 19),120)) AS [year]
    --     ,DATEPART(month, CONVERT(datetime, SUBSTRING([start_date], 1, 19),120)) AS [month]
    --     ,DATEPART(day, CONVERT(datetime, SUBSTRING([start_date], 1, 19),120)) AS [day]
    --     ,DATEPART(quarter, CONVERT(datetime, SUBSTRING([start_date], 1, 19),120)) AS [quarter]
    -- FROM [dbo].[stage_riders]
    --
    -- INSERT INTO [dates]
    -- SELECT
    --     CONVERT(datetime, SUBSTRING([end_date], 1, 19),120) AS datetime
    --     ,DATENAME(dw, CONVERT(datetime, SUBSTRING([end_date], 1, 19),120)) AS [day_of_week]
    --     ,DATEPART(hour, CONVERT(datetime, SUBSTRING([end_date], 1, 19),120)) AS [hour_of_day]
    --     ,DATEPART(year, CONVERT(datetime, SUBSTRING([end_date], 1, 19),120)) AS [year]
    --     ,DATEPART(month, CONVERT(datetime, SUBSTRING([end_date], 1, 19),120)) AS [month]
    --     ,DATEPART(day, CONVERT(datetime, SUBSTRING([end_date], 1, 19),120)) AS [day]
    --     ,DATEPART(quarter, CONVERT(datetime, SUBSTRING([end_date], 1, 19),120)) AS [quarter]
    -- FROM [dbo].[stage_riders]

    -- -- Payment dates
    -- INSERT INTO [dates]
    -- SELECT
    --     CONVERT(datetime, SUBSTRING([date], 1, 19),120) AS datetime
    --     ,DATENAME(dw, CONVERT(datetime, SUBSTRING([date], 1, 19),120)) AS [day_of_week]
    --     ,DATEPART(hour, CONVERT(datetime, SUBSTRING([date], 1, 19),120)) AS [hour_of_day]
    --     ,DATEPART(year, CONVERT(datetime, SUBSTRING([date], 1, 19),120)) AS [year]
    --     ,DATEPART(month, CONVERT(datetime, SUBSTRING([date], 1, 19),120)) AS [month]
    --     ,DATEPART(day, CONVERT(datetime, SUBSTRING([date], 1, 19),120)) AS [day]
    --     ,DATEPART(quarter, CONVERT(datetime, SUBSTRING([date], 1, 19),120)) AS [quarter]
    -- FROM [dbo].[stage_payments]

    -- The above queries cover all of the dates that exist in your various tables.
    -- A better approach is to create a date dimension table that creates all
    -- possible dates for a given date range that represents all the possible
    -- dates that already exist but also may exist within a reasonable time period.
    -- There are many approaches to this but typically a date dimension table
    -- will create an arbitrary range of dates that includes many years into
    -- the future so as to cover future transactional records.
    --
    -- The queries below get the range of dates between:
    -- 1. The oldest date possible, which should be the sign-up
    --    date of the very first rider i.e. the oldest stage_riders.start_date.
    -- 2. The latest date + 30 years. The latest date should be the the latest
    --    date in the database, that is, the latest end trip date i.e. the newest
    --    stage_trips.end_date.

    -- Get the latest date by creating a table that selects the latest trip and payment dates.
    -- START
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'temp_latest_dates')
        DROP TABLE [temp_latest_dates]
    GO

    CREATE TABLE [temp_latest_dates] (
        [date] datetime
    );

    WITH latest_trip AS (
        SELECT TOP 1 CONVERT(Datetime, SUBSTRING([ended_at], 1, 19),120) AS date FROM [dbo].[stage_trips] ORDER BY date DESC
    ), latest_payment AS (
        SELECT TOP 1 CONVERT(Datetime, SUBSTRING([date], 1, 19),120) AS date FROM [dbo].[stage_payments] ORDER BY date DESC
    )
    INSERT INTO [temp_latest_dates](date)
    SELECT date from latest_trip UNION ALL SELECT date FROM latest_payment;

    DECLARE @start_date DATETIME = (SELECT TOP 1 CONVERT(Datetime, SUBSTRING([start_date], 1, 19),120)
        FROM [dbo].[stage_riders] ORDER BY [start_date]);
    DECLARE @num_years INT = 1;
    DECLARE @cutoff_date DATETIME = (SELECT TOP 1 DATEADD(YEAR, @num_years, [date]) FROM
            [temp_latest_dates] ORDER BY [date] DESC);
    -- END

    INSERT [dates]([datetime])
    SELECT d
    FROM
    (
      SELECT d = DATEADD(HOUR, rn - 1, @start_date)
      FROM
      (
        SELECT TOP (DATEDIFF(HOUR, @start_date, @cutoff_date))
          rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
        FROM sys.all_objects AS s1
        CROSS JOIN sys.all_objects AS s2
        ORDER BY s1.[object_id]
      ) AS x
    ) AS y;


    UPDATE [dates]
    set
      [day_of_week]  = DATEPART(WEEKDAY,  [datetime]),
      [hour_of_day]  = DATEPART(HOUR,     [datetime]),
      [year]         = DATEPART(YEAR,     [datetime]),
      [month]        = DATEPART(MONTH,    [datetime]),
      [day]          = DATEPART(DAY,      [datetime]),
      [quarter]      = DATEPART(QUARTER,  [datetime])
    ;
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
    -- ,DATEDIFF(year, r.birthday,
    --     CONVERT(Datetime, SUBSTRING([start_date], 1, 19),120)) AS [rider_age]
    ,DATEDIFF(year, r.birthday,
        CONVERT(Datetime, SUBSTRING([started_at], 1, 19),120)) -
        CASE WHEN MONTH(r.birthday) >
            MONTH(CONVERT(Datetime, SUBSTRING([start_date], 1, 19),120))
        OR MONTH(r.birthday) =
            MONTH(CONVERT(Datetime, SUBSTRING([start_date], 1, 19),120))
        AND DAY(r.birthday) >
            DAY(CONVERT(Datetime, SUBSTRING([start_date], 1, 19),120))
        THEN 1 ELSE 0 END
        AS [rider_age]
    INTO [fact_payments]
    FROM [dbo].[stage_payments] p
    JOIN [dbo].[stage_riders] r
        ON p.[rider_id] = r.[rider_id]
GO
