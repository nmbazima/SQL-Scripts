---------------------------------------------------------------------
-- LAB 10
--
-- Exercise 3
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT
	c.custid, c.contactname,
	(
		SELECT MAX(o.orderdate) 
		FROM Sales.Orders AS o 
		WHERE o.custid = c.custid
	) AS lastorderdate
FROM Sales.Customers AS c;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT c.custid, c.contactname
FROM Sales.Customers AS c
WHERE 
	NOT EXISTS (SELECT * FROM Sales.Orders AS o WHERE o.custid = c.custid);

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT c.custid, c.contactname
FROM Sales.Customers AS c
WHERE 
	EXISTS (
		SELECT * 
		FROM Sales.Orders AS o 
		INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
		WHERE o.custid = c.custid
			AND d.unitprice > 100.
			AND o.orderdate >= '20080401' 
		);

---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

SELECT
	YEAR(o.orderdate) as orderyear, 
	SUM(d.qty * d.unitprice) AS totalsales,
	(
		SELECT SUM(d2.qty * d2.unitprice)
		FROM Sales.Orders AS o2
		INNER JOIN Sales.OrderDetails AS d2 ON d2.orderid = o2.orderid
		WHERE YEAR(o2.orderdate) <= YEAR(o.orderdate)
	) AS runsales
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
GROUP BY YEAR(o.orderdate)
ORDER BY orderyear;


---------------------------------------------------------------------
-- Task 5
---------------------------------------------------------------------

DELETE Sales.Orders
WHERE custid IS NULL;


