-- Demonstration 2B - AFTER DELETE Triggers

-- Step A: Open a new query window 
--         and use the AdventureWorks database

USE AdventureWorks;
GO

-- Step B: Show the contents of the Sales.SalesTerritoryHistory table 
--         (highlighting the nullable EndDate column)

SELECT * FROM Sales.SalesTerritoryHistory;
GO

-- Step C: Create a trigger to disallow deletion of active history rows

CREATE TRIGGER TR_SalesTerritoryHistory_Delete
ON Sales.SalesTerritoryHistory
AFTER DELETE AS BEGIN
  IF EXISTS(SELECT 1
            FROM deleted AS d
            WHERE d.EndDate IS NULL) BEGIN
    PRINT 'Current Sales Territory History rows cannot be deleted';
    ROLLBACK;
  END;
END;
GO

-- Step D: Test the trigger by attempting to delete a row
--         (the delete will fail)

SELECT * FROM Sales.SalesTerritoryHistory WHERE BusinessEntityID = 283;
GO

DELETE FROM Sales.SalesTerritoryHistory 
WHERE BusinessEntityID = 283;
GO

-- Step E: Drop the trigger
DROP TRIGGER Sales.TR_SalesTerritoryHistory_Delete;
GO

