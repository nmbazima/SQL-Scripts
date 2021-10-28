USE [master];
GO

DROP database if exists Adventureworks;
GO

RESTORE DATABASE [AdventureWorks] FROM  DISK = N'D:\SetupFiles\AdventureWorks_15.bak' WITH  REPLACE,
MOVE N'AdventureWorks_Data' TO N'$(SUBDIR)SetupFiles\AdventureWorks_Data.mdf', 
MOVE N'AdventureWorks_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks TO [ADVENTUREWORKS\Student];
GO

DROP database if exists MarketDev
RESTORE DATABASE [MarketDev] FROM  DISK = N'D:\SetupFiles\MarketDev_15.bak' WITH  FILE = 1,  
MOVE N'MarketDev' TO N'$(SUBDIR)SetupFiles\MarketDev_data.mdf',  
MOVE N'MarketDev_log' TO N'$(SUBDIR)SetupFiles\MarketDev_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5
GO
ALTER AUTHORIZATION ON DATABASE::MarketDev TO [ADVENTUREWORKS\Student];
GO