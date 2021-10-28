---------------------------------------------------------------------
-- LAB 10
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT MAX(orderdate) AS lastorderdate 
FROM Sales.Orders;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT
	orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE 
	orderdate = (SELECT MAX(orderdate) FROM Sales.Orders);

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT
	orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE 
	custid = 
	(
		SELECT custid
		FROM Sales.Customers
		WHERE contactname LIKE N'I%'
	);

-- error
SELECT
	orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE 
	custid = 
	(
		SELECT custid
		FROM Sales.Customers
		WHERE contactname LIKE N'B%'
	);

-- fixed
SELECT
	orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE 
	custid IN 
	(
		SELECT custid
		FROM Sales.Customers
		WHERE contactname LIKE N'B%'
	);

---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

SELECT
	o.orderid, 
	SUM(d.qty * d.unitprice) AS totalsalesamount,
	SUM(d.qty * d.unitprice) /
	(
		SELECT SUM(d.qty * d.unitprice) 
		FROM Sales.Orders AS o
		INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
		WHERE o.orderdate >= '20080501' AND o.orderdate < '20080601'
	) * 100. AS salespctoftotal
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
WHERE o.orderdate >= '20080501' AND o.orderdate < '20080601'
GROUP BY o.orderid;




