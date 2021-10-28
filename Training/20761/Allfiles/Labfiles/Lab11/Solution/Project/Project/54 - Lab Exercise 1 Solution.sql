---------------------------------------------------------------------
-- LAB 11
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------
SELECT
	productid, productname, supplierid, unitprice, discontinued
FROM Production.Products
WHERE categoryid = 1;

GO

CREATE VIEW Production.ProductsBeverages AS
SELECT
	productid, productname, supplierid, unitprice, discontinued
FROM Production.Products
WHERE categoryid = 1;
	


---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT	
	productid, productname
FROM Production.ProductsBeverages
WHERE supplierid = 1;

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

ALTER VIEW Production.ProductsBeverages AS
SELECT
	productid, productname, supplierid, unitprice, discontinued
FROM Production.Products
WHERE categoryid = 1
ORDER BY productname;

GO

ALTER VIEW Production.ProductsBeverages AS
SELECT TOP(100) PERCENT
	productid, productname, supplierid, unitprice, discontinued
FROM Production.Products
WHERE categoryid = 1
ORDER BY productname;

GO
---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

ALTER VIEW Production.ProductsBeverages AS
SELECT
	productid, productname, supplierid, unitprice, discontinued,
	CASE WHEN unitprice > 100. THEN N'high' ELSE N'normal' END
FROM Production.Products
WHERE categoryid = 1;

GO

ALTER VIEW Production.ProductsBeverages AS
SELECT
	productid, productname, supplierid, unitprice, discontinued,
	CASE WHEN unitprice > 100. THEN N'high' ELSE N'normal' END AS pricetype
FROM Production.Products
WHERE categoryid = 1;

GO

---------------------------------------------------------------------
-- Task 5
---------------------------------------------------------------------

IF OBJECT_ID(N'Production.ProductsBeverages', N'V') IS NOT NULL
	DROP VIEW Production.ProductsBeverages;
