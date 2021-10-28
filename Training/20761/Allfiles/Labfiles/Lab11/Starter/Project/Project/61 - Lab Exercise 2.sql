---------------------------------------------------------------------
-- LAB 11
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Write a SELECT statement against a derived table and retrieve the productid and productname columns. Filter the results to include only the rows in which the pricetype column value is equal to high. Use the SELECT statement from exercise 1, task 4 as the inner query that defines the derived table.  Do not forget to use an alias for the derived table. (You can use the alias p.)
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 62 - Lab Exercise 2 - Task 1 Result.txt.
---------------------------------------------------------------------


---------------------------------------------------------------------
-- Task 2
-- 
-- Write a SELECT statement to retrieve the custid column and two calculated columns: totalsalesamount, which returns the total sales amount per customer, and avgsalesamount, which returns the average sales amount of orders per customer. To correctly calculate the average sales amount of orders per customer, you will first have to calculate the total sales amount per order. You can do so by defining a derived table based on a query that joins the Sales.Orders and Sales.OrderDetails tables. You can use the custid and orderid columns from the Sales.Orders table and the qty and unitprice columns from the Sales.OrderDetails table.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 63 - Lab Exercise 2 - Task 2 Result.txt. 
---------------------------------------------------------------------


---------------------------------------------------------------------
-- Task 3
-- 
-- Write a SELECT statement to retrieve the following columns: 
--  orderyear, representing the year of the order date
--  curtotalsales, representing the total sales amount for the current order year
--  prevtotalsales, representing the total sales amount for the previous order year 
--  percentgrowth, representing the percentage of sales growth in the current order year compared to the previous order year 
-- You will have to write a T-SQL statement using two derived tables. To get the order year and total sales columns for each SELECT statement, you can query an already existing view named Sales.OrderValues. The val column represents the sales amount.
-- Do not forget that the order year 2006 does not have a previous order year in the database, but it should still be retrieved by the query.
--
-- Execute the T-SQL code and compare the results that you got with the recommended result shown in the file 64 - Lab Exercise 2 - Task 3 Result.txt.

---------------------------------------------------------------------
