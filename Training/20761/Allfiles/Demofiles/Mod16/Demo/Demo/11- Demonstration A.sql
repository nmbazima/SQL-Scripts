-- Demonstration A

-- Step 1: Open a new query window to the TSQL database
USE TSQL;
GO


-- Step 2: Set up for demo
-- Clean up if the procedure already exists
IF OBJECT_ID('Production.ProdsByCategory','P') IS NOT NULL
	DROP PROC Production.ProdsByCategory;
GO

-- Create a proc to search for category
-- and a parameter to limit the number of results
CREATE PROC Production.ProdsByCategory
(@numrows AS int, @catid AS int)
 AS
SELECT TOP(@numrows) productid, productname, unitprice
FROM Production.Products
WHERE categoryid = @catid
ORDER BY productid;
GO

-- Set up table for batch demos
CREATE TABLE dbo.t1 (c1 INT PRIMARY KEY, c2 INT, c3 NCHAR(5));
GO


-- Step 3: Exploring batches
-- Execute the following batch to show statements
-- submitted and executed as one unit
-- Valid batch
INSERT INTO dbo.t1 VALUES(1,2,N'abc');
INSERT INTO dbo.t1 VALUES(2,3,N'def');
GO

-- Show that the batch was successful
SELECT c1, c2, c3 FROM dbo.t1;
GO


-- Step 4: Clean up the table for the next demo
TRUNCATE TABLE dbo.t1;
GO


-- Step 5: Batches with errors
--Run the following batch to show entire batch rejected
--on compile/syntax error
--THIS WILL RETURN AN ERROR
INSERT INTO dbo.t1 VALUE(1,2,N'abc');
INSERT INTO dbo.t1 VALUES(2,3,N'def');
GO

--Show that no rows were inserted
SELECT c1, c2, c3 FROM dbo.t1;


-- Step 6: Variables
-- Show the following code to illustrate use of
-- variables for executing stored procedure
-- Declare and initialize variables
DECLARE @numrows INT = 3, @catid INT = 2;
--Use variables to pass parameters to procedure
EXEC Production.ProdsByCategory @numrows = @numrows, @catid = @catid;

--Run the following batch in its entirety to show the choices 
--for assigning values to variables
DECLARE @var1 AS INT = 99;
DECLARE @var2 AS NVARCHAR(255);
SET @var2 = N'string';
DECLARE @var3 AS NVARCHAR(20);
SELECT @var3 = lastname 
	FROM HR.Employees
	WHERE empid=1;
SELECT @var1 AS var1, @var2 AS var2, @var3 AS var3;
GO


-- Step 7: Synonyms
-- Clean up if the procedure already exists
IF OBJECT_ID('Production.ProdsByCategory','P') IS NOT NULL
	DROP PROC Production.ProdsByCategory;
GO

-- Declare a parameter to search for category
-- and a parameter to limit the number of results
CREATE PROC Production.ProdsByCategory
(@numrows AS int, @catid AS int)
 AS
SELECT TOP(@numrows) productid, productname, unitprice
FROM Production.Products
WHERE categoryid = @catid;
GO

-- Test it locally
DECLARE @numrows INT = 3, @catid INT = 2;
EXEC Production.ProdsByCategory @numrows = @numrows, @catid = @catid;


-- Step 8: Switch databases
USE tempdb;
GO


-- Step 9: Create synonym
CREATE SYNONYM dbo.ProdsByCategory FOR TSQL.Production.ProdsByCategory;
EXEC dbo.ProdsByCategory @numrows = 3, @catid = 2;
GO


-- Step 10: Query system view to see defined synonyms
SELECT *
FROM sys.synonyms;
GO


--Step 11: Clean up
IF OBJECT_ID('Production.ProdsByCategory','P') IS NOT NULL
	DROP PROC Production.ProdsByCategory;
GO




