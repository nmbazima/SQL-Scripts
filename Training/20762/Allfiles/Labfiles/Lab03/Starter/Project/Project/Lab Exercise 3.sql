-- Module 3 - Lab Exercise 3 - Test the Partitioning Strategy

-- Query the Timesheet table
USE HumanResources;
GO
SELECT	PersonID, ShiftID, RegisteredStartTime, RegisteredEndTime, $PARTITION.pfHumanResourcesDates(RegisteredStartTime) AS PartitionNumber
FROM	Payment.Timesheet;
GO


-- View partition metadata
SELECT	i.index_id, i.name AS IndexName, ps.name AS PartitionScheme, pf.name AS PartitionFunction, p.partition_number AS PartitionNumber, 
		fg.name AS [Filegroup], prv_left.[value] AS StartKey, prv_right.[value] AS EndKey, p.row_count AS [Rows]
FROM	sys.dm_db_partition_stats AS p
INNER	JOIN sys.indexes AS i								ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
INNER	JOIN sys.data_spaces AS ds							ON ds.data_space_id = i.data_space_id
LEFT	OUTER JOIN sys.partition_schemes AS ps				ON ps.data_space_id = i.data_space_id
LEFT	OUTER JOIN sys.partition_functions AS pf			ON ps.function_id = pf.function_id
LEFT	OUTER JOIN sys.destination_data_spaces AS dds		ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
LEFT	OUTER JOIN sys.filegroups AS fg						ON fg.data_space_id = dds.data_space_id
LEFT	OUTER JOIN sys.partition_range_values AS prv_right	ON prv_right.function_id = ps.function_id AND prv_right.boundary_id = p.partition_number
LEFT	OUTER JOIN sys.partition_range_values AS prv_left	ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
WHERE	OBJECT_NAME(p.object_id) = 'Timesheet'
GO


-- Create the staging table
CREATE TABLE Timesheet_Staging
(
	PersonID int NOT NULL,
	ShiftID tinyint NOT NULL,
	RegisteredStartTime datetime NOT NULL,
	RegisteredEndTime datetime NOT NULL,
	CONSTRAINT PK_Timesheet_PersonID_ShiftID_RegisteredStartTime PRIMARY KEY (PersonID ASC, ShiftID ASC, RegisteredStartTime)
) ON FG1
GO


-- Add check constraint 
ALTER TABLE Timesheet_Staging
WITH CHECK ADD CONSTRAINT DateBoundaries
CHECK (RegisteredStartTime >= '2011-10-01 00:00' and RegisteredStartTime < '2012-01-01 00:00' AND RegisteredStartTime IS NOT NULL);
GO


-- Switch out the old data
DECLARE @p int = $PARTITION.pfHumanResourcesDates('2011-10-01 00:00');
ALTER TABLE Payment.Timesheet
SWITCH PARTITION @p TO Timesheet_Staging 
GO


-- View archive data in staging table 
SELECT * FROM Timesheet_Staging


-- View partition metadata
SELECT	i.index_id, i.name AS IndexName, ps.name AS PartitionScheme, pf.name AS PartitionFunction, p.partition_number AS PartitionNumber, 
		fg.name AS [Filegroup], prv_left.[value] AS StartKey, prv_right.[value] AS EndKey, p.row_count AS [Rows]
FROM	sys.dm_db_partition_stats AS p
INNER	JOIN sys.indexes AS i								ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
INNER	JOIN sys.data_spaces AS ds							ON ds.data_space_id = i.data_space_id
LEFT	OUTER JOIN sys.partition_schemes AS ps				ON ps.data_space_id = i.data_space_id
LEFT	OUTER JOIN sys.partition_functions AS pf			ON ps.function_id = pf.function_id
LEFT	OUTER JOIN sys.destination_data_spaces AS dds		ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
LEFT	OUTER JOIN sys.filegroups AS fg						ON fg.data_space_id = dds.data_space_id
LEFT	OUTER JOIN sys.partition_range_values AS prv_right	ON prv_right.function_id = ps.function_id AND prv_right.boundary_id = p.partition_number
LEFT	OUTER JOIN sys.partition_range_values AS prv_left	ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
WHERE	OBJECT_NAME(p.object_id) = 'Timesheet'
GO


-- Merge the first two partitions
ALTER PARTITION FUNCTION pfHumanResourcesDates() MERGE RANGE('2011-10-01 00:00');
GO


-- View partition metadata
SELECT	i.index_id, i.name AS IndexName, ps.name AS PartitionScheme, pf.name AS PartitionFunction, p.partition_number AS PartitionNumber, 
		fg.name AS [Filegroup], prv_left.[value] AS StartKey, prv_right.[value] AS EndKey, p.row_count AS [Rows]
FROM	sys.dm_db_partition_stats AS p
INNER	JOIN sys.indexes AS i								ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
INNER	JOIN sys.data_spaces AS ds							ON ds.data_space_id = i.data_space_id
LEFT	OUTER JOIN sys.partition_schemes AS ps				ON ps.data_space_id = i.data_space_id
LEFT	OUTER JOIN sys.partition_functions AS pf			ON ps.function_id = pf.function_id
LEFT	OUTER JOIN sys.destination_data_spaces AS dds		ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
LEFT	OUTER JOIN sys.filegroups AS fg						ON fg.data_space_id = dds.data_space_id
LEFT	OUTER JOIN sys.partition_range_values AS prv_right	ON prv_right.function_id = ps.function_id AND prv_right.boundary_id = p.partition_number
LEFT	OUTER JOIN sys.partition_range_values AS prv_left	ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
WHERE	OBJECT_NAME(p.object_id) = 'Timesheet'
GO


-- Make FG1 the next used filegroup  
ALTER PARTITION SCHEME psHumanResources
NEXT USED FG1;
GO


-- Split the empty partition at the end
ALTER PARTITION FUNCTION pfHumanResourcesDates() SPLIT RANGE('2012-07-01 00:00');
GO


-- Insert data for the new period
INSERT INTO Payment.Timesheet
VALUES (28,1, '2012-05-21 07:00', '2012-05-21 15:00');
GO
INSERT INTO Payment.Timesheet
VALUES (28,1, '2012-05-23 07:00', '2012-05-23 15:00');
GO

-- View partition metadata
SELECT	i.index_id, i.name AS IndexName, ps.name AS PartitionScheme, pf.name AS PartitionFunction, p.partition_number AS PartitionNumber, 
		fg.name AS [Filegroup], prv_left.[value] AS StartKey, prv_right.[value] AS EndKey, p.row_count AS [Rows]
FROM	sys.dm_db_partition_stats AS p
INNER	JOIN sys.indexes AS i								ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
INNER	JOIN sys.data_spaces AS ds							ON ds.data_space_id = i.data_space_id
LEFT	OUTER JOIN sys.partition_schemes AS ps				ON ps.data_space_id = i.data_space_id
LEFT	OUTER JOIN sys.partition_functions AS pf			ON ps.function_id = pf.function_id
LEFT	OUTER JOIN sys.destination_data_spaces AS dds		ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
LEFT	OUTER JOIN sys.filegroups AS fg						ON fg.data_space_id = dds.data_space_id
LEFT	OUTER JOIN sys.partition_range_values AS prv_right	ON prv_right.function_id = ps.function_id AND prv_right.boundary_id = p.partition_number
LEFT	OUTER JOIN sys.partition_range_values AS prv_left	ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
WHERE	OBJECT_NAME(p.object_id) = 'Timesheet'
GO