---------------------------------------------------------------------
-- LAB 17
--
-- Exercise 2
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 1 - Open Activity Monitor
-- Open Activity Monitor in SSMS
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 2 - Clear Wait Statistics
-- Run the following code to clear wait statistics
---------------------------------------------------------------------
DBCC SQLPERF('sys.dm_os_wait_stats',CLEAR);

---------------------------------------------------------------------
-- Task 3 - Run a Workload
-- NB: BEFORE working on any other the tasks in this exercise, make sure you have run the sample workload
-- by right-clicking D:\Labfiles\Lab17\Starter\start_load_exercise_02.ps1 and clicking "Run with PowerShell"
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 4 - View Lock Waits in Activity Monitor
-- Return to the MIA-SQL - Activity Monitor tab. In the Resource Waits section, 
-- note the value of Cumulative Wait Time (sec) for the Lock wait type
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 5 - Enable Partition-Level Locking
-- Write a query to alter the Proseware.CampaignResponsePartitioned table in the AdventureWorks database
-- so that partition-level locking is permitted
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 6 - Clear wait statistics
-- Rerun the query under the heading for task 2
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 7 - Rerun the Workload
-- Rerun the sample workload by right-clicking 
-- D:\Labfiles\Lab17\Starter\start_load_exercise_02.ps1 and clicking "Run with PowerShell"
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 8 - View Lock Waits in Activity Monitor
-- Return to the MIA-SQL - Activity Monitor tab. In the Resource Waits section, 
-- note the value of Cumulative Wait Time (sec) for the Lock wait type
---------------------------------------------------------------------