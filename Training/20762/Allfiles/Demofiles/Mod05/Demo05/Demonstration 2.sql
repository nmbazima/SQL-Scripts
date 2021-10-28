-- Demonstration 2

-- Step 1: Open a new query window against the tempdb database
USE tempdb;
GO


-- Step 2: Create a table with a primary key specified
CREATE TABLE dbo.PhoneLog
( PhoneLogID int IDENTITY(1,1) PRIMARY KEY,
  LogRecorded datetime2 NOT NULL,
  PhoneNumberCalled nvarchar(100) NOT NULL,
  CallDurationMs int NOT NULL
);
GO


-- Step 3: Query sys.indexes to view the structure
-- (note also the name chosen by SQL Server for the constraint and index)
-- In the GUI expand Databases, System Databases, tempdb, Tables, dbo.PhoneLog, and Indexes
-- Show that even though no clustered index was specified, one was created automatically
SELECT * FROM sys.indexes WHERE OBJECT_NAME(object_id) = N'PhoneLog';
GO
SELECT * FROM sys.key_constraints WHERE OBJECT_NAME(parent_object_id) = N'PhoneLog';
GO


-- Step 4: Insert some data into the table
SET NOCOUNT ON;

INSERT dbo.PhoneLog (LogRecorded, PhoneNumberCalled, CallDurationMs)
    VALUES(SYSDATETIME(),'999-9999',CAST(RAND() * 1000 AS int))
GO 100000 --insert dummy data, 100,000 times


-- Step 5: Check the level of fragmentation via sys.dm_db_index_physical_stats
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('dbo.PhoneLog'),NULL,NULL,'DETAILED');
GO


-- Step 6: Note the avg_fragmentation_in_percent and avg_page_space_used_in_percent


-- Step 7: Modify the data in the table - this will increase data and cause page fragmentation
-- (note how much more quickly this command runs)
SET NOCOUNT ON;

DECLARE @Counter int = 0;

WHILE @Counter < 100000 BEGIN
  UPDATE dbo.PhoneLog SET PhoneNumberCalled = REPLICATE('9',CAST(RAND() * 100 AS int))
    WHERE PhoneLogID = @Counter % 100000;
  IF @Counter % 100 = 0 PRINT @Counter;
  SET @Counter += 1;
END;
GO


-- Step 8: Check the level of fragmentation via sys.dm_db_index_physical_stats
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('dbo.PhoneLog'),NULL,NULL,'DETAILED');
GO

-- Step 9: Note the avg_fragmentation_in_percent and avg_page_space_used_in_percent


-- Step 10: Rebuild the table and its indexes
ALTER INDEX ALL ON dbo.PhoneLog REBUILD;
GO


-- Step 11: Check the level of fragmentation via sys.dm_db_index_physical_stats
SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),OBJECT_ID('dbo.PhoneLog'),NULL,NULL,'DETAILED');
GO


-- Step 12: Note the avg_fragmentation_in_percent and avg_page_space_used_in_percent


-- Step 13: Run a query showing the execution plan (CTR+M)
SELECT [PhoneLogID]
      ,[LogRecorded]
      ,[PhoneNumberCalled]
      ,[CallDurationMs]
	  ,p.Name
  FROM [tempdb].[dbo].[PhoneLog] pl join [AdventureWorks].[Production].Product p
  ON pl.CallDurationMs = p.ProductID
GO

-- Step 14: Create a covering index, point out the columns included
CREATE NONCLUSTERED INDEX NCIX_CallDurationMS
ON [dbo].[PhoneLog] ([CallDurationMs])
INCLUDE ([PhoneLogID],[LogRecorded],[PhoneNumberCalled])
GO

-- Step 15: Run the query showing the execution plan (CTR+M) - it now uses the new index
SELECT [PhoneLogID]
      ,[LogRecorded]
      ,[PhoneNumberCalled]
      ,[CallDurationMs]
	  ,p.Name
  FROM [tempdb].[dbo].[PhoneLog] pl join [AdventureWorks].[Production].Product p
  ON pl.CallDurationMs = p.ProductID
GO

-- Step 16: Drop the table
DROP TABLE dbo.PhoneLog;
GO

