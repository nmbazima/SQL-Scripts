USE master
GO

-- Drop and restore Databases


-- Drop the TSQL Database if this Already Exists
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'TSQL')
BEGIN
	DROP DATABASE TSQL
END
GO

-- Restore the TQL Database
RESTORE DATABASE [TSQL] FROM  DISK = N'D:\SetupFiles\TSQL.bak' WITH  REPLACE,
MOVE N'TSQL' TO N'$(SUBDIR)SetupFiles\TSQL.mdf', 
MOVE N'TSQL_Log' TO N'$(SUBDIR)SetupFiles\TSQL_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::TSQL TO [ADVENTUREWORKS\Student];
GO



-- Drop the AdventureWorks Database if this Already Exists
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorks2016')
BEGIN
	DROP DATABASE AdventureWorks2016
END
GO

-- Restore the AdventureWorks Database
RESTORE DATABASE [AdventureWorks2016] FROM  DISK = N'D:\SetupFiles\AdventureWorks2016.bak' WITH  REPLACE,
MOVE N'AdventureWorks2016_Data' TO N'$(SUBDIR)SetupFiles\AdventureWorks_Data.mdf', 
MOVE N'AdventureWorks2016_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks_log.ldf',
MOVE N'AdventureWorks2016_mod' TO N'$(SUBDIR)SetupFiles\AdventureWorks_mod.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks2016 TO [ADVENTUREWORKS\Student];
GO
