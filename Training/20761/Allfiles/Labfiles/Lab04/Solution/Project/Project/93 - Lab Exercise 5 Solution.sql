---------------------------------------------------------------------
-- LAB 04
--
-- Exercise 5
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SET NOCOUNT ON;

IF OBJECT_ID('HR.Calendar') IS NOT NULL 
	DROP TABLE HR.Calendar;

CREATE TABLE HR.Calendar (
	calendardate DATE CONSTRAINT PK_Calendar PRIMARY KEY
);

DECLARE 
	@startdate DATE = DATEFROMPARTS(YEAR(SYSDATETIME()), 1, 1),
	@enddate DATE = DATEFROMPARTS(YEAR(SYSDATETIME()), 12, 31);

WHILE @startdate <= @enddate
BEGIN
	INSERT INTO HR.Calendar (calendardate)
	VALUES (@startdate);

	SET @startdate = DATEADD(DAY, 1, @startdate);
END;

SET NOCOUNT OFF;

-- observe the HR.Calendar table
SELECT 
	calendardate
FROM HR.Calendar;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT 
	e.empid, e.firstname, e.lastname, c.calendardate
FROM HR.Employees AS e
CROSS JOIN HR.Calendar AS c;

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

IF OBJECT_ID('HR.Calendar') IS NOT NULL 
	DROP TABLE HR.Calendar;
