-- Demonstration B

-- Step 1: Open a new query window to the TSQL database
USE TSQL;
GO

-- Step 2: Using functions
-- Select and execute the following to 
-- demonstrate using the sample function
-- Note: dbo.GetNums() takes as parameters: @low (bigint) and (@high) bigint
SELECT * FROM dbo.GetNums(10,20);
GO

-- Step 3: Creating simple functions
-- Select and execute the following to 
-- Create a function to calculate line extension for orders
CREATE FUNCTION Sales.fn_LineTotal ( @orderid INT )
RETURNS TABLE
AS
RETURN
    SELECT  orderid, productid, unitprice, qty, discount,
            CAST(( qty * unitprice * ( 1 - discount ) ) AS DECIMAL(8, 2)) AS line_total
    FROM    Sales.OrderDetails
    WHERE   orderid = @orderid ;
GO
-- Use the function
SELECT orderid, productid, unitprice, qty, discount, line_total
FROM Sales.fn_LineTotal(10252) AS LT;
GO

-- Step 4: Cleanup
DROP FUNCTION Sales.fn_LineTotal;
GO