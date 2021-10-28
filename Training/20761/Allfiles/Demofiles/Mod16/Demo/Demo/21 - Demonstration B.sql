-- Demonstration B

-- Step 1: Open a new query window to the TSQL database
USE TSQL;
GO


-- Step 2: Control of Flow
--IF..ELSE

IF OBJECT_ID('Production.ProdsByCategory','P') IS NULL
	PRINT 'Object does not exist';
ELSE
	DROP PROC Production.ProdsByCategory;
GO


-- Step 3: Examples from workbook
USE TSQL;
GO
IF OBJECT_ID('HR.Employees') IS NULL
BEGIN
	PRINT 'The specified object does not exist';
END;

IF OBJECT_ID('HR.Employees') IS NULL
BEGIN
	PRINT 'The specified object does not exist';
END
ELSE
BEGIN
	PRINT 'The specified object exists';
END;


-- Step 4: Demonstrate IF EXIST
IF EXISTS (SELECT * FROM Sales.EmpOrders WHERE empid =5)
	BEGIN
		PRINT 'Employee has associated orders';
	END;
GO


-- Step 5: WHILE
DECLARE @empid AS INT, @lname AS NVARCHAR(20);
SET @empid = 1
WHILE @empid <=5
	BEGIN
		SELECT @lname = lastname FROM HR.Employees
			WHERE empid = @empid;
		PRINT @lname;
		SET @empid += 1;
	END;