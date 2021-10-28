--10776A Module 2 Demonstration 3A: Converting Data Types

-- Step 1: Open a new query window to the tempdb database

USE tempdb;
GO

-- Step 2: Execute statements to see different formats
--         of a date conversion
 
SELECT CAST(SYSDATETIME() as varchar(20)) as CastDate,
		   CONVERT(varchar(20), SYSDATETIME(), 110) as USA,
		   CONVERT(varchar(20), SYSDATETIME(), 104) as German,
		   CONVERT(varchar(20), SYSDATETIME(), 105) as Italian,
		   CONVERT(varchar(20), SYSDATETIME(), 112) as ISO,
		   CONVERT(varchar(20), SYSDATETIME(), 114) as [Time];
GO

-- Step 3: Execute queries to see how language settings affect date conversions

CREATE TABLE dbo.TestDate
(
  id int NOT NULL IDENTITY,
  BirthDate date
);

SET LANGUAGE US_ENGLISH;
INSERT INTO dbo.TestDate (BirthDate)
VALUES('1.2.1972'), (CAST ('1.2.1972' as DATE));	

SET LANGUAGE GERMAN;
INSERT INTO dbo.TestDate (BirthDate)
VALUES('1.2.1972'),(CAST ('1.2.1972' as DATE));

SELECT *, MONTH(BirthDate) AS [Month] FROM dbo.TestDate;
GO

-- Step 4: Execute alternate queries that are independent of settings

TRUNCATE TABLE dbo.TestDate;

SET LANGUAGE US_ENGLISH;
INSERT INTO dbo.TestDate (BirthDate)
VALUES('19720201'), (CONVERT (DATE,'1.2.1972', 104));	

SET LANGUAGE GERMAN;
INSERT INTO dbo.TestDate (BirthDate)
VALUES('19720201'),(CONVERT (DATE,'1.2.1972' ,104));

SELECT *, MONTH(BirthDate) AS [Month] FROM dbo.TestDate;
GO

-- Step 5: Execute a query that truncates a string during conversion.

SELECT CAST('This is a long character string.' as VARCHAR(12));
GO

-- Step 6: Before executing the following batch, calculate
--         what the output should be. Then execute the batch
--         to confirm the output.

DECLARE @int1 int = 1;
DECLARE @int2 int = 2;
DECLARE @char char(1) = 3;
DECLARE @numeric numeric(18,2) = 1.0;

SELECT @int1/@int2;
SELECT @numeric/@int2;
SELECT @int2 * @char;
SELECT @char / @int2;
GO

-- Step 7: Execute a TRY_PARSE statement

SELECT 
  CASE WHEN TRY_PARSE('NotLikely' AS decimal USING 'sr-Latn-CS') IS NULL 
       THEN 'Not Decimal' 
       ELSE 'Decimal' 
  END AS Result ;
