USE master
GO

-- Drop and restore Databases
DROP DATABASE IF EXISTS AdventureWorks;
DROP DATABASE IF EXISTS AdventureWorks2016;
GO

RESTORE DATABASE [AdventureWorks2016] FROM  DISK = N'D:\Setupfiles\AdventureWorks2016_16.bak' WITH  REPLACE,
MOVE N'AdventureWorks2016_Data' TO N'$(SUBDIR)SetupFiles\AdventureWorks2016_Data.mdf', 
MOVE N'AdventureWorks2016_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks2016_log.ldf',
MOVE N'AdventureWorks2016_mod' TO N'$(SUBDIR)SetupFiles\AdventureWorks2016_mod'
GO
