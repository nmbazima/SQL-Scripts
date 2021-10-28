---------------------------------------------------------------------
-- LAB 16
--
-- Exercise 3
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 1
-- 
-- Execute the first SELECT query below, which lists the tables that have a full text 
-- index in the AdventureWorks2016 database. 
--
-- Write a query that creates a new full-text catalog in the AdventureWorks2016 database 
-- with the name ProductFullTextCatalog.
--
-- Write a query that creates a new unique index called ui_ProductDescriptionID and 
-- indexes the ProductDescriptionID column in the Production.ProductDescription table.
--
-- Write a query that creates a new full-text index on the Description column of the 
-- Production.ProductDescription table. Use the ui_ProductDescription unique index and 
-- the ProductFullTextCatalog.
--
---------------------------------------------------------------------

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





---------------------------------------------------------------------
-- Task 2
-- 
-- Write a script that executes a simple term query against the Description column in the 
-- Production.ProductDescription table. Locate rows that contain the word "Bike"
--
-- Write a script that executes a generation term query against the Description column 
-- in the Production.ProductDescription table. Locate rows that contain the word "Bike". 
--
-- Write a script that returns rows from the previous generation term query but not terms 
-- from the previous simple terms query. Examine the Description text for these results.
--
---------------------------------------------------------------------






