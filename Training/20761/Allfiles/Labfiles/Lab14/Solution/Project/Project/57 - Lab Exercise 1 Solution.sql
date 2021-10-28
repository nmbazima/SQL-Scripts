---------------------------------------------------------------------
-- LAB 14
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------
CREATE VIEW Sales.CustGroups AS
SELECT 
	custid,
	CHOOSE(custid % 3 + 1, N'A', N'B', N'C') AS custgroup,
	country
FROM Sales.Customers;

GO

SELECT 
	custid,
	custgroup,
	country
FROM Sales.CustGroups;

GO

SELECT 
	country,
	p.A,
	p.B,
	p.C
FROM Sales.CustGroups
PIVOT (COUNT(custid) FOR custgroup IN (A, B, C)) AS p;

GO
---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

ALTER VIEW Sales.CustGroups AS
SELECT 
	custid,
	CHOOSE(custid % 3 + 1, N'A', N'B', N'C') AS custgroup,
	country,
	city,
	contactname
FROM Sales.Customers;

GO

SELECT 
	country,
	p.A,
	p.B,
	p.C
FROM Sales.CustGroups
PIVOT (COUNT(custid) FOR custgroup IN (A, B, C)) AS p;

GO

SELECT 
	country,
	city,
	contactname,
	p.A,
	p.B,
	p.C
FROM Sales.CustGroups
PIVOT (COUNT(custid) FOR custgroup IN (A, B, C)) AS p;

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

WITH PivotCustGroups AS
(
	SELECT 
		custid,
		country,
		custgroup
	FROM Sales.CustGroups
)
SELECT 
	country,
	p.A,
	p.B,
	p.C
FROM PivotCustGroups
PIVOT (COUNT(custid) FOR custgroup IN (A, B, C)) AS p;

---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

WITH SalesByCategory AS
(
	SELECT
		o.custid,
		d.qty * d.unitprice AS salesvalue,
		c.categoryname
	FROM Sales.Orders AS o
	INNER JOIN Sales.OrderDetails AS d ON o.orderid = d.orderid
	INNER JOIN Production.Products AS p ON p.productid = d.productid
	INNER JOIN Production.Categories AS c ON c.categoryid = p.categoryid
	WHERE o.orderdate >= '20080101' AND o.orderdate < '20090101'	
)
SELECT
	custid,
	p.Beverages,
	p.Condiments,
	p.Confections,
	p.[Dairy Products],
	p.[Grains/Cereals],
	p.[Meat/Poultry],
	p.Produce,
	p.Seafood
FROM SalesByCategory
PIVOT (SUM(salesvalue) FOR categoryname 
	IN (Beverages, Condiments, Confections, [Dairy Products], [Grains/Cereals], [Meat/Poultry], Produce, Seafood)) AS p;

