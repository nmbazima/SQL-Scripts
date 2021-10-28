-- Demonstration C

-- Step 1: Open a new query window to the TSQL database
USE TSQL;
GO


-- Step 2: Clean up if the procedure already exists
IF OBJECT_ID('Production.ProdsByCategory','P') IS NOT NULL
	DROP PROC Production.ProdsByCategory;
GO


-- Step 3: Creating simple procedures with input parameters
-- Declare a parameter to search for category
-- and a parameter to limit the number of results
CREATE PROC Production.ProdsByCategory
(@numrows AS int, @catid AS int)
 AS
SELECT TOP(@numrows) productid, productname, unitprice
FROM Production.Products
WHERE categoryid = @catid;
GO


-- Step 4: Test procedure
DECLARE @numrows INT = 3, @catid INT = 2;
EXEC Production.ProdsByCategory @numrows = @numrows, @catid = @catid;
GO


-- Step 5: Clean up
IF OBJECT_ID('Production.ProdsByCategory','P') IS NOT NULL
	DROP PROC Production.ProdsByCategory;
GO
