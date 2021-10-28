---------------------------------------------------------------------
-- LAB 18
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------
SELECT empid, lastname, firstname
FROM HR.Employees
ORDER BY empid DESC;

GO

BEGIN TRAN;

INSERT INTO HR.Employees (lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city, region, postalcode, country, phone, mgrid)
VALUES (N'Johnson', N'Test 1', N'Sales Manager', N'Mr.', '19700101', '20110101', N'Some Address 18', N'Ljubljana', NULL, N'1000', N'Slovenia', N'(386) 113322', 2);

INSERT INTO HR.Employees (lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city, region, postalcode, country, phone, mgrid)
VALUES (N'Robertson', N'Test 2', N'Sales Representative', N'Mr.', '19850101', '10110601', N'Some Address 22', N'Ljubljana', NULL, N'1000', N'Slovenia', N'(386) 553344', 10);

COMMIT TRAN;

GO
---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

DELETE HR.Employees
WHERE empid IN (10, 11);
DBCC CHECKIDENT ('HR.Employees', RESEED, 9);

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

BEGIN TRY 

	BEGIN TRAN;
	
	INSERT INTO HR.Employees (lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city, region, postalcode, country, phone, mgrid)
	VALUES (N'Johnson', N'Test 1', N'Sales Manager', N'Mr.', '19700101', '20110101', N'Some Address 18', N'Ljubljana', NULL, N'1000', N'Slovenia', N'(386) 113322', 2);

	INSERT INTO HR.Employees (lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city, region, postalcode, country, phone, mgrid)
	VALUES (N'Robertson', N'Test 2', N'Sales Representative', N'Mr.', '19850101', '10110601', N'Some Address 22', N'Ljubljana', NULL, N'1000', N'Slovenia', N'(386) 553344', 10);

	PRINT 'Commit the transaction...';
	COMMIT TRAN;

END TRY
BEGIN CATCH

	IF @@TRANCOUNT > 0
	BEGIN
		PRINT 'Rollback the transaction...';
		ROLLBACK TRAN;
	END

END CATCH;

GO

SELECT empid, lastname, firstname
FROM HR.Employees
ORDER BY empid DESC;

GO

---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

DBCC CHECKIDENT ('HR.Employees', RESEED, 9);
