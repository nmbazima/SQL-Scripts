-- Demonstration 3 - Configuring and Using Full-Text Search

-- Step 1: Investigate Existing Full-Text Indexes
-- Select and execute the following statements to determine the full-text indexes 
-- that already exist in the AdventureWorks database.

USE AdventureWorks2016;
GO

SELECT t.name AS IndexedTable, c.name AS FullTextCatalog, i.name AS IndexName, cl.name AS ColumnName
FROM sys.tables t 
INNER JOIN sys.fulltext_indexes fi 
ON t.[object_id] = fi.[object_id] 
INNER JOIN sys.fulltext_index_columns ic
ON ic.[object_id] = t.[object_id]
INNER JOIN sys.columns cl
ON ic.column_id = cl.column_id AND ic.[object_id] = cl.[object_id]
INNER JOIN sys.fulltext_catalogs c 
ON fi.fulltext_catalog_id = c.fulltext_catalog_id
INNER JOIN sys.indexes i
ON fi.unique_index_id = i.index_id AND fi.[object_id] = i.[object_id];
GO

-- Step 2: Create a Full-Text Catalog
-- Select and execute the following statements to create a new full-text catalog
-- in the AdventureWorks database

CREATE FULLTEXT CATALOG DemoFullTextCatalog;
GO

-- Step 3: Create a Unique Index
-- Select and execute the following statements to create a new unique index
-- for the ProductDescription table. Note that this is not the full-text index.
-- Instead this index will be used and the index key for the full-text index.

CREATE UNIQUE INDEX ui_ProductDescriptionID ON Production.ProductDescription(ProductDescriptionID);
GO

-- Step 4: Create a Full-Text Index
-- Select and execute the following statements to create a new full-text index
-- for the ProductDescription table.

CREATE FULLTEXT INDEX ON Production.ProductDescription
  ( 
  Description Language 1033    
  ) 
  KEY INDEX ui_ProductDescriptionID 
  ON DemoFullTextCatalog; 
GO

-- Step 5: Execute a Full-Text Search
-- Select and execute the following statements to search the full-text index 
-- that you created in Step 4. This example is a simple term query.

SELECT ProductDescriptionID, Description
FROM Production.ProductDescription
WHERE CONTAINS(Description, 'ride');

-- Step 6: Execute a Generation Term Full-Text Search
-- Select and execute the following statements to search the full-text index 
-- that you created in Step 4. This example is a generation term query. It returns
-- items that contain forms of "ride" such as "riding" and "ridden".

SELECT ProductDescriptionID, Description
FROM Production.ProductDescription
WHERE CONTAINS(Description, 'FORMSOF(INFLECTIONAL, ride)');
