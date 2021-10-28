USE master
GO

IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorks')
BEGIN
	DROP DATABASE AdventureWorks
END
GO

RESTORE DATABASE [AdventureWorks] FROM  DISK = N'D:\SetupFiles\AdventureWorks2016.bak' WITH  REPLACE,
MOVE N'AdventureWorks2016_Data' TO N'$(SUBDIR)SetupFiles\AdventureWorks_Data.mdf', 
MOVE N'AdventureWorks2016_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks_log.ldf',
MOVE N'AdventureWorks2016_mod' TO N'$(SUBDIR)SetupFiles\AdventureWorks2016_mod'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks TO [ADVENTUREWORKS\Student];
GO

USE AdventureWorks;
GO
CREATE SCHEMA Proseware;
GO
CREATE TABLE Proseware.Campaign
(CampaignID int IDENTITY PRIMARY KEY,
CampaignName varchar(20) NOT NULL,
CampaignTerritoryID int NOT NULL,
CampaignStartDate date NOT NULL,
CampaignEndDate date NOT NULL
)
GO

CREATE TABLE Proseware.Campaign2
(CampaignID int PRIMARY KEY,
CampaignName varchar(20) NOT NULL,
CampaignTerritoryID int NOT NULL,
CampaignStartDate date NOT NULL,
CampaignEndDate date NOT NULL
)
GO

INSERT Proseware.Campaign
(CampaignName, CampaignTerritoryID, CampaignStartDate, CampaignEndDate)
SELECT TOP (10000)
CAST(1000000 +ROW_NUMBER() OVER (ORDER BY a.name, b.name) AS nvarchar(20)),
(ROW_NUMBER() OVER (ORDER BY a.name, b.name) % 10) + 1,
DATEADD(dd, ROW_NUMBER() OVER (ORDER BY a.name, b.name) % 2000, '2011-01-01'),
DATEADD(dd, (ROW_NUMBER() OVER (ORDER BY a.name, b.name) % 2000) + 30, '2011-01-01')
FROM master.dbo.spt_values AS a
CROSS JOIN master.dbo.spt_values AS b
GO

INSERT Proseware.Campaign2
(CampaignID, CampaignName, CampaignTerritoryID, CampaignStartDate, CampaignEndDate)
SELECT CampaignID, CampaignName, CampaignTerritoryID, CampaignStartDate, CampaignEndDate
FROM Proseware.Campaign;
GO


CREATE PROC Proseware.up_Campaign_Replace
	@rnd int
AS
	DECLARE @rc int; 
	BEGIN TRANSACTION
	
		DELETE Proseware.Campaign
		WHERE CampaignTerritoryID = @rnd;
		SET @rc = @@ROWCOUNT;

		WAITFOR DELAY '00:00:04';

		INSERT Proseware.Campaign
		(CampaignName, CampaignTerritoryID, CampaignStartDate, CampaignEndDate)
		SELECT TOP (@rc)
		CAST(1000000 +ROW_NUMBER() OVER (ORDER BY a.name) AS nvarchar(20)),
		@rnd,
		DATEADD(dd, ROW_NUMBER() OVER (ORDER BY a.name, b.name) % 2000, '2011-01-01'),
		DATEADD(dd, (ROW_NUMBER() OVER (ORDER BY a.name, b.name) % 2000) + 30, '2011-01-01')
		FROM master.dbo.spt_values AS a
		CROSS JOIN master.dbo.spt_values AS b

		WAITFOR DELAY '00:00:06';
	COMMIT
GO

CREATE PROC Proseware.up_Campaign_Report
AS
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

-- Create partition function
CREATE PARTITION FUNCTION pf_CampaignResponse(date)
AS 
	RANGE LEFT FOR VALUES ('20111231','20121231','20131231','20141231', '20151231')
GO

-- Create partition scheme
CREATE PARTITION SCHEME ps_CampaignResponse
AS 
	PARTITION pf_CampaignResponse  ALL TO ([PRIMARY])
GO

-- Create table on partition scheme
CREATE TABLE Proseware.CampaignResponsePartitioned 
(
	ResponseDate date, 
    CampaignResponseID int NOT NULL,
	CampaignID int NOT NULL,
	ConvertedToSale bit NOT NULL,
	ConvertedSaleValueUSD decimal(20,2) NULL,
	CONSTRAINT pk_CampaignResponsePartitioned PRIMARY KEY 
	(ResponseDate,CampaignResponseID)
)
	ON ps_CampaignResponse (ResponseDate) ;
GO

CREATE INDEX ix_CampaignResponsePartitioned_CampaignResponseID ON Proseware.CampaignResponsePartitioned (CampaignResponseID);
GO

;WITH myCTE
AS
(
	SELECT c.*,
	ROW_NUMBER() OVER (PARTITION BY c.CampaignID ORDER BY b.name ) as rn1,
	ROW_NUMBER() OVER (ORDER BY b.name ) as rn2,
	CASE WHEN RIGHT(CONVERT(varchar(40),NEWID()),1) BETWEEN 'A' AND 'F' THEN 1 ELSE 0 END AS rnd1
	FROM Proseware.Campaign2 AS c
	CROSS JOIN master.dbo.spt_values AS b
)
INSERT Proseware.CampaignResponsePartitioned
(CampaignResponseID, CampaignID, ResponseDate, ConvertedToSale, ConvertedSaleValueUSD)
SELECT c.rn2, c.CampaignID,
DATEADD(dd, rn1 % 40, c.CampaignStartDate),
c.rnd1,
CASE WHEN rnd1 = 1 THEN rn1 * 1.99 ELSE NULL END
FROM myCTE AS c
WHERE c.rn1 <= c.CampaignID % 1000

GO