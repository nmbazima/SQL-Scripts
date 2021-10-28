---------------------------------------------------------------------
-- LAB 16
--
-- Exercise 2
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Task 1
-- 
-- Write a query that uses the sys.database_filestream_options system view to display whether 
-- non-transacted access is enabled for each database in the instance.
--
-- Write a query that enables non-transacted access for the AdventureWorks database. 
-- Set the transacted access level to full and the directory name to "FileTablesDirectory".
--
---------------------------------------------------------------------


USE AdventureWorks;
SELECT DB_NAME(database_id) AS dbname, non_transacted_access, non_transacted_access_desc
FROM sys.database_filestream_options;
GO

ALTER DATABASE AdventureWorks
SET FILESTREAM ( NON_TRANSACTED_ACCESS = FULL, DIRECTORY_NAME = N'FileTablesDirectory' );
GO

---------------------------------------------------------------------
-- Task 2
-- 
-- Write a query to create a new FileTable in the AdventureWorks database. Name the FileTable 
-- "DocumentStore" and use a FileTable directory named "DocumentStore"
--
-- Write a query that uses the sys.database_filestream_options system view to display whether 
-- non-transacted access is enabled for each database in the instance
--
-- Write a query that uses the sys.filetables system view to list the FileTables in the 
-- AdventureWorks database
--
---------------------------------------------------------------------

CREATE TABLE dbo.DocumentStore AS FileTable
WITH (FileTable_Directory = 'DocumentStore');
GO

SELECT DB_NAME(database_id) AS dbname, non_transacted_access, non_transacted_access_desc
FROM sys.database_filestream_options;
GO

SELECT * FROM AdventureWorks.sys.filetables;

---------------------------------------------------------------------
-- Task 3
-- 
-- In SQL Server Management Studio, write a query that uses the FileTableRootPath() function 
-- to find the path to the file share for the DocumentStore filetable.
--
-- Copy and paste the path you determined into the address bar of a new File Explorer window.
--
-- Create a new text document called DocumentStoreTest in the file table shared folder.
--
-- Write a query that displays all rows in the DocumentStore FileTable.
--
---------------------------------------------------------------------

SELECT FileTableRootPath('dbo.DocumentStore');
GO

SELECT * FROM dbo.DocumentStore;