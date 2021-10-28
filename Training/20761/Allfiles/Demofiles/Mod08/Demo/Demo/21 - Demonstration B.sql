-- Demonstration B
-- Step 1: Open a new query window to the TSQL database
USE TSQL;
GO
-- Step 2: Select and execute the following query to illustrate
-- the CAST function
-- This will succeed
SELECT CAST(SYSDATETIME() AS DATE);

-- Step 3: Select and execute the following query to illustrate
-- the CAST function
-- THIS WILL FAIL
SELECT CAST(SYSDATETIME() AS INT);

-- Step 4a: Select and execute the following query to illustrate
-- the CONVERT function
-- This will succeed at converting datetime2 to date
SELECT CONVERT(DATE, SYSDATETIME());

-- Step 4b:
-- THIS WILL FAIL at converting datetime2 to int
SELECT CONVERT(INT, SYSDATETIME());

-- Step 5: Select and execute the following query to illustrate
-- CONVERT with datetime data and a style option
SELECT  CONVERT(datetime, '20120212', 102) AS ANSI_style ;
SELECT CONVERT(CHAR(8), CURRENT_TIMESTAMP,112) AS ISO_style;

-- Step 6: Select and execute the following query to illustrate
-- PARSE converting a string date to a US-style date
SELECT PARSE('01/02/2012' AS datetime2 USING 'en-US') AS parse_result; 

-- Step 7: Select and execute the following query to illustrate
-- PARSE converting a string date to a UK-style date
SELECT PARSE('01/02/2012' AS datetime2 USING 'en-GB') AS parse_result; 

-- Step 8a: Select and execute the following query to illustrate
-- TRY_PARSE compared to PARSE
-- THIS WILL FAIL
SELECT PARSE('SQLServer' AS datetime2 USING 'en-US') AS parse_result;

-- Step 8b:
-- This will succeed
SELECT TRY_PARSE('SQLServer' AS datetime2 USING 'en-US') AS try_parse_result;
