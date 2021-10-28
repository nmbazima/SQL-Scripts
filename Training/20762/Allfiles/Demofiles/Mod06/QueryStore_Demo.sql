-- QueryStore_Demo

-- This lab is done using Azure SQL Database and the AdventureWorksLT database
-- Make AdventureWorksLT the current database

--------------------------------------------------------------------------------
-- Create a covering index on the TempProduct table
--------------------------------------------------------------------------------

IF EXISTS(SELECT * FROM sys.indexes WHERE name = N'ix_TempProduct' AND object_id = OBJECT_ID(N'SalesLT.TempProduct', N'U'))
BEGIN
	DROP INDEX ix_TempProduct
		ON SalesLT.TempProduct;
END

CREATE NONCLUSTERED INDEX ix_TempProduct
	ON SalesLT.TempProduct (ProductCategoryID)
	INCLUDE (Name, ProductNumber);


--------------------------------------------------------------------------------
-- Clear the Query Store
--------------------------------------------------------------------------------

ALTER DATABASE AdventureWorksLT
	SET QUERY_STORE CLEAR;


--------------------------------------------------------------------------------
-- Work load 1
-- Run this six times
--------------------------------------------------------------------------------

SELECT C.ProductCategoryID, C.Name AS 'Category', P.Name AS 'ProductName', P.ProductNumber, SUM(D.OrderQty) AS 'OrderQty', SUM(D.LineTotal) AS 'OrderValue'
	FROM SalesLT.ProductCategory AS C
		INNER JOIN SalesLT.TempProduct AS P
			ON P.ProductCategoryID = C.ProductCategoryID
		LEFT OUTER JOIN SalesLT.SalesOrderDetail AS D
			ON D.ProductID = P.ProductID
	GROUP BY C.ProductCategoryID, C.Name, P.Name, P.ProductNumber;


--------------------------------------------------------------------------------
-- Work load 2
-- Run this four times
--------------------------------------------------------------------------------

SELECT C.CompanyName, CONCAT(C.FirstName, N' ' + C.MiddleName, N' ' + C.LastName) AS Name, P.Name as 'ProductName', P.ProductNumber, SUM(H.TotalDue) AS 'TotalDue'
	FROM SalesLT.Customer AS C
		INNER JOIN SalesLT.SalesOrderHeader AS H
			ON H.CustomerID = C.CustomerID
		INNER JOIN SalesLT.SalesOrderDetail AS D
			ON D.SalesOrderID = H.SalesOrderID
		INNER JOIN SalesLT.TempProduct AS P
			ON P.ProductID = D.ProductID
	WHERE P.ProductCategoryID <= 15
	GROUP BY C.CompanyName, C.FirstName, C.MiddleName, C.LastName, P.Name, P.ProductNumber;


--------------------------------------------------------------------------------
-- Regress work load 1
--------------------------------------------------------------------------------

DROP INDEX ix_TempProduct
	ON SalesLT.TempProduct;

-- Execute work load 1 -- six more times

