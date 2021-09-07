DECLARE @path nvarchar(4000);

SELECT @path= path
FROM sys.traces
WHERE id = 1;

SELECT TextData, HostName, ApplicationName, LoginName, SPID, StartTime
FROM fn_trace_gettable(@path, DEFAULT)
WHERE TextData LIKE '%xp_cmdshell%';