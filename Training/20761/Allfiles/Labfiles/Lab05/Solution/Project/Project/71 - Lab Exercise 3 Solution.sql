---------------------------------------------------------------------
-- LAB 06
--
-- Exercise 3
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT TOP (20)
	orderid, orderdate
FROM Sales.Orders
ORDER BY orderdate DESC;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT 
	orderid, orderdate
FROM Sales.Orders
ORDER BY orderdate DESC
OFFSET 0 ROWS FETCH FIRST 20 ROWS ONLY;


---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT TOP (10) PERCENT
	 productname, unitprice
FROM Production.Products
ORDER BY unitprice DESC;