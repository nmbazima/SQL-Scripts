-- Demonstration B

-- Step 1: Try to execute the bellow statement
USE AdventureWorksLT;
GO

-- When first connecting to an Azure database server you must use the 
-- Available Databases drop down and select ADVENTUREWORKSLT
-- After connecting, a USE statement can be used to switch database contexts.

-- Step 2: Querying a table	 
-- Select and run the completed query to show results
-- Point out that there are 8 rows returned
SELECT	ProductID
		,UnitPrice
		,SUM(OrderQty) as 'TotalOrdered'
FROM SalesLT.SalesOrderDetail
WHERE UnitPrice > 50
GROUP BY ProductID, UnitPrice
HAVING SUM(OrderQty) > 19
ORDER BY TotalOrdered DESC;

-- Step 3: Querying a table	 
-- Select and run the partial query to show results
-- Point out the use of the * as a placeholder since FROM can't be run by itself
-- and that there are 542 rows returned
SELECT *
FROM SalesLT.SalesOrderDetail;

-- Step 4: Querying a table	 
-- Select and run the partial query to show results
-- Point out that there are 331 rows returned
SELECT * 
FROM SalesLT.SalesOrderDetail
WHERE UnitPrice > 50;

-- Step 5: Querying a table	with an invalid SELECT statement
-- Select and run the partial query to show results
-- THIS WILL CAUSE AN ERROR DUE TO THE SELECT LIST:
--
-- Column 'SalesLT.SalesOrderDetail.SalesOrderID' is invalid in 
-- the select list because it is not contained in either an 
-- aggregate function or the GROUP BY clause.
SELECT *
FROM SalesLT.SalesOrderDetail
WHERE UnitPrice > 50
GROUP BY ProductID, UnitPrice;

-- Step 6: Querying a table	 
-- Select and run the partial query to show results
-- Point out that the * in the SELECT list has been 
-- replaced with columns that are either in the GROUP BY expression
-- or are aggregate functions (this will be explained further in Module 9)
-- Point out that there are 107 rows returned
SELECT	ProductID
		,UnitPrice
		,SUM(OrderQty) as 'TotalOrdered'
FROM SalesLT.SalesOrderDetail
WHERE UnitPrice > 50
GROUP BY ProductID, UnitPrice;

-- Step 7: Querying a table	 
-- Select and run the partial query to show results
-- Point out that a HAVING clause further filters the results
-- based on the groups, and also that there are 8 rows returned 
-- and there is no apparent sort order
SELECT	ProductID
		,UnitPrice
		,SUM(OrderQty) as 'TotalOrdered'
FROM SalesLT.SalesOrderDetail
WHERE UnitPrice > 50
GROUP BY ProductID, UnitPrice
HAVING SUM(OrderQty) > 19;

-- Step 8: Querying a table	 
-- Select and run the completed query to show results
-- Point out that the ORDER BY clause has sorted the results
-- and that there are still 8 rows returned 
SELECT	ProductID
		,UnitPrice
		,SUM(OrderQty) as 'TotalOrdered'
FROM SalesLT.SalesOrderDetail
WHERE UnitPrice > 50
GROUP BY ProductID, UnitPrice
HAVING SUM(OrderQty) > 19
ORDER BY TotalOrdered DESC;
