-- Demonstration 2A - AFTER INSERT Triggers

-- Step A: Open a new query window 
--         and use the AdventureWorks database

USE AdventureWorks;
GO

-- Step B: Create an INSERT trigger

CREATE TRIGGER TR_SalesOrderHeader_Insert
ON Sales.SalesOrderHeader
AFTER INSERT AS BEGIN
  IF EXISTS( SELECT 1 
             FROM inserted AS i
             WHERE i.SubTotal > 10000
             AND i.PurchaseOrderNumber IS NULL
           ) BEGIN
    PRINT 'Orders above 10000 must have PO numbers';
    ROLLBACK;           
  END;
END;
GO

-- Step C: Execute the following code to test the trigger 
--         (first try to insert with a value more than 10000 
--         but with a PO number)

INSERT INTO Sales.SalesOrderHeader 
  (RevisionNumber, OrderDate, DueDate, Status, 
   OnlineOrderFlag, PurchaseOrderNumber,
   CustomerID, SalespersonID, BillToAddressID, ShipToAddressID, 
   ShipMethodID, SubTotal, TaxAmt, Freight)
  VALUES (1, SYSDATETIME(), SYSDATETIME(), 1,
          1, 'ABC-123',
          4, 274, 3, 3,
          1, 10502, 12, 100);
GO

-- Step D: Try to insert with a value less than 10000 
--         and without a PO number (will work)

INSERT INTO Sales.SalesOrderHeader 
  (RevisionNumber, OrderDate, DueDate, Status, 
   OnlineOrderFlag, PurchaseOrderNumber,
   CustomerID, SalespersonID, BillToAddressID, ShipToAddressID, 
   ShipMethodID, SubTotal, TaxAmt, Freight)
  VALUES (1, SYSDATETIME(), SYSDATETIME(), 1,
          1, NULL,
          4, 274, 3, 3,
          1, 8000, 12, 100);
GO

-- Step E: Try to insert without a purchase order number 
--         but with a value more than 10000 (will fail)

INSERT INTO Sales.SalesOrderHeader 
  (RevisionNumber, OrderDate, DueDate, Status, 
   OnlineOrderFlag, PurchaseOrderNumber,
   CustomerID, SalespersonID, BillToAddressID, ShipToAddressID, 
   ShipMethodID, SubTotal, TaxAmt, Freight)
  VALUES (1, SYSDATETIME(), SYSDATETIME(), 1,
          1, NULL,
          4, 274, 3, 3,
          1, 18000, 12, 100);
GO

-- Step F: Drop the trigger and remove the rows added

DROP TRIGGER Sales.TR_SalesOrderHeader_Insert;
GO

DELETE soh 
FROM Sales.SalesOrderHeader AS soh
WHERE NOT EXISTS (SELECT 1
                  FROM Sales.SalesOrderDetail AS sod
                  WHERE soh.SalesOrderID = sod.SalesOrderID);
GO


