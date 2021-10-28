---------------------------------------------------------------------
-- LAB 17
--
-- Exercise 1
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 1 - Clear Wait Statistics
-- Execute the following query to clear wait statistics
---------------------------------------------------------------------
DBCC SQLPERF('sys.dm_os_wait_stats',CLEAR);

---------------------------------------------------------------------
-- Task 2 - Run a Workload
-- NB: BEFORE working on any other the tasks in this exercise, make sure you have run the sample workload
-- by right-clicking D:\Labfiles\Lab17\Starter\start_load_exercise_01.ps1 and clicking "Run with PowerShell"
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 3 - Capture Lock Wait Statistics
-- Amend the following query to capture lock wait statistics into a temporary table
---------------------------------------------------------------------
SELECT wait_type, waiting_tasks_count, wait_time_ms, 
max_wait_time_ms, signal_wait_time_ms
INTO 
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE '' 
AND wait_time_ms > 0
ORDER BY wait_time_ms DESC;

---------------------------------------------------------------------
-- Task 4 - Enable SNAPSHOT isolation on AdventureWorks (use SSMS GUI)
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 5 - Implement SNAPSHOT isolation (amend Lab Exercise 01 - stored procedure.sql)
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 6 - Clear wait statistics
-- Rerun the query under the heading for Task 1
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 7 - Rerun the Workload
-- Rerun the sample workload by right-clicking 
-- D:\Labfiles\Lab17\Starter\start_load_exercise_01.ps1 and clicking "Run with PowerShell"
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 8 - Capture Lock Wait Statistics
-- Amend the query to capture lock wait statistics into a temporary table called #task8
---------------------------------------------------------------------
SELECT wait_type, waiting_tasks_count, wait_time_ms, 
max_wait_time_ms, signal_wait_time_ms
INTO 
FROM sys.dm_os_wait_stats
WHERE wait_type LIKE '' 
AND wait_time_ms > 0
ORDER BY wait_time_ms DESC;

---------------------------------------------------------------------
-- Task 9 - Compare Overall Lock Wait Time
-- Execute the following query to compare the wait statistics captured in task 3 and in task 8
---------------------------------------------------------------------
SELECT SUM(t3.wait_time_ms) AS baseline_wait_time_ms,
SUM(t8.wait_time_ms) AS SNAPSHOT_wait_time_ms
FROM #task3 AS t3
FULL OUTER JOIN #task8 AS t8
ON t8.wait_type = t3.wait_type;

