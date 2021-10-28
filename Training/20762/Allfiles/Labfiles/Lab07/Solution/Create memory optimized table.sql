/************************************************************************
 * Step 14																*
 *																		*
 * Create a  memory optimized table	and import the data					*
 *																		*
 ************************************************************************/

USE [master]
GO

ALTER DATABASE [AdventureWorksDW] ADD FILEGROUP [memory_optimized_filegroup_0] CONTAINS MEMORY_OPTIMIZED_DATA 
GO

ALTER DATABASE [AdventureWorksDW] ADD FILE ( NAME = N'memory_optimized_file_959037648', FILENAME = N'D:\Labfiles\Lab07\Starter\SetupFiles\memory_optimized_file_959037648' ) TO FILEGROUP [memory_optimized_filegroup_0]
GO

USE [AdventureWorksDW]
GO

EXEC dbo.sp_rename @objname = N'[dbo].[FactInternetSales]', @newname = N'FactInternetSales_old', @objtype = N'OBJECT'
GO

USE [AdventureWorksDW]
GO

SET ANSI_NULLS ON
GO

CREATE TABLE [dbo].[FactInternetSales]
(
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float](53) NOT NULL,
	[DiscountAmount] [float](53) NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CustomerPONumber] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[ShipDate] [datetime] NULL,

 CONSTRAINT [FactInternetSales_primaryKey]  PRIMARY KEY NONCLUSTERED HASH 
(
	[SalesOrderNumber],
	[SalesOrderLineNumber]
)WITH ( BUCKET_COUNT = 2097152)
,INDEX CCI_OnlineFactInternetSales CLUSTERED COLUMNSTORE
)WITH ( MEMORY_OPTIMIZED = ON , DURABILITY = SCHEMA_AND_DATA )

GO

INSERT INTO [AdventureWorksDW].[dbo].[FactInternetSales] ([ProductKey], [OrderDateKey], [DueDateKey], [ShipDateKey], [CustomerKey], [PromotionKey], [CurrencyKey], [SalesTerritoryKey], [SalesOrderNumber], [SalesOrderLineNumber], [RevisionNumber], [OrderQuantity], [UnitPrice], [ExtendedAmount], [UnitPriceDiscountPct], [DiscountAmount], [ProductStandardCost], [TotalProductCost], [SalesAmount], [TaxAmt], [Freight], [CarrierTrackingNumber], [CustomerPONumber], [OrderDate], [DueDate], [ShipDate]) SELECT [ProductKey], [OrderDateKey], [DueDateKey], [ShipDateKey], [CustomerKey], [PromotionKey], [CurrencyKey], [SalesTerritoryKey], [SalesOrderNumber], [SalesOrderLineNumber], [RevisionNumber], [OrderQuantity], [UnitPrice], [ExtendedAmount], [UnitPriceDiscountPct], [DiscountAmount], [ProductStandardCost], [TotalProductCost], [SalesAmount], [TaxAmt], [Freight], [CarrierTrackingNumber], [CustomerPONumber], [OrderDate], [DueDate], [ShipDate] FROM [AdventureWorksDW].[dbo].[FactInternetSales_old] 

GO


