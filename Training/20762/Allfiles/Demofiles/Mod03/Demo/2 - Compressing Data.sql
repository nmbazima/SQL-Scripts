-- Demonstration 2 - Compressing Data

-- Step 1 - Connect to AdventureWorks
-- Select and execute the following query to connect to the AdventureWorks database
USE AdventureWorks2016;
GO



-- Step 2: Determine if a Table is Worth Compressing
-- Select and execute the following query to run the sp_estimate_data_compression_savings 
-- Highlight that the size_with_current_compression_setting shows the current size of the indexes
-- Point out the size_with_requested_compression_setting column values showing the estimated size after applying ROW compression
EXEC sp_estimate_data_compression_savings 'Sales', 'SalesOrderDetail', NULL, NULL, 'ROW';



-- Step 3: Set the Compression to ROW
-- Select and execute the following query to set the compression level to ROW 
ALTER TABLE Sales.SalesOrderDetail REBUILD PARTITION = ALL
WITH (DATA_COMPRESSION = ROW); 
GO



-- Step 4: Determine if the Table Can be Further Compressed
-- Select and execute the following query to run the sp_estimate_data_compression_savings 
-- Highlight that the size_with_current_compression_setting shows the current size of the indexes with ROW compression
-- Point out the size_with_requested_compression_setting column values showing the estimated size after applying PAGE compression
-- The results show that the indexes with an id of 1 and 3, could be further compressed using PAGE compression 
EXEC sp_estimate_data_compression_savings 'Sales', 'SalesOrderDetail', NULL, NULL, 'PAGE';



-- Step 5: Rebuild Indexes 1 and 3
-- Select and execute the following query to rebuild the indexes to use PAGE compression
ALTER INDEX PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID ON Sales.SalesOrderDetail REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);
GO
ALTER INDEX IX_SalesOrderDetail_ProductID ON Sales.SalesOrderDetail REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);
GO



-- Step 6: Re-Run the Data Compression Estimatio DMV
-- Select and execute the following query to re-run the sp_estimate_data_compression_savings DMV
-- Point out that the values in the size_with_current_compression_setting have now been reduced
EXEC sp_estimate_data_compression_savings 'Sales', 'SalesOrderDetail', NULL, NULL, 'PAGE';