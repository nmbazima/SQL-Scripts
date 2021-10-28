---------------------------------------------------------------------
-- LAB 06
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT
	custid, companyname, contactname, address, city, country, phone
FROM Sales.Customers
WHERE 
	country = N'Brazil';

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT
	custid, companyname, contactname, address, city, country, phone
FROM Sales.Customers
WHERE 
	country IN (N'Brazil', N'UK', N'USA');

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT
	custid, companyname, contactname, address, city, country, phone
FROM Sales.Customers
WHERE 
	contactname LIKE N'A%';

---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

SELECT
	c.custid, c.companyname, o.orderid
FROM Sales.Customers AS c
LEFT OUTER JOIN Sales.Orders AS o ON c.custid = o.custid AND c.city = N'Paris';

SELECT
	c.custid, c.companyname, o.orderid
FROM Sales.Customers AS c
LEFT OUTER JOIN Sales.Orders AS o ON c.custid = o.custid 
WHERE 
	c.city = N'Paris';

---------------------------------------------------------------------
-- Task 5
---------------------------------------------------------------------

SELECT
	c.custid, c.companyname
FROM Sales.Customers AS c
LEFT OUTER JOIN Sales.Orders AS o ON c.custid = o.custid 
WHERE o.custid IS NULL;
