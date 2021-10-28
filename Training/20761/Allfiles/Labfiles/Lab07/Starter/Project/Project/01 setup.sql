USE TempDB
GO

-- Setup exercise environment

CREATE SCHEMA Hr
GO
CREATE SCHEMA Sales
GO

-- Note that there is a much more efficient way, as above, of deleting exisitng objects in SQL Server 2016. 
-- However one often needs to get meta data information from the Information_Schema so both 
-- methods are useful to know about. The alternative method is used in the 99 Cleanup script,
-- which can be used at the end of this lab or if you want to restart part way through.

IF EXISTS (	SELECT * 
			FROM INFORMaTION_SCHEMA.TABLES 
			WHERE TABLE_NAME = 'Employees'
			AND TABLE_SCHEMA = 'Hr' 
			AND TABLE_CATALOG = 'AdventureWorks2016CTP3' )
			DROP TABLE Hr.Employees 
GO

SELECT * INTO hr.employees FROM TSQL.hr.Employees;
GO

IF EXISTS (	SELECT * 
			FROM INFORMaTION_SCHEMA.TABLES 
			WHERE TABLE_NAME = 'Customers'
			AND TABLE_SCHEMA = 'sales' 
			AND TABLE_CATALOG = 'AdventureWorks2016CTP3' ) 
			DROP TABLE AdventureWorks2016CTP3.sales.Customers; 
GO


SELECT * INTO sales.Customers from TSQL.Sales.Customers
WHERE contactname NOT IN (
'Taylor, Maurice',
'Mallit, Ken',
'Tiano, Mike');
GO

IF EXISTS (	SELECT * 
			FROM INFORMaTION_SCHEMA.TABLES 
			WHERE TABLE_NAME = 'PotentialCustomers'
			AND TABLE_SCHEMA = 'dbo' 
			AND TABLE_CATALOG = 'AdventureWorks2016CTP3' ) 
			DROP TABLE AdventureWorks2016CTP3.dbo.PotentialCustomers; 
GO

SELECT * INTO dbo.PotentialCustomers from TSQL.Sales.Customers
WHERE contactname IN (
'Taylor, Maurice',
'Mallit, Ken',
'Tiano, Mike');
GO

