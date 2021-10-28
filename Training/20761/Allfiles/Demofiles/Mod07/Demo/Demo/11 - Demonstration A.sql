USE TSQL
GO

--	First try the INSERT by stored procedure to see that it doesn't work becasue it is not there
INSERT INTO Production.Products 
	(	productID
	,	productname
	,	supplierid
	,	categoryid
	,	unitprice)
EXEC Production.AddNewProducts;

--	To make this routine work we remove some rows from two linked tables to allow 
--	deletion, delete the rows and then put the rows back ;-)

--	Create a backup of the Products with a chosen ID
DROP TABLE IF EXISTS NewProducts
GO

SELECT * INTO NewProducts 
FROM PRODUCTION.PRODUCTS WHERE ProductID >= 70		

-- Create a backup of the Order Details for the chosen productID
DROP TABLE IF EXISTS NewOrderDetails
GO

SELECT * INTO NewOrderDetails 
FROM SALES.OrderDetails WHERE ProductID >= 70		

-- Delete the copied data from the original tables 
DELETE FROM SALES.OrderDetails		
OUTPUT DELETED.*
WHERE ProductID >= 70

DELETE FROM Production.Products		
OUTPUT DELETED.*
WHERE ProductID >= 70

-- check that they have been transfered safely
SELECT * FROM NewProducts
SELECT * FROM NewOrderDetails

SELECT * FROM SALES.OrderDetails	
WHERE productid >= 70

SELECT * FROM Production.Products
WHERE productid >= 70

-- Now we can put back the rows from the NewTables, using the INSERT statement
-- Firstly the Products, for which we will create a run a stored procedure
DROP PROCEDURE IF EXISTS Production.AddNewProducts
GO

CREATE PROCEDURE Production.AddNewProducts
AS
	BEGIN
		SELECT Productid, productname, SUpplierID, CategoryID, Unitprice FROM NewProducts
	END

-- Having created it, we can run it to feed the missing rows into the Products table
INSERT INTO Production.Products (productid, productname, supplierid, categoryid, unitprice)
EXEC Production.AddNewProducts;

SELECT * FROM Production.Products
WHERE productid >= 70

-- The OrderDetails will be put back using INSERT .. SELECT
INSERT Sales.OrderDetails (orderid, productid, unitprice, qty, discount)
OUTPUT INSERTED.*
SELECT * FROM NewOrderDetails

-- Clean up the database

DROP TABLE NewProducts
GO

DROP TABLE NewOrderDetails
GO

DROP PROCEDURE Production.AddNewProducts
GO