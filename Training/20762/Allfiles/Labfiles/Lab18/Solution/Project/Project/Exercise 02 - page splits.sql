-- Module 9 Exercise 1

-- Task 1 - create an Extended Events session to track page splits
-- create a new Extended Events session on the MIA-SQL instance with the following properties:
-- Session name: track page splits
-- Event(s) included: sqlserver.transaction_log
-- Event filter(s): 
--  operation = LOP_DELETE_SPLIT
--  database_name = AdventureWorks
-- Session target: Histogram
--  Filtering target: sqlserver.transaction_log
--  Source: alloc_unit_id
--  Source type: event

-- Task 2 - run a workload
-- Run the workload before proceeding with this exercise

-- Task 3 - query the output from the session
-- Edit the following query to extract data from the histogram target of the track page splits session. 
-- Use the DMV sys.dm_xe_session_targets to extract data from the session’s histogram target. 
-- For this task, include only the target_data column in your output result set, cast to XML.
USE AdventureWorks;
GO
SELECT CAST(target_data AS XML) AS target_data
FROM sys.dm_xe_sessions AS xs 
JOIN sys.dm_xe_session_targets xt
ON xs.address = xt.event_session_address
WHERE xs.name = 'track page splits'
AND xt.target_name = 'histogram';
  
-- Task 4 - Extract alloc_unit_id and Count values
-- Edit the following query so that it returns the count attribute for 
-- each HistogramTarget/Slot node, and the value child node for each HistogramTarget/Slot node. 

SELECT xe_node.value('(value)[1]', 'bigint') AS alloc_unit_id,
       xe_node.value('(@count)[1]', 'bigint') AS split_count
FROM (	SELECT CAST(target_data AS XML) AS target_data
		FROM sys.dm_xe_sessions AS xs 
		JOIN sys.dm_xe_session_targets xt
		ON xs.address = xt.event_session_address
		WHERE xs.name = 'track page splits'
		AND xt.target_name = 'histogram') AS xe_data
CROSS APPLY target_data.nodes('HistogramTarget/Slot') AS xe_xml (xe_node);

-- Task 5 - Find object names
-- Edit the folloiwng query to join to sys.allocation_units, sys.partitions and sys.indexes 
-- to find the names of objects affected by page splits. 
SELECT OBJECT_SCHEMA_NAME(sp.object_id) AS object_schema,
		OBJECT_NAME(sp.object_id) AS object_name, 
		si.name AS index_name,
		xe.split_count
FROM (	SELECT xe_node.value('(value)[1]', 'bigint') AS alloc_unit_id,
				xe_node.value('(@count)[1]', 'bigint') AS split_count
		FROM (	SELECT CAST(target_data AS XML) AS target_data
				FROM sys.dm_xe_sessions AS xs 
				JOIN sys.dm_xe_session_targets xt
				ON xs.address = xt.event_session_address
				WHERE xs.name = 'track page splits'
				AND xt.target_name = 'histogram') AS xe_data
		CROSS APPLY target_data.nodes('HistogramTarget/Slot') AS xe_xml (xe_node)) AS xe
JOIN sys.allocation_units AS sau
ON sau.allocation_unit_id = xe.alloc_unit_id
JOIN sys.partitions AS sp
ON sp.partition_id = sau.container_id
JOIN sys.indexes AS si
ON si.object_id = sp.object_id
AND si.index_id = sp.index_id;
	