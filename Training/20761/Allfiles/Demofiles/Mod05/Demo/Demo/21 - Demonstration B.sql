-- Demonstration B

-- Step 1: Connect to the AdventureWorksLT database
-- Prepare the environment by running the following query (without this, all order dates are the same)
UPDATE SalesLT.SalesOrderHeader 
SET	OrderDate = DATEADD(d,SalesOrderID % 7000, '2008-06-01'),
	ShipDate = DATEADD(d,7 + (SalesOrderID % 7000), '2008-06-08'),
	DueDate = DATEADD(d,14 + (SalesOrderID % 7000), '2008-06-13');

-- Step 2: Use WHERE to filter results
-- WHERE clause referencing an expression defined in the SELECT clause
SELECT SalesOrderID, CustomerID, MONTH(OrderDate) AS ordermonth
FROM SalesLT.SalesOrderHeader
WHERE MONTH(OrderDate) = 9;

-- Step 3: Use WHERE to filter results
-- WHERE clause fails when referencing expression by alias
-- NOTE THIS WILL CAUSE AN ERROR - Invalid column name 'ordermonth'
SELECT SalesOrderID, CustomerID, MONTH(OrderDate) AS ordermonth
FROM SalesLT.SalesOrderHeader
WHERE ordermonth = 9;

-- Step 4: Use WHERE to filter results
-- Simple WHERE clause
SELECT AddressLine1, CountryRegion
FROM SalesLT.Address
WHERE CountryRegion = N'United Kingdom';

-- Step 5: Use WHERE to filter results
-- Filter by date
SELECT SalesOrderID, OrderDate
FROM SalesLT.SalesOrderHeader
WHERE OrderDate > '2013-05-01';

-- Step 6: Use WHERE to filter results
-- Use of OR to check for multiple search values
SELECT AddressLine1, CountryRegion
FROM SalesLT.Address
WHERE CountryRegion = N'United Kingdom' OR CountryRegion = N'Canada';

-- Step 7: Use WHERE to filter results
-- Use IN operator to evaluate from a list
SELECT AddressLine1, CountryRegion
FROM SalesLT.Address
WHERE CountryRegion IN (N'United Kingdom',N'Canada');

-- Step 8: Use WHERE to filter results
-- Use NOT operator with IN to provide an exclusion list
SELECT AddressLine1, CountryRegion
FROM SalesLT.Address
WHERE CountryRegion NOT IN (N'United Kingdom',N'Canada');

-- Step 9: Use WHERE to filter results
-- Use logical operators to search within a range of dates
SELECT SalesOrderID, OrderDate
FROM SalesLT.SalesOrderHeader
WHERE OrderDate >= '20130501' AND OrderDate <= '20130601';

-- Step 10: Use WHERE to filter results
-- Use BETWEEN operator to search within a range of dates
SELECT SalesOrderID, OrderDate
FROM SalesLT.SalesOrderHeader
WHERE OrderDate BETWEEN '20130501' AND '20130601';

-- Step 11: Revert the changes made to date columns
UPDATE SalesLT.SalesOrderHeader 
SET OrderDate = '2008-06-01', 
	ShipDate = '2008-06-08',
	DueDate = '2008-06-13';
