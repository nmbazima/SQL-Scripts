-- Demonstration 1A

-- Step 1 - Ensure the AdventureWorksLT database is the current database.

-- =========================================================
-- CATALOG VIEWS and INFORMATION_SCHEMA VIEWS
-- =========================================================

-- Step 2 - Query sys.views

-- Note the Microsoft shipped view and the user created views 
SELECT * FROM sys.views;
GO


-- Step 3 - Query sys.tables

-- Note the new fields for temporal tables (a new feature in SQL Server 2016)
SELECT * FROM sys.tables;
GO

-- Step 4 - Query sys.objects

-- Note the first two views inherit from sys.objects. Run first without a filter,
-- then again to show that sys.views inherits from sys.objects
SELECT * FROM sys.objects
GO

SELECT * FROM sys.objects
	WHERE type_desc = 'VIEW';
GO


-- Step 5 - Query information_schema.tables

-- Run information_schema.tables
-- Compare the results to sys.tables

SELECT * FROM INFORMATION_SCHEMA.TABLES;
GO

-- ===============================================================
-- DYNAMIC MANAGEMENT VIEWS
-- ==============================================================


-- Step 6 - Query sys.dm_exec_connections

SELECT * FROM sys.dm_exec_connections;
GO


-- Step 7 - Query sys.dm_exec_sessions 

SELECT * FROM sys.dm_exec_sessions;
GO


-- Step 8 - Query sys.dm_exec_requests

SELECT * FROM sys.dm_exec_requests;
GO


-- Step 9 - Query sys.dm_exec_query_stats

SELECT * FROM sys.dm_exec_query_stats;
GO


-- Step 10 - Modify the query to add a TOP(20) and an ORDER BY

SELECT TOP (20) qs.max_logical_reads,
                st.text 
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.max_logical_reads DESC;
