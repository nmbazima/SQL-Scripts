USE [master]
RESTORE DATABASE [AdventureWorks2016CTP3] FROM  DISK = N'E:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\AdventureWorks2016CTP3.bak' WITH  FILE = 1,  MOVE N'AdventureWorks2016CTP3_Data' TO N'E:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureWorks2016CTP3_Data.mdf',  MOVE N'AdventureWorks2016CTP3_Log' TO N'E:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureWorks2016CTP3_Log.ldf',  MOVE N'AdventureWorks2016CTP3_mod' TO N'E:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureWorks2016CTP3_mod',  NOUNLOAD,  STATS = 5

GO

