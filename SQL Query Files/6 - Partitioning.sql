-- Demonstration 6 - Partitioning

Use master
GO

DROP DATABASE DemoDB
GO

CREATE DATABASE DemoDB
GO

Use DemoDB;
ALTER DATABASE DemoDB ADD FILEGROUP FG0000
GO
ALTER DATABASE DemoDB ADD FILE (NAME = F0000, FILENAME = 'C:\temp\F0000.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG0000;
GO
ALTER DATABASE DemoDB ADD FILEGROUP FG2000
GO
ALTER DATABASE DemoDB ADD FILE (NAME = F2000, FILENAME = 'C:\temp\F2000.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG2000;
GO
ALTER DATABASE DemoDB ADD FILEGROUP FG2001
GO
ALTER DATABASE DemoDB ADD FILE (NAME = F2001, FILENAME = 'C:\temp\F2001.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG2001;
GO
ALTER DATABASE DemoDB ADD FILEGROUP FG2002
GO
ALTER DATABASE DemoDB ADD FILE (NAME = F2002, FILENAME = 'C:\temp\F2002.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG2002;
GO
ALTER DATABASE DemoDB ADD FILEGROUP FG2003
GO
ALTER DATABASE DemoDB ADD FILE (NAME = F2003, FILENAME = 'C:\temp\F2003.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG2002;
GO

-- Create a partitioned table
CREATE PARTITION FUNCTION PF (int) AS RANGE RIGHT FOR VALUES (20000101, 20010101, 20020101);
CREATE PARTITION SCHEME PS AS PARTITION PF TO (FG0000, FG2000, FG2001, FG2002, FG2003);

CREATE TABLE dbo.order_table
 (datekey int, amount int)
ON PS(datekey);
GO

INSERT dbo.order_table VALUES (20000101, 100);
INSERT dbo.order_table VALUES (20001231, 100);
INSERT dbo.order_table VALUES (20010101, 100);
INSERT dbo.order_table VALUES (20010403, 100);
GO

-- View partition metadata
SELECT ps.name AS PartitionScheme, pf.name AS PartitionFunction, p.partition_number AS PartitionNumber, fg.name AS Filegroup, prv_left.value AS StartKey, prv_right.value AS EndKey, p.row_count Rows
FROM sys.dm_db_partition_stats p
INNER JOIN sys.indexes i
ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.data_spaces ds
ON ds.data_space_id = i.data_space_id
LEFT OUTER JOIN sys.partition_schemes ps
ON ps.data_space_id = i.data_space_id
LEFT OUTER JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
LEFT OUTER JOIN sys.destination_data_spaces dds
ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
LEFT OUTER JOIN sys.filegroups fg
ON fg.data_space_id = dds.data_space_id
LEFT OUTER JOIN sys.partition_range_values prv_right
ON prv_right.function_id = ps.function_id AND prv_right.boundary_id = p.partition_number
LEFT OUTER JOIN sys.partition_range_values prv_left
ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
WHERE OBJECT_NAME(p.object_id) = 'order_table'
AND i.index_id = 0
ORDER BY PartitionNumber
GO

-- Split the partition at the end to add a new partition for 2003 onwards
ALTER PARTITION FUNCTION PF() SPLIT RANGE(20030101);
GO

-- View partition metadata again
SELECT ps.name AS PartitionScheme, pf.name AS PartitionFunction, p.partition_number AS PartitionNumber, fg.name AS Filegroup, prv_left.value AS StartKey, prv_right.value AS EndKey, p.row_count Rows
FROM sys.dm_db_partition_stats p
INNER JOIN sys.indexes i
ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.data_spaces ds
ON ds.data_space_id = i.data_space_id
LEFT OUTER JOIN sys.partition_schemes ps
ON ps.data_space_id = i.data_space_id
LEFT OUTER JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
LEFT OUTER JOIN sys.destination_data_spaces dds
ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
LEFT OUTER JOIN sys.filegroups fg
ON fg.data_space_id = dds.data_space_id
LEFT OUTER JOIN sys.partition_range_values prv_right
ON prv_right.function_id = ps.function_id AND prv_right.boundary_id = p.partition_number
LEFT OUTER JOIN sys.partition_range_values prv_left
ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
WHERE OBJECT_NAME(p.object_id) = 'order_table'
AND i.index_id = 0
ORDER BY PartitionNumber
GO

-- Merge 2000 and pre-2000
ALTER PARTITION FUNCTION PF()
MERGE RANGE (20000101);
GO

-- view partition info
SELECT ps.name AS PartitionScheme, pf.name AS PartitionFunction, p.partition_number AS PartitionNumber, fg.name AS Filegroup, prv_left.value AS StartKey, prv_right.value AS EndKey, p.row_count Rows
FROM sys.dm_db_partition_stats p
INNER JOIN sys.indexes i
ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.data_spaces ds
ON ds.data_space_id = i.data_space_id
LEFT OUTER JOIN sys.partition_schemes ps
ON ps.data_space_id = i.data_space_id
LEFT OUTER JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
LEFT OUTER JOIN sys.destination_data_spaces dds
ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
LEFT OUTER JOIN sys.filegroups fg
ON fg.data_space_id = dds.data_space_id
LEFT OUTER JOIN sys.partition_range_values prv_right
ON prv_right.function_id = ps.function_id AND prv_right.boundary_id = p.partition_number
LEFT OUTER JOIN sys.partition_range_values prv_left
ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
WHERE OBJECT_NAME(p.object_id) = 'order_table'
AND i.index_id = 0
ORDER BY PartitionNumber
GO

-- Create an archive table
CREATE TABLE dbo.archive_staging_table
 (datekey int, amount int)
ON FG0000;
GO


-- Switch the partition
ALTER TABLE dbo.order_table SWITCH PARTITION $PARTITION.PF(20000101)
TO dbo.archive_staging_table 
GO

-- view archive data
SELECT * FROM dbo.archive_staging_table;

-- view partition info
SELECT ps.name AS PartitionScheme, pf.name AS PartitionFunction, p.partition_number AS PartitionNumber, fg.name AS Filegroup, prv_left.value AS StartKey, prv_right.value AS EndKey, p.row_count Rows
FROM sys.dm_db_partition_stats p
INNER JOIN sys.indexes i
ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.data_spaces ds
ON ds.data_space_id = i.data_space_id
LEFT OUTER JOIN sys.partition_schemes ps
ON ps.data_space_id = i.data_space_id
LEFT OUTER JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
LEFT OUTER JOIN sys.destination_data_spaces dds
ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
LEFT OUTER JOIN sys.filegroups fg
ON fg.data_space_id = dds.data_space_id
LEFT OUTER JOIN sys.partition_range_values prv_right
ON prv_right.function_id = ps.function_id AND prv_right.boundary_id = p.partition_number
LEFT OUTER JOIN sys.partition_range_values prv_left
ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
WHERE OBJECT_NAME(p.object_id) = 'order_table'
AND i.index_id = 0
ORDER BY PartitionNumber
GO

