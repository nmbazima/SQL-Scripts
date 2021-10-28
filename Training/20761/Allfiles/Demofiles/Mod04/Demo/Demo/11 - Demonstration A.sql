-- Demonstration A

-- Step 1: Open a new query window to the TSQL database
USE TSQL;
GO

-- Step 2: Join 2 tables
-- Select and execute the following query
-- to illustrate ANSI SQL-89 syntax
-- to join 2 tables
-- Point out that 830 rows are returned.
SELECT c.companyname, o.orderdate
FROM Sales.Customers AS c, Sales.Orders AS o
WHERE c.custid = o.custid;

-- Step 3: Join 2 tables
-- Select and execute the following query
-- to illustrate ANSI SQL-89 syntax
-- omitting the WHERE clause and causing an inadvertent Cartesian join.
-- Point out that 75530 rows are returned.
SELECT c.companyname, o.orderdate
FROM Sales.Customers AS c, Sales.Orders AS o;

-- Step 4: Join 2 tables
-- Select and execute the following query
-- to illustrate ANSI SQL-92 syntax
-- to join 2 tables
-- Point out that 830 rows are returned.
SELECT c.companyname, o.orderdate
FROM Sales.Customers AS c JOIN Sales.Orders AS o
ON c.custid = o.custid;

-- Step 5: Join 2 tables
-- Select and execute the following query
-- to illustrate ANSI SQL-92 syntax.
-- Note that the ON clause is deliberately omitted
-- to cause an error, showing the protection
-- against accidental Cartesian products
--THIS WILL INTENTIONALLY CAUSE AN ERROR

SELECT c.companyname, o.orderdate
FROM Sales.Customers AS c JOIN Sales.Orders AS o;
-- ON c.custid = o.custid
