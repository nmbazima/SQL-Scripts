-- Step 1: DO NOT RUN THE WHOLE SCRIPT, RUN EACH STEP INDIVIDUALLY
-- Display the execution plan (CTRL-M or click the GUI button), then execute the steps SQL, 
-- point to the final Table Scan to show I/O cost is approx 57. 
-- Point to the Hash Match (Aggregate) step - show the estimate execution mode is ROW.

USE AdventureworksDW

SET STATISTICS IO ON
GO

SELECT	ProductKey
		,SUM(UnitPrice) SumUnitPrice
		,AVG(UnitPrice) AvgUnitPrice
		,SUM(OrderQuantity) SumOrderQty
		,AVG(OrderQuantity) AvgOrderQty
		,SUM(TotalProductCost) SumTotalProductCost
		,AVG(TotalProductCost) AvgTotalProductCost
		,SUM(UnitPrice - TotalProductCost) ProductProfit
FROM dbo.FactInternetSales 
GROUP BY ProductKey
ORDER BY ProductKey
GO

SET STATISTICS IO OFF
GO

------------------ END OF STEP 1 ------------------


-- Step 2: DO NOT RUN THE WHOLE SCRIPT, RUN EACH STEP INDIVIDUALLY
-- Look and record the data column - this is the space used by the index and table
-- Clustered Index Scan and the Hash Match (Aggregate)

--Data space used: 615,584 KB
sp_spaceused 'dbo.FactInternetSales'
GO

------------------ END OF STEP 2 ------------------


-- Step 3: Replace the rowstore index with a columnstore
-- Look and record the data column - this is the space used by the new index and table
-- Highlight the massive space savings on this table
-- 
-- Re-run the Step 1 SQL and show the costs of:
-- Columnstore Index Scan I/O is now less than ~0.008 versus ~57 for rowstore
-- Hash Match (Aggregate) now execution mode is now BATCH

ALTER TABLE [dbo].[FactInternetSalesReason] DROP CONSTRAINT [FK_FactInternetSalesReason_FactInternetSales]
GO

ALTER TABLE [dbo].[FactInternetSalesReason] DROP CONSTRAINT [PK_FactInternetSalesReason_SalesOrderNumber_SalesOrderLineNumber_SalesReasonKey]
GO

ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber]
GO

CREATE CLUSTERED COLUMNSTORE INDEX PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber on [FactInternetSales] 
GO

--Data space used: 39,928 KB (15x smaller than the rowstore table!)
sp_spaceused 'dbo.FactInternetSales'
GO
