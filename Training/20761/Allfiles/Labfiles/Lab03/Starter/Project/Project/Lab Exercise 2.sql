---------------------------------------------------------------------
-- LAB 03
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Write a SELECT statement against the Sales.Customers table showing only the country column.
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file Lab Exercise 2 - Task 1 Result.txt.
---------------------------------------------------------------------




---------------------------------------------------------------------
-- Task 2
-- 
-- Copy the SELECT statement in Task 1 and modify it to return only distinct values.
--
-- Execute the written statement and compare the results that you got with the desired results shown in file Lab Exercise 2 - Task 2 Result.txt.
--  How many rows did the query in Task 1 return?
--  How many rows did the query in Task 2 return?
---------------------------------------------------------------------






---------------------------------------------------------------------
-- Under which circumstances do the following queries against the Sales.Customers table return the same result?
--
-- Is the DISTINCT clause being applied to all columns specified in the query or just the first column?
---------------------------------------------------------------------

SELECT city, region 
FROM Sales.Customers;

SELECT DISTINCT city, region 
FROM Sales.Customers;
