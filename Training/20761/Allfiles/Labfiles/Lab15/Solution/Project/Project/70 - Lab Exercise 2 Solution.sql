---------------------------------------------------------------------
-- LAB 15
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

ALTER PROCEDURE Sales.GetTopCustomers 
	@orderyear int
AS
SELECT
	c.custid,
	c.contactname,
	SUM(o.val) AS salesvalue
FROM Sales.OrderValues AS o
INNER JOIN Sales.Customers AS c ON c.custid = o.custid
WHERE YEAR(o.orderdate) = @orderyear
GROUP BY c.custid, c.contactname
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

GO

EXECUTE Sales.GetTopCustomers @orderyear = 2007;
EXECUTE Sales.GetTopCustomers @orderyear = 2008;
EXECUTE Sales.GetTopCustomers;

GO
---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

ALTER PROCEDURE Sales.GetTopCustomers 
	@orderyear int = NULL
AS
SELECT
	c.custid,
	c.contactname,
	SUM(o.val) AS salesvalue
FROM Sales.OrderValues AS o
INNER JOIN Sales.Customers AS c ON c.custid = o.custid
WHERE YEAR(o.orderdate) = @orderyear OR @orderyear IS NULL
GROUP BY c.custid, c.contactname
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

GO

EXECUTE Sales.GetTopCustomers;

GO
---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------
ALTER PROCEDURE Sales.GetTopCustomers 
	@orderyear int = NULL,
	@n int = 10
AS
SELECT
	c.custid,
	c.contactname,
	SUM(o.val) AS salesvalue
FROM Sales.OrderValues AS o
INNER JOIN Sales.Customers AS c ON c.custid = o.custid
WHERE YEAR(o.orderdate) = @orderyear OR @orderyear IS NULL
GROUP BY c.custid, c.contactname
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT @n ROWS ONLY;

GO

EXECUTE Sales.GetTopCustomers;
EXECUTE Sales.GetTopCustomers @orderyear = 2008, @n = 5;
EXECUTE Sales.GetTopCustomers @orderyear = 2007;
EXECUTE Sales.GetTopCustomers @n = 20;

GO

---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

ALTER PROCEDURE Sales.GetTopCustomers 
	@customerpos int = 1,
	@customername nvarchar(30) OUTPUT
AS
SET @customername = (
	SELECT
		c.contactname
	FROM Sales.OrderValues AS o
	INNER JOIN Sales.Customers AS c ON c.custid = o.custid
	GROUP BY c.custid, c.contactname
	ORDER BY SUM(o.val) DESC
	OFFSET @customerpos - 1 ROWS FETCH NEXT 1 ROW ONLY
);

GO

DECLARE @outcustomername nvarchar(30);

EXECUTE Sales.GetTopCustomers @customerpos = 1, @customername = @outcustomername OUTPUT;

SELECT @outcustomername AS customername;

