---------------------------------------------------------------------
-- LAB 16
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------
DECLARE 
	@i int = 8,
	@result nvarchar(20);

IF @i < 5
	SET @result = N'Less than 5'
ELSE IF @i <= 10
	SET @result = N'Between 5 and 10'
ELSE if @i > 10
	SET @result = N'More than 10'
ELSE
	SET @result = N'Unknown';

SELECT @result AS result;

GO

DECLARE 
	@i int = 8,
	@result nvarchar(20);

SET @result = 
		CASE 
		WHEN @i < 5 THEN
			N'Less than 5'
		WHEN @i <= 10 THEN
			N'Between 5 and 10'
		WHEN @i > 10 THEN
			N'More than 10'
		ELSE
			N'Unknown'
		END;

SELECT @result AS result;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

DECLARE 
	@birthdate date,
	@cmpdate date;

SET @birthdate = (SELECT birthdate FROM HR.Employees WHERE empid = 5);
SET @cmpdate = '19700101';

IF @birthdate < @cmpdate
	PRINT 'The person selected was born before January 1, 1970';
ELSE
	PRINT 'The person selected was born on or after January 1, 1970';

GO
---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------
CREATE PROCEDURE Sales.CheckPersonBirthDate 
	@empid int,
	@cmpdate date
AS

DECLARE 
	@birthdate date;

SET @birthdate = (SELECT birthdate FROM HR.Employees WHERE empid = @empid);

IF @birthdate < @cmpdate
	PRINT 'The person selected was born before ' + FORMAT(@cmpdate, 'MMMM d, yyyy', 'en-US');
ELSE
	PRINT 'The person selected was born on or after ' + FORMAT(@cmpdate, 'MMMM d, yyyy', 'en-US');


GO

EXECUTE Sales.CheckPersonBirthDate @empid = 3, @cmpdate = '19900101';
GO

---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

DECLARE @i int = 1;

WHILE @i <= 10
BEGIN
	PRINT @i;
	SET @i = @i + 1;
END;

---------------------------------------------------------------------
-- Task 5
---------------------------------------------------------------------

DROP PROCEDURE Sales.CheckPersonBirthDate;

