USE master
GO

-- Drop and restore Databases

IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'InternetSales')
BEGIN
	DROP DATABASE InternetSales
END
GO


RESTORE DATABASE [InternetSales] FROM  DISK = N'D:\SetupFiles\InternetSales.bak' WITH  REPLACE,
MOVE N'InternetSales' TO N'$(SUBDIR)SetupFiles\InternetSales.mdf', 
MOVE N'InternetSales_Log' TO N'$(SUBDIR)SetupFiles\InternetSales_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::InternetSales TO [ADVENTUREWORKS\Student];
GO