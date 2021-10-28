-- Demonstration 4

-- Step 1 - Open a new query window to the AdventureWorks database

USE AdventureWorks;
GO

-- Step 2 - Execute RAW mode queries

SELECT ProductModelID, Name
FROM Production.ProductModel
WHERE ProductModelID=122 or ProductModelID=119
FOR XML RAW;
GO
SELECT ProductModelID, Name
FROM Production.ProductModel
WHERE ProductModelID=122 or ProductModelID=119
FOR XML RAW('Model');
GO
SELECT ProductModelID, Name
FROM Production.ProductModel
WHERE ProductModelID=122 or ProductModelID=119
FOR XML RAW('Model'), ROOT('Models');
GO

-- Step 3 - Execute an AUTO mode query

SELECT pm.ProductModelID, pm.Name AS ProductModel,
       p.Name AS ProductName
FROM Production.ProductModel AS pm
INNER JOIN Production.Product AS p
ON pm.ProductModelID = p.ProductModelID 
WHERE pm.ProductModelID=122 or pm.ProductModelID=119
FOR XML AUTO;

-- Step 4 - Execute an EXPLICIT mode query

SELECT 1 AS Tag, NULL AS Parent,
       ProductID AS [Product!1!ProductID],
       Color AS [Product!1!Color!Element]
FROM Production.Product 
ORDER BY ProductID
FOR XML EXPLICIT;
GO

-- Step 5 - Execute PATH mode queries (and compare the queries and output)

SELECT ProductModelID,
       Name
FROM Production.ProductModel
WHERE ProductModelID IN (119,122)
FOR XML PATH ('ProductModel');
GO
SELECT ProductModelID AS "@ProductModelID",
       Name
FROM Production.ProductModel
WHERE ProductModelID IN (119,122)
FOR XML PATH ('ProductModel');
GO

-- Step 6 - Execute the following query (that uses TYPE)

SELECT Customer.CustomerID, Customer.TerritoryID, 
       (SELECT SalesOrderID, [Status]
        FROM Sales.SalesOrderHeader AS soh
        WHERE Customer.CustomerID = soh.CustomerID
        FOR XML AUTO, TYPE) as Orders
FROM Sales.Customer as Customer
WHERE EXISTS
  (SELECT 1 FROM Sales.SalesOrderHeader AS soh
   WHERE soh.CustomerID = Customer.CustomerID)				
ORDER BY Customer.CustomerID;

-- Step 7 - Now show the same query without the TYPE to highlight the difference

SELECT Customer.CustomerID, Customer.TerritoryID, 
       (SELECT SalesOrderID, soh.Status
        FROM Sales.SalesOrderHeader AS soh
        WHERE soh.CustomerID = Customer.CustomerID 
        FOR XML AUTO) as Orders
FROM Sales.Customer as Customer
WHERE EXISTS
  (SELECT 1 FROM Sales.SalesOrderHeader AS soh
   WHERE soh.CustomerID = Customer.CustomerID)	 				
ORDER BY Customer.CustomerID;




