---------------------------------------------------------------------
-- LAB 15
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Execute the provided T-SQL code to modify the Sales.GetTopCustomers stored procedure to include a parameter for order year (@orderyear).
--
-- Write an EXECUTE statement to invoke the Sales.GetTopCustomers stored procedure for the year 2007.
--
-- Execute the T-SQL statement and compare the results that you got with the desired results shown in the file 62 - Lab Exercise 2 - Task 1_1 Result.txt.
--
-- Write an EXECUTE statement to invoke the Sales.GetTopCustomers stored procedure for the year 2008.
--
-- Execute the T-SQL statement and compare the results that you got with the desired results shown in the file 63 - Lab Exercise 2 - Task 1_2 Result.txt.
--
-- Write an EXECUTE statement to invoke the Sales.GetTopCustomers stored procedure without a parameter. 
--
-- Execute the T-SQL statement. What happened? What is the error message?
--
-- If an application was designed to use the exercise 1 version of the stored procedure, would the modification made to the stored procedure in this exercise impact the usability of that application? Please explain.
---------------------------------------------------------------------

ALTER PROCEDURE Sales.GetTopCustomers 
	@orderyear int
AS
SELECT
	c.custid,
	c.contactname,
	SUM(o.val) AS salesvalue
FROM Sales.OrderValues AS o
INNER JOIN Sales.Customers AS c ON c.custid = o.custid
WHERE YEAR(o.orderdate) = @orderyear
GROUP BY c.custid, c.contactname
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

GO



---------------------------------------------------------------------
-- Task 2
-- 
-- Execute the provided T-SQL code to modify the Sales.GetTopCustomers stored procedure:
--
-- Write an EXECUTE statement to invoke the Sales.GetTopCustomers stored procedure without a parameter. 
--
-- Execute the T-SQL statement and compare the results that you got with the recommended result shown in the file 64 - Lab Exercise 2 - Task 2 Result.txt. 
--
-- If an application was designed to use the exercise 1 version of the stored procedure, would the change made to the stored procedure in this task impact the usability of that application? How does this change influence the design of future applications?
---------------------------------------------------------------------

ALTER PROCEDURE Sales.GetTopCustomers 
	@orderyear int = NULL
AS
SELECT
	c.custid,
	c.contactname,
	SUM(o.val) AS salesvalue
FROM Sales.OrderValues AS o
INNER JOIN Sales.Customers AS c ON c.custid = o.custid
WHERE YEAR(o.orderdate) = @orderyear OR @orderyear IS NULL
GROUP BY c.custid, c.contactname
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

GO




---------------------------------------------------------------------
-- Task 3
-- 
-- Execute the provided T-SQL code to add the parameter @n to the Sales.GetTopCustomers stored procedure. You use this parameter to specify how many customers you want retrieved. The default value is 10.
--
-- Write an EXECUTE statement to invoke the Sales.GetTopCustomers stored procedure without any parameters.
--
-- Execute the T-SQL statement and compare the results that you got with the recommended result shown in the file 65 - Lab Exercise 2 - Task 3_1 Result.txt.
--
-- Write an EXECUTE statement to invoke the Sales.GetTopCustomers stored procedure for order year 2008 and five customers.
--
-- Execute the T-SQL statement and compare the results that you got with the recommended result shown in the file 66 - Lab Exercise 2 - Task 3_2 Result.txt. 
--
-- Write an EXECUTE statement to invoke the Sales.GetTopCustomers stored procedure for the order year 2007.
--
-- Execute the T-SQL statement and compare the results that you got with the recommended result shown in the file 67 - Lab Exercise 2 - Task 3_3 Result.txt.
--
-- Write an EXECUTE statement to invoke the Sales.GetTopCustomers stored procedure to retrieve 20 customers.
--
-- Execute the T-SQL statement and compare the results that you got with the recommended result shown in the file 68 - Lab Exercise 2 - Task 3_4 Result.txt.
--
-- Do the applications using the stored procedure need to be changed because another parameter was added?
---------------------------------------------------------------------

ALTER PROCEDURE Sales.GetTopCustomers 
	@orderyear int = NULL,
	@n int = 10
AS
SELECT
	c.custid,
	c.contactname,
	SUM(o.val) AS salesvalue
FROM Sales.OrderValues AS o
INNER JOIN Sales.Customers AS c ON c.custid = o.custid
WHERE YEAR(o.orderdate) = @orderyear OR @orderyear IS NULL
GROUP BY c.custid, c.contactname
ORDER BY salesvalue DESC
OFFSET 0 ROWS FETCH NEXT @n ROWS ONLY;

GO


---------------------------------------------------------------------
-- Task 4
-- 
-- Execute the provided T-SQL code to modify the Sales.GetTopCustomers stored procedure to return the customer contact name based on a specified position in a ranking of total sales, which is provided by the parameter @customerpos. The procedure also includes a new parameter named @customername, which has an output option.
--
-- The IT department also supplied you with T-SQL code to declare the new variable @outcustomername. You will use this variable as an output parameter for the stored procedure.
--  DECLARE @outcustomername nvarchar(30);
--
-- Write an EXECUTE statement to invoke the Sales.GetTopCustomers stored procedure and retrieve the first customer. 
--
-- Write a SELECT statement to retrieve the value of the output parameter @outcustomername. 
--
-- Execute the batch of T-SQL code consisting of the provided DECLARE statement, the written EXECUTE statement, and the written SELECT statement.
--
-- Observe and compare the results that you got with the recommended result shown in the file 69 - Lab Exercise 2 - Task 4 Result.txt.
---------------------------------------------------------------------

ALTER PROCEDURE Sales.GetTopCustomers 
	@customerpos int = 1,
	@customername nvarchar(30) OUTPUT
AS
SET @customername = (
	SELECT
		c.contactname
	FROM Sales.OrderValues AS o
	INNER JOIN Sales.Customers AS c ON c.custid = o.custid
	GROUP BY c.custid, c.contactname
	ORDER BY SUM(o.val) DESC
	OFFSET @customerpos - 1 ROWS FETCH NEXT 1 ROW ONLY
);

GO

DECLARE @outcustomername nvarchar(30);


