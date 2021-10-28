restore database wideworldimporters from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Backup\wideworldimporters-full.bak'
with move 'wwi_primary' to 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\wideworldimporters.mdf',
move 'wwi_userdata' to 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\wideworldimporters_userdata.ndf',
move 'wwi_log' to 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\wideworldimporters.ldf',
move 'wwi_inmemory_data_1' to 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\wideworldimporters_inmemory_data_1',
stats