USE master
GO

-- Drop and restore Databases
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorksDW')
BEGIN
	DROP DATABASE AdventureWorksDW
END
GO

RESTORE DATABASE [AdventureWorksDW] FROM  DISK = N'D:\SetupFiles\AdventureWorksDW.bak' WITH  REPLACE,
MOVE N'AdventureWorksDW2012_Data' TO N'$(SUBDIR)SetupFiles\AdventureWorksDW_Data.mdf', 
MOVE N'AdventureWorksDW2012_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorksDW_log.ldf'
GO

ALTER AUTHORIZATION ON DATABASE::AdventureWorksDW TO [ADVENTUREWORKS\Student];
GO