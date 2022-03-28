IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat')
    CREATE EXTERNAL FILE FORMAT SynapseDelimitedTextFormat
    WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
           FORMAT_OPTIONS (
             FIELD_TERMINATOR = ',',
             USE_TYPE_DEFAULT = FALSE
            ))
GO

-- DROP EXTERNAL DATA SOURCE myproject_dfs_core_windows_net
IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'myproject_dfs_core_windows_net')
    CREATE EXTERNAL DATA SOURCE myproject_dfs_core_windows_net
    WITH (
        LOCATION = 'abfss://udacitydwaz-fs@udacitydwaz.dfs.core.windows.net',
        TYPE = HADOOP
    )
GO

-- DROP EXTERNAL TABLE stage_payments
IF NOT EXISTS (SELECT * FROM sys.external_tables WHERE name = 'stage_payments')
  CREATE EXTERNAL TABLE stage_payments (
      [payment_id] int,
      [date] varchar(30),
      [amount] decimal(10,2),
      [rider_id] int
      )
      WITH (
      LOCATION = 'publicpayment.csv',
      DATA_SOURCE = myproject_dfs_core_windows_net,
      FILE_FORMAT = SynapseDelimitedTextFormat
      )
GO

-- DROP EXTERNAL TABLE stage_riders
IF NOT EXISTS (SELECT * FROM sys.external_tables WHERE name = 'stage_riders')
  CREATE EXTERNAL TABLE stage_riders (
      [rider_id] int,
      [first] varchar(30),
      [last] varchar(30),
      [address] varchar(100),
      [birthday] varchar(30),
      [start_date] varchar(30),
      [end_date] varchar(30),
      [member] bit
      )
      WITH (
      LOCATION = 'publicrider.csv',
      DATA_SOURCE = myproject_dfs_core_windows_net,
      FILE_FORMAT = SynapseDelimitedTextFormat
      )
GO

-- DROP EXTERNAL TABLE stage_stations
IF NOT EXISTS (SELECT * FROM sys.external_tables WHERE name = 'stage_stations')
  CREATE EXTERNAL TABLE stage_stations (
      [station_id] varchar(50),
      [name] varchar(100),
      [latitude] float,
      [longitude] float
      )
      WITH (
      LOCATION = 'publicstation.csv',
      DATA_SOURCE = myproject_dfs_core_windows_net,
      FILE_FORMAT = SynapseDelimitedTextFormat
      )
GO

-- DROP EXTERNAL TABLE stage_trips
IF NOT EXISTS (SELECT * FROM sys.external_tables WHERE name = 'stage_trips')
  CREATE EXTERNAL TABLE stage_trips (
      [trip_id] varchar(30),
      [rideable_type] varchar(30),
      [started_at] varchar(30),
      [ended_at] varchar(30),
      [start_station_id] varchar(50),
      [end_station_id] varchar(50),
      [rider_id] int
      )
      WITH (
      LOCATION = 'publictrip.csv',
      DATA_SOURCE = myproject_dfs_core_windows_net,
      FILE_FORMAT = SynapseDelimitedTextFormat
      )
GO
