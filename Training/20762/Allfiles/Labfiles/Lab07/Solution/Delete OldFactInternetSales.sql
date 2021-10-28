USE [AdventureWorksDW]
GO

ALTER TABLE [dbo].[FactInternetSalesReason] DROP CONSTRAINT [FK_FactInternetSalesReason_FactInternetSales]
GO

/****** Object:  Table [dbo].[OldFactInternetSales]    Script Date: 1/8/2016 2:26:56 AM ******/
DROP TABLE [dbo].[OldFactInternetSales]
GO
