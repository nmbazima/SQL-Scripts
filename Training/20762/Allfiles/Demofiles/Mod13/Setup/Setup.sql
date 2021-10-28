USE master
GO

-- Drop and restore databases
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorks2014')
BEGIN
	DROP DATABASE AdventureWorks2014
END
GO


RESTORE DATABASE [AdventureWorks2014] FROM  DISK = N'D:\Setupfiles\AdventureWorks2014.bak' WITH  REPLACE,
MOVE N'AdventureWorks2014_Data' TO N'$(SUBDIR)Setup\AdventureWorks_Data.mdf', 
MOVE N'AdventureWorks2014_Log' TO N'$(SUBDIR)Setup\AdventureWorks_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks2014 TO [ADVENTUREWORKS\Student];
GO

USE master
GO

IF EXISTS ( SELECT * FROM sys.server_principals WHERE name = N'Trusted_Assembly_Login' )
	DROP LOGIN [Trusted_Assembly_Login]

IF EXISTS ( SELECT * FROM sys.asymmetric_keys WHERE name = N'ClrDemo_Key')
	DROP ASYMMETRIC KEY ClrDemo_Key

