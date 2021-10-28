---------------------------------------------------------------------
-- LAB 10
--
-- Exercise 3
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Write a SELECT statement to retrieve the custid and contactname columns from the Sales.Customers table. Add a calculated column named lastorderdate that contains the last order date from the Sales.Orders table for each customer. (Hint: You have to use a correlated subquery.)
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 72 - Lab Exercise 3 - Task 1 Result.txt. 
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 2
-- 
-- Write a SELECT statement to retrieve all customers that do not have any orders in the Sales.Orders table, similar to the request in exercise 2, task 3. However, this time use the EXISTS predicate to filter the results to include only those customers without an order. Also, you do not need to explicitly check that the custid column in the Sales.Orders table is not NULL.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 73 - Lab Exercise 3 - Task 2 Result.txt. 
--
-- Why didn’t you need to check for a NULL?
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 3
-- 
-- Write a SELECT statement to retrieve the custid and contactname columns from the Sales.Customers table. Filter the results to include only customers that placed an order on or after April 1, 2008, and ordered a product with a price higher than $100.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 74 - Lab Exercise 3 - Task 3 Result.txt.
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 4
-- 
-- Running aggregates are aggregates that accumulate values over time. Write a SELECT statement to retrieve the following information for each year:
--  The order year
--  The total sales amount
--  The running total sales amount over the years. That is, for each year, return the sum of sales amount up to that year. So, for example, for the earliest year (2006) return the total sales amount, for the next year (2007), return the sum of the total sales amount for the previous year and  the year 2007.
-- The SELECT statement should have three calculated columns:
--  orderyear, representing the order year. This column should be based on the orderyear column from the Sales.Orders table. 
--  totalsales, representing the total sales amount for each year. This column should be based on the qty and unitprice columns from the Sales.OrderDetails table.
--  runsales, representing the running sales amount. This column should use the correlated subquery. 
-- Execute the T-SQL code and compare the results that you got with the recommended result shown in the file 75 - Lab Exercise 3 - Task 4 Result.txt.
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 5
-- 
-- Delete the row added in exercise 2 using the provided SQL statement. Execute this query exactly as written inside a query window.
---------------------------------------------------------------------

DELETE Sales.Orders
WHERE custid IS NULL;


