-- Demonstration C

-- Step 1: Open a new query window to the TSQL database
USE TSQL;
GO

-- Step 2: Create inline Table-valued Function
-- Create a TVF to accept a supplier id and return 
-- the top 3 most expensive products for that shipper
CREATE FUNCTION dbo.fn_TopProductsByShipper
(@supplierid int)
RETURNS TABLE
AS
RETURN
	SELECT TOP (3) productid, productname, unitprice
	FROM Production.Products
	WHERE supplierid = @supplierid
	ORDER BY unitprice DESC;
GO

-- Step 3: Test the function
SELECT * FROM dbo.fn_TopProductsByShipper(2);

-- Test with CROSS APPLY
SELECT S.supplierid, S.companyname,
	P.productid, P.productname, P.unitprice
FROM Production.Suppliers AS S
CROSS APPLY dbo.fn_TopProductsByShipper(S.supplierid) AS P
ORDER BY S.supplierid ASC, P.unitprice DESC;

-- Step 4: Using OUTER APPLY
-- Find customers with no orders 
SELECT C.custid, C.companyname
FROM Sales.Customers AS C --91 customers
LEFT OUTER JOIN Sales.Orders AS O -- 830 orders
ON C.custid = O.custid --832 results with NULL cust

-- Step 5: Using CROSS APPLY
-- Return 3 most recent orders per customer
SELECT C.custid, TopOrders.orderid, TopOrders.orderdate
FROM Sales.Customers AS C
CROSS APPLY
(SELECT TOP (3) orderid, orderdate
	FROM Sales.Orders AS O
	WHERE O.custid = C.custid
	ORDER BY orderdate DESC, orderid DESC) AS TopOrders;

-- Use OUTER APPLY to include customers with no orders
SELECT C.custid, TopOrders.orderid, TopOrders.orderdate
FROM Sales.Customers AS C
OUTER APPLY
(SELECT TOP (3) orderid, orderdate
	FROM Sales.Orders AS O
	WHERE O.custid = C.custid
	ORDER BY orderdate DESC, orderid DESC) AS TopOrders; 

