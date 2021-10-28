-- ClusterVsHeap_lab

USE AdventureWorks2016;
GO

--------------------------------------------------------------------------------
-- Create a heap and a clustered index
--------------------------------------------------------------------------------

IF OBJECT_ID(N'Sales.SalesOrderDetailHeap', N'U') IS NOT NULL
	DROP TABLE Sales.SalesOrderDetailHeap;
GO

SELECT SalesOrderID, ISNULL(SalesOrderDetailID * 2, 0) AS 'SalesOrderDetailID', CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, rowguid, ModifiedDate
	INTO Sales.SalesOrderDetailHeap
	FROM Sales.SalesOrderDetail;
GO

IF OBJECT_ID(N'Sales.SalesOrderDetailClustered', N'U') IS NOT NULL
	DROP TABLE Sales.SalesOrderDetailClustered;
GO

SELECT SalesOrderID, ISNULL(SalesOrderDetailID * 2, 0) AS 'SalesOrderDetailID', CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, rowguid, ModifiedDate
	INTO Sales.SalesOrderDetailClustered
	FROM Sales.SalesOrderDetail;
GO

ALTER TABLE Sales.SalesOrderDetailClustered
	ADD CONSTRAINT PK_SalesOrderDetailClustered PRIMARY KEY CLUSTERED (SalesOrderID, SalesOrderDetailID);
GO


--------------------------------------------------------------------------------
-- SET STATIATICS ON
--------------------------------------------------------------------------------

SET STATISTICS XML ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

--------------------------------------------------------------------------------
-- SELECT 
--------------------------------------------------------------------------------

SELECT *
	FROM Sales.SalesOrderDetailHeap;

SELECT *
	FROM Sales.SalesOrderDetailClustered;

--------------------------------------------------------------------------------
-- SELECT ORDER BY
--------------------------------------------------------------------------------

SELECT *
	FROM Sales.SalesOrderDetailHeap
	ORDER BY SalesOrderID, SalesOrderDetailID
	OPTION (MAXDOP 1);


SELECT *
	FROM Sales.SalesOrderDetailClustered
	ORDER BY SalesOrderID, SalesOrderDetailID;


--------------------------------------------------------------------------------
-- SELECT WHERE
--------------------------------------------------------------------------------

SELECT *
	FROM Sales.SalesOrderDetailHeap
	WHERE SalesOrderID BETWEEN 50000 AND 53000;

SELECT *
	FROM Sales.SalesOrderDetailClustered
	WHERE SalesOrderID BETWEEN 50000 AND 53000;

--------------------------------------------------------------------------------
-- SELECT WHERE ORDER BY
--------------------------------------------------------------------------------

SELECT *
	FROM Sales.SalesOrderDetailHeap
	WHERE SalesOrderID BETWEEN 50000 AND 53000
	ORDER BY SalesOrderID, SalesOrderDetailID;

SELECT *
	FROM Sales.SalesOrderDetailClustered
	WHERE SalesOrderID BETWEEN 50000 AND 53000
	ORDER BY SalesOrderID, SalesOrderDetailID;

--------------------------------------------------------------------------------
-- INSERT
--------------------------------------------------------------------------------

INSERT INTO Sales.SalesOrderDetailHeap (SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, rowguid, ModifiedDate)
	SELECT SalesOrderID, ISNULL((SalesOrderDetailID * 2) + 1, 0) AS 'SalesOrderDetailID', CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, rowguid, ModifiedDate
		FROM Sales.SalesOrderDetail;

INSERT INTO Sales.SalesOrderDetailClustered (SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, rowguid, ModifiedDate)
	SELECT SalesOrderID, ISNULL((SalesOrderDetailID * 2) + 1, 0) AS 'SalesOrderDetailID', CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, LineTotal, rowguid, ModifiedDate
		FROM Sales.SalesOrderDetail
	OPTION (MAXDOP 1);

SET STATISTICS XML OFF;
SET STATISTICS IO OFF;
SET STATISTICS TIME ON;
