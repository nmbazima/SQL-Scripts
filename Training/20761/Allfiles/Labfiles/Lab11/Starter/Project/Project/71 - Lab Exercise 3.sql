---------------------------------------------------------------------
-- LAB 11
--
-- Exercise 3
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Write a SELECT statement like that in exercise 2, task 1, but use a CTE instead of a derived table. Use inline column aliasing in the CTE query and name the CTE ProductBeverages.
--
-- Execute the T-SQL code and compare the results that you got with the recommended result shown in the file 72 - Lab Exercise 3 - Task 1 Result.txt. 
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 2
-- 
-- Write a SELECT statement against Sales.OrderValues to retrieve each customer’s ID and total sales amount for the year 2008. Define a CTE named c2008 based on this query using the external aliasing form to name the CTE columns custid and salesamt2008. Join the Sales.Customers table and the c2008 CTE, returning the custid and contactname columns from the Sales.Customers table and the salesamt2008 column from the c2008 CTE.
--
-- Execute the T-SQL code and compare the results that you got with the recommended result shown in the file 73 - Lab Exercise 3 - Task 2 Result.txt. 
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 3
-- 
-- Write a SELECT statement to retrieve the custid and contactname columns from the Sales.Customers table. Also retrieve the following calculated columns:
--  salesamt2008, representing the total sales amount for the year 2008
--  salesamt2007, representing the total sales amount for the year 2007 
--  percentgrowth, representing the percentage of sales growth between the year 2007 and 2008 
-- If percentgrowth is NULL, then display the value 0.
--
-- You can use the CTE from the previous task and add another CTE for the year 2007. Then join both of them with the Sales.Customers table. Order the result by the percentgrowth column.
--
-- Execute the T-SQL code and compare the results that you got with the recommended result shown in the file 74 - Lab Exercise 3 - Task 3 Result.txt.
---------------------------------------------------------------------

