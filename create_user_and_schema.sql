--need use sqldwschool
IF (SELECT schema_id FROM sys.schemas WHERE name = 'zharynin_schema')  IS NOT NULL
DROP SCHEMA zharynin_schema
GO
CREATE SCHEMA zharynin_schema
GO
IF  EXISTS (SELECT name FROM sys.database_principals WHERE name = 'zharynin')
DROP USER [zharynin]
GO
CREATE USER [zharynin] FOR LOGIN [zharynin] WITH DEFAULT_SCHEMA=[zharynin_schema]
GO
EXEC sp_addrolemember N'db_owner', N'zharynin'
GO
