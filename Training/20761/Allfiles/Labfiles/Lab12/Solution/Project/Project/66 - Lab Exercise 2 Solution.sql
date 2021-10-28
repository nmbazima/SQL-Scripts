---------------------------------------------------------------------
-- LAB 12
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT
	p.productid, p.productname, o.orderid
FROM Production.Products AS p
CROSS APPLY 
(
	SELECT TOP(2)
		d.orderid	
	FROM Sales.OrderDetails AS d
	WHERE d.productid = p.productid
	ORDER BY d.orderid DESC
) o
ORDER BY p.productid;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------
IF OBJECT_ID('dbo.fnGetTop3ProductsForCustomer') IS NOT NULL
	DROP FUNCTION dbo.fnGetTop3ProductsForCustomer;

GO

CREATE FUNCTION dbo.fnGetTop3ProductsForCustomer
(@custid AS INT) RETURNS TABLE
AS
RETURN
SELECT TOP(3)
	d.productid, 
	p.productname, 
	SUM(d.qty * d.unitprice) AS totalsalesamount	
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
INNER JOIN Production.Products AS p ON p.productid = d.productid
WHERE custid = @custid
GROUP BY d.productid, p.productname;

GO

SELECT
	c.custid, c.contactname, p.productid, p.productname, p.totalsalesamount
FROM Sales.Customers AS c
CROSS APPLY dbo.fnGetTop3ProductsForCustomer (c.custid) AS p
ORDER BY c.custid;

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT
	c.custid, c.contactname, p.productid, p.productname, p.totalsalesamount
FROM Sales.Customers AS c
OUTER APPLY dbo.fnGetTop3ProductsForCustomer (c.custid) AS p
ORDER BY c.custid;


---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

SELECT
	c.custid, c.contactname, p.productid, p.productname, p.totalsalesamount
FROM Sales.Customers AS c
OUTER APPLY dbo.fnGetTop3ProductsForCustomer (c.custid) AS p
WHERE p.productid IS NULL;

---------------------------------------------------------------------
-- Task 5
---------------------------------------------------------------------

IF OBJECT_ID('dbo.fnGetTop3ProductsForCustomer') IS NOT NULL
	DROP FUNCTION dbo.fnGetTop3ProductsForCustomer;