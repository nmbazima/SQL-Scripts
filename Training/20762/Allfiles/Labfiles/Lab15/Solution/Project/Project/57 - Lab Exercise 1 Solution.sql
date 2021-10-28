---------------------------------------------------------------------
-- LAB 12
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT 
	productid, productname
FROM Production.Products
WHERE categoryid = 4;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT
	d.productid, p.productname
FROM Sales.OrderDetails d 
INNER JOIN Production.Products p ON p.productid = d.productid
GROUP BY d.productid, p.productname
HAVING SUM(d.qty * d.unitprice) > 50000;


---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT 
	productid, productname
FROM Production.Products
WHERE categoryid = 4

UNION

SELECT
	d.productid, p.productname
FROM Sales.OrderDetails d 
INNER JOIN Production.Products p ON p.productid = d.productid
GROUP BY d.productid, p.productname
HAVING SUM(d.qty * d.unitprice) > 50000;


SELECT 
	productid, productname
FROM Production.Products
WHERE categoryid = 4

UNION ALL

SELECT
	d.productid, p.productname
FROM Sales.OrderDetails d 
INNER JOIN Production.Products p ON p.productid = d.productid
GROUP BY d.productid, p.productname
HAVING SUM(d.qty * d.unitprice) > 50000;

---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

SELECT 
	c1.custid, c1.contactname
FROM
(
	SELECT TOP (10)
		o.custid, c.contactname
	FROM Sales.OrderValues AS o
	INNER JOIN Sales.Customers AS c ON c.custid = o.custid
	WHERE o.orderdate >= '20080101' AND o.orderdate < '20080201'
	GROUP BY o.custid, c.contactname
	ORDER BY SUM(o.val) DESC
) AS c1

UNION

SELECT c2.custid, c2.contactname
FROM
(
	SELECT TOP (10)
		o.custid, c.contactname
	FROM Sales.OrderValues AS o
	INNER JOIN Sales.Customers AS c ON c.custid = o.custid
	WHERE o.orderdate >= '20080201' AND o.orderdate < '20080301'
	GROUP BY o.custid, c.contactname
	ORDER BY SUM(o.val) DESC
) AS c2;
