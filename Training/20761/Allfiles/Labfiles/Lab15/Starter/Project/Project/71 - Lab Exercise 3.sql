---------------------------------------------------------------------
-- LAB 15
--
-- Exercise 3
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Write an EXECUTE statement to invoke the sys.sp_help stored procedure without a parameter.
--
-- Execute the T-SQL statement and compare the results that you got with the recommended result shown in the file 72 - Lab Exercise 3 - Task 1_1 Result.txt.
--
-- Write an EXECUTE statement to invoke the sys.sp_help stored procedure for a specific table by passing the parameter Sales.Customers.
--
-- Execute the T-SQL statement and compare the results that you got with the recommended result shown in the file 73 - Lab Exercise 3 - Task 1_2 Result.txt.
---------------------------------------------------------------------




---------------------------------------------------------------------
-- Task 2
-- 
-- Write an EXECUTE statement to invoke the sys.sp_helptext stored procedure, passing the Sales.GetTopCustomers stored procedure as a parameter.
--
-- Execute the T-SQL statement and compare the results that you got with the recommended result shown in the file 74 - Lab Exercise 3 - Task 2 Result.txt. 
---------------------------------------------------------------------




---------------------------------------------------------------------
-- Task 3
-- 
-- Write an EXECUTE statement to invoke the sys.sp_columns stored procedure for the table Sales.Customers. You will have to pass two parameters: @table_name and @table_owner. 
--
-- Execute the T-SQL statement and compare the results that you got with the recommended result shown in the file 75 - Lab Exercise 3 - Task 3 Result.txt.
---------------------------------------------------------------------




---------------------------------------------------------------------
-- Task 4
-- 
-- Execute the provided T-SQL statement to remove the Sales.GetTopCustomers stored procedure.
---------------------------------------------------------------------

DROP PROCEDURE Sales.GetTopCustomers;