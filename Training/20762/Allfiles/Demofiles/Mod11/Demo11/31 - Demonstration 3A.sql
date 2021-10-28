-- Demonstration 3A - INSTEAD OF Triggers

-- Step A: Open a new query window 
--         and use the tempdb database

USE tempdb;
GO

-- Step B: Create and populate the dbo.CurrentPrice table 
--         Note the additional IsValid column

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
	  DEFAULT (ORIGINAL_LOGIN()),
	IsValid bit NOT NULL
	  CONSTRAINT DF_CurrentPrice_IsValid
	  DEFAULT (1)
);
GO

INSERT INTO dbo.CurrentPrice 
  (SellingPrice)
  VALUES (2.3), (4.3), (5);
GO

SELECT * FROM dbo.CurrentPrice;
GO

-- Step C: Create the trigger for INSTEAD OF DELETE

CREATE TRIGGER TR_CurrentPrice_Delete
ON dbo.CurrentPrice
INSTEAD OF DELETE AS BEGIN
  SET NOCOUNT ON;
  UPDATE cp
  SET cp.IsValid = 0
  FROM dbo.CurrentPrice AS cp
  INNER JOIN deleted AS d
  ON cp.CurrentPriceID = d.CurrentPriceID;
END;
GO

-- Step D: Try to delete a row
--         Note the number of rows shown as being affected 
--         and that no errors are returned

DELETE dbo.CurrentPrice
WHERE CurrentPriceID = 2;
GO

-- Step E: Requery the table and note that row 2 is still 
--         there but now modified instead of deleted

SELECT * FROM dbo.CurrentPrice;
GO

-- Step F: Query sys.triggers and note the value in 
--         the is_instead_of_trigger column

SELECT * FROM sys.triggers;
GO

-- Step G: Drop the table (and with it, the trigger)

DROP TABLE dbo.CurrentPrice;
GO

-- Step H: Create another table with two string columns

CREATE TABLE dbo.PostalCode
( CustomerID int PRIMARY KEY,
  PostalCode nvarchar(5) NOT NULL,
  PostalSubCode nvarchar(5) NULL
);
GO

-- Step I: Create a view over the table that concatenates the string columns

CREATE VIEW dbo.PostalRegion
AS
SELECT CustomerID,
       PostalCode + COALESCE('-' + PostalSubCode,'') AS PostalRegion
FROM dbo.PostalCode;
GO

-- Step J: Insert some data to the base table

INSERT dbo.PostalCode (CustomerID,PostalCode,PostalSubCode)
VALUES (1,'23422','234'),
       (2,'23523',NULL),
       (3,'08022','523');
GO
       
-- Step K: Query the view to see the results

SELECT * FROM dbo.PostalRegion;
GO

-- Step L: Try to insert into the view (will fail - note the error)

INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (4,'09232-432');
GO

-- Step M: Try to update the view (will fail - note the error)

UPDATE dbo.PostalRegion SET PostalRegion = '23234-523' WHERE CustomerID = 3;
GO

-- Step N: Try to delete a row 

DELETE FROM dbo.PostalRegion WHERE CustomerID = 3;
GO

-- Question: Why does the DELETE succeed when INSERT and UPDATE fail?

-- Step O: Create an INSTEAD OF INSERT trigger

CREATE TRIGGER TR_PostalRegion_Insert
ON dbo.PostalRegion
INSTEAD OF INSERT
AS
INSERT INTO dbo.PostalCode 
SELECT CustomerID, 
       SUBSTRING(PostalRegion,1,5),
       CASE WHEN SUBSTRING(PostalRegion,7,5) <> '' THEN SUBSTRING(PostalRegion,7,5) END
FROM inserted;
GO

-- Step P: Try to insert into the view again

INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (4,'09232-432');
GO

-- Step Q: Note that two row counts have been returned

-- Step R: Alter the trigger to remove the extra rowset

ALTER TRIGGER TR_PostalRegion_Insert
ON dbo.PostalRegion
INSTEAD OF INSERT
AS
SET NOCOUNT ON;
INSERT INTO dbo.PostalCode 
SELECT CustomerID, 
       SUBSTRING(PostalRegion,1,5),
       CASE WHEN SUBSTRING(PostalRegion,7,5) <> '' THEN SUBSTRING(PostalRegion,7,5) END
FROM inserted;
GO

-- Step S: Try to insert into the view again

INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (5,'92232-142');
GO

-- Step T: Note that only the correct rowcount is returned now

-- Step U: Make sure the trigger works for multi-row inserts

INSERT INTO dbo.PostalRegion (CustomerID,PostalRegion)
VALUES (6,'11111-111'),
       (7,'99999-999');
GO

SELECT * FROM dbo.PostalRegion;
GO

-- Step V: Drop the view and the table

DROP VIEW dbo.PostalRegion;
GO
DROP TABLE dbo.PostalCode;
GO
