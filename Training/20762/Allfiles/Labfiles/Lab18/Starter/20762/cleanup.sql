--cleanup
IF EXISTS (SELECT * FROM sys.server_event_sessions WHERE name = 'AnalyzeSQLEE')
    DROP EVENT SESSION [AnalyzeSQLEE] ON SERVER
GO