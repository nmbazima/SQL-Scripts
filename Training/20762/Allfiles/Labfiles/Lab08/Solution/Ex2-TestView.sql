USE AdventureWorks2016CTP3;
GO

INSERT INTO Sales.NewCustomer
VALUES
(10001,'Ed', 'Kish'),
(10002, 'Kermit', 'Albritton');
GO

USE AdventureWorks2016CTP3;
GO

SELECT * FROM Sales.NewCustomer 
ORDER BY CustomerID
