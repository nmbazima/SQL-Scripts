IF EXISTS (SELECT * FROM sys.server_event_sessions WHERE name = 'AnalyzeSQLEE')
    DROP EVENT SESSION [AnalyzeSQLEE] ON SERVER
GO

DECLARE @EEcmd NVARCHAR(4000) =
'CREATE EVENT SESSION [AnalyzeSQLEE] ON SERVER 

ADD EVENT sqlserver.sp_statement_completed
(
	ACTION(sqlserver.query_hash)
	WHERE sqlserver.database_id = ' + CAST(DB_ID('AdventureWorks') AS NVARCHAR(2)) + '
)

ADD TARGET package0.ring_buffer
	(SET max_events_limit=(5000),max_memory=(4096))
'

EXEC sp_executesql @EEcmd

--start the extended event session
ALTER EVENT SESSION [AnalyzeSQLEE] ON SERVER STATE = START;
GO