-- Demonstration 2A

-- 
-- Step 1 - Make sure AdventureWorksLT is the current database


-- Step 2 - Create a new view

IF OBJECT_ID(N'SalesLT.vw_CustomerOrders', N'V') IS NOT NULL
	DROP VIEW SalesLT.vw_CustomerOrders;
GO
CREATE VIEW SalesLT.vw_CustomerOrders
AS
SELECT C.CustomerID, C.FirstName, C.LastName, O.OrderDate, O.SubTotal, O.TotalDue 
FROM SalesLT.Customer AS C
	INNER JOIN SalesLT.SalesOrderHeader as O
ON C.CustomerID =O.CustomerID;
GO

-- Step 3 - Query the view
SELECT * 
	FROM SalesLT.vw_CustomerOrders;
GO

-- Step 4 - Query the view and order the results
SELECT * 
FROM SalesLT.vw_CustomerOrders
ORDER BY TotalDue Desc;
GO

-- Step 5 - Query the view definition via OBJECT_DEFINITION 
SELECT OBJECT_DEFINITION(OBJECT_ID(N'SalesLT.vw_CustomerOrders',N'V'));
GO

-- Step 6 - Alter the view to use WITH ENCRYPTION
ALTER VIEW SalesLT.vw_CustomerOrders
WITH ENCRYPTION
AS
	SELECT C.CustomerID, C.FirstName, C.LastName, O.OrderDate, O.SubTotal, O.TotalDue 
FROM SalesLT.Customer AS C
	INNER JOIN SalesLT.SalesOrderHeader as O
ON C.CustomerID =O.CustomerID;
GO


-- Step 7 - Requery the view definition via OBJECT_DEFINITION
-- Not visible due to ENCRYPTION option
SELECT OBJECT_DEFINITION(OBJECT_ID(N'SalesLT.vw_CustomerOrders',N'V'));
GO

-- Step 8 - Drop the view
DROP VIEW SalesLT.vw_CustomerOrders;
GO

