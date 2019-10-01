USE [master]
RESTORE DATABASE [TSQL] FROM  DISK = N'/var/opt/mssql/data/TSQL.bak' WITH  FILE = 1,  MOVE N'TSQL' TO N'/var/opt/mssql/data/TSQL.mdf',  MOVE N'TSQL_log' TO N'/var/opt/mssql/data/TSQL_log.ldf',  NOUNLOAD,  STATS = 5;
