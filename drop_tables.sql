-- drop tables, etc.
IF OBJECT_ID('zharynin_schema.Payment_type', 'U') IS NOT NULL
DROP TABLE zharynin_schema.Payment_type
GO

IF OBJECT_ID('zharynin_schema.RateCode', 'U') IS NOT NULL
DROP TABLE zharynin_schema.RateCode
GO

IF OBJECT_ID('zharynin_schema.Vendor', 'U') IS NOT NULL
DROP TABLE zharynin_schema.Vendor
GO

IF OBJECT_ID('zharynin_schema.fact_tripdata', 'ET') IS NOT NULL
DROP TABLE zharynin_schema.fact_tripdata
GO

IF (SELECT file_format_id FROM sys.external_file_formats WHERE name = 'file_format_zharynin') IS NOT NULL
DROP EXTERNAL FILE FORMAT file_format_zharynin
GO

IF (SELECT data_source_id FROM sys.external_data_sources WHERE name = 'zharynin_blob') IS NOT NULL
DROP EXTERNAL DATA SOURCE zharynin_blob
GO

IF (SELECT credential_id FROM sys.database_scoped_credentials WHERE name = 'AzureStorageZharynin') IS NOT NULL
DROP DATABASE SCOPED CREDENTIAL AzureStorageZharynin
GO
