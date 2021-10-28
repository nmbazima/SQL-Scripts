---------------------------------------------------------------------
-- Module 02
--
-- Exercise 3
---------------------------------------------------------------------

--USE TSQL;
--GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Observe the results. Why is the result window empty?
---------------------------------------------------------------------

/*
SELECT	firstname
		,lastname
		,city
		,country
FROM	HR.Employees
WHERE	country = 'USA'
ORDER BY lastname;
*/

---------------------------------------------------------------------
-- Task 2
-- 
-- Observe that before the USE statement there are the characters 
-- which means that the USE statement is treated as a comment. There 
-- is also a block comment around the whole T-SQL SELECT statement. 
--
-- Uncomment both statements.
--
-- First execute the USE statement and then execute the statement 
-- starting with the SELECT clause. Observe the results. Notice that 
-- the results have the same rows as in exercise 1, task 2, but they
-- are sorted by the lastname column. 
---------------------------------------------------------------------
