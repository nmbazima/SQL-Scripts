-- Demonstration 3 - Working with Tables

-- Step 1: Open a new query window to the AdventureWorksLT database on Azure


-- Step 2: Create a table
-- Select and execute the following query to create the tables to extend the AdventureWorksLT database
-- Point out the choice of schemas
-- Refresh the Tables list in Object Explorer after creating the tables

CREATE TABLE SalesLT.Courier
( 
	CourierID int NOT NULL,
	CourierCode char(3) NOT NULL,
	CourierName nvarchar(50) NOT NULL,
	PRIMARY KEY (CourierID, CourierCode)
);
GO

CREATE TABLE dbo.WebLog
(
	WebLogID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	LogTime datetime NOT NULL DEFAULT GETDATE(),
	UserName sysname NOT NULL,
	URL nvarchar(4000) NOT NULL,
	ErrorSeverity int NULL,
	ErrorState int NULL,
	ErrorProcedure nvarchar(126) NULL,
	ErrorLine int NULL,
	ErrorMessage nvarchar(4000) NOT NULL
);
GO


-- Step 3: Alter the SalesLT.Courier table
-- Select and execute the following query to add two new columns to the SalesLT.Courier table
-- Mention that you do not need to specify the word COLUMN when adding a column, but need it when dropping a column

ALTER TABLE SalesLT.Courier
ADD Telephone varchar(15) NULL, Email varchar(25) NULL;
GO

ALTER TABLE SalesLT.Courier
DROP COLUMN Email;


-- Step 4: Drop the tables
-- Select and execute the following query to drop the two tables

DROP TABLE SalesLT.Courier;
GO
DROP TABLE dbo.WebLog;
GO