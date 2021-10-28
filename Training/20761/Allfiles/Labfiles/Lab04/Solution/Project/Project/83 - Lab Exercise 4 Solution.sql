---------------------------------------------------------------------
-- LAB 04
--
-- Exercise 4
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- copy-paste text about lab from doc file
---------------------------------------------------------------------

SELECT 
	c.custid, c.contactname, o.orderid
FROM Sales.Customers AS c
LEFT OUTER JOIN Sales.Orders AS o ON c.custid = o.custid;


