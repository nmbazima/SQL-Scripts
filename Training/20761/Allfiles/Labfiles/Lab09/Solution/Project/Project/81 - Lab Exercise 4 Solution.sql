---------------------------------------------------------------------
-- LAB 09
--
-- Exercise 4
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT TOP (10) 
	o.custid, 
	SUM(d.qty * d.unitprice) AS totalsalesamount 
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
GROUP BY o.custid
HAVING SUM(d.qty * d.unitprice) > 10000
ORDER BY totalsalesamount DESC;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT
	o.orderid,
	o.empid,
	SUM(d.qty * d.unitprice) as totalsalesamount
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
WHERE o.orderdate >= '20080101' AND o.orderdate < '20090101'
GROUP BY o.orderid, o.empid;

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

-- add having clause
SELECT
	o.orderid,
	o.empid,
	SUM(d.qty * d.unitprice) as totalsalesamount
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
WHERE o.orderdate >= '20080101' AND o.orderdate < '20090101'
GROUP BY o.orderid, o.empid
HAVING SUM(d.qty * d.unitprice) >= 10000;

-- add predicate
SELECT
	o.orderid,
	o.empid,
	SUM(d.qty * d.unitprice) as totalsalesamount
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
WHERE 
	o.orderdate >= '20080101' AND o.orderdate <= '20090101'
	AND o.empid = 3
GROUP BY o.orderid, o.empid
HAVING SUM(d.qty * d.unitprice) >= 10000;


---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

SELECT
	o.custid, 
	MAX(orderdate) AS lastorderdate, 
	SUM(d.qty * d.unitprice) AS totalsalesamount
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
GROUP BY o.custid 
HAVING COUNT(DISTINCT o.orderid) > 25;

