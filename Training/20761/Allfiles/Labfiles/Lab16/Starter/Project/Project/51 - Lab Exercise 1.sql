---------------------------------------------------------------------
-- LAB 16
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Write T-SQL code that will create a variable called @num as an int data type. Set the value of the variable to 5 and display the value of the variable using the alias mynumber. Execute the T-SQL code.
--
-- Observe and compare the results that you got with the desired results shown in the file 52 - Lab Exercise 1 - Task 1_1 Result.txt. 
--
-- Write the batch delimiter GO after the written T-SQL code. In addition, write new T-SQL code that defines two variables, @num1 and @num2, both as an int data type. Set the values to 4 and 6, respectively. Write a SELECT statement to retrieve the sum of both variables using the alias totalnum. Execute the T-SQL code.
--
-- Observe and compare the results that you got with the desired results shown in the file 53 - Lab Exercise 1 - Task 1_2 Result.txt.
---------------------------------------------------------------------




---------------------------------------------------------------------
-- Task 2
-- 
-- Write T-SQL code that defines the variable @empname as an nvarchar(30) data type. 
--
-- Set the value by executing a SELECT statement against the HR.Employees table. Compute a value that concatenates the firstname and lastname column values. Add a space between the two column values and filter the result to return the employee whose empid value is equal to 1.
--
-- Return the @empname variable’s value using the alias employee.
--
-- Execute the T-SQL code.
--
-- Observe and compare the results that you got with the desired results shown in the file 54 - Lab Exercise 1 - Task 2Result.txt. 
--
-- What would happen if the SELECT statement would return more than one row?
---------------------------------------------------------------------




---------------------------------------------------------------------
-- Task 3
-- 
-- Copy the T-SQL code from task 2 and modify it by defining an additional variable named @empid with an int data type. Set the variable’s value to 5. In the WHERE clause, modify the SELECT statement to use the newly created variable as a value for the column empid.
--
-- Execute the modified T-SQL code.
--
-- Observe and compare the results that you got with the desired results shown in the file 55 - Lab Exercise 1 - Task 3 Result.txt. 
--
-- Change the @empid variable’s value from 5 to 2 and execute the modified T-SQL code to observe the changes.

---------------------------------------------------------------------




---------------------------------------------------------------------
-- Task 4
-- 
-- Copy the T-SQL code from task 3 and modify it by adding the batch delimiter GO before the statement:
--  SELECT @empname AS employee;
-- Execute the modified T-SQL code.
--
-- What happened? What is the error message? Can you explain why the batch delimiter caused an error?
---------------------------------------------------------------------
	

