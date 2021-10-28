--10776A Module 2 Demonstration 4: rowversion Data Type

-- Step 1: Open a new query window to the tempdb database

USE tempdb;
GO

-- Step 2: Create and populate a table that uses the rowversion data type

CREATE TABLE dbo.Orders
( 
  OrderID int NOT NULL
    IDENTITY(1,1),
  OrderDate date NOT NULL,
  SalespersonID int NULL,
  Concurrency rowversion NOT NULL
);
GO

-- Step 3: Add 2 new rows to dbo.Opportunity

INSERT dbo.Orders (OrderDate)
VALUES (SYSDATETIME()),
       (SYSDATETIME());
GO
		   
-- Step 4: Show that the rowversion column was populated automatically 

SELECT * FROM dbo.Orders;		   
GO

-- Step 5: Try to update the rowversion column. This will fail as 
--         you cannot update a rowversion column directly. 

UPDATE dbo.Orders
  SET Concurrency = Concurrency +1
  WHERE OrderID =1;
GO

-- Step 6: Try to insert an explicit value for the rowversion column.
--         This will fail as you cannot insert into a rowversion
--         column directly.

INSERT dbo.Orders (OrderDate, Concurrency)
VALUES (SYSDATETIME(), 0x00000000000007E4);
GO

-- Step 7: Update another column for OrderID 1

SELECT * FROM dbo.Orders		   
WHERE OrderID = 1;

UPDATE dbo.Orders
  SET SalespersonID = 35 
  WHERE OrderID =1;

SELECT * FROM dbo.Orders		   
WHERE OrderID = 1;		   
GO

 
