-- Demonstration E - Working with Calculated Columns


-- Step 1: Open a new query window to the AdventureWorksLT database on Azure


-- Step 2: Create a table with two computed columns
-- Select and execute the following query to create the table
-- Mention the use of the PERSISTED keyword on both computed columns
CREATE TABLE SalesLT.SalesOrderDates
(
    SalesOrderID int NOT NULL,
    SalesOrderNumber nvarchar(30) NOT NULL,
    OrderDate date NOT NULL,
    YearOfOrder AS DATEPART(year, OrderDate) PERSISTED,
	ShipDate date NOT NULL,
    YearShipped AS DATEPART(year, ShipDate) PERSISTED
);
GO


-- Step 3: Populate the table with data
-- Select and execute the following query to populate the SalesLT.SalesOrderDates table
-- Point out that the insert statement does not need to include any data for the computed column
INSERT	INTO SalesLT.SalesOrderDates (SalesOrderID, SalesOrderNumber, OrderDate, ShipDate)
SELECT	SalesOrderID, SalesOrderNumber, OrderDate, ShipDate 
FROM	SalesLT.SalesOrderHeader;
GO


-- Step 4: Return the results from the SalesLT.SalesOrderDates table
-- Select and execute the following query to show that the computed columns have been populated automatically
-- Mention the use of the PERSISTED keyword and remind students the computed columns do not get updated with each SELECT statement
SELECT	*
FROM	SalesLT.SalesOrderDates;
GO


-- Step 5: Update a row in the SalesLT.SalesOrderDates table
-- Select and execute the following query to update a row, and return the contents of the table
-- Show that the YearOfOrder computed column has now been updated automatically
UPDATE	SalesLT.SalesOrderDates
SET		OrderDate = '2015-10-01'
WHERE	SalesOrderID = 71774;
GO
SELECT	*
FROM	SalesLT.SalesOrderDates;
GO


-- Step 6: Create a table with a computed column that is not persisted
-- Select and execute the following query to create the SalesLT.TotalSales table
-- Mention that the TotalSales column is not persisted
CREATE TABLE SalesLT.TotalSales
(
    ProductID int NOT NULL,
    ProductName nvarchar(50) NOT NULL,
	UnitPrice money NOT NULL,
	UnitsSold smallint NULL, 
	TotalSales AS (UnitsSold * UnitPrice)
);
GO


-- Step 7: Populate the table with data
-- Select and execute the following query to populate the SalesLT.TotalSales table
-- Point out that the insert statement does not need to include any data for the computed column
INSERT INTO SalesLT.TotalSales (ProductID, ProductName, UnitPrice, UnitsSold)
SELECT	s.ProductID, p.Name AS ProductName, SUM(s.UnitPrice) AS UnitPrice, SUM(OrderQty) AS UnitsSold
FROM	SalesLT.SalesOrderDetail AS s
INNER	JOIN SalesLT.Product AS p ON s.ProductID = p.ProductID
GROUP	BY s.ProductID, p.Name;
GO


-- Step 8 - Return the results from the SalesLT.TotalSales table
-- Select and execute the following query to show that the computed columns have been populated automatically
-- Mention that the TotalSales column, will be computed each time a SELECT query is run against the table
SELECT	* 
FROM	SalesLT.TotalSales;
GO