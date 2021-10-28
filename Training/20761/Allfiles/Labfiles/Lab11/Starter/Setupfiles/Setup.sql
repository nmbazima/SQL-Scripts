USE master
GO

-- Drop and restore Databases
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'TSQL')
BEGIN
	DROP DATABASE TSQL
END
GO



RESTORE DATABASE [TSQL] FROM  DISK = N'D:\SetupFiles\TSQL_11.bak' WITH  REPLACE,
MOVE N'TSQL' TO N'$(SUBDIR)SetupFiles\TSQL.mdf', 
MOVE N'TSQL_Log' TO N'$(SUBDIR)SetupFiles\TSQL_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::TSQL TO [ADVENTUREWORKS\Student];
GO

IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorks')
BEGIN
	DROP DATABASE AdventureWorks
END
GO



RESTORE DATABASE [AdventureWorks] FROM  DISK = N'D:\SetupFiles\AdventureWorks.bak' WITH  REPLACE,
MOVE N'AdventureWorks2012_Data' TO N'$(SUBDIR)SetupFiles\AdventureWorks_Data.mdf', 
MOVE N'AdventureWorks2012_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks TO [ADVENTUREWORKS\Student];
GO