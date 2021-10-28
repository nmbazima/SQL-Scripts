-- Demonstration 2 - Configuring FILESTREAM and FileTables

-- Step 1: Configure FILESTREAM Access Level
-- Select and execute the following statement to configure FILESTREAM at the instance level

EXEC sp_configure filestream_access_level, 2
RECONFIGURE;
GO

-- Step 2: Create a FILESTREAM Filegroup
-- Select and execute the following statement to add a FILESTREAM FileGroup to the 
-- AdventureWorks database

ALTER DATABASE AdventureWorks2016
ADD FILEGROUP FILESTREAMGroup CONTAINS FILESTREAM;
GO

ALTER DATABASE AdventureWorks2016
ADD FILE (NAME='FILESTREAMGroup', FILENAME='D:\DemoFiles\Mod16\SetupFiles\AdventureWorksFILESTREAM')
TO FILEGROUP FILESTREAMGroup
GO

-- Step 3: Add a ROWGUID Column to the ProductPhoto Table
-- Select and execute the following statement to add a ROWGUID column to the 
-- ProductPhoto table. This is a requirement for FILESTREAM

USE AdventureWorks2016;
GO

ALTER TABLE Production.ProductPhoto 
ADD PhotoGuid UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL UNIQUE DEFAULT newid();
GO

-- Step 4: Enable FILESTREAM for the ProductPhoto Table
-- Select and execute the following statement to enable FILESTREAM for the
-- ProductPhoto table.

ALTER TABLE Production.ProductPhoto
SET (filestream_on = FILESTREAMGroup);
GO

-- Step 5: Add a FILESTREAM Column to the ProductPhoto Table
-- Select and execute the following statement to create a new FILESTREAM column
-- in the ProductPhoto table.

ALTER TABLE Production.ProductPhoto
ADD MediumPhoto varbinary(max) FILESTREAM NULL;
GO

-- Step 6: Check Non-Transactional Access
-- Select and execute the following statement to check whether non-transactional
-- access is enabled for all databases. In the results, scroll down to locate the 
-- AdventureWorks2016 database

SELECT DB_NAME(database_id), non_transacted_access, non_transacted_access_desc
    FROM sys.database_filestream_options;
GO

-- Step 7: Enable Non-Transactional Access
-- Select and execute the following statement to enable non-transactional access
-- for the Adventure Works database.

ALTER DATABASE AdventureWorks2016
SET FILESTREAM ( NON_TRANSACTED_ACCESS = FULL, DIRECTORY_NAME = N'FileTablesDirectory' );
GO

--Step 8: Create a FileTable
-- Select and execute the following statement to create a new FileTable

CREATE TABLE DocumentStore AS FileTable
WITH (FileTable_Directory = 'DocumentStore');
GO

-- Step 9: Check Non-Transactional Access
-- Select and execute the following statement to check whether non-transactional
-- access is enabled for all databases. This is the same query as in Step 6.
-- In the results, scroll down to locate the AdventureWorks2016 database

SELECT DB_NAME(database_id), non_transacted_access, non_transacted_access_desc
    FROM sys.database_filestream_options;
GO
