---------------------------------------------------------------------
-- LAB 11
--
-- Exercise 4
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT
	custid, SUM(val) AS totalsalesamount
FROM Sales.OrderValues
WHERE YEAR(orderdate) = 2007
GROUP BY custid;

GO

CREATE FUNCTION dbo.fnGetSalesByCustomer
(@orderyear AS INT) RETURNS TABLE
AS
RETURN
SELECT
	custid, SUM(val) AS totalsalesamount
FROM Sales.OrderValues
WHERE YEAR(orderdate) = @orderyear
GROUP BY custid;

GO


---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT 
	custid, totalsalesamount
FROM dbo.fnGetSalesByCustomer(2007);

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT TOP(3)
	d.productid, 
	MAX(p.productname) AS productname, 
	SUM(d.qty * d.unitprice) AS totalsalesamount	
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
INNER JOIN Production.Products AS p ON p.productid = d.productid
WHERE custid = 1
GROUP BY d.productid
ORDER BY totalsalesamount DESC;

GO

CREATE FUNCTION dbo.fnGetTop3ProductsForCustomer
(@custid AS INT) RETURNS TABLE
AS
RETURN
SELECT TOP(3)
	d.productid, 
	MAX(p.productname) AS productname, 
	SUM(d.qty * d.unitprice) AS totalsalesamount	
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
INNER JOIN Production.Products AS p ON p.productid = d.productid
WHERE custid = @custid
GROUP BY d.productid
ORDER BY totalsalesamount DESC;

GO

SELECT 
	p.productid,
	p.productname,
	p.totalsalesamount
FROM dbo.fnGetTop3ProductsForCustomer(1) AS p;

---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

SELECT 
	c.custid, c.contactname,
	c2008.totalsalesamount AS salesamt2008,
	c2007.totalsalesamount AS salesamt2007,
	COALESCE((c2008.totalsalesamount - c2007.totalsalesamount) / c2007.totalsalesamount * 100., 0) AS percentgrowth
FROM Sales.Customers AS c
LEFT OUTER JOIN dbo.fnGetSalesByCustomer(2007) AS c2007 ON c.custid = c2007.custid
LEFT OUTER JOIN dbo.fnGetSalesByCustomer(2008) AS c2008 ON c.custid = c2008.custid;

---------------------------------------------------------------------
-- Task 5
---------------------------------------------------------------------

IF OBJECT_ID('dbo.fnGetSalesByCustomer') IS NOT NULL
	DROP FUNCTION dbo.fnGetSalesByCustomer;

IF OBJECT_ID('dbo.fnGetTop3ProductsForCustomer') IS NOT NULL
	DROP FUNCTION dbo.fnGetTop3ProductsForCustomer;
GO


