---------------------------------------------------------------------
-- LAB 04
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------


---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT *
FROM Sales.Customers;

GO

-- When writing queries we avoid using * and always specify the needed columns. 
-- One way to select all columns using SQL Management Studio is to use Object Explorer and expand the database TSQL
-- and then expand the table Sales.Customers and drag the Columns folder on to this script file.

SELECT custid, companyname, contactname, contacttitle, [address], city, region, postalcode, country, phone, fax
FROM Sales.Customers;

GO

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT contactname, [address], postalcode, city, country
FROM Sales.Customers;

GO
