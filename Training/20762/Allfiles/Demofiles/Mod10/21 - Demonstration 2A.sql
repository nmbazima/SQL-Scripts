-- Demonstration 2A

-- Step A. Use the tempdb database

USE tempdb;
GO

-- Step B. Create a function that calculates the end date of the previous month

CREATE FUNCTION dbo.EndOfPreviousMonth (@DateToTest date)
RETURNS date
AS BEGIN
  RETURN DATEADD(day, 0 - DAY(@DateToTest), @DateToTest);
END;
GO

-- Step C. Query the function
--         The first query will return the date of the last day of the previous month returned by the current date function
--         The second query will return the date of the last day of the previous month based on the specified date

SELECT dbo.EndOfPreviousMonth(SYSDATETIME());
SELECT dbo.EndOfPreviousMonth('2017-06-01');
GO

-- Step D. Determine if the function is deterministic
--         The function is not deterministic

SELECT OBJECTPROPERTY(OBJECT_ID('dbo.EndOfPreviousMonth'),'IsDeterministic');
GO

 -- Step E. Drop the function

DROP FUNCTION dbo.EndOfPreviousMonth;
GO

-- Step F. Student Exercise
--         SQL Server includes the EOMONTH ( start_date [, month_to_add ] ) function
--         This function returns the last day of the specified start_date
--         Please modify the code above to create a dbo.EndOfPreviousMonth function that uses the EOMONTH function
--         Enter your code after this this comment and before the next comment:

-- Step G. Query the new function
--         The first query will return the date of the last day of the previous month returned by the current date function
--         The second query will return the date of the last day of the previous month based on the specified date

SELECT dbo.EndOfPreviousMonth(SYSDATETIME());
SELECT dbo.EndOfPreviousMonth('2018-03-01');
GO

-- Step H. Drop the function

DROP FUNCTION dbo.EndOfPreviousMonth;
GO