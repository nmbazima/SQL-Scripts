USE master
GO


-- Drop the AdventureWorks Database if it already Exists
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorks2016')
BEGIN
	DROP DATABASE AdventureWorks2016
END
GO

-- Restore the AdventureWorks2016 Database
RESTORE DATABASE [AdventureWorks2016] FROM DISK = N'D:\Setupfiles\AdventureWorks2016.bak' WITH  REPLACE,
MOVE N'AdventureWorks2016_Data' TO N'$(SUBDIR)SetupFiles\AdventureWorks2016_Data.mdf', 
MOVE N'AdventureWorks2016_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks2016_log.ldf',
MOVE N'AdventureWorks2016_mod' TO N'$(SUBDIR)SetupFiles\AdventureWorks2016_mod'

GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks2016 TO [ADVENTUREWORKS\Student];
GO