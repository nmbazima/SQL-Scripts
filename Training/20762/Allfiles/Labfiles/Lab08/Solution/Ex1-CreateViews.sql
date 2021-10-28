USE AdventureWorks2016CTP3;
GO

CREATE VIEW
Production.OnlineProducts
AS
SELECT p.ProductID, p.Name, p.ProductNumber AS [Product Number], COALESCE(p.Color, 'N/A') AS Color,
CASE p.DaysToManufacture
WHEN 0 THEN 'In stock' 
WHEN 1 THEN 'Overnight'
WHEN 2 THEN '2 to 3 days delivery'
ELSE 'Call us for a quote'
END AS Availability,
p.Size, p.SizeUnitMeasureCode AS [Unit of Measure], p.ListPrice AS Price, p.Weight
FROM Production.Product AS p
WHERE p.SellEndDate IS NULL AND p.SellStartDate IS NOT NULL;
GO


USE AdventureWorks2016CTP3;
GO

CREATE VIEW
Production.AvailableModels
AS
SELECT p.ProductID AS [Product ID], p.Name, pm.ProductModelID AS [Product Model ID], pm.Name as [Product Model]
FROM Production.Product AS p
INNER JOIN Production.ProductModel AS pm
ON p.ProductModelID = pm.ProductModelID
WHERE p.SellEndDate IS NULL
AND p.SellStartDate IS NOT NULL;
GO
