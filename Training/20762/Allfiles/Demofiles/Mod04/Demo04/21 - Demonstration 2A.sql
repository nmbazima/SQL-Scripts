--Demonstration 2A - Data and Domain Integrity

-- Step 1: Review the requirements for a table design

/*
Table called dbo.ProspectiveHire

Columns and requirements are:

ProspectiveHireID (identifies the row)
GivenNames
FamilyName
FullName
CountryCode   (used to hold a 3 letter ISO code)
StateOrRegion (used to hold details of a state or region – if the countrycode is USA, this must be 2 characters long)
DateOfBirth
LikelihoodOfJoining (value from 1 to 5 with 5 being most likely but 3 as the default if not specified)

 What constraints should be put in place?

*/
 
-- Step 2: Determine the data types, nullability, default and check constraints
--         that should be put in place

-- Step 3: Check the outcome with this proposed solution

USE tempdb;
GO

CREATE TABLE dbo.ProspectiveHire
(
	ProspectiveHireID int NOT NULL,
	GivenNames nvarchar(30) NOT NULL,
	FamilyName nvarchar(30) NULL,
	FullName nvarchar(50) NOT NULL,
	CountryCode nchar(3) NOT NULL
	  CONSTRAINT CHK_ProspectiveHire_CountryCode_Length3
	  CHECK (LEN(CountryCode) = 3),
	StateOrRegion nvarchar(20) NULL,
	DateOfBirth date NOT NULL
	  CONSTRAINT CHK_ProspectiveHire_DateOfBirth_NotFuture
	  CHECK (DateOfBirth < SYSDATETIME()),
	LikelihoodOfJoining int NOT NULL
	  CONSTRAINT CHK_ProspectiveHire_LikelihoodOfJoining_Range1To5
	  CHECK (LikelihoodOfJoining BETWEEN 1 AND 5)
	  CONSTRAINT DF_ProspectiveHire_LikelihoodOfJoining
	  DEFAULT (3),
	CONSTRAINT CHK_ProspectiveHire_US_States_Length2
	CHECK (CountryCode <> N'USA' OR LEN(StateOrRegion) = 2)
);
GO

-- Step 4: Execute statements to test the actions of the integrity constraints

-- INSERT a row providing all values ok:

INSERT INTO dbo.ProspectiveHire 
  ( ProspectiveHireID, GivenNames, FamilyName, FullName,
    CountryCode, StateOrRegion, DateOfBirth, LikelihoodOfJoining)
  VALUES (1, 'Jon','Jaffe','Jon Jaffe',
          'USA', 'WA', '19730402', 4);
GO
SELECT * FROM dbo.ProspectiveHire;
GO

-- Step 5: INSERT rows that test the nullability and constraints

-- INSERT a row that fails a nullability test

INSERT INTO dbo.ProspectiveHire 
  ( ProspectiveHireID, GivenNames, FamilyName, 
    CountryCode, StateOrRegion, DateOfBirth, LikelihoodOfJoining)
  VALUES (2, 'Jacobsen','Lola',
          'USA', 'W', '19730405', 2);
GO

-- INSERT a row that fails the country code length test

INSERT INTO dbo.ProspectiveHire 
  ( ProspectiveHireID, GivenNames, FamilyName, FullName,
    CountryCode, StateOrRegion, DateOfBirth, LikelihoodOfJoining)
  VALUES (2, 'Jacobsen','Lola', 'Lola Jacobsen',
          'US', 'WA', '20600405', 2);
GO

-- INSERT a row that fails the date of birth test

INSERT INTO dbo.ProspectiveHire 
  ( ProspectiveHireID, GivenNames, FamilyName, FullName,
    CountryCode, StateOrRegion, DateOfBirth, LikelihoodOfJoining)
  VALUES (2, 'Jacobsen','Lola', 'Lola Jacobsen',
          'USA', 'WA', '20600405', 2);
GO

-- INSERT a row that fails the US State length test

INSERT INTO dbo.ProspectiveHire 
  ( ProspectiveHireID, GivenNames, FamilyName, FullName,
    CountryCode, StateOrRegion, DateOfBirth, LikelihoodOfJoining)
  VALUES (2, 'Jacobsen','Lola', 'Lola Jacobsen',
          'USA', 'W', '19730405', 2);
GO

-- Step 6: Query sys.sysconstraints to see the list of constraints 
--         that have been cataloged

SELECT OBJECT_NAME(id) AS TableName,
       OBJECT_NAME(constid) AS ConstraintName,
       * 
FROM sys.sysconstraints;
GO

-- Step 7 Explore system catalog views through the INFORMATION_SCHEMA owner

SELECT * FROM INFORMATION_SCHEMA.DOMAIN_CONSTRAINTS
SELECT * FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS
SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS