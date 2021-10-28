---------------------------------------------------------------------
-- LAB 11
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------


SELECT
	p.productid, p.productname
FROM
(
	SELECT
		productid, productname, supplierid, unitprice, discontinued,
		CASE WHEN unitprice > 100. THEN N'high' ELSE N'normal' END AS pricetype
	FROM Production.Products
	WHERE categoryid = 1
) AS p
WHERE p.pricetype = N'high';


---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT
	c.custid,
	SUM(c.totalsalesamountperorder) AS totalsalesamount,
	AVG(c.totalsalesamountperorder) AS avgsalesamount
FROM
(
	SELECT 
		o.custid, o.orderid, SUM(d.unitprice * d.qty) AS totalsalesamountperorder
	FROM Sales.Orders AS o 
	INNER JOIN Sales.OrderDetails d ON d.orderid = o.orderid
	GROUP BY o.custid, o.orderid
) AS c
GROUP BY c.custid;

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------
SELECT
	cy.orderyear, 
	cy.totalsalesamount AS curtotalsales, 
	py.totalsalesamount AS prevtotalsales,
	(cy.totalsalesamount - py.totalsalesamount) / py.totalsalesamount * 100. AS percentgrowth
FROM
(
	SELECT
		YEAR(orderdate) AS orderyear, SUM(val) AS totalsalesamount
	FROM Sales.OrderValues
	GROUP BY YEAR(orderdate)
) AS cy
LEFT OUTER JOIN
(
	SELECT
		YEAR(orderdate) AS orderyear, SUM(val) AS totalsalesamount
	FROM Sales.OrderValues
	GROUP BY YEAR(orderdate)
) AS py ON cy.orderyear = py.orderyear + 1
ORDER BY cy.orderyear;
