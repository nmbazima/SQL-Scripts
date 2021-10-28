-- Module 17 - Demonstration File 1b
-- Switch this query window to use your copy of the AdventureWorksLT database

-- Demonstrate Dirty Reads
--------------------------
-- Query 1
BEGIN TRANSACTION
	UPDATE SalesLT.Customer
	SET Phone = N'999-555-9999'
	WHERE CustomerID = 2;

-- Query 2
ROLLBACK


-- Demonstrate non-repeatable reads
-----------------------------------

-- Query 3
UPDATE SalesLT.Customer
SET Phone = N'333-555-3333'
WHERE CustomerID = 2;

-- Query 4
UPDATE SalesLT.Customer
SET Phone = N'444-555-4444'
WHERE CustomerID = 2;


-- Demonstration phantom read
----------------------------

-- Query 5 -- adds a new row
INSERT SalesLT.Customer
(NameStyle, Title, FirstName, MiddleName, LastName, Suffix, CompanyName, SalesPerson, EmailAddress, Phone, PasswordHash, PasswordSalt, ModifiedDate)
SELECT NameStyle, Title, FirstName, MiddleName, LastName, Suffix,  N'Demo Sports' AS CompanyName, SalesPerson, EmailAddress, 
N'111-555-1111' AS Phone, PasswordHash, PasswordSalt, GETDATE() AS ModifiedDate
FROM SalesLT.Customer
WHERE CustomerID = 2;


-- Demonstrate SNAPSHOT isolation
------------------------------------------------

-- Query 6
-- Begin a transaction with snapshot isolation
-- the UPDATE statement blocks until the other transaction ends

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

BEGIN TRANSACTION;

UPDATE SalesLT.Customer
	SET Title = N'Mrs.'
	WHERE CustomerID = 5;


-- Query 7

SELECT *
	FROM sys.dm_tran_locks
	WHERE resource_database_id = DB_ID(N'AdventureWorksLT');

