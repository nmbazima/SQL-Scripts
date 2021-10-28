-- Module 3 - Lab Exercise 1 - Create HumanResources Database

USE master;
GO

IF EXISTS (SELECT name FROM dbo.sysdatabases  WHERE name = 'HumanResources')
DROP DATABASE HumanResources;
GO

CREATE DATABASE HumanResources
ON PRIMARY 
( 
	NAME = N'HR', FILENAME = N'D:\Labfiles\Lab03\Starter\SetupFiles\HumanResources.mdf' , SIZE = 55360KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB 
)
LOG ON 
( 
	NAME = N'HR_log', FILENAME = N'D:\Labfiles\Lab03\Starter\SetupFiles\HumanResources_log.ldf' , SIZE = 32960KB , MAXSIZE = 2048GB , FILEGROWTH = 10%
);
GO

USE HumanResources
GO

-- Create HR Schema 
CREATE SCHEMA HR;
GO

-- Create Payment Schema 
CREATE SCHEMA Payment;
GO

-- Create Table HR.Department 
CREATE TABLE HR.Department
(
	DepartmentID smallint NOT NULL,
	Name nvarchar(50) NOT NULL,
	ModifiedDate datetime NOT NULL,
	CONSTRAINT PK_Department PRIMARY KEY CLUSTERED (DepartmentID)
) ON [PRIMARY]
GO

-- Create Table HR.Employee 
CREATE TABLE HR.Employee
(
	PersonID int NOT NULL,
	NationalIDNumber nvarchar(15) NOT NULL,
	LoginID nvarchar(256) NOT NULL,
	OrganizationNode hierarchyid NULL,
	JobTitle nvarchar(50) NOT NULL,
	BirthDate date NOT NULL,
	MaritalStatus nchar(1) NOT NULL,
	Gender nchar(1) NOT NULL,
	HireDate date NOT NULL,
	SalariedFlag bit NOT NULL,
	VacationHours smallint NOT NULL,
	SickLeaveHours smallint NOT NULL,
	EmergencyContactID int NULL,
	CurrentFlag bit NOT NULL,
    CONSTRAINT PK_Employee PRIMARY KEY (PersonID)
) ON [PRIMARY]
GO

-- Create Table HR.EmployeeDepartmentHistory 
CREATE TABLE HR.EmployeeDepartmentHistory
(
	PersonID int NOT NULL,
	DepartmentID smallint NOT NULL,
	ShiftID tinyint NOT NULL,
	StartDate date NOT NULL,
	EndDate date NULL,
	ModifiedDate datetime NOT NULL,
	CONSTRAINT PK_EmployeeDepartmentHistory PRIMARY KEY (PersonID, DepartmentID, ShiftID, StartDate)
) ON [PRIMARY]
GO

-- Create Table HR.Shift 
CREATE TABLE HR.[Shift]
(
	ShiftID tinyint NOT NULL,
	Name nvarchar(50) NOT NULL,
	StartTime time(7) NOT NULL,
	EndTime time(7) NOT NULL,
	ModifiedDate datetime NOT NULL,
    CONSTRAINT PK_Shift PRIMARY KEY (ShiftID)
) ON [PRIMARY]
GO

-- Create Table HR.Address 
CREATE TABLE HR.[Address]
(
	AddressID int NOT NULL,
	AddressLine1 nvarchar(60) NOT NULL,
	AddressLine2 nvarchar(60) NULL,
	City nvarchar(30) NOT NULL,
	StateProvinceID int NOT NULL,
	PostalCode nvarchar(15) NOT NULL,
	CONSTRAINT PK_Address PRIMARY KEY (AddressID)
) ON [PRIMARY] 
GO

-- Create Table HR.Contact 
CREATE TABLE HR.EmergencyContact
(
	PersonID int NOT NULL,
	RelationshipToEmployee nvarchar(30) NOT NULL,
	CONSTRAINT PK_EmergencyContact PRIMARY KEY (PersonID)
) ON [PRIMARY]
GO

-- Create Table HR.CountryRegion 
CREATE TABLE HR.CountryRegion
(
	CountryRegionCode nvarchar(3) NOT NULL,
	Name nvarchar(50) NOT NULL,
	CONSTRAINT PK_CountryRegion PRIMARY KEY (CountryRegionCode)
) ON [PRIMARY]
GO

-- Create Table HR.EmailAddress 
CREATE TABLE HR.EmailAddress
(
	PersonID int NOT NULL,
	EmailAddress nvarchar(50) NOT NULL,
	CONSTRAINT PK_EmailAddress PRIMARY KEY (PersonID, EmailAddress)
) ON [PRIMARY]
GO

-- Create Table HR.Person 
CREATE TABLE HR.Person
(
	PersonID int NOT NULL,
	PersonType nchar(2) NOT NULL,
	FirstName nvarchar(50) NOT NULL,
	MiddleName nvarchar(50) NULL,
	LastName nvarchar(50) NOT NULL,
	CONSTRAINT PK_Person PRIMARY KEY (PersonID)
) ON [PRIMARY]
GO

-- Create Table HR.PersonAddress 
CREATE TABLE HR.PersonAddress
(
	PersonID int NOT NULL,
	AddressID int NOT NULL,
	CONSTRAINT PK_PersonAddress PRIMARY KEY (PersonID, AddressID)
) ON [PRIMARY]
GO

-- Create Table HR.PersonPhone 
CREATE TABLE HR.PersonPhone
(
	PersonID int NOT NULL,
	PhoneNumber nvarchar(25) NOT NULL,
	CONSTRAINT PK_PersonPhone PRIMARY KEY (PersonID, PhoneNumber)
) ON [PRIMARY]
GO

-- Create Table HR.StateProvince 
CREATE TABLE HR.StateProvince
(
	StateProvinceID int NOT NULL,
	StateProvinceName nvarchar(50) NOT NULL,
	CountryRegionCode nvarchar(3) NOT NULL,
	CONSTRAINT PK_StateProvince PRIMARY KEY (StateProvinceID)
) ON [PRIMARY]
GO

-- Create Table Payment.EmployeePayHistory 
CREATE TABLE Payment.EmployeePayHistory
(
	PersonID int NOT NULL,
	RateChangeDate datetime NOT NULL,
	Rate money NOT NULL,
	PayFrequency tinyint NOT NULL,
	BankDetailsID int NOT NULL,
	ModifiedDate datetime NOT NULL,
	CONSTRAINT PK_EmployeePayHistory PRIMARY KEY (PersonID, RateChangeDate)
) ON [PRIMARY]
GO

-- Create Table Payment.BankDetails 
CREATE TABLE Payment.BankDetails
(
	BankDetailsID int NOT NULL,
	AccountNumber nvarchar(20),
	BankID int NOT NULL,
	CONSTRAINT PK_BankDetails PRIMARY KEY (BankDetailsID)
) ON [PRIMARY]
GO

-- Create Table Payment.Bank 
CREATE TABLE Payment.Bank
(
	BankID int NOT NULL,
	Name varchar(50) NOT NULL,
	AddressID int NOT NULL,
	CONSTRAINT PK_Bank PRIMARY KEY (BankID)
) ON [PRIMARY]
GO


ALTER TABLE HR.Employee ADD CONSTRAINT FK_Employee_Person FOREIGN KEY (PersonID)
REFERENCES HR.Person (PersonID)
GO

ALTER TABLE HR.Employee ADD CONSTRAINT FK_Employee_EmergencyContact FOREIGN KEY (EmergencyContactID)
REFERENCES HR.EmergencyContact (PersonID)
GO

ALTER TABLE HR.EmployeeDepartmentHistory ADD CONSTRAINT FK_EmployeeDepartmentHistory_Department FOREIGN KEY (DepartmentID)
REFERENCES HR.Department (DepartmentID)
GO

ALTER TABLE HR.EmployeeDepartmentHistory ADD CONSTRAINT FK_EmployeeDepartmentHistory_Employee FOREIGN KEY (PersonID)
REFERENCES HR.Employee (PersonID)
GO

ALTER TABLE HR.EmployeeDepartmentHistory ADD CONSTRAINT FK_EmployeeDepartmentHistory_Shift FOREIGN KEY (ShiftID)
REFERENCES HR.[Shift] (ShiftID)
GO

ALTER TABLE Payment.EmployeePayHistory ADD CONSTRAINT FK_EmployeePayHistory_Employee FOREIGN KEY (PersonID)
REFERENCES HR.Employee (PersonID)
GO

ALTER TABLE HR.[Address] ADD CONSTRAINT FK_Address_StateProvince FOREIGN KEY (StateProvinceID)
REFERENCES HR.StateProvince (StateProvinceID)
GO

ALTER TABLE HR.EmailAddress ADD CONSTRAINT FK_EmailAddress_Person FOREIGN KEY (PersonID)
REFERENCES HR.Person (PersonID)
GO

ALTER TABLE HR.PersonAddress ADD CONSTRAINT FK_PersonAddress_Address FOREIGN KEY (AddressID)
REFERENCES HR.[Address] (AddressID)
GO

ALTER TABLE HR.PersonAddress ADD CONSTRAINT FK_PersonAddress_Person FOREIGN KEY (PersonID)
REFERENCES HR.Person (PersonID)
GO

ALTER TABLE HR.PersonPhone ADD CONSTRAINT FK_PersonPhone_Person FOREIGN KEY (PersonID)
REFERENCES HR.Person (PersonID)
GO

ALTER TABLE HR.StateProvince ADD CONSTRAINT FK_StateProvince_CountryRegion FOREIGN KEY (CountryRegionCode)
REFERENCES HR.CountryRegion (CountryRegionCode)
GO

ALTER TABLE HR.EmergencyContact ADD CONSTRAINT FK_EmergencyContact_Person FOREIGN KEY (PersonID)
REFERENCES HR.Person (PersonID)
GO

ALTER TABLE Payment.BankDetails ADD CONSTRAINT FK_BankDetails_Bank FOREIGN KEY (BankID)
REFERENCES Payment.Bank (BankID)
GO

ALTER TABLE Payment.Bank ADD CONSTRAINT FK_Bank_Address FOREIGN KEY (AddressID)
REFERENCES HR.[Address] (AddressID)
GO

ALTER TABLE Payment.EmployeePayHistory ADD CONSTRAINT FK_EmployeePayHistory_BankDetails FOREIGN KEY (BankDetailsID)
REFERENCES Payment.BankDetails (BankDetailsID)
GO

