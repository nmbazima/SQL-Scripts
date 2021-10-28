-- Module 9 Exercise 1

-- Task 1 - run a workload
-- Run the workload before proceeding with this exercise

-- Task 2 - query the system_health session
-- Edit the following query to return data from the system_health session, using the DMF 
-- sys.fn_xe_file_target_read_file to extract data from the session’s event file target. 
-- Hint: You can examine the definition of the system_health session to find the file name used by the event file target.
SELECT CAST(event_data AS xml) AS xe_data
FROM sys.fn_xe_file_target_read_file('system_health*.xel', NULL, NULL, NULL)

-- Task 3 - modify the query to return deadlock data
-- Edit the following query to extracts the events with a name attribute of 
-- xml_deadlock_report from the XML version of the event_data column. 
-- Include the event time and the /event/data/value/deadlock element in your output.
-- Order the output by event time, ascending.
SELECT xe_event.c.value('@timestamp', 'datetime2(3)') AS event_time,
xe_event.c.query('/event/data/value/deadlock') AS deadlock_data
FROM
(
	SELECT CAST(event_data AS xml) AS xe_data
	FROM sys.fn_xe_file_target_read_file('system_health*.xel', NULL, NULL, NULL)
) AS xe_data
CROSS APPLY xe_data.nodes('/event') AS xe_event(c)
WHERE xe_event.c.value('@name', 'varchar(100)') = 'xml_deadlock_report'
ORDER BY event_time;

-- Task 4 - view the deadlock XML
-- Click on any of the row values in the deadlock_data to view the deadlock XML in detail.

