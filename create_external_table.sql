--use previously created login
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '[ДАННЫЕ УДАЛЕНЫ]'
GO

IF (SELECT credential_id FROM sys.database_scoped_credentials WHERE name = 'AzureStorageZharynin') IS NOT NULL
DROP DATABASE SCOPED CREDENTIAL AzureStorageZharynin
GO
CREATE DATABASE SCOPED CREDENTIAL AzureStorageZharynin
WITH
  IDENTITY = 'SHARED ACCESS SIGNATURE' ,
  SECRET = '[ДАННЫЕ УДАЛЕНЫ]'
GO

CREATE EXTERNAL DATA SOURCE zharynin_blob
  WITH
  -- Please note the abfss endpoint when your account has secure transfer enabled
  ( LOCATION = 'abfss://zharynin@bigdataschools01.blob.core.windows.net' ,
    CREDENTIAL = AzureStorageZharynin ,
    TYPE = HADOOP
  ) ;

IF (SELECT file_format_id FROM sys.external_file_formats WHERE name = 'file_format_zharynin') IS NOT NULL
DROP EXTERNAL FILE FORMAT file_format_zharynin
GO
CREATE EXTERNAL FILE FORMAT file_format_zharynin
  WITH (
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS ( FIELD_TERMINATOR = ',',
    First_Row = 2)
  );

IF OBJECT_ID('zharynin_schema.table_ext_zharynin', 'ET') IS NOT NULL
DROP EXTERNAL TABLE sqldwschool.zharynin_schema.table_ext_zharynin
GO
CREATE EXTERNAL TABLE sqldwschool.zharynin_schema.table_ext_zharynin
(
  VendorID              int      ,
  tpep_pickup_datetime  datetime ,
  tpep_dropoff_datetime datetime ,
  passenger_count       int      ,
  Trip_distance         float(24),
  RatecodeID            int      ,
  store_and_fwd_flag    char(1)  ,
  PULocationID          int      ,
  DOLocationID          int      ,
  payment_type          int      ,
  fare_amount           money,
  extra                 money,
  mta_tax               money,
  tip_amount            money,
  tolls_amount          money,
  improvement_surcharge money,
  total_amount          money,
  congestion_surcharge  money
)
  WITH (
    LOCATION = '/homework_3/yellow_tripdata_2020-01.csv',
    DATA_SOURCE = zharynin_blob,
    FILE_FORMAT = file_format_zharynin
  )
