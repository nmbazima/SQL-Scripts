USE master
GO


IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorks')
BEGIN
	DROP DATABASE AdventureWorks
END
GO

RESTORE DATABASE [AdventureWorks] FROM  DISK = N'D:\SetupFiles\AdventureWorks2016.bak' WITH  REPLACE,
MOVE N'AdventureWorks2016_Data' TO N'$(SUBDIR)SetupFiles\AdventureWorks_Data.mdf', 
MOVE N'AdventureWorks2016_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks_log.ldf',
MOVE N'AdventureWorks2016_mod' TO N'$(SUBDIR)SetupFiles\AdventureWorks2016_mod'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks TO [ADVENTUREWORKS\Student];
GO