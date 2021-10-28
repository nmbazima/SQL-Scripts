---------------------------------------------------------------------
-- LAB 12
--
-- Exercise 3
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT 
	o.custid
FROM Sales.Orders AS o 
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
GROUP BY o.custid
HAVING COUNT(DISTINCT d.productid) > 20;


---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT
	custid
FROM Sales.Customers 
WHERE country = 'USA'

EXCEPT

SELECT 
	o.custid
FROM Sales.Orders AS o 
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
GROUP BY o.custid
HAVING COUNT(DISTINCT d.productid) > 20;



---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT 
	o.custid
FROM Sales.Orders AS o 
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
GROUP BY o.custid
HAVING SUM(d.qty * d.unitprice) > 10000;

---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

SELECT
	c.custid
FROM Sales.Customers AS c

EXCEPT

SELECT 
	o.custid
FROM Sales.Orders AS o 
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
GROUP BY o.custid
HAVING COUNT(DISTINCT d.productid) > 20

INTERSECT

SELECT 
	o.custid
FROM Sales.Orders AS o 
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
GROUP BY o.custid
HAVING SUM(d.qty * d.unitprice) > 10000;

---------------------------------------------------------------------
-- Task 5
---------------------------------------------------------------------

(
SELECT
	c.custid
FROM Sales.Customers AS c

EXCEPT

SELECT 
	o.custid
FROM Sales.Orders AS o 
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
GROUP BY o.custid
HAVING COUNT(DISTINCT d.productid) > 20
)

INTERSECT

SELECT 
	o.custid
FROM Sales.Orders AS o 
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
GROUP BY o.custid
HAVING SUM(d.qty * d.unitprice) > 10000;

