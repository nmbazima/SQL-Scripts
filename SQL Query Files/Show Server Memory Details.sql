/*******************************************************************************

  Script:   Show Server Memory Details.sql
  Author:   Chris Wye
  Date:     06/01/2014

  RUN THIS SCRIPT WITH RESULTS TO TEXT.
  
  Description:
  ------------
  Runs a number of queries to display information from the SQL Server
  memory from  
  
  a. the buffer pool
  b. the plan cache which stores sql execution plans  

  Amendments:
  -----------
  16/01/2014 - v1.10 - Added Plan cache queries (CW)

*******************************************************************************/

USE master;

PRINT '** Script "Show Server Memory Details" (v1.10) starts at ' + CAST(GETDATE() as VARCHAR);
PRINT 'Running on server ' + @@SERVERNAME;

-- Set options

SET NOCOUNT ON;

-- *****************************************************

PRINT '';
PRINT '------------------------------';
PRINT '---- BUFFER POOL DETAILS -----';
PRINT '------------------------------';
PRINT '';

PRINT 'Monitor the buffer pool to look out for memory pressure on a server.';
PRINT 'Use PerfMon counters :-';
PRINT '1. MSSQL:Memory Manager\Total Server Memory (Kb) - to show current size of the buffer pool';
PRINT '2. MSSQL:Memory Manager\Target Server Memory (Kb) - to show the ideal size of the buffer pool.';
PRINT '3. MSSQL:Buffer Manager\Page Life Expectancy - to show the time (in secs) that SQL expects a page loaded';
PRINT '   into the buffer pool to remain there. Under memory pressure data pages from cache are flushed more frequently.';
PRINT '';
PRINT 'NB Target and Total should be virtually identical on a server with no memory pressure';
PRINT '   If Total is less than Target then it is likely SQL cannot grow the buffer pool due to memory pressure';
PRINT '   MS recommends 300 secs for a good PLE, but systems with loads of RAM this could easily be in the thousands.';
PRINT '';

-- *****************************************************

PRINT '1. Displaying the data cache size used in the buffer pool for each database ...';
PRINT '';
SELECT 
  COUNT(*) * 8/1024 AS 'Cached Size (Mb)',
  COUNT(*) as 'No of Pages (8Kb)',
  CASE database_id
    WHEN 32767 THEN 'ResourceDb'
    ELSE LEFT(db_name(database_id),30) 
  END AS 'Database'
FROM 
  sys.dm_os_buffer_descriptors
GROUP BY
  db_name(database_id), database_id
ORDER BY 
  'Cached Size (Mb)' DESC;

-- *****************************************************
 
PRINT '';
PRINT '2. Displaying the number of dirty pages (pages yet to be written to the DB) ...';
PRINT '';
SELECT
  COUNT(page_id) as 'Dirty Pages',
  COUNT(page_id) * 8 as 'Size in Kb',
  LEFT(db_name(database_id),30) as 'Database Name'
FROM
  sys.dm_os_buffer_descriptors
WHERE
  is_modified = 1
GROUP BY
  db_name(database_id)
ORDER BY 
  COUNT(page_id) DESC; 

-- *****************************************************

PRINT '';
PRINT '------------------------------';
PRINT '---- PLAN CACHE DETAILS  -----';
PRINT '------------------------------';
PRINT '';

PRINT 'The Plan Cache is the memory pool that SQL uses to store SQL Execution plans.';
PRINT 'Execution plans can be time consuming and resource intensive to create so SQL ';
PRINT 'will try to reuse query plans previously created.';
PRINT '';
PRINT 'The Max Plan Cache size is calculated by SQL Server dependent upon the total';
PRINT 'RAM in the server, as follows :-';
PRINT '  (a)   75% of server memory from 0 - 4Gb + ';
PRINT '  (b)   10% of server memory from 4Gb - 64Gb + ';
PRINT '  (c)    5% of server memory > 64Gb';
PRINT 'e.g.';
PRINT 'A system with 16Gb RAM will have a maximum plan cache size of ';
PRINT '	 3.0Gb calculated from (a) i.e 75% x 4Gb';
PRINT '+ 1.2Gb calculated from (b) i.e. 10% x (16Gb - 4Gb)';
PRINT '+ 0.0Gb calculated from (c)';
PRINT ' ------'
PRINT '  4.2Gb Total of above';
PRINT '';

-- *****************************************************

PRINT '3. Number of plans and current cache size....';
PRINT '';

SELECT 
  COUNT(*) AS 'Number of Plans',
  SUM(CAST(size_in_bytes as BIGINT))/1024/1024 AS 'Plan Cache Size (Mb)'
FROM
  sys.dm_exec_cached_plans;

-- *****************************************************

PRINT '4. Breaking down Plan Cache by Object Type ....';
PRINT '';

SELECT
  objtype AS 'Cached Object Type',
  COUNT(*) AS 'Number of Plans',
  SUM(CAST(size_in_bytes as BIGINT))/1024/1024 AS 'Plan Cache Size (Mb)',
  AVG(usecounts) AS 'Avg User Count'
FROM
  sys.dm_exec_cached_plans
GROUP BY
  objtype;

PRINT 'NB If AdHoc plans greater than Proc, etc then workload mostly dymanic sql';
PRINT 'and therefore these do not tend to get reused - if so consider using';
PRINT 'sp_configure option for OPTIMIZE FOR ADHOC WORKLOADS (new in SQL2008)';
PRINT '';
PRINT 'Also consider using DBCC FREESYSTEMCACHE(''SQL Plans'') to flush adhoc ';
PRINT 'and Prepared plans (but not Stored Proc plans) if necessary to free memory';
PRINT '3. Displaying the number of cached sql execution plans and plan cache size ...';
PRINT '';

-- *****************************************************

PRINT '';
PRINT '** Script finishes at ' + CAST(GETDATE() as VARCHAR);

/*******************************************************************************
  End of script
*******************************************************************************/
