-- Module 3 - Lab Exercise 5 - Estimate Storage Savings with Compression



-- View partition metadata
USE HumanResources
GO
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



-- View compression estimated savings
EXEC sp_estimate_data_compression_savings 'Payment', 'Timesheet', NULL, NULL, 'ROW';
EXEC sp_estimate_data_compression_savings 'Payment', 'Timesheet', NULL, NULL, 'PAGE';