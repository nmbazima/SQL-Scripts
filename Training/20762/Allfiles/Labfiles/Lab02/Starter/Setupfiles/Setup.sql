USE master
GO

-- Drop and restore Databases


-- Drop the TSQL Database if this already exists
IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'TSQL')
BEGIN
	DROP DATABASE TSQL
END
GO

-- Restore the TSQL Database
RESTORE DATABASE [TSQL] FROM  DISK = N'D:\SetupFiles\TSQL.bak' WITH  REPLACE,
MOVE N'TSQL' TO N'$(SUBDIR)SetupFiles\TSQL.mdf', 
MOVE N'TSQL_Log' TO N'$(SUBDIR)SetupFiles\TSQL_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::TSQL TO [ADVENTUREWORKS\Student];
GO


