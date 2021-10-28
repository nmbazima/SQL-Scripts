---------------------------------------------------------------------
-- LAB 06
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT DISTINCT
	custid
FROM Sales.Orders 
WHERE 
	YEAR(orderdate) = 2008 
	AND MONTH(orderdate) = 2;

-- This one can better utilize indexing than the first solution.

SELECT DISTINCT
	custid
FROM Sales.Orders 
WHERE 
	orderdate >= '20080201'
	AND orderdate < '20080301';


---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT
	CURRENT_TIMESTAMP AS currentdate, 
	DATEADD (day, 1, EOMONTH(CURRENT_TIMESTAMP, -1)) AS firstofmonth,
	EOMONTH(CURRENT_TIMESTAMP) AS endofmonth;

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT 
	orderid, custid, orderdate
FROM Sales.Orders
WHERE 
	DATEDIFF(
		day,
		orderdate,
		EOMONTH(orderdate)  
	) < 5;


---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

SELECT DISTINCT
	d.productid
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
WHERE 
	DATEPART(week, orderdate) <= 10 
	AND YEAR(orderdate) = 2007;