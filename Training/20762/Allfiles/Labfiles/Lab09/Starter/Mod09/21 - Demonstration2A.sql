-- Step 1 - Switch to the AdventureWorks database

USE AdventureWorks;
GO

-- Step 2 - Create the GetBlueProducts stored procedure

CREATE PROC Production.GetBlueProducts
AS
SET NOCOUNT ON;
BEGIN
  SELECT p.ProductID,
         p.Name,
         p.Size,
         p.ListPrice 
  FROM Production.Product AS p
  WHERE p.Color = N'Blue'
  ORDER BY p.ProductID;
END;
GO

-- Step 3 - Execute the GetBlueProducts stored procedure

EXEC Production.GetBlueProducts;
GO

-- Step 4 - Create the GetBlueProductsAndModels stored procedure

CREATE PROC Production.GetBlueProductsAndModels
AS
SET NOCOUNT ON;
BEGIN
  SELECT p.ProductID,
         p.Name,
         p.Size,
         p.ListPrice 
  FROM Production.Product AS p
  WHERE p.Color = N'Blue'
  ORDER BY p.ProductID;
  
  SELECT p.ProductID,
         pm.ProductModelID,
         pm.Name AS ModelName
  FROM Production.Product AS p
  INNER JOIN Production.ProductModel AS pm
  ON p.ProductModelID = pm.ProductModelID 
  ORDER BY p.ProductID, pm.ProductModelID;
END;
GO

-- Step 5 - Execute the GetBlueProductsAndModels stored procedure which returns multiple rowsets

EXEC Production.GetBlueProductsAndModels;
GO


-- Step 6 - Alter the procedure because the 2nd query does not show only blue products

ALTER PROC Production.GetBlueProductsAndModels
AS
SET NOCOUNT ON;
BEGIN
  SELECT p.ProductID,
         p.Name,
         p.Size,
         p.ListPrice 
  FROM Production.Product AS p
  WHERE p.Color = N'Blue'
  ORDER BY p.ProductID;
  
  SELECT p.ProductID,
         pm.ProductModelID,
         pm.Name AS ModelName
  FROM Production.Product AS p
  INNER JOIN Production.ProductModel AS pm
  ON p.ProductModelID = pm.ProductModelID 
  WHERE p.Color = N'Blue'
  ORDER BY p.ProductID, pm.ProductModelID;
END;
GO

-- Step 7 - And re-execute the GetBlueProductsAndModels stored procedure

EXEC Production.GetBlueProductsAndModels;
GO

-- Step 8 - Query sys.procedures to see the list of procedures

SELECT SCHEMA_NAME(schema_id) AS SchemaName,
       name AS ProcedureName
FROM sys.procedures;
GO