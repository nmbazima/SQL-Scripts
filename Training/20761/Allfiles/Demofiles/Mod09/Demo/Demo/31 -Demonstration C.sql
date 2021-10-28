-- Demonstration C

-- Step 1: Filtering Groups with HAVING
-- Change to AdventureWorks database
USE AdventureWorks;
GO

-- Step 2a: Using the HAVING clause
-- Select and execute the following query to show
-- The use of a HAVING clause. This query has no HAVING clause:
SELECT CustomerID, COUNT(*) AS count_orders
FROM Sales.SalesOrderHeader
GROUP BY CustomerID;

-- Step 2b: This query uses a HAVING clause to filter out customers with fewer than 10 orders
SELECT CustomerID, COUNT(*) AS count_orders
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(*) >= 10

-- Step 2c: Review the logical order of operations
-- the column alias for COUNT(*) hasn't been processed yet
-- when HAVING refers to it
-- THIS WILL FAIL
SELECT CustomerID, COUNT(*) AS count_orders
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING count_orders >= 10

-- Step 2d: Select and execute the following queries to show
-- difference between WHERE filter and HAVING filter:
-- The following query uses a WHERE clause to filter
-- orders

SELECT COUNT(*) AS cnt, AVG(OrderQty) AS [avg_qty]
FROM Production.Product AS p
JOIN Sales.SalesOrderDetail AS od
	ON p.productid = od.productid
WHERE od.OrderQty > 20
GROUP BY p.ProductLine;

-- Step 2e: This query uses a HAVING clause to filter groups
-- with an average quantity > 20
SELECT COUNT(*) AS cnt, AVG(OrderQty) AS [avg_qty]
FROM Production.Product AS p
JOIN Sales.SalesOrderDetail AS od
	ON p.productid = od.productid
GROUP BY p.ProductLine
HAVING AVG(OrderQty) > 20;

-- Step 2f: Select and execute the following query to show
-- All customers and how many orders they have placed
-- 89 rows - note custid 13
SELECT c.CustomerID, COUNT(*) AS No_Of_Orders
FROM Sales.Customer AS c
JOIN Sales.SalesOrderHeader AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY No_Of_Orders DESC;

-- Step 2g: Use HAVING to filter only customers who have placed more than 20 orders
SELECT c.CustomerID, COUNT(*) AS No_Of_Orders
FROM Sales.Customer AS c
JOIN Sales.SalesOrderHeader AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
HAVING COUNT(*) > 20
ORDER BY No_Of_Orders DESC;

-- Step 2h: Select and execute the following query to show
-- All products and in how many orders they appear
SELECT p.ProductID, COUNT(*) AS cnt
FROM Production.Product AS p
JOIN Sales.SalesOrderDetail AS od
ON p.ProductID = od.Productid
GROUP BY p.ProductID
ORDER BY cnt DESC;

-- Step 2i: Use HAVING to filter only products which have been ordered less than 20 times
-- 9 rows returned
SELECT p.ProductID, COUNT(*) AS cnt
FROM Production.Product AS p
JOIN Sales.SalesOrderDetail AS od
ON p.ProductID = od.Productid
GROUP BY p.ProductID
HAVING COUNT(*) < 20
ORDER BY cnt DESC;