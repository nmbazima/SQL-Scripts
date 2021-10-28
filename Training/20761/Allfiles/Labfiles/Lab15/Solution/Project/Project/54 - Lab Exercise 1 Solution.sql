---------------------------------------------------------------------
-- LAB 15
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------
CREATE PROCEDURE Sales.GetTopCustomers AS
SELECT TOP(10)
	c.custid,
	c.contactname,
	SUM(o.val) AS salesvalue
FROM Sales.OrderValues AS o
INNER JOIN Sales.Customers AS c ON c.custid = o.custid
GROUP BY c.custid, c.contactname
ORDER BY salesvalue DESC;

GO

EXECUTE Sales.GetTopCustomers;	

GO
---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

ALTER PROCEDURE Sales.GetTopCustomers AS
SELECT 
	c.custid,
	c.contactname,
	SUM(o.val) AS salesvalue
FROM Sales.OrderValues AS o
INNER JOIN Sales.Customers AS c ON c.custid = o.custid
GROUP BY c.custid, c.contactname
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

GO

EXECUTE Sales.GetTopCustomers;	


