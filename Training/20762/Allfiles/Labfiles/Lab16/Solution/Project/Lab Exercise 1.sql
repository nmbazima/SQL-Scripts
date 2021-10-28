---------------------------------------------------------------------
-- LAB 16
--
-- Exercise 1
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 1
-- 
-- Using SQL Server Configuration Manager, enable FILESTREAM for the SQL Server (MSSQLSSERVER) instance. 
--
-- Using SSMS, connect to MIA-SQL using Windows authentication.
--
-- Write and execute a script that uses the sp_configure stored procedure to set the FILESTREAM access level to 2
--
---------------------------------------------------------------------

EXEC sp_configure filestream_access_level, 2; 
RECONFIGURE;
GO

---------------------------------------------------------------------
-- Task 2
-- 
-- In SQL Server Management Studio, write a query to add a FILESTREAM filegroup called 
-- AdWorksFilestreamGroup to the AdventureWorks database.
--
-- Write a query to add a file named D:\FilestreamData to the AdventureWorks database
--
---------------------------------------------------------------------

ALTER DATABASE AdventureWorks
   ADD FILEGROUP AdworksFilestreamGroup CONTAINS FILESTREAM;
GO

ALTER DATABASE AdventureWorks
ADD FILE (NAME='FilestreamData', FILENAME='D:\FilestreamData') 
TO FILEGROUP AdworksFilestreamGroup;
GO

---------------------------------------------------------------------
-- Task 3
-- 
-- In SQL Server Management Studio, write a query to add a new UNIQUEIDENITFIER, non-nullable 
-- row GUID column called PhotoGuid to the Production.ProductPhoto table
--
-- Write a query to enable FILESTREAM for the Product.ProductPhoto table and add BLOBs to the 
-- AdworksFilestreamGroup
--
-- Write a query to add a new column called NewLargePhoto to the Production.ProductPhoto table. 
-- Ensure the new column has FILESTREAM enabled and is a nullable varbinary(max) column.
--
---------------------------------------------------------------------

USE AdventureWorks;
GO

ALTER TABLE Production.ProductPhoto 
ADD PhotoGuid UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL UNIQUE DEFAULT newid();
GO

ALTER TABLE Production.ProductPhoto
SET (filestream_on = AdworksFilestreamGroup);
GO

ALTER TABLE Production.ProductPhoto
ADD NewLargePhoto varbinary(max) FILESTREAM NULL;
GO

---------------------------------------------------------------------
-- Task 4
-- 
-- In SQL Server Management Studio, write a query to add copy all data from the LargePhoto 
-- column into the NewLargePhoto column. 
--
-- Write a query to drop the LargePhoto column from the Production.ProductPhoto table
--
-- Write a query that used the sp_rename stored procedure to change the name of the 
-- NewLargePhoto column to LargePhoto
--
---------------------------------------------------------------------

UPDATE Production.ProductPhoto
SET NewLargePhoto = LargePhoto;
GO

ALTER TABLE Production.ProductPhoto
DROP COLUMN LargePhoto;
GO

