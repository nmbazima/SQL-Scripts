---------------------------------------------------------------------
-- LAB 08
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Write a SELECT statement against the Production.Products table to retrieve a calculated column named productdesc. The calculated column should be based on the columns productname and unitprice and look like this:
--  The unit price for the Product HHYDP is 18.00 $.
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 52 - Lab Exercise 1 - Task 1 Result.txt. 
--
-- Did you use the CAST or the CONVERT function? Which one do you think is more appropriate to use?
---------------------------------------------------------------------


---------------------------------------------------------------------
-- Task 2
-- 
-- The US marketing department has supplied you with a start date 4/1/2007 (using US English form, read as April 1, 2007) and an end date 11/30/2007 (using US English form, read as November 30, 2007). Write a SELECT statement against the Sales.Orders table to retrieve the orderid, orderdate, shippeddate, and shipregion columns. Filter the result to include only rows with the order date between the specified start date and end date and have more than 30 days between the shipped date and order date. Also check the shipregion column for missing values. If there is a missing value, then return the value ‘No region’.
--
-- In this SELECT statement, you can use the CONVERT function with a style parameter or the new PARSE function.
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 53 - Lab Exercise 1 - Task 2 Result.txt. 
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 3
-- 
-- The IT department would like to convert all the information about phone numbers in the Sales.Customers table to integer values. The IT staff indicated that all hyphens, parentheses, and spaces have to be removed before the conversion to an integer data type. 
--
-- Write a SELECT statement to implement the requirement of the IT department. Replace all the specified characters in the phone column of the Sales.Customers table and then convert the column from the nvarchar datatype to the int datatype. The T-SQL statement must not fail if there is a conversion error, but rather it should return a NULL. (Hint: First try writing a T-SQL statement using the CONVERT function and then use the new functionality in SQL Server 2012). Use the alias phoneasint for this calculated column.
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 54 - Lab Exercise 3 - Task 3 Result.txt. 
---------------------------------------------------------------------


