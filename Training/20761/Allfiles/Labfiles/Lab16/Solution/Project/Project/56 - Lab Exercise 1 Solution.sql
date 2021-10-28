---------------------------------------------------------------------
-- LAB 16
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------
DECLARE @num int = 5;

SELECT @num AS mynumber;

GO

DECLARE 
	@num1 int,
	@num2 int;

SET @num1 = 4;
SET @num2 = 6;

SELECT @num1 + @num2 AS totalnum;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

DECLARE @empname nvarchar(30);

SET @empname = (SELECT firstname + N' ' + lastname FROM HR.Employees WHERE empid = 1);

SELECT @empname AS employee;

GO
---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

DECLARE 
	@empname nvarchar(30),
	@empid int;

SET @empid = 5;

SET @empname = (SELECT firstname + N' ' + lastname FROM HR.Employees WHERE empid = @empid);

SELECT @empname AS employee;

GO
---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------
	
DECLARE 
	@empname nvarchar(30),
	@empid int;

SET @empid = 5;

SET @empname = (SELECT firstname + N' ' + lastname FROM HR.Employees WHERE empid = @empid);

GO

SELECT @empname AS employee;

