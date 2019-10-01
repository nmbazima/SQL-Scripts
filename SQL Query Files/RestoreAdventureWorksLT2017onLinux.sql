USE [master]
RESTORE DATABASE [AdventureWorksLT2017] FROM  DISK = N'/var/opt/mssql/data/AdventureWorksLT2017.bak' WITH  FILE = 1,  MOVE N'AdventureWorksLT2012_Data' TO N'/var/opt/mssql/data/AdventureWorksLT2012.mdf',  MOVE N'AdventureWorksLT2012_Log' TO N'/var/opt/mssql/data/AdventureWorksLT2012_log.ldf',  NOUNLOAD,  STATS = 5;
