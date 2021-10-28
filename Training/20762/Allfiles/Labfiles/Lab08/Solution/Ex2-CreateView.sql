USE AdventureWorks2016CTP3;
GO

CREATE VIEW Sales.NewCustomer
AS
SELECT CustomerID, FirstName, LastName 
FROM Sales.CustomerPII;
GO
