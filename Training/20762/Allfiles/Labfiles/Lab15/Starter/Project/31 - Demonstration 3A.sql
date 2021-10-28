-- Demonstration 3A

-- Step 1 - Open a new query window to the AdventureWorks database

USE AdventureWorks;
GO

ALTER TABLE Person.Address ADD SpatialLocation geography;
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

SELECT c.ContactID,
       c.FirstName,
       c.LastName,
       a.SpatialLocation.STDistance(@NewYork) / 1000 AS DistanceKms
FROM Person.Contact AS c
INNER JOIN Sales.SalesPerson AS sp
ON c.ContactID = sp.SalesPersonID 
INNER JOIN HumanResources.EmployeeAddress AS ea
ON c.ContactID = ea.EmployeeID 
INNER JOIN Person.Address AS a
ON ea.AddressID = a.AddressID 
WHERE (a.SpatialLocation.STDistance(@NewYork) / 1000) < 500
ORDER BY DistanceKms;
GO

-- Step 3 - Which two salespeople live the closest together?

WITH SalesPersonLocation
AS ( SELECT c.ContactID,
            c.FirstName,
            c.LastName,
            a.SpatialLocation
     FROM Person.Contact AS c
     INNER JOIN Sales.SalesPerson AS sp
     ON c.ContactID = sp.SalesPersonID 
     INNER JOIN HumanResources.EmployeeAddress AS ea
     ON sp.SalesPersonID = ea.EmployeeID 
     INNER JOIN Person.Address AS a
     ON ea.AddressID = a.AddressID
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
 WHERE sp1.ContactID <> sp2.ContactID 
 ORDER BY DistanceKms;

GO
