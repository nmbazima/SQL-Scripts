-- Test_StringAggregate


USE AdventureWorks2014;
GO


--------------------------------------------------------------------------------
-- Nice simple test
--------------------------------------------------------------------------------

SELECT Name
	FROM (VALUES (N'Alpha'),
				(N'Bravo'),
				(N'Charlie')) AS X (Name);


SELECT dbo.StringAggregate(Name) AS 'AggregatedName'
	FROM (VALUES (N'Alpha'),
				(N'Bravo'),
				(N'Charlie')) AS X (Name);



--------------------------------------------------------------------------------
-- Starter query
-- So we can see how the query works without any grouping
-------------------------------------------------------------------------------

WITH CustomerCategory_CTE AS
(
	SELECT H.CustomerID, PC.Name AS Category
		FROM Sales.SalesOrderHeader AS H
			INNER JOIN Sales.SalesOrderDetail AS D
				ON D.SalesOrderID = H.SalesOrderID
			INNER JOIN Production.Product AS X
				ON X.ProductID = D.ProductID
			INNER JOIN Production.ProductSubcategory AS PS
				ON PS.ProductSubcategoryID = X.ProductSubcategoryID
			INNER JOIN Production.ProductCategory AS PC
				ON PC.ProductCategoryID = PS.ProductCategoryID
		GROUP BY H.CustomerID, PC.Name
)

SELECT P.BusinessEntityID, CONCAT(P.FirstName + N' ', P.MiddleName + N' ', P.LastName) AS PersonName, CC.Category
	FROM CustomerCategory_CTE AS CC
		INNER JOIN Sales.Customer AS C
			ON C.CustomerID = CC.CustomerID
		INNER JOIN Person.Person AS P
			ON P.BusinessEntityID = C.PersonID
	ORDER BY P.LastName, P.FirstName, P.BusinessEntityID;



--------------------------------------------------------------------------------
-- Test StringAggregate
-------------------------------------------------------------------------------

WITH CustomerCategory_CTE AS
(
	SELECT H.CustomerID, PC.Name AS Category
		FROM Sales.SalesOrderHeader AS H
			INNER JOIN Sales.SalesOrderDetail AS D
				ON D.SalesOrderID = H.SalesOrderID
			INNER JOIN Production.Product AS X
				ON X.ProductID = D.ProductID
			INNER JOIN Production.ProductSubcategory AS PS
				ON PS.ProductSubcategoryID = X.ProductSubcategoryID
			INNER JOIN Production.ProductCategory AS PC
				ON PC.ProductCategoryID = PS.ProductCategoryID
		GROUP BY H.CustomerID, PC.Name
)

SELECT P.BusinessEntityID, CONCAT(P.FirstName + N' ', P.MiddleName + N' ', P.LastName) AS PersonName, dbo.StringAggregate(CC.Category) AS Categories
	FROM CustomerCategory_CTE AS CC
		INNER JOIN Sales.Customer AS C
			ON C.CustomerID = CC.CustomerID
		INNER JOIN Person.Person AS P
			ON P.BusinessEntityID = C.PersonID
	GROUP BY P.BusinessEntityID, P.FirstName, P.MiddleName, P.LastName
	ORDER BY P.LastName, P.FirstName, P.BusinessEntityID;



