-- Demonstration D

-- Step 1: Open a new query window to the TSQL database
USE TSQL;
GO


--Step 2: Using EXEC to execute dynamic SQL
DECLARE @sqlstring AS VARCHAR(1000);
SET @sqlstring='SELECT empid, lastname FROM HR.employees;'
EXEC(@sqlstring);
GO


-- Step 3: Using sys.sp_executesql to execute dynamic SQL
-- Simple example with no parameters
DECLARE @sqlcode AS NVARCHAR(256) = N'SELECT GETDATE() AS dt';
EXEC sys.sp_executesql @statement = @sqlcode;
GO


-- Step 4: Example with a single input parameter
DECLARE @sqlstring AS NVARCHAR(1000);
DECLARE @empid AS INT;
SET @sqlstring=N'
	SELECT empid, lastname 
	FROM HR.employees
	WHERE empid=@empid;'
EXEC sys.sp_executesql 
	@statement = @sqlstring,
	@params=N'@empid AS INT',
	@empid = 5;
GO
