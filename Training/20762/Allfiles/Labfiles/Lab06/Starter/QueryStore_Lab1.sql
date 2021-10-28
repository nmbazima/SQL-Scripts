-- QueryStore_Lab1

-- Use the AdventureWorks2016 database

USE AdventureWorks2016;
GO

--------------------------------------------------------------------------------
-- Create indexed view
--------------------------------------------------------------------------------

IF OBJECT_ID(N'dbo.vw_TransactionHistorySummary', N'V') IS NOT NULL
	DROP VIEW dbo.vw_TransactionHistorySummary;
GO

CREATE VIEW dbo.vw_TransactionHistorySummary
	WITH SCHEMABINDING
	AS
		SELECT ProductID, SUM(Quantity) AS 'Quantity', COUNT_BIG(*) AS 'Count'
			FROM Production.TransactionHistory
			GROUP BY ProductID;
GO

CREATE UNIQUE CLUSTERED INDEX ix_TransactionHistorySummary
	ON dbo.vw_TransactionHistorySummary(ProductID);
GO


--------------------------------------------------------------------------------
-- Clear the Query Store
--------------------------------------------------------------------------------

ALTER DATABASE AdventureWorks2016
	SET QUERY_STORE CLEAR;


--------------------------------------------------------------------------------
-- Run a select query six times
--------------------------------------------------------------------------------

SELECT C.Name AS 'ProductCategory', S.Name AS 'ProductSubcategory', P.ProductNumber, P.Name AS 'ProductName', T.Quantity
	FROM Production.ProductCategory AS C
		INNER JOIN Production.ProductSubcategory AS S
			ON S.ProductCategoryID = C.ProductCategoryID
		INNER JOIN Production.Product AS P
			ON P.ProductSubcategoryID = S.ProductSubcategoryID
		INNER JOIN dbo.vw_TransactionHistorySummary AS T
			ON T.ProductID = P.ProductID;


--------------------------------------------------------------------------------
-- Update the statistics with fake figures
--------------------------------------------------------------------------------

UPDATE STATISTICS dbo.vw_TransactionHistorySummary
	WITH ROWCOUNT = 60000000, PAGECOUNT = 10000000;



-- Run the select query again, two more times

-- Examine the Top Resource Consuming Queries report

-- Force the plan to use the original, more efficient, plan

-- Run the select query again, three more times


