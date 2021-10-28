-- Demonstration 4 - Working with Temporary Tables

-- Step 1: Create a local temporary table
-- Select and execute the following query to create a local temporary table and populate it with data
-- Point out that the table is only visible to this session 

USE AdventureWorks;
GO

CREATE TABLE #ProductList
(
	ProductID int NULL,
	ProductCode varchar(15) NULL,
	ProductName varchar(35) NULL

);

INSERT INTO #ProductList (ProductID, ProductCode, ProductName)
SELECT ProductID, ProductNumber, Name FROM Production.Product;

SELECT	* 
FROM	#ProductList


-- Step 2: Open the [5 - Temporary Tables.sql] file and execute Steps 1


-- Step 3: Create a global temporary table
-- Select and execute the following query to create a global temporary table
-- Point out that this table is available to all sessions on the server

CREATE TABLE ##ProductList
(
	ProductID int NULL,
	ProductCode varchar(15) NULL,
	ProductName varchar(35) NULL

);

INSERT INTO ##ProductList (ProductID, ProductCode, ProductName)
SELECT ProductID, ProductNumber, Name FROM Production.Product;

SELECT	* 
FROM	##ProductList


-- Step 4: In the [5 - Temporary Tables.sql] file and execute Step 2


-- Step 5: Drop the two temporary tables

DROP TABLE #ProductList;
DROP TABLE ##ProductList;

