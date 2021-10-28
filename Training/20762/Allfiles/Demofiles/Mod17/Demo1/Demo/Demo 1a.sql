
-- Module 17 - Demonstration File 1a
-- Switch this query window to use your copy of the AdventureWorksLT database


-- Demonstrate Dirty Read
-------------------------

-- Step 1: Demonstrate the settings for ALLOW_SNAPSHOT_ISOLATION and READ_COMMITTED_SNAPSHOT 
SELECT name, snapshot_isolation_state, is_read_committed_snapshot_on FROM sys.databases;

-- Step 2: Examine the row the examples will change
-- The value of the Phone column is 170-555-0127
SELECT CustomerID, Phone FROM SalesLT.Customer WHERE CustomerID = 2;

-- Step 3: Demonstrate a dirty read in READ UNCOMMITTED isolation
-- Run the statement under the heading Query 1 in the Demo 1b - concurrency 2.sql file, then return to this query
-- Run the statements below. Note that the updated value for the Phone column is shown, even through the transaction is not committed
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
GO
SELECT CustomerID, Phone 
FROM SalesLT.Customer
WHERE CustomerID = 2;
GO

-- Step 4: Demonstrate that READ COMMITTED isolation with READ_COMMITTED_SNAPSHOT OFF prevents a dirty read
-- Note that in Azure SQL database, READ_COMMITTED_SNAPSHOT is ON by default and cannot be disabled.
-- Using the READCOMMITTEDLOCK table hint disables row versioning.
-- Demonstrate that this query waits 
-- Run the statement under the heading Query 2 in the Demo 1b - concurrency 2.sql file, then return to this query
-- Once the blocking session is rolled back, this query returns a value
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
SELECT CustomerID, Phone 
FROM SalesLT.Customer WITH (READCOMMITTEDLOCK)
WHERE CustomerID = 2;
GO

-- Demonstrate Non-repeatable reads
----------------------------------- 

-- Step 5: Demonstrate that READ COMMITTED isolation with READ_COMMITTED_SNAPSHOT OFF allows a non-repeatable read
-- Run the following statements
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION
	SELECT CustomerID, Phone 
	FROM SalesLT.Customer WITH (READCOMMITTEDLOCK)
	WHERE CustomerID = 2;

-- Run the statement under the heading Query 3 in the Demo 1b - concurrency 2.sql file, then return to this query
-- Run the following query. Note that the value of the Phone column has changed during the transaction
	SELECT CustomerID, Phone 
	FROM SalesLT.Customer WITH (READCOMMITTEDLOCK)
	WHERE CustomerID = 2;
COMMIT TRANSACTION;

-- Step 6: Demonstrate that REPEATABLE READ isolation prevents a non-repeatable read
-- Run the following statements
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
GO
BEGIN TRANSACTION
	SELECT CustomerID, Phone 
	FROM SalesLT.Customer
	WHERE CustomerID = 2;

-- Run the statement under the heading Query 4 in the Demo 1b - concurrency 2.sql file, then return to this query
-- Note that the query in the Demo 1b - concurrency 2.sql file is blocked
-- Run the following query. Note that the value of the Phone column has not changed during the transaction
-- Note that, once this transaction is committed, the query in the Demo 1b - concurrency 2.sql completes
	SELECT CustomerID, Phone 
	FROM SalesLT.Customer
	WHERE CustomerID = 2;
COMMIT TRANSACTION;


-- Demonstrate Phantom Read
---------------------------

-- Step 7: Demonstrate that REPEATABLE READ isolation allows a phantom read
-- Run the following statements
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
GO
BEGIN TRANSACTION
	SELECT COUNT(*) AS CustCount 
	FROM SalesLT.Customer
	WHERE Phone < '111-555-2222';

-- Run the statement under the heading Query 5 in the Demo 1b.sql file, then return to this query
-- Run the following query. Note that the value of the count has increased by one
	SELECT COUNT(*) AS CustCount 
	FROM SalesLT.Customer
	WHERE Phone < '111-555-2222';
COMMIT TRANSACTION;

-- Serializable and phantom read
--------------------------------

-- Step 8: Demonstrate that SERIALIZABLE isolation prevents a phantom read
-- Run the following statements
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
GO
BEGIN TRANSACTION
	SELECT COUNT(*) AS CustCount 
	FROM SalesLT.Customer
	WHERE Phone < '111-555-2222';

-- Run the statement under the heading Query 5 in the Demo 1b.sql file, then return to this query
-- Note that the query in the Demo 1b.sql file is blocked
-- Run the following query. Note that the value of the count matches the first query
-- Note that, once this transaction is committed, the query in the Demo 1b.sql completes 
	SELECT COUNT(*) AS CustCount 
	FROM SalesLT.Customer
	WHERE Phone < '111-555-2222';
COMMIT TRANSACTION;


-- Snapshot Isolation
----------------------

-- Step 9

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

BEGIN TRANSACTION;
UPDATE SalesLT.Customer
	SET Title = N'Ms.'
	WHERE CustomerID = 5;

SELECT *
	FROM sys.dm_tran_version_store
	WHERE database_id = DB_ID(N'AdventureWorksLT');

-- We can see that there is an Exclusive (X) lock on a key and a couple of
-- Intent Exclusive (IX) locks on a page and an object. Therefore pessimistic
-- locking is being used, even under SNAPSHOT isolation.
SELECT *
	FROM sys.dm_tran_locks
	WHERE resource_database_id = DB_ID(N'AdventureWOrksLT');


-- Step 10
-- Examine the locks again. We can see that two more Intent Exclusive (IX)
-- locks have been granted. A second Exclusive (X) lock is waiting.
-- The request_session_id column shows which session is responsible for each
-- lock.

SELECT *
	FROM sys.dm_tran_locks
	WHERE resource_database_id = DB_ID(N'AdventureWorksLT');

--------------------------------------------------------------------------------
-- Step 11
-- Commit the transaction

COMMIT TRANSACTION;



