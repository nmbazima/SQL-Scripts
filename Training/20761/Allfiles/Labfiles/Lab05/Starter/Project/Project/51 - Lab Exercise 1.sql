---------------------------------------------------------------------
-- LAB 05
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Write a SELECT statement that will return the custid, companyname, contactname, address, city, country, and phone columns from the Sales.Customers table. 
-- Filter the results to include only the customers from the country Brazil.
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 52 - Lab Exercise  Task 1 Result.txt.
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 2
-- 
-- Write a SELECT statement that will return the custid, companyname, contactname, address, city, country, and phone columns from the Sales.Customers table. 
-- Filter the results to include only customers from the countries Brazil, UK, and USA.
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 53 - Lab Exercise 1 - Task 2 Result.txt.
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 3
-- 
-- Write a SELECT statement that will return the custid, companyname, contactname, address, city, country, and phone columns from the Sales.Customers table. 
-- Filter the results to include only the customers with a contact name starting with the letter A.
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 54 - Lab Exercise 1 - Task 3 Result.txt.
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 4a
-- 
-- The IT department has written a T-SQL statement that retrieves the custid and companyname columns from the Sales.Customers table and the orderid column from the Sales.Orders table.
--
-- Execute the query. Notice two things: 
--  First, the query retrieves all the rows from the Sales.Customers table. 
--  Second, there is a comparison operator in the ON clause specifying that the city column should be equal to the value “Paris”.
---------------------------------------------------------------------

SELECT
	c.custid, c.companyname, o.orderid
FROM Sales.Customers AS c
LEFT OUTER JOIN Sales.Orders AS o ON c.custid = o.custid AND c.city = N'Paris';

---------------------------------------------------------------------
-- Task 4b
-- 
-- Copy the provided T-SQL statement and modify it to have a comparison operator for the city column in the WHERE clause. Execute the query. 
-- 
-- Compare the results that you got with the desired results shown in the file 55 - Lab Exercise 1 - Task 4 Result.txt. 
--
-- Is the result the same as in the first T-SQL statement? Why? What is the difference between specifying the predicate in the ON clause and in the WHERE clause?
---------------------------------------------------------------------




---------------------------------------------------------------------
-- Task 5
-- 
-- Write a T-SQL statement to retrieve customers from the Sales.Customers table that do not have matching orders in the Sales.Orders table. 
-- Matching customers with orders is based on a comparison between the customer’s custid value and the order’s custid value. 
-- Retrieve the custid and companyname columns from the Sales.Customers table. 
-- (Hint: Use a T-SQL statement that is similar to the one in the previous task.)
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 56 - Lab Exercise 1 - Task 5 Result.txt.
---------------------------------------------------------------------

