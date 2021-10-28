---------------------------------------------------------------------
-- LAB 06
--
-- Exercise 4
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Write a SELECT statement to retrieve the contactname column from the Sales.Customers table. Based on this column, add a calculated column named lastname, which should consist of all the characters before the comma.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 82 - Lab Exercise 4 - Task 1 Result.txt. 
---------------------------------------------------------------------




---------------------------------------------------------------------
-- Task 2
-- 
-- Write a SELECT statement to retrieve the contactname column from the Sales.Customers table and replace the comma in the contact name with an empty string. Based on this column, add a calculated column named firstname, which should consist of all the characters after the comma.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 83 - Lab Exercise 4 - Task 2 Result.txt. 
---------------------------------------------------------------------


---------------------------------------------------------------------
-- Task 3
-- 
-- Write a SELECT statement to retrieve the custid column from the Sales.Customers table. Add a new calculated column to create a string representation of the custid as a fixed-width (6 characters) customer code prefixed with the letter C and leading zeros. For example, the custid value 1 should look like C00001.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 84 - Lab Exercise 4 - Task 3 Result.txt. 
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 4
--
-- Write a SELECT statement to retrieve the contactname column from the Sales.Customers table. Add a calculated column, which should count the number of occurrences of the character ‘a’ inside the contact name. (Hint: Use the string functions REPLACE and LEN.) Order the result from rows with the highest occurrences to lowest.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 85 - Lab Exercise 4 - Task 4 Result.txt. 
---------------------------------------------------------------------
