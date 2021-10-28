---------------------------------------------------------------------
-- LAB 12
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Write a SELECT statement to retrieve the productid and productname columns from the Production.Products table. In addition, for each product, retrieve the last two rows from the Sales.OrderDetails table based on orderid number.
--
-- Use the CROSS APPLY operator and a correlated subquery. Order the result by the column productid.
--
-- Execute the written statement and compare the results that you got with the desired results shown in the file 62 - Lab Exercise 2 - Task 1 Result.txt.
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 2
-- 
-- Execute the provided T-SQL code to create the inline table-valued function fnGetTop3ProductsForCustomer, as you did in the previous module:
--
-- Write a SELECT statement to retrieve the custid and contactname columns from the Sales.Customers table. Use the CROSS APPLY operator with the dbo.fnGetTop3ProductsForCustomer function to retrieve productid, productname, and totalsalesamount columns for each customer.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 63 - Lab Exercise 2 - Task 2 Result.txt. Remember the number of rows in the result.
---------------------------------------------------------------------
IF OBJECT_ID('dbo.fnGetTop3ProductsForCustomer') IS NOT NULL
	DROP FUNCTION dbo.fnGetTop3ProductsForCustomer;

GO

CREATE FUNCTION dbo.fnGetTop3ProductsForCustomer
(@custid AS INT) RETURNS TABLE
AS
RETURN
SELECT TOP(3)
	d.productid, 
	MAX(p.productname) AS productname, 
	SUM(d.qty * d.unitprice) AS totalsalesamount	
FROM Sales.Orders AS o
INNER JOIN Sales.OrderDetails AS d ON d.orderid = o.orderid
INNER JOIN Production.Products AS p ON p.productid = d.productid
WHERE custid = @custid
GROUP BY d.productid
ORDER BY totalsalesamount DESC;

GO


---------------------------------------------------------------------
-- Task 3
-- 
-- Copy the T-SQL statement from the previous task and modify it by replacing the CROSS APPLY operator with the OUTER APPLY operator.
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 64 - Lab Exercise 2 - Task 3 Result.txt. Notice that you got more rows than in the previous task.
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 4
--
-- Copy the T-SQL statement from the previous task and modify it by filtering the results to show only customers without products. (Hint: In a WHERE clause, look for any column returned by the inline table-valued function that is NULL.) 
--
-- Execute the written statement and compare the results that you got with the recommended result shown in the file 65 - Lab Exercise 2 - Task 4 Result.txt. 
--
-- What is the difference between the CROSS APPLY and OUTER APPLY operators?
---------------------------------------------------------------------



---------------------------------------------------------------------
-- Task 5
-- 
-- Remove the created inline table-valued function by executing the provided T-SQL code:
--
-- Execute this code exactly as written inside a query window.
---------------------------------------------------------------------

IF OBJECT_ID('dbo.fnGetTop3ProductsForCustomer') IS NOT NULL
	DROP FUNCTION dbo.fnGetTop3ProductsForCustomer;


