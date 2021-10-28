USE master
GO

-- Drop and restore Databases
DROP DATABASE IF EXISTS TSQL;
DROP DATABASE IF EXISTS AdventureWorks;
DROP DATABASE IF EXISTS AdventureWorks2016;
DROP DATABASE IF EXISTS AdventureWorks2016CTP3;
GO

RESTORE DATABASE [TSQL] FROM  DISK = N'D:\SetupFiles\TSQL.bak' WITH  REPLACE,
MOVE N'TSQL' TO N'$(SUBDIR)SetupFiles\TSQL.mdf', 
MOVE N'TSQL_Log' TO N'$(SUBDIR)SetupFiles\TSQL_log.ldf'
GO


RESTORE DATABASE [AdventureWorks] FROM  DISK = N'D:\SetupFiles\AdventureWorks.bak' WITH  REPLACE,
MOVE N'AdventureWorks2012_Data' TO N'$(SUBDIR)SetupFiles\AdventureWorks_Data.mdf', 
MOVE N'AdventureWorks2012_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks_log.ldf'
GO


RESTORE DATABASE [AdventureWorks2016] FROM  DISK = N'D:\SetupFiles\AdventureWorks2016CTP3.bak' WITH  REPLACE,
MOVE N'AdventureWorks2016CTP3_Data' TO N'$(SUBDIR)SetupFiles\AdventureWorks2016CTP3_Data.mdf', 
MOVE N'AdventureWorks2016CTP3_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks2016CTP3_log.ldf'
GO
