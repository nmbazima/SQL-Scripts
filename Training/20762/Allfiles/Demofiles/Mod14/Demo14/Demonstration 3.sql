-- Demonstration 3

-- Step 1 - Open a new query window against tempdb

USE tempdb;
GO

-- Step 2 - Create a primary XML index

CREATE PRIMARY XML INDEX IX_ProductImport_ProductDetails
ON dbo.ProductImport (ProductDetails);
GO

-- Step 3 - Create a secondary VALUE index

CREATE XML INDEX IX_ProductImport_ProductDetails_Value
ON dbo.ProductImport (ProductDetails)
USING XML INDEX IX_ProductImport_ProductDetails
FOR VALUE;
GO

-- Step 4 - Query the sys.xml_indexes system view

SELECT * FROM sys.xml_indexes;
GO

-- Step 5 - Drop and recreate the table without a primary key

DROP TABLE dbo.ProductImport;
GO

CREATE TABLE dbo.ProductImport
( ProductImportID int IDENTITY(1,1),
  ProductDetails xml (CONTENT dbo.ProductDetailsSchema)
);
GO

-- Step 6 - Now try to re-add the primary xml index. Note that this will fail.

CREATE PRIMARY XML INDEX IX_ProductImport_ProductDetails
ON dbo.ProductImport (ProductDetails);
GO

