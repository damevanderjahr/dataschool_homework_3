-- need use master db
IF (SELECT name FROM sys.sql_logins WHERE name = 'zharynin')  IS NOT NULL
DROP LOGIN zharynin
GO
