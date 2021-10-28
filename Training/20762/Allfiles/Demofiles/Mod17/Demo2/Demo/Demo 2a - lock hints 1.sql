-- Module 17 Demonstration 2 File 1

-- Step 1: Switch this query window to use the AdventureWorks database
USE AdventureWorks;
GO

-- Step 2: Switch the Demo 2b - lock hints 2.sql query to use the AdventureWorks database

-- Step 3: Demonstrate that the current isolation level is READ COMMITTED with READ_COMMITTED_SNAPSHOT OFF
-- and that SNAPSHOT isolation is not enabled
-- Execute the following query
SELECT d.snapshot_isolation_state, d.is_read_committed_snapshot_on,
CASE transaction_isolation_level 
	WHEN 0 THEN 'UNSPECIFIED' 
	WHEN 1 THEN 'READ UNCOMMITTED' 
	WHEN 2 THEN 'READ COMMITTED' 
	WHEN 3 THEN 'REPEATABLE READ' 
	WHEN 4 THEN 'SERIALIZABLE' 
	WHEN 5 THEN 'SNAPSHOT'  
END AS transaction_isolation_level 
FROM sys.dm_exec_sessions AS es
join sys.databases  AS d
ON d.database_id = es.database_id
WHERE es.session_id = @@SPID

-- Step 4: Show locks held by a SELECT statement inside a transaction at READ UNCOMMITTED isolation
-- Execute the code up to the next comment:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION
	SELECT TOP (100) * FROM AdventureWorks.Person.Person;
-- The following code to shows the locks held by the transaction
-- Only a shared DATABASE lock and shared METADATA locks are held:
	SELECT resource_type, request_mode,COUNT(*) AS lock_count
	FROM sys.dm_tran_locks 
	WHERE request_session_id = @@SPID 
	GROUP BY resource_type,request_mode;

ROLLBACK

-- HINTS AFFECTING LOCK ISOLATION LEVEL

-- Step 5: Show locks held by the same SELECT statement inside a transaction at REPEATABLE READ isolation
-- Execute the code up to the next comment:
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
	SELECT TOP (100) * FROM AdventureWorks.Person.Person;
-- Now execute the following code to show the locks held by the transaction
-- As well as the locks held in step 4, 100 shared locks are held at KEY level (corresponding to TOP (100) in the query)
-- Intent-shared locks are held at page and object level
	SELECT resource_type, request_mode,COUNT(*) AS lock_count
	FROM sys.dm_tran_locks 
	WHERE request_session_id = @@SPID 
	GROUP BY resource_type,request_mode;

ROLLBACK

-- Step 6: Still at REPEATABLE READ isolation, demonstrate the effect of the READCOMMITTED locking hint
-- Execute the code up to the next comment:
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
	SELECT TOP (100) * FROM AdventureWorks.Person.Person WITH (READCOMMITTED);
-- Now execute the following code to show the locks held by the transaction
-- Even though the transaction isolation level is REPEATABLE READ, the locks
-- taken by the query are the same as for READ COMMITTED isolation:
	SELECT resource_type, request_mode,COUNT(*) AS lock_count
	FROM sys.dm_tran_locks 
	WHERE request_session_id = @@SPID 
	GROUP BY resource_type,request_mode;

ROLLBACK

-- HINTS AFFECTING LOCK MODE

-- Step 7: In the READ COMMITTED isolation level, demonstrate the effect of a TABLOCKX locking hint
-- Execute the code up to the next comment:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION
	SELECT TOP (100) * FROM AdventureWorks.Person.Person WITH (TABLOCKX);
-- Now execute the following code to show the locks held by the transaction
-- A single exclusive lock is acquired at table level
	SELECT resource_type, request_mode,COUNT(*) AS lock_count
	FROM sys.dm_tran_locks 
	WHERE request_session_id = @@SPID 
	GROUP BY resource_type,request_mode;

ROLLBACK

-- Step 8: In the REPEATABLE READ isolation level, demonstrate the effect of a TABLOCKX locking hint
-- Execute the code up to the next comment:
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
	SELECT TOP (100) * FROM AdventureWorks.Person.Person WITH (TABLOCKX);
-- Now execute the following code to show the locks held by the transaction
-- A single exclusive lock is acquired at table level
	SELECT resource_type, request_mode,COUNT(*) AS lock_count
	FROM sys.dm_tran_locks 
	WHERE request_session_id = @@SPID 
	GROUP BY resource_type,request_mode;

ROLLBACK

-- THE READPAST HINT

-- Step 9: Behavior without READPAST
-- Run the statement under the heading Query 1 in the Demo 1b - concurrency 2.sql file, then return to this query
-- Execute the following statement; it will wait for the lock held by the Demo 1b - concurrency 2.sql query
-- Allow the query to run for a few seconds before cancelling it
SELECT * FROM AdventureWorks.Sales.SalesTerritory;

-- Step 10: Behavior with READPAST
-- If it is still running, cancel the executing query in this window 
-- Execute the following statement
-- The query returns 9 rows; the locked row (TerritoryID = 3) is skipped
SELECT * FROM AdventureWorks.Sales.SalesTerritory WITH (READPAST);

-- Step 11: Close the open transaction
-- Run the statement under the heading Query 2 in the Demo 1b - concurrency 2.sql file, then return to this query
