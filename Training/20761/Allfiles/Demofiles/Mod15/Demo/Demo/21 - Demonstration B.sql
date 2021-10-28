-- Demonstration B

-- Step 1: Open a new query window to the TSQL database
USE TSQL;
GO


--Step 2: Discovering Parameter definitions
--Demonstrate using SSMS to learn about stored procedure parameter definitions
/*
1) Connect to instance using Object Browser
2) Expand Databases folder
3) Expand user database
4) Expand Programmability folder
5) Expand Stored Procedures folder
6) Expand desired procedure
7) Expand Parameters folder
8) Point out list of parameters, data type and direction
*/


-- Step 3: Discover parameters by querying system catalog
DECLARE @proc AS NVARCHAR(255)= N'<put schema and procedure name here>';
SELECT SCHEMA_NAME(schema_id) AS schema_name
    ,o.name AS object_name
    ,o.type_desc
    ,p.parameter_id
    ,p.name AS parameter_name
    ,TYPE_NAME(p.user_type_id) AS parameter_type
    ,p.max_length
    ,p.precision
    ,p.scale
    ,p.is_output
FROM sys.objects AS o
INNER JOIN sys.parameters AS p ON o.object_id = p.object_id
WHERE o.object_id = OBJECT_ID(@proc)
ORDER BY schema_name, object_name, p.parameter_id;
GO


-- Step 4: Clean up if the procedure already exists
IF OBJECT_ID('Production.ProductsbySuppliers','P') IS NOT NULL
	DROP PROC Production.ProductsbySuppliers;
GO


-- Step 5: Create a procedure which accepts a parameter 
-- to search for products by supplierid
CREATE PROCEDURE Production.ProductsbySuppliers
(@supplierid AS INT)
AS
SELECT  productid,
        productname,
        categoryid,
        unitprice,
        discontinued
FROM Production.Products
WHERE   supplierid = @supplierid
ORDER BY productid;
GO

EXEC Production.ProductsbySuppliers @supplierid = 5;


--Step 6: Working with OUTPUT parameters
USE TSQL;
GO


-- Step 7: Create simple proc which
-- returns rows via SELECT (no output parameter yet)
CREATE PROC Sales.GetCustPhone
(@custid AS INT)
AS
SELECT phone
FROM Sales.Customers
WHERE custid=@custid;
GO


-- Step 8: Test procedure
EXEC Sales.GetCustPhone @custid=5;
GO


-- Step 9: Modify procedure to use an output parameter
ALTER PROC Sales.GetCustPhone
(@custid AS INT,
 @phone AS nvarchar(24)OUTPUT)
AS
SELECT @phone = phone
FROM Sales.Customers
WHERE custid=@custid;
GO


-- Step 10: Test by declaring a variable to hold
-- the output value, executing the proc and display the value
DECLARE @customerid INT =5, @phonenum NVARCHAR(24);
EXEC Sales.GetCustPhone @custid=@customerid, @phone=@phonenum OUTPUT;
SELECT @customerid AS custid, @phonenum AS phone;


-- Step 11: Clean up
IF OBJECT_ID('Sales.GetCustPhone','P') IS NOT NULL DROP PROCEDURE Sales.GetCustPhone;
