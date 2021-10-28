---------------------------------------------------------------------
-- LAB 16
--
-- Exercise 3
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

DECLARE @SQLstr nvarchar(200);

SET @SQLstr = N'SELECT empid, firstname, lastname FROM HR.Employees';

EXECUTE sys.sp_executesql @statement = @SQLstr;

GO
---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

DECLARE 
	@SQLstr nvarchar(200),
	@SQLparam nvarchar(100);

SET @SQLstr = N'SELECT empid, firstname, lastname FROM HR.Employees WHERE empid = @empid';
SET @SQLparam = N'@empid int';

EXECUTE sys.sp_executesql @statement = @SQLstr, @params = @SQLparam, @empid = 5;

