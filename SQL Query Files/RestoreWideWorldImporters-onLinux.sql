USE master
2> RESTORE DATABASE WideWorldImporters
3> FROM DISK = N'C:\Users\newton\Desktop\WideWorldImporters-FULL.bak'
4> WITH FILE = 1;
5> MOVE N'WWI_Primary' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\WideWorldImporters.mdf';
6> MOVE N'WWI_UserData' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\WIdeWorldImports_UserData.ndf';
7> MOVE N'WWI_Log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\WideWorldImporters.ldf';
8> MOVE N'WWI_InMemory_Data_1' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\WideWorldImporters_InMemory_Data_1';
9> NOUNLOAD, STATS = 5
10> GO
