---------------------------------------------------------------------
-- LAB 06
--
-- Exercise 3
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT 
	CONCAT(contactname, N' (city: ', city, N')') AS contactwithcity
FROM Sales.Customers;

SELECT 
	contactname + N' (city: ' + city + N')' AS contactwithcity 
FROM Sales.Customers;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT 
	CONCAT(contactname, N' (city: ', city,  N', region: ', region, N')') AS fullcontact
FROM Sales.Customers;

SELECT 
	contactname + N' (city: ' + city + N', region: ' + COALESCE(region, '') + N')' AS fullcontact
FROM Sales.Customers;

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT contactname, contacttitle
FROM Sales.Customers
WHERE contactname LIKE N'[A-G]%'
ORDER BY contactname;


