USE master
GO

-- Drop and restore Databases
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorks')
BEGIN
	DROP DATABASE AdventureWorks
END
GO


RESTORE DATABASE [AdventureWorks] FROM  DISK = N'D:\SetupFiles\AdventureWorks.bak' WITH  REPLACE,
MOVE N'AdventureWorks2012_Data' TO N'$(SUBDIR)SetupFiles\AdventureWorks.mdf', 
MOVE N'AdventureWorks2012_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks TO [ADVENTUREWORKS\Student];
GO

IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'MarketDev')
BEGIN
	DROP DATABASE MarketDev
END
GO

RESTORE DATABASE [MarketDev] FROM  DISK = N'D:\SetupFiles\MarketDev.bak' WITH  REPLACE,
MOVE N'MarketDev' TO N'$(SUBDIR)SetupFiles\MarketDev.mdf', 
MOVE N'MarketDev_Log' TO N'$(SUBDIR)SetupFiles\MarketDev_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::MarketDev TO [ADVENTUREWORKS\Student];
GO