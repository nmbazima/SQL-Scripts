---------------------------------------------------------------------
-- LAB 09
--
-- Exercise 3
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT
	YEAR(orderdate) AS orderyear, 
	COUNT(orderid) AS nooforders, 
	COUNT(DISTINCT custid) AS noofcustomers
FROM Sales.Orders 
GROUP BY YEAR(orderdate);

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT
	SUBSTRING(c.contactname,1,1) AS firstletter,
	COUNT(DISTINCT c.custid) AS noofcustomers, 
	COUNT(o.orderid) AS nooforders
FROM Sales.Customers AS c
LEFT OUTER JOIN Sales.Orders AS o ON o.custid = c.custid
GROUP BY SUBSTRING(c.contactname,1,1)
ORDER BY firstletter;


---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT
	c.categoryid, c.categoryname, 
	SUM(d.qty * d.unitprice) AS totalsalesamount, 
	COUNT(DISTINCT o.orderid) AS nooforders,
	SUM(d.qty * d.unitprice) / COUNT(DISTINCT o.orderid) AS avgsalesamountperorder
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
INNER JOIN Production.Products AS p ON p.productid = d.productid
INNER JOIN Production.Categories AS c ON c.categoryid = p.categoryid
WHERE orderdate >= '20080101' AND orderdate < '20090101'
GROUP BY c.categoryid, c.categoryname;

