USE master
GO

-- Drop and restore Databases

-- Drop the AdventureWorks2016 Database if this Already Exists
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorks2016')
BEGIN
	DROP DATABASE AdventureWorks2016
END
GO

-- Restore the AdventureWorks Database
RESTORE DATABASE [AdventureWorks2016] FROM  DISK = N'D:\Setupfiles\AdventureWorks2016_16.bak' WITH  REPLACE,
MOVE N'AdventureWorks2016_Data' TO N'$(SUBDIR)Setupfiles\AdventureWorks2016_Data.mdf', 
MOVE N'AdventureWorks2016_Log' TO N'$(SUBDIR)Setupfiles\AdventureWorks2016_log.ldf',
MOVE N'AdventureWorks2016_mod' TO N'$(SUBDIR)Setupfiles\AdventureWorks2016_mod'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks2016 TO [ADVENTUREWORKS\Student];
GO