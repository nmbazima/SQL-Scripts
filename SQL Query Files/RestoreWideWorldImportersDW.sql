restore database wideworldimportersDW from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\wideworldimportersDW-full.bak'
with move 'wwi_primary' to 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\wideworldimportersDW.mdf',
move 'wwi_userdata' to 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\wideworldimportersDW_userdata.ndf',
move 'wwi_log' to 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\wideworldimportersDW.ldf',
move 'wwiDW_inmemory_data_1' to 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\wideworldimportersDW_inmemory_data_1',
stats