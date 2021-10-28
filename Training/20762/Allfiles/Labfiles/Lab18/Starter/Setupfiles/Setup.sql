USE master
GO

IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'AdventureWorks')
BEGIN
	DROP DATABASE AdventureWorks
END
GO

RESTORE DATABASE [AdventureWorks] FROM  DISK = N'D:\SetupFiles\AdventureWorks2016.bak' WITH  REPLACE,
MOVE N'AdventureWorks2016_Data' TO N'$(SUBDIR)SetupFiles\AdventureWorks2016_Data.mdf', 
MOVE N'AdventureWorks2016_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks2016_log.ldf',
MOVE N'AdventureWorks2016_mod' TO N'$(SUBDIR)SetupFiles\AdventureWorks2016_mod'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks TO [ADVENTUREWORKS\Student];
GO

USE AdventureWorks;
GO
CREATE SCHEMA Proseware;
GO
CREATE TABLE Proseware.Campaign
(CampaignID int PRIMARY KEY,
CampaignName varchar(20) NOT NULL,
CampaignTerritoryID int NOT NULL,
CampaignStartDate date NOT NULL,
CampaignEndDate date NOT NULL
)
GO
ALTER TABLE Proseware.Campaign WITH CHECK ADD  CONSTRAINT FK_Campaign_SalesTerritory FOREIGN KEY (CampaignTerritoryID)
REFERENCES Sales.SalesTerritory(TerritoryID)
GO
ALTER TABLE Proseware.Campaign CHECK CONSTRAINT FK_Campaign_SalesTerritory
GO

INSERT Proseware.Campaign
(CampaignID, CampaignName, CampaignTerritoryID, CampaignStartDate, CampaignEndDate)
SELECT TOP (100)
ROW_NUMBER() OVER (ORDER BY a.name, b.name),
CAST(1000000 +ROW_NUMBER() OVER (ORDER BY a.name, b.name) AS nvarchar(20)),
(ROW_NUMBER() OVER (ORDER BY a.name, b.name) % 10) + 1,
DATEADD(dd, ROW_NUMBER() OVER (ORDER BY a.name, b.name) % 3650, '2015-01-01'),
DATEADD(dd, (ROW_NUMBER() OVER (ORDER BY a.name, b.name) % 3650) + 30, '2015-01-01')
FROM master.dbo.spt_values AS a
CROSS JOIN master.dbo.spt_values AS b
GO

CREATE TABLE Proseware.CampaignMaterial
(CampaignMaterialID int identity PRIMARY KEY,
CampaignID int NOT NULL,
MaterialType varchar(10),
MaterialCost money,
DateAdded datetime2
)
GO
ALTER TABLE Proseware.CampaignMaterial WITH CHECK ADD  CONSTRAINT FK_CampaignMaterial_Campaign FOREIGN KEY (CampaignID)
REFERENCES Proseware.Campaign(CampaignID)
GO
ALTER TABLE Proseware.CampaignMaterial CHECK CONSTRAINT FK_CampaignMaterial_Campaign
GO

CREATE TABLE Proseware.WebAdvert
( WebAdvertID int IDENTITY NOT NULL PRIMARY KEY,
  AdvertName varchar(100) NOT NULL,
  CreatedDate datetime2 NOT NULL 
);
GO
-- index should mid-split based on random column values
CREATE INDEX ix_WebAdvert_CreatedDate ON Proseware.WebAdvert (CreatedDate);
GO

CREATE PROC Proseware.up_WebAdvert_Add
AS
	INSERT Proseware.WebAdvert (AdvertName,CreatedDate)
	SELECT 'index split', DATEADD(d, RAND()*-1000, '2016-02-01');
GO

CREATE TABLE Proseware.WebAdvertHit
(WebAdvertHitID uniqueidentifier NOT NULL DEFAULT NEWID() PRIMARY KEY,
WebAdvertID int NOT NULL,
PageVisitTimeSeconds int NOT NULL,
VisitDate datetime2 NOT NULL DEFAULT GETDATE()
)
GO
-- index will mid-split based on random values for AdvertID
CREATE INDEX ix_WebAdHits_AdvertID ON Proseware.WebAdvertHit (WebAdvertID);
GO
-- index will end-split based on the column value increasing
CREATE INDEX ix_WebAdHits_VisitDate ON Proseware.WebAdvertHit (VisitDate);
GO

CREATE PROC Proseware.up_WebAdvertHit_Add
AS
	INSERT Proseware.WebAdvertHit (WebAdvertID, PageVisitTimeSeconds) 
	SELECT RAND() * 1111, RAND() * 30;
GO

ALTER EVENT SESSION system_health ON SERVER
	STATE=STOP
GO

IF EXISTS (SELECT * FROM sys.server_event_sessions WHERE name = 'track page splits')
    DROP EVENT SESSION [track page splits] ON SERVER
GO
