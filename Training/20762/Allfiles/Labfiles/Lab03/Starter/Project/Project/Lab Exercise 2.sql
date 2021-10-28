-- Module 3 - Lab Exercise 2 - Implement the Partitioning Strategy


-- Create filegroups
USE HumanResources;
GO
ALTER DATABASE HumanResources ADD FILEGROUP FG0
GO
ALTER DATABASE HumanResources ADD FILE (NAME = F0, FILENAME = 'D:\Labfiles\Lab03\Starter\SetupFiles\F0.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG0;
GO
ALTER DATABASE HumanResources ADD FILEGROUP FG1
GO
ALTER DATABASE HumanResources ADD FILE (NAME = F1, FILENAME = 'D:\Labfiles\Lab03\Starter\SetupFiles\F1.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG1;
GO
ALTER DATABASE HumanResources ADD FILEGROUP FG2
GO
ALTER DATABASE HumanResources ADD FILE (NAME = F2, FILENAME = 'D:\Labfiles\Lab03\Starter\SetupFiles\F2.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG2;
GO
ALTER DATABASE HumanResources ADD FILEGROUP FG3
GO
ALTER DATABASE HumanResources ADD FILE (NAME = F3, FILENAME = 'D:\Labfiles\Lab03\Starter\SetupFiles\F3.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG3;
GO


-- Create partition function
CREATE PARTITION FUNCTION pfHumanResourcesDates (datetime) 
AS RANGE RIGHT 
FOR VALUES ('2011-10-01 00:00','2012-01-01 00:00','2012-04-01 00:00');


-- Create partition scheme
CREATE PARTITION SCHEME psHumanResources 
AS PARTITION pfHumanResourcesDates TO (FG0, FG1, FG2, FG3);


-- Create the Timesheet table
CREATE TABLE Payment.Timesheet
(
	PersonID int NOT NULL,
	ShiftID tinyint NOT NULL,
	RegisteredStartTime datetime NOT NULL,
	RegisteredEndTime datetime NOT NULL,
	CONSTRAINT PK_Timesheet_PersonID_ShiftID_ResgisteredStartTime PRIMARY KEY (PersonID ASC, ShiftID ASC, RegisteredStartTime)
) ON psHumanResources(RegisteredStartTime);
GO


--Insert data into Timesheet table
INSERT INTO Payment.Timesheet
VALUES (28,1, '2011-11-23 07:00', '2011-11-23 15:00');
GO
INSERT INTO Payment.Timesheet
VALUES (28,1, '2011-11-25 07:00', '2011-11-25 15:00');
GO
INSERT INTO Payment.Timesheet
VALUES (28,1, '2012-02-21 07:00', '2012-02-21 15:00');
GO
INSERT INTO Payment.Timesheet
VALUES (28,1, '2012-02-23 07:00', '2012-02-23 15:00');
GO