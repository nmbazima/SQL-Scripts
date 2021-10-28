-- Module 18 - Demo 2

-- Step 14 - query to aggregate waits by session id
WITH xeCTE
AS
(
	SELECT CAST(event_data AS xml) AS xe_xml
	FROM sys.fn_xe_file_target_read_file('D:\Demofiles\Mod18\waitbysession*.xel', NULL, NULL, NULL)
)
,valueCTE
AS
(
	SELECT xe_xml.value('(event/action[@name="session_id"]/value)[1]','int') AS sessionID,
	xe_xml.value('(event/data[@name="wait_type"]/text)[1]','varchar(50)') AS wait_type,
	xe_xml.value('(event/data[@name="duration"]/value)[1]','int') AS wait_duration,
	xe_xml.value('(event/data[@name="signal_duration"]/value)[1]','int') AS wait_signal_duration
	FROM xeCTE
)
SELECT sessionID, wait_type, 
SUM(wait_duration) AS total_wait_duration, 
SUM(wait_signal_duration) AS signal_wait_duration, 
SUM(wait_duration - wait_signal_duration) AS resource_wait_duration
FROM valueCTE
WHERE wait_duration > 0
GROUP BY sessionID, wait_type
ORDER BY sessionID, wait_type;

-- Step 15 - stop and drop the session, stop the workload
ALTER EVENT SESSION [Waits by Session] ON SERVER
	STATE=STOP
GO

DROP EVENT SESSION [Waits by Session] ON SERVER
GO

CREATE TABLE ##stopload (id int)
GO
