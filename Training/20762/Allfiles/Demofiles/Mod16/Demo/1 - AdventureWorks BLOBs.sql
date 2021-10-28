-- Demonstration 1 - BLOBs in the AdventureWorks Database

-- Step 1: Switch to the Adventure works database
-- Select and execute the following statement to ensure queries use the right database

use AdventureWorks2016;
GO

-- Step 2: Find varbinary(max) columns
-- Select and execute the following query to locate columns with data type varbinary(max)
-- Examine the results with the students

SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH 
FROM AdventureWorks2016.INFORMATION_SCHEMA.COLUMNS 
WHERE DATA_TYPE = 'varbinary' 
AND CHARACTER_MAXIMUM_LENGTH = -1;
GO

-- Step 3: Check for FILESTREAM columns
-- Select and execute the following query to find out if the LargePhoto column is a FILESTREAM column

SELECT OBS.name AS TableName, COLS.name AS ColumnName, is_filestream
FROM sys.columns AS COLS
INNER JOIN sys.objects AS OBS
ON COLS.object_id = OBS.object_id 
WHERE COLS.name = 'LargePhoto';

-- Step 4: Check for FileTables
-- Select and execute the following query to find all the FileTables in the database

SELECT * FROM AdventureWorks2016.sys.filetables;

