USE AdventureWorks -- Or connect to azure Database if you have access to it
GO

SELECT * INTO Store FROM Sales.Store				-- Make a copy of the Sales.Store Table
SELECT TOP 10 * FROM Sales.Store					-- Show that you have done this
SELECT TOP 10 * INTO StoreBackup FROM Sales.Store   -- Copy the top 10 rows into source
SELECT * FROM StoreBackup							-- Make a copy of the Sales.Store Table
SELECT * FROM Store									-- Make a copy of the Sales.Store Table


-- Remove the copied rows from the store table
DELETE FROM Store	
OUTPUT DELETED.*
WHERE BusinessEntityID <= (SELECT MAX(BusinessENtityID) FROM StoreBackup)	-- Remove top 10 rows from target

-- Show that they have been removed
SELECT BusinessEntityID FROM Store					-- Show that the rows have been copied back into Sales
INTERSECT
SELECT BusinessEntityID FROM StoreBackup


-- Use the Merge statement to put them back

MERGE top (10) INTO		Store AS Destination					-- Known in online help as Target, which is a reserved word
	USING		StoreBackup AS StagingTable						-- Known in online help as the source, which is also a reserved word
	ON			(Destination.BusinessEntityID = StagingTable.BusinessEntityID)	-- the matching control column
WHEN NOT MATCHED THEN
	INSERT (	BusinessEntityID
			,	Name
			,	SalesPersonID
			,	Demographics
			,	rowguid
			,	ModifiedDate
			)
	VALUES (	StagingTable.BusinessEntityID
			,	StagingTable.Name
			,	StagingTable.SalesPersonID
			,	StagingTable.Demographics
			,	StagingTable.rowguid
			,	StagingTable.ModifiedDate
			)
OUTPUT INSERTED.*;



-- SELECT * FROM Sales.Store where 1 = 0 -- used to extract column names for all columns, without cost of data access

SELECT BusinessEntityID FROM Store					-- Show that the rows have been copied back into Sales
INTERSECT
SELECT BusinessEntityID FROM StoreBackup

UPDATE Store SET Name = 'TestUpdate' 
OUTPUT	INSERTED.name	AS NewName, 
		DELETED.name	AS OldName
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM StoreBackup)	-- Update Names in store that are for backed up stores

SELECT * FROM Store WHERE Name = 'TestUpdate'							-- Show that they have been changed

-- Use the Merge statement to Change the names back

MERGE top (10) INTO		Store AS Destination			-- Known in online help as Target, which is a reserved word
	USING		StoreBackup AS StagingTable				-- Known in online help as the source, which is also a reserved word
	ON			(Destination.BusinessEntityID = StagingTable.BusinessEntityID)	-- the matching control column
WHEN MATCHED THEN -- 
	UPDATE SET
	            Destination.BusinessEntityID	= StagingTable.BusinessEntityID
,				Destination.Name				= StagingTable.Name
,				Destination.SalesPersonID		= StagingTable.SalesPersonID
,				Destination.Demographics		= StagingTable.Demographics
,				Destination.rowguid				= StagingTable.rowguid
,				Destination.ModifiedDate		= StagingTable.ModifiedDate
OUTPUT $Action, INSERTED.*, DELETED.*;


-- Ensure that the environment has been restored to the 
-- state it was in before the changes were made

SELECT * FROM store

-- Clean up the database

DROP TABLE IF EXISTS Store;
DROP TABLE IF EXISTS StoreBackup;




