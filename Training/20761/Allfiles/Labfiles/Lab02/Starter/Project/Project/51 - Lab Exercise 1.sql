---------------------------------------------------------------------
-- Module 02
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Using SQL Server Management Studio (SSMS), connect to MIA-SQL using 
-- Windows authentication.
--
-- Open the  T-SQL script 51 - Lab Exercise 1.sql.
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 2
-- 
-- Execute the script by clicking Execute on the toolbar (or press F5 on the keyboard). 
-- This will execute the whole script.
--
-- Observe the result and the database context. 
--
-- Which database is selected in the Available Databases box?
---------------------------------------------------------------------

SELECT  firstname
		,lastname
		,city
		,country
FROM HR.Employees;

---------------------------------------------------------------------
-- Task 3
-- 
-- Highlight the SELECT statement in the T-SQL script under the task 2 
-- description and click Execute.
--
-- Observe the result. You should get the same result as in task 2. 
--
-- Tip: One way to highlight a portion of code is to hold down the Alt
-- key while drawing a rectangle around it with your mouse. The code inside 
-- the drawn rectangle will be selected. Try it.
---------------------------------------------------------------------
