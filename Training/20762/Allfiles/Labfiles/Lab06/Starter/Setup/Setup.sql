USE master
GO

-- Drop and restore databases
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorks2016')
BEGIN
	DROP DATABASE AdventureWorks2016
END
GO


RESTORE DATABASE [AdventureWorks2016] FROM  DISK = N'D:\Setupfiles\AdventureWorks2016.bak' WITH  REPLACE,
MOVE N'AdventureWorks2016_Data' TO N'$(SUBDIR)Setup\AdventureWorks_Data.mdf', 
MOVE N'AdventureWorks2016_Log' TO N'$(SUBDIR)Setup\AdventureWorks_log.ldf',
MOVE N'AdventureWorks2016_mod' TO N'$(SUBDIR)Setup\AdventureWorks_mod'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks2016 TO [ADVENTUREWORKS\Student];
GO