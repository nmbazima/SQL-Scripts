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
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '23987hxJ#KL95234nl0zBe';  
GO 

IF EXISTS ( SELECT * FROM sys.server_principals WHERE name = N'sign_assemblies' )
	DROP LOGIN sign_assemblies

IF EXISTS ( SELECT * FROM sys.asymmetric_keys WHERE name = N'assembly_key')
	DROP ASYMMETRIC KEY assembly_key
