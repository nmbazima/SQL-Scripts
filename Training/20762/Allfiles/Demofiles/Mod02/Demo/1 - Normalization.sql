-- Demonstration 1 - Working with Normalization


-- Step 1: Set AdventureWorks as the current database
USE AdventureWorks;
GO

-- Step 2: Create a table for denormalizing
-- Select and execute the following query to create the table, insert data, and return the results.
-- Ask the students to examine the table and suggest which columns do not conform to third normal form, and why. --------------------------------------------------- A:  SupplierPostCode.

CREATE TABLE Sales.ProductList
(
	ProductID int NOT NULL,
	ProductName nvarchar(50) NOT NULL,
	ProductNumber nvarchar(25) NOT NULL,
	Color nvarchar(15) NULL,
	ProductCategoryID int NOT NULL,
	Supplier nvarchar(30) NULL,
	SupplierPostCode nvarchar(10) NULL,
	DateCreated datetime DEFAULT GETDATE() NOT NULL
);
GO

INSERT INTO Sales.ProductList (ProductID, ProductName, ProductNumber, Color, ProductCategoryID, Supplier, SupplierPostCode)
SELECT p.ProductID, p.[Name], p.ProductNumber, p.Color, p.ProductSubcategoryID, 
		CASE c.ProductCategoryID
			WHEN 1 THEN 'Bike Warehouse'
			WHEN 2 THEN 'AW Parts & Components'
			WHEN 3 THEN 'Riding High Apparel'
			WHEN 4 THEN 'The Bike Chain'
		END AS Supplier, 
		CASE c.ProductCategoryID
			WHEN 1 THEN 'AB9 0JU'
			WHEN 2 THEN 'NG7 9HT'
			WHEN 3 THEN 'SW12 4GB'
			WHEN 4 THEN '00-0001'
		END AS SupplierPostCode	
FROM	Production.Product AS p
INNER	JOIN Production.ProductCategory AS c ON p.ProductSubcategoryID = c.ProductCategoryID;
GO

SELECT * 
	FROM sales.productList


-- Step 3: Alter the table to confirm to third normal form
-- Select and execute the following query to create the Supplier table and create relationships between the Supplier and ProductCategory tables.
-- Highlight and execute each query in turn

CREATE TABLE Sales.Supplier
(
	SupplierID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Supplier nvarchar(30) NOT NULL,
	SupplierPostCode nvarchar(10) NULL
);
GO

INSERT INTO Sales.Supplier (Supplier, SupplierPostCode)
VALUES ('Bike Warehouse','AB9 0JU'), ('AW Parts & Components','NG7 9HT'), ('Riding High Apparel', 'SW12 4GB'), ('The Bike Chain', '00-0001');
GO

SELECT * 
	FROM Sales.Supplier

-- Step 4: Drop and recreate the ProductList table

DROP TABLE Sales.ProductList

CREATE TABLE Sales.ProductList
(
	ProductID int NOT NULL,
	ProductName nvarchar(50) NOT NULL,
	ProductNumber nvarchar(25) NOT NULL,
	Color nvarchar(15) NULL,
	ProductCategoryID int FOREIGN KEY REFERENCES Production.ProductCategory (ProductCategoryID) NOT NULL,
	SupplierID int FOREIGN KEY REFERENCES Sales.Supplier (SupplierID) NOT NULL,
	DateCreated datetime DEFAULT GETDATE() NOT NULL,

);
GO

-- Step 5: Populate the new ProductList table
-- Select and execute the following query to populate the new table.
-- Note the foreign keys from ProductCategory and Supplier

INSERT INTO Sales.ProductList (ProductID, ProductName, ProductNumber, Color, ProductCategoryID, SupplierID)
SELECT p.ProductID, p.[Name], p.ProductNumber, p.Color, p.ProductSubcategoryID, 
		CASE c.ProductCategoryID
			WHEN 1 THEN 1
			WHEN 2 THEN 2
			WHEN 3 THEN 3
			WHEN 4 THEN 4
		END AS SupplierID 
FROM	Production.Product AS p
INNER	JOIN Production.ProductCategory AS c ON p.ProductSubcategoryID = c.ProductCategoryID;
GO

SELECT * 
	FROM sales.ProductList



