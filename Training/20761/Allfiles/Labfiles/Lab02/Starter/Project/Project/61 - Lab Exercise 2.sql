---------------------------------------------------------------------
-- Module 02
--
-- Exercise 2
---------------------------------------------------------------------

--USE TSQL;
--GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Close all open script files.
-- Open the T-SQL script 61 - Lab Exercise 2.sql. Execute the whole script.
-- You get an error. What is the error message? Why do you think you got this error? 
---------------------------------------------------------------------

SELECT  firstname
		,lastname
		,city
		,country
FROM	HR.Employees
WHERE	country = 'USA';

---------------------------------------------------------------------
-- Task 2
-- 
-- Apply the needed changes to the script so that it will run without 
-- an error. (Hint: The SELECT statement is not the problem. Look at 
-- what is selected in the Available Databases box.) Test the changes 
-- by executing the whole script.
-- Observe the result. Notice that the result has fewer rows than the 
-- result in exercise 1, task 2.
---------------------------------------------------------------------




---------------------------------------------------------------------
-- Task 3
-- 
-- As you learned in Module 2, comments in T-SQL scripts can be written 
-- inside the line by specifying --. The text after the two hyphens will
-- be ignored by SQL Server. You can also specify a comment as a block 
-- starting with /* and ending with */. The text in between is treated as 
-- a block comment and is ignored by SQL Server.   
--
-- Uncomment the USE TSQL; statement.
--
-- Save and close the T-SQL script. Open the T-SQL script 61 - Lab Exercise 2.sql
-- again. Execute the whole script. Why did the script execute with no errors?
--
-- Observe the result and notice the database context in the Available Databases box. 
---------------------------------------------------------------------
