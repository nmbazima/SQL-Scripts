use master

DROP DATABASE IF EXISTS AdventureWorks;

RESTORE DATABASE AdventureWorks FROM  DISK = N'D:\SetupFiles\AdventureWorks_09.bak' WITH  REPLACE,
MOVE N'AdventureWorks_Data' TO N'$(SUBDIR)SetupFiles\AdventureWorks.mdf', 
MOVE N'AdventureWorks_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks.ldf',
MOVE N'AdventureWorks_mod' TO N'$(SUBDIR)SetupFiles\AdventureWorks_mod'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks TO [ADVENTUREWORKS\Student];
GO


DROP database if exists MarketDev
RESTORE DATABASE [MarketDev] FROM  DISK = N'D:\SetupFiles\MarketDev.bak' WITH  FILE = 1,  
MOVE N'MarketDev' TO N'$(SUBDIR)SetupFiles\MarketDev_data.mdf',  
MOVE N'MarketDev_log' TO N'$(SUBDIR)SetupFiles\MarketDev_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5
GO
ALTER AUTHORIZATION ON DATABASE::MarketDev TO [ADVENTUREWORKS\Student];
GO

USE master;
GO
CREATE LOGIN SecureUser WITH PASSWORD = 'Pa$$w0rd', CHECK_POLICY = OFF;
GO

USE tempdb;
GO
CREATE USER SecureUser FOR LOGIN SecureUser;
GO