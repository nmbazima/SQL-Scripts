-- Demonstration 2 - Working with Schemas

-- Step 1: Open a new query window to the AdventureWorksLT database on Azure


-- Step 2: Create a Schema
-- Select and execute the following query to create schema

CREATE SCHEMA HumanResources
AUTHORIZATION dbo;
GO


-- Step 3: Create a table using the new schema
-- Select and execute the following query to create the table
-- Remind students that the schema must be specified, or the default schema will be used

CREATE TABLE HumanResources.Employee
(
	EmployeeID int IDENTITY(1,1) PRIMARY KEY,
	EmployeeInsuranceCode nvarchar(15) NOT NULL,
	FirstName nvarchar(15) NOT NULL,
	MiddleInitial char(1) NULL,
	LastName nvarchar(25) NOT NULL,
	Email nvarchar(30) NOT NULL
);
GO


-- Step 4: Drop the schema
-- Ask the students if they think the following query will drop the schema? Looking for an answer of yes, but need to drop the Employee table first
-- Select and execute the following query to drop the schema
-- Show the error message to confirm this cannot be dropped while objects exist in the schema

DROP SCHEMA HumanResources;
GO


-- Step 5: Drop the table and then the schema
-- Select and execute the following query to drop the table and schema

DROP TABLE HumanResources.Employee;
GO

DROP SCHEMA HumanResources;
GO