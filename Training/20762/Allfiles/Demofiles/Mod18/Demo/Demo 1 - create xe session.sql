-- Module 18 - Demo 1

-- Step 1 - Define an Extended Events session to capture the text of completed SQL statements
-- when executed by the ADVENTUREWORKS\Student login
CREATE EVENT SESSION SqlStatementCompleted 
	ON SERVER ADD EVENT sqlserver.sql_statement_completed 
	(
	ACTION (sqlserver.sql_text,sqlserver.session_id)
	WHERE server_principal_name = 'ADVENTUREWORKS\Student'
	)

ADD TARGET package0.ring_buffer
WITH (MAX_MEMORY=4096 KB,
	EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
	MAX_DISPATCH_LATENCY=30 SECONDS,
	MAX_EVENT_SIZE=0 KB,
	MEMORY_PARTITION_MODE=NONE,
	TRACK_CAUSALITY=OFF,
	STARTUP_STATE=OFF);
GO

-- Step 2 - the session has been created, so it exists in sys.server_event_sessions
-- but is not visible in sys.dm_xe_sessions
SELECT * FROM sys.server_event_sessions WHERE name = 'SqlStatementCompleted';
SELECT * FROM sys.dm_xe_sessions WHERE name = 'SqlStatementCompleted';

-- Step 3 - alter the session to start it and execute some SQL statements
ALTER EVENT SESSION SqlStatementCompleted ON SERVER
	STATE=START
GO
SELECT 'sample extended events 1' AS v1;
GO
SELECT 'sample extended events 2' AS v2;
GO


-- Step 4 - query the captured data
-- run the SQL statement below, then click on the XML data in the first row of the xe_data column
-- In the xml window which opens, scroll down to demonstrate that the SELECT statements
-- executed in step 2 were captured. 
-- Demonstrate that the structure of the XML corresponds to the session definition, with actions nested inside events
SELECT CAST(target_data AS XML) AS xe_data
FROM sys.dm_xe_session_targets AS st
JOIN sys.dm_xe_sessions AS  s 
ON st.event_session_address = s.address
WHERE s.name = 'SqlStatementCompleted';

-- Step 5 - query the captured data (ii) - to make the data more usable, shred the XML
-- run the SQL statement below, then click on the XML data in the first row of the xe_event column
-- In the xml window which opens, scroll down to demonstrate that it includes a single event
-- Explain that you can use the .value XML method to apply filters and extract individual values
SELECT TOP (10) xa.xe_xml.query('.') AS xe_event,
xa.xe_xml.value('(./data[@name="statement"]/value)[1]', 'nvarchar(MAX)') AS sql_statement,
xa.xe_xml.value('(./data[@name="duration"]/value)[1]', 'bigint')AS duration_ms
FROM	(	SELECT CAST(target_data AS XML) AS xe_data
			FROM sys.dm_xe_session_targets AS st
			JOIN sys.dm_xe_sessions AS  s 
			ON st.event_session_address = s.address
			WHERE s.name = 'SqlStatementCompleted'
		) AS xe
CROSS APPLY xe_data.nodes('//event') xa (xe_xml);

-- Step 6 - Use the GUI
-- In Object Explorer, expand the Management node under MIA-SQL, then expand the Extended Events node, then the Sessions node. 
-- Expand the SqlStatementCompleted node, then double-click package0.ring_buffer
-- Click the XML value in the Data column, and demonstrate that this is the same data as is returned by the query in step 4
-- (note that additional statements will have been captured since you ran the code in step 4)

-- Step 7 - Watch live activity
-- In Object Explorer, right-click the SqlStatementCompleted node then click Watch Live Data.
-- Execute the statements below, then return to the live query results window and wait for the
-- events to appear.
SELECT 'sample extended events 3' AS v1;
GO
SELECT 'sample extended events 4' AS v2;
GO
-- Demonstrate that events are captured, then return to this window

-- Step 8 - alter the session to stop it
ALTER EVENT SESSION SqlStatementCompleted ON SERVER
	STATE=STOP
GO

-- Step 9 - view session properties in the GUI
-- In Object Explorer, right-click the SqlStatementCompleted node then click Properties.
-- Work through the General, Events, Data Storage and Advanced tabs, if necessary referring back to 
-- the session definition in step 1.

-- Step 10 - drop the session
DROP EVENT SESSION SqlStatementCompleted ON SERVER
