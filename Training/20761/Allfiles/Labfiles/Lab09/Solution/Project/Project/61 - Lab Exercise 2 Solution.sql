---------------------------------------------------------------------
-- LAB 09
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT
	o.orderid, o.orderdate, SUM(d.qty * d.unitprice) AS salesamount
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
GROUP BY o.orderid, o.orderdate
ORDER BY salesamount DESC;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT
	o.orderid, o.orderdate, 
	SUM(d.qty * d.unitprice) AS salesamount, 
	COUNT(*) AS noofoderlines, 
	AVG(d.qty * d.unitprice) AS avgsalesamountperorderline
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
GROUP BY o.orderid, o.orderdate
ORDER BY salesamount DESC;

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------
SELECT
	YEAR(orderdate) * 100 + MONTH(orderdate) AS yearmonthno, 
	SUM(d.qty * d.unitprice) AS saleamountpermonth
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
GROUP BY YEAR(orderdate), MONTH(orderdate)
ORDER BY yearmonthno;

---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

SELECT 
	c.custid, c.contactname, 
	SUM(d.qty * d.unitprice) AS totalsalesamount,
	MAX(d.qty * d.unitprice) AS maxsalesamountperorderline, 
	COUNT(*) AS numberofrows,
	COUNT(o.orderid) AS numberoforderlines
FROM Sales.Customers AS c
LEFT OUTER JOIN Sales.Orders AS o ON o.custid = c.custid
LEFT OUTER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
GROUP BY c.custid, c.contactname
ORDER BY totalsalesamount;



