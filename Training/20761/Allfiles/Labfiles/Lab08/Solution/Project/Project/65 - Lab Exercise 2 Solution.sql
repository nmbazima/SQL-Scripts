---------------------------------------------------------------------
-- LAB 08
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT
	IIF(country = N'Mexico' AND contacttitle = N'Owner', N'Target group', N'Other') AS segmentgroup, custid, contactname
FROM Sales.Customers;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT
	IIF(contacttitle = N'Owner' OR region IS NOT NULL, N'Target group', N'Other') AS segmentgroup,  custid,  contactname
FROM Sales.Customers;

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT CHOOSE(custid % 4 + 1, N'Group One', N'Group Two', N'Group Three', N'Group Four') AS segmentgroup, custid, contactname
FROM Sales.Customers;


