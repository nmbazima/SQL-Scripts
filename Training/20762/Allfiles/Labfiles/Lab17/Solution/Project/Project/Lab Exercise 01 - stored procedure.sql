USE AdventureWorks;
GO

ALTER PROC Proseware.up_Campaign_Report
AS
	SET TRANSACTION ISOLATION LEVEL SNAPSHOT
	SELECT TOP 10 * FROM Sales.SalesTerritory AS T
	JOIN (
		SELECT CampaignTerritoryID, 
		DATEPART(MONTH, CampaignStartDate) as start_month_number,
		DATEPART(MONTH, CampaignEndDate) as end_month_number, 
		COUNT(*) AS campaign_count
		FROM Proseware.Campaign 
		GROUP BY CampaignTerritoryID, DATEPART(MONTH, CampaignStartDate),DATEPART(MONTH, CampaignEndDate)
	) AS x
	ON x.CampaignTerritoryID = T.TerritoryID
	ORDER BY campaign_count;
GO