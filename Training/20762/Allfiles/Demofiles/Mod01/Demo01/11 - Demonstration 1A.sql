--10776A Module 2 Demonstration 1: Working with Data Types

-- Step 1: Open a new query window to the tempdb database

USE tempdb;
GO

-- Step 2: Create the dbo.Opportunity table

CREATE TABLE dbo.Opportunity
( 
  OpportunityID int NOT NULL,
  Requirements nvarchar(50) NOT NULL,
  ReceivedDate date NOT NULL,
  LikelyClosingDate date NULL,
  SalespersonID int NULL,
  Rating int NOT NULL
);

-- Step 3: Populate the table with 2 rows

INSERT INTO dbo.Opportunity 
  (OpportunityID, Requirements, ReceivedDate, LikelyClosingDate,
   SalespersonID,Rating)
VALUES (1,'n.d.', SYSDATETIME(), DATEADD(month,1,SYSDATETIME()), 34,9),
       (2,'n.d.', SYSDATETIME(), DATEADD(month,1,SYSDATETIME()), 37,2);

-- Step 4: Try to omit a value for OpportunityID. This will
--         fail as a column that is defined as NOT NULL needs a value.

INSERT dbo.Opportunity 
  (Requirements, ReceivedDate, 
   LikelyClosingDate, SalespersonID,Rating)
VALUES ('n.d.', SYSDATETIME(), DATEADD(month,1,SYSDATETIME()), 34,9);

-- Step 5: Create a table with a uniqueidentifier data type

CREATE TABLE dbo.TestGuid
(
  id INT NOT NULL IDENTITY(1,1),
  [Guid] UNIQUEIDENTIFIER NOT NULL
);

-- Step 6: Add 3 rows using the NEWID() function.				

INSERT INTO dbo.TestGuid ([Guid]) 
VALUES (NEWID()),(NEWID()),(NEWID());

-- Step 7: Examine the resulting rows

SELECT * FROM dbo.TestGuid;

-- Step 8: Clean up by dropping the tables

DROP TABLE dbo.Opportunity;
DROP TABLE dbo.TestGuid;
