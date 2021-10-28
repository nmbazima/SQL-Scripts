-- Demonstration A

-- Step 1: Open a new query window to the TSQL database
USE [TSQL]
GO

-- Step 2: create basic procedure with single input parameter
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

-- Step 3: Test procedure
EXEC Production.ProductsbySuppliers @supplierid = 1;
GO


-- Step 4: Modify it to take a parameter for rows returned.
-- Note that a maximum default value for @numrows is supplied
-- to avoid breaking existing applications that 
-- don't pass the @numrows parameter
ALTER PROCEDURE Production.ProductsbySuppliers
(@supplierid AS INT, @numrows AS BIGINT = 9223372036854775807) --largest possible value for a bigint (9,223,372,036,854,775,807)
AS
SELECT  TOP (@numrows) productid,
        productname,
        categoryid,
        unitprice,
        discontinued
FROM Production.Products
WHERE   supplierid = @supplierid
ORDER BY productid;
GO

-- Step 5: Test procedure
EXEC Production.ProductsbySuppliers @supplierid = 1, @numrows = 2;

-- Step 6: Clean up
IF OBJECT_ID('Production.ProductsbySuppliers','P') IS NOT NULL DROP PROCEDURE Production.ProductsbySuppliers;
