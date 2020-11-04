--need use sqldwschool
IF  EXISTS (SELECT name FROM sys.database_principals WHERE name = 'zharynin')
DROP USER [zharynin]
GO

IF (SELECT schema_id FROM sys.schemas WHERE name = 'zharynin_schema')  IS NOT NULL
DROP SCHEMA zharynin_schema
GO
