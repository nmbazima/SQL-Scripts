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