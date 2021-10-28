USE master
GO

-- Drop and restore Databases
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorksDW')
BEGIN
	DROP DATABASE AdventureWorksDW
END
GO

RESTORE DATABASE [AdventureWorksDW] FROM  DISK = N'D:\SetupFiles\AdventureWorksDW.bak' WITH REPLACE
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorksDW TO [ADVENTUREWORKS\Student];
GO