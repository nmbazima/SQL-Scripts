-- Module 17 Demonstration 2 File 2

-- Query 1 take an exclusive lock on a single row in Sales.SalesTerritory, inside a transaction
USE AdventureWorks;
GO
BEGIN TRANSACTION 
	SELECT * FROM AdventureWorks.Sales.SalesTerritory WITH (XLOCK)
	WHERE TerritoryID = 3 

-- Query 2
ROLLBACK
