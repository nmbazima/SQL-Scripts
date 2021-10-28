-- Demonstration 3 - Adding System-Versioning to an Existing Table



-- Step 1: Connect to AdventureWorks
-- Select and execute the following query to use AdventureWorks
USE AdventureWorks2016;
GO



-- Step 2: Add System-Versioning Columns to an Existing Table, and Enable System-Versioning
-- Select and execute the following query to add the data columns to the Production.Product table and set system-versioning on
-- Remind students that these columns need to be added first, then system-versioning can be enabled
-- Point out that the datetime column names have been changed from the default vlaues, and that the values in the PERIOD FOR SYSTEM_TIME reflects this

-- Add the two date range columns
ALTER TABLE Person.Person
ADD 
StartDate datetime2(0) GENERATED ALWAYS AS ROW START HIDDEN CONSTRAINT DF_ProductSysStartDate DEFAULT SYSDATETIME(), 
EndDate datetime2(0) GENERATED ALWAYS AS ROW END HIDDEN CONSTRAINT DF_ProductSysEndDate DEFAULT CONVERT(datetime2 (0), '9999-12-31 23:59:59'), 
PERIOD FOR SYSTEM_TIME (StartDate, EndDate); 
GO 
-- Enable system-versioning
ALTER TABLE Person.Person
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = Person.Person_History));
GO


-- Step 3: Show the new history table in Object Explorer
-- In the object explorer window, refresh the Tables node and scroll down if necessary,  as the table will now be at the bottom of list
-- Point out that the table name now includes "(System-Versioned)"
-- Expand the table node to show a history table has been paired with the current data table
-- Point out that the history table name includes "(History)"
-- Expand the list of columns to show the identical column names



-- Step 4: Make Data Modifications
-- Select and execute the following query to update an existing row 
UPDATE	Person.Person
SET		FirstName = 'James'
WHERE	BusinessEntityID = 1704



-- Step 5: Query the data changes
-- Select and execute the following query to show the history of the updated row
-- Point out that the history table stores all column data for the row, even when it has been updated
-- Mention the use of the ALL keyword to return rows for all time
SELECT	* 
FROM	Person.Person FOR SYSTEM_TIME ALL
WHERE	BusinessEntityID = 1704
