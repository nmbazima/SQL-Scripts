---------------------------------------------------------------------
-- LAB 14
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------
CREATE VIEW Sales.PivotCustGroups AS
WITH PivotCustGroups AS
(
	SELECT 
		custid,
		country,
		custgroup
	FROM Sales.CustGroups
)
SELECT 
	country,
	p.A,
	p.B,
	p.C
FROM PivotCustGroups
PIVOT (COUNT(custid) FOR custgroup IN (A, B, C)) AS p;

GO

SELECT 
	country, A, B, C
FROM Sales.PivotCustGroups;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT 
	custgroup,
	country,
	numberofcustomers
FROM Sales.PivotCustGroups
UNPIVOT (numberofcustomers FOR custgroup IN (A, B, C)) AS p;

GO

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

DROP VIEW Sales.CustGroups;
DROP VIEW Sales.PivotCustGroups;
