--  Demonstration B

--  Step 1: Open a new query window to the TSQL database
USE TSQL;
GO

-- Step 2: Join 2 tables
-- Select and execute the following query
-- to demonstrate a two-table inner join.
-- Point out that there are 77 rows output
SELECT c.categoryid, c.categoryname, p.productid, p.productname
FROM Production.Categories AS c
JOIN Production.Products AS p
ON c.categoryid = p.categoryid;

-- Step 3: Join 2 tables
-- Select and execute the following query
-- to demonstrate a two-table inner composite join.
-- Point out that there are 27 rows output without a distinct filter
SELECT e.city, e.country
FROM Sales.Customers AS c
JOIN HR.Employees AS e 
ON c.city = e.city AND c.country = e.country;

-- Step 4: Join 2 tables
-- Select and execute the following query
-- to demonstrate a two-table inner composite join.
-- Point out that there are 3 rows output with a distinct filter
SELECT DISTINCT  e.city, e.country
FROM Sales.Customers AS c
JOIN HR.Employees AS e 
ON c.city = e.city AND c.country = e.country;

-- Step 5: Join multiples tables
-- Select and execute the following query
-- to demonstrate a two-table inner join.
-- Point out that the elements needed to add and display data
-- from a third table have been commented out to join
-- the first two tables only
-- 830 rows will be returned
SELECT c.custid, c.companyname, o.orderid, o.orderdate-- , od.productid, od.qty
FROM Sales.Customers AS c 
JOIN Sales.Orders AS o
ON c.custid = o.custid;
-- JOIN Sales.OrderDetails od
-- ON o.orderid = od.orderid;

-- Step 6: Join 3 tables
-- Select and execute the following query
-- to demonstrate a three-table inner join.
-- 2155 rows will be returned. Why?
SELECT c.custid, c.companyname, o.orderid, o.orderdate, od.productid, od.qty
FROM Sales.Customers AS c 
JOIN Sales.Orders AS o
ON c.custid = o.custid
JOIN Sales.OrderDetails od
ON o.orderid = od.orderid;
