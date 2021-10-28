/*
Missing Index Details from SalesQuery.sql - MIA-SQL.AdventureWorks (ADVENTUREWORKS\Student (56))
The Query Processor estimates that implementing the following index could improve the query cost by 14.4222%.
*/


USE [AdventureWorks]
GO
CREATE NONCLUSTERED INDEX NCI_PrintMediaPlacement
ON [Sales].[PrintMediaPlacement] ([PublicationDate],[PlacementCost])
INCLUDE ([PrintMediaPlacementID],[MediaOutletID],[PlacementDate],[RelatedProductID])
GO

