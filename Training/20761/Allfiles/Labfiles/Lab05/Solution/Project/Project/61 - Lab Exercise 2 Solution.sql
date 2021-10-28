---------------------------------------------------------------------
-- LAB 06
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT
	c.custid, c.contactname, o.orderid, o.orderdate
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o ON c.custid = o.custid 
WHERE 
	o.orderdate >= '20080401'
ORDER BY
	o.orderdate DESC, c.custid ASC;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT
	e.empid, e.lastname, e.firstname, e.title, e.mgrid,
	m.lastname AS mgrlastname, m.firstname AS mgrfirstname
FROM HR.Employees AS e
INNER JOIN HR.Employees AS m ON e.mgrid = m.empid
WHERE
	m.lastname = N'Buck';

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT
	e.empid, e.lastname, e.firstname, e.title, e.mgrid,
	m.lastname AS mgrlastname, m.firstname AS mgrfirstname
FROM HR.Employees AS e
INNER JOIN HR.Employees AS m ON e.mgrid = m.empid
ORDER BY 
	m.firstname;

SELECT
	e.empid, e.lastname, e.firstname, e.title, e.mgrid,
	m.lastname AS mgrlastname, m.firstname AS mgrfirstname
FROM HR.Employees AS e
INNER JOIN HR.Employees AS m ON e.mgrid = m.empid
ORDER BY 
	mgrfirstname;

