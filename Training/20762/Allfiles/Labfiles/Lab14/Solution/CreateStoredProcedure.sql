USE AdventureWorks;
GO

CREATE PROCEDURE Production.GetAvailableModelsAsXML
AS BEGIN
  SELECT p.ProductID,
         p.Name as ProductName,
         p.ListPrice,
         p.Color,
         p.SellStartDate, 
         pm.ProductModelID,
         pm.Name as ProductModel
  FROM Production.Product AS p
  INNER JOIN Production.ProductModel AS pm
  ON p.ProductModelID = pm.ProductModelID 
  WHERE p.SellStartDate IS NOT NULL
  AND p.SellEndDate IS NULL
  ORDER BY p.SellStartDate, p.Name DESC
  FOR XML RAW('AvailableModel'), ROOT('AvailableModels');
END;
GO

EXEC Production.GetAvailableModelsAsXML;
GO
