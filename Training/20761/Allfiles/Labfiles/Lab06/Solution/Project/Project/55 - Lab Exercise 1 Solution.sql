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
	CURRENT_TIMESTAMP AS currentdatetime,
	CAST(CURRENT_TIMESTAMP AS date) AS currentdate,
	CAST(CURRENT_TIMESTAMP AS time) AS currenttime,
	YEAR(CURRENT_TIMESTAMP) AS currentyear,
	MONTH(CURRENT_TIMESTAMP) AS currentmonth,
	DAY(CURRENT_TIMESTAMP) AS currentday,
	DATEPART(week, CURRENT_TIMESTAMP) AS currentweeknumber,
	DATENAME(month, CURRENT_TIMESTAMP) AS currentmonthname;

-- and some other possibilities to remove the time portion from datetime, useful when working with versions of SQL Server before SQL Server 2008
-- When working with SQL Server 2008 and later, 
SELECT CAST(CONVERT(char(8), CURRENT_TIMESTAMP, 112) AS datetime) AS currentdate;
SELECT DATEADD(day, DATEDIFF(day, '20000101', CURRENT_TIMESTAMP), '20000101') AS currentdate;


---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT DATEFROMPARTS(2015, 12, 11) AS somedate;

SELECT CAST('20151211' AS date) AS somedate;

SELECT CONVERT(date, '12/11/2015', 101) AS somedate;

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT 
	DATEADD(month, 3, CURRENT_TIMESTAMP) AS threemonths,
	DATEDIFF(day, CURRENT_TIMESTAMP, DATEADD(month, 3, CURRENT_TIMESTAMP)) AS diffdays,
	DATEDIFF(week, '19920404', '20110916') AS diffweeks,
	DATEADD(day, 1, EOMONTH(CURRENT_TIMESTAMP,-1)) AS firstday; 


---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

SET NOCOUNT ON;

DROP TABLE IF EXISTS Sales.Somedates;

CREATE TABLE Sales.Somedates (
	isitdate varchar(9)
);

INSERT INTO Sales.Somedates (isitdate) VALUES 
	('20110101'),
	('20110102'),
	('20110103X'),
	('20110104'),
	('20110105'),
	('20110106'),
	('20110107Y'),
	('20110108');

SET NOCOUNT OFF;

SELECT isitdate
FROM Sales.Somedates;

-- solution

SELECT 
	isitdate,
	CASE WHEN ISDATE(isitdate) = 1 THEN CONVERT(DATE, isitdate) ELSE NULL END AS converteddate
FROM Sales.Somedates;

-- Alternate solution using TRY_CONVERT
SELECT 
	isitdate,
	TRY_CONVERT(DATE, isitdate) AS converteddate
FROM Sales.Somedates;

-- drop a table 

DROP TABLE Sales.Somedates;