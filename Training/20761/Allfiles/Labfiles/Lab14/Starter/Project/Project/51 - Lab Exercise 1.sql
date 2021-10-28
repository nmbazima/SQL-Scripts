---------------------------------------------------------------------
-- LAB 14
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- The IT department has provided you with T-SQL code to generate a view named Sales.CustGroups, which contains three pieces of information about customers: their IDs, the countries in which they are located, and the customer group in which they have been placed. Customers are placed into one of three predefined customers groups (A, B, or C).
--
-- Execute the provided T-SQL code.
--
-- Write a SELECT statement that will return the custid, custgroup, and country columns from the newly created Sales.CustGroups view. 
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 52 - Lab Exercise 1 - Task 1_1 Result.txt.
--
-- Modify the SELECT statement. Begin by retrieving the column country. Then use the PIVOT operator to retrieve three columns based on the possible values of the custgroup column (values A, B, and C), showing the number of customers in each group.
--
-- Execute the modified statement and compare the results that you got with the desired results shown in the file 53 - Lab Exercise 1 - Task 1_2 Result.txt.
---------------------------------------------------------------------
CREATE VIEW Sales.CustGroups AS
SELECT 
	custid,
	CHOOSE(custid % 3 + 1, N'A', N'B', N'C') AS custgroup,
	country
FROM Sales.Customers;

GO



---------------------------------------------------------------------
-- Task 2
-- 
-- The IT department has provided T-SQL code to add two new columns—city and contactname—to the Sales.CustGroups view. Execute the provided T-SQL code.
--
-- Copy the last SELECT statement in task 1 and execute it. 
--
-- Is this result the same as the result from the query in task 1? Is the number of rows retrieved the same? 
--
-- To better understand the reason for the different results, modify the copied SELECT statement to include the new city and contactname columns.
--
-- Execute the modified statement and compare the results that you got with the desired results shown in the file 54 - Lab Exercise 1 - Task 2 Result.txt. 
--
-- Notice that this query returned the same number of rows as the previous SELECT statement. Why did you get the same result with and without specifying the grouping columns for the PIVOT operator?
---------------------------------------------------------------------

ALTER VIEW Sales.CustGroups AS
SELECT 
	custid,
	CHOOSE(custid % 3 + 1, N'A', N'B', N'C') AS custgroup,
	country,
	city,
	contactname
FROM Sales.Customers;

GO



---------------------------------------------------------------------
-- Task 3
-- 
-- Define a CTE named PivotCustGroups based on a query that retrieves the custid, country, and custgroup columns from the Sales.CustGroups view. Write a SELECT statement against the CTE, using a PIVOT operator to retrieve the same result as in task 1. 
--
-- Execute the written T-SQL code and compare the results that you got with the desired results shown in the file 55 - Lab Exercise 1 - Task 3 Result.txt.
--
-- Is this result the same as the one returned by the last query in task 1? Can you explain why?
--
-- Why do you think it is beneficial to use the CTE when using the PIVOT operator?
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 4
-- 
-- For each customer, write a SELECT statement to retrieve the total sales amount for each product category. Display each product category as a separate column. Here is how to accomplish this task:
--  Create a CTE named SalesByCategory to retrieve the custid column from the Sales.Orders table as a calculated column based on the qty and unitprice columns and the categoryname column from the table Production.Categories. Filter the result to include only orders in the year 2008.
--  You will need to JOIN tables Sales.Orders, Sales.OrderDetails, Production.Products and Production.Categories.
--  Write a SELECT statement against the CTE that returns a row for each customer (custid) and a column for each product category, with the total sales amount for the current customer and product category. 
--  Display the following product categories: Beverages, Condiments, Confections, [Dairy Products], [Grains/Cereals], [Meat/Poultry], Produce, and Seafood..
--
-- Execute the complete T-SQL code (the CTE and the SELECT statement).
--
-- Observe and compare the results that you got with the desired results shown in the file 56 - Lab Exercise 1 - Task 4 Result.txt. 
---------------------------------------------------------------------

