---------------------------------------------------------------------
-- LAB 04
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT 
	custid, contactname, orderid
FROM Sales.Customers  
INNER JOIN Sales.Orders ON Customers.custid = Orders.custid;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT 
	Customers.custid, contactname, orderid
FROM Sales.Customers  
INNER JOIN Sales.Orders ON Customers.custid = Orders.custid;

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT 
	c.custid, c.contactname, o.orderid
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o ON c.custid = o.custid;

-- produce an error
SELECT 
	Customers.custid, Customers.contactname, Orders.orderid
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o ON c.custid = o.custid;


---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

SELECT 
	c.custid, c.contactname, o.orderid, d.productid, d.qty, d.unitprice
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o ON c.custid = o.custid
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid;
