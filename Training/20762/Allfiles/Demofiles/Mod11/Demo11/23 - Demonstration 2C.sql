-- Demonstration 2C - AFTER UPDATE Triggers

-- Step A: Open a new query window 
--         and use the tempdb database

USE tempdb;
GO

-- Step B: Create the CurrentPrice table

CREATE TABLE dbo.CurrentPrice
(
	CurrentPriceID int IDENTITY(1,1) 
	  CONSTRAINT PK_CurrentPrice PRIMARY KEY,
	SellingPrice decimal(18,2) NOT NULL,
	LastModified datetime2 NOT NULL
	  CONSTRAINT DF_CurrentPrice_LastModified
	  DEFAULT (SYSDATETIME()),
	ModifiedBy sysname NOT NULL
	  CONSTRAINT DF_CurrentPrice_ModifiedBy
	  DEFAULT (ORIGINAL_LOGIN())
);
GO

-- Step C: Populate the table

INSERT INTO dbo.CurrentPrice 
  (SellingPrice)
  VALUES (2.3), (4.3), (5);
GO

-- Step D: Select the current rows

SELECT * FROM dbo.CurrentPrice;
GO
  
-- Step E: Update the row where CurrentPriceID = 2

UPDATE dbo.CurrentPrice 
SET SellingPrice = 10 
WHERE CurrentPriceID = 2;
GO

-- Step F: Reselect the rows and note that the LastModified 
--         column has not been updated

SELECT * FROM dbo.CurrentPrice;
GO

-- Step G: Create a trigger to update the LastModifed and ModifiedBy columns

CREATE TRIGGER TR_CurrentPrice_Update
ON dbo.CurrentPrice
AFTER UPDATE AS BEGIN
  SET NOCOUNT ON;
  UPDATE cp
  SET cp.LastModified = SYSDATETIME(),
      cp.ModifiedBy = ORIGINAL_LOGIN()
  FROM dbo.CurrentPrice AS cp
  INNER JOIN inserted AS i
  ON cp.CurrentPriceID = i.CurrentPriceID;
END;
GO

-- Step H: Test the UPDATE again then reselect rows from 
--         dbo.CurrentPrice and note that the LastModified
--         and Modified columns are now updated

UPDATE dbo.CurrentPrice 
SET SellingPrice = 20 
WHERE CurrentPriceID = 2;
GO

SELECT * FROM dbo.CurrentPrice;
GO

-- Step I: Query the sys.triggers view and note the existence of the view

SELECT * FROM sys.triggers;
GO

-- Step J: Drop the dbo.CurrentPrice table

DROP TABLE dbo.CurrentPrice;
GO

-- Step K: Requery the sys.triggers view and 
--          note that the trigger is dropped when the table is dropped

SELECT * FROM sys.triggers;
GO
