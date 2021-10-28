-- Demonstration 3A

-- Step 1 - Open a new query window to the AdventureWorks database

USE AdventureWorks;
GO


UPDATE Person.Address SET SpatialLocation =
  geography::STGeomFromText(CASE AddressID WHEN 1 THEN 'POINT (-74.05 40)'
                                           WHEN 2 THEN 'POINT (-40 40)'
                                           WHEN 3 THEN 'POINT (-73 40.5)'
                            END,4326);
GO


-- Step 2 - Which salesperson is closest to New York?  

DECLARE @NewYork geography;
SET @NewYork = geography::STGeomFromText('POINT (-74.007339 40.726966)',4326);

SELECT c.BusinessEntityID,
       c.FirstName,
       c.LastName,
       a.SpatialLocation.STDistance(@NewYork) / 1000 AS DistanceKms
FROM Person.Person AS c
INNER JOIN Sales.SalesPerson AS sp
ON c.BusinessEntityID = sp.BusinessEntityID 
INNER JOIN Person.BusinessEntityAddress AS ea
ON c.BusinessEntityID = ea.BusinessEntityID 
INNER JOIN Person.Address AS a
ON ea.AddressID = a.AddressID 
WHERE (a.SpatialLocation.STDistance(@NewYork) / 1000) < 500
ORDER BY DistanceKms;
GO


-- Step 3 - Which two salespeople live the closest together?

WITH SalesPersonLocation
AS ( SELECT c.BusinessEntityID,
       c.FirstName,
       c.LastName,
       a.SpatialLocation
FROM Person.Person AS c
INNER JOIN Person.BusinessEntityAddress AS ea
ON c.BusinessEntityID = ea.BusinessEntityID 
INNER JOIN Person.Address AS a
ON ea.AddressID = a.AddressID 
WHERE a.SpatialLocation IS NOT NULL
   )
 SELECT TOP(1)
        sp1.FirstName, 
        sp1.LastName,
        sp2.FirstName,
        sp2.LastName,
        sp1.SpatialLocation.STDistance(sp2.SpatialLocation) / 1000
          AS DistanceKms
 FROM SalesPersonLocation AS sp1
 CROSS JOIN SalesPersonLocation AS sp2
 WHERE sp1.BusinessEntityID > sp2.BusinessEntityID 
 ORDER BY DistanceKms;
