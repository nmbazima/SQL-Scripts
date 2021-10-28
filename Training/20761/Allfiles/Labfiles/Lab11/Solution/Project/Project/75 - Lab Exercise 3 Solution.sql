---------------------------------------------------------------------
-- LAB 11
--
-- Exercise 3
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

WITH ProductsBeverages AS
(
	SELECT
		productid, productname, supplierid, unitprice, discontinued,
		CASE WHEN unitprice > 100. THEN N'high' ELSE N'normal' END AS pricetype
	FROM Production.Products
	WHERE categoryid = 1
)
SELECT
	productid, productname
FROM ProductsBeverages
WHERE pricetype = N'high';

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

WITH c2008 (custid, salesamt2008) AS
(
	SELECT
		 custid, SUM(val)
	FROM Sales.OrderValues
	WHERE YEAR(orderdate) = 2008
	GROUP BY custid
)
SELECT
	c.custid, c.contactname, c2008.salesamt2008
FROM Sales.Customers AS c
LEFT OUTER JOIN c2008 ON c.custid = c2008.custid;

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

WITH c2008 (custid, salesamt2008) AS
(
	SELECT
		 custid, SUM(val)
	FROM Sales.OrderValues
	WHERE YEAR(orderdate) = 2008
	GROUP BY custid
),
c2007 (custid, salesamt2007) AS
(
	SELECT
		 custid, SUM(val)
	FROM Sales.OrderValues
	WHERE YEAR(orderdate) = 2007
	GROUP BY custid
)
SELECT
	c.custid, c.contactname, 
	c2008.salesamt2008, 
	c2007.salesamt2007,
	COALESCE((c2008.salesamt2008 - c2007.salesamt2007) / c2007.salesamt2007 * 100., 0) AS percentgrowth
FROM Sales.Customers AS c
LEFT OUTER JOIN c2008 ON c.custid = c2008.custid
LEFT OUTER JOIN c2007 ON c.custid = c2007.custid
ORDER BY percentgrowth DESC;

