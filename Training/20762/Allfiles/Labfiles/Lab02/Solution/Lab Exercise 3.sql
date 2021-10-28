---------------------------------------------------------------------
-- LAB 02
--
-- Exercise 3
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Write a script to create a table to store the Competitor data.
---------------------------------------------------------------------

CREATE TABLE DirectMarketing.Competitor
(
	CompetitorCode nvarchar(6) NOT NULL,
	Name varchar(30) NOT NULL,
	[Address] varchar(max) NULL,
	Date_Entered varchar(10) NULL,
	Strength_of_competition	varchar(8) NULL,
	Comments varchar(max) NULL
);
GO

---------------------------------------------------------------------
-- Task 2
-- 
-- Write a script to create a table to store the TVAdvertisement data.
---------------------------------------------------------------------

CREATE TABLE DirectMarketing.TVAdvertisement
(
	TV_Station nvarchar(15) NOT NULL,
	City nvarchar(25) NULL,
	CostPerAdvertisement float NULL,
	TotalCostOfAllAdvertisements float NULL,
	NumberOfAdvertisements varchar(4) NULL,
	Date_Of_Advertisement_1 varchar(12) NULL,
	Time_Of_Advertisement_1	int NULL,
	Date_Of_Advertisement_2	varchar(12) NULL,
	Time_Of_Advertisement_2	int NULL,
	Date_Of_Advertisement_3	varchar(12) NULL,
	Time_Of_Advertisement_3	int NULL,
	Date_Of_Advertisement_4	varchar(12) NULL,
	Time_Of_Advertisement_4	int NULL,
	Date_Of_Advertisement_5	varchar(12) NULL,
	Time_Of_Advertisement_5	int NULL
);
GO


---------------------------------------------------------------------
-- Task 3
-- 
-- Write a script to create a table to store the CampaignResponse data.
--
-- Change the column nullability to be appropriate for the data.
---------------------------------------------------------------------

CREATE TABLE DirectMarketing.CampaignResponse
(
	ResponseOccurredWhen datetime NOT NULL, 
	RelevantProspect int NOT NULL,
	RespondedHow varchar(8) NOT NULL,
	ChargeFromReferrer float NULL,
	RevenueFromResponse	float NULL,
	ResponseProfit AS (RevenueFromResponse - ChargeFromReferrer) PERSISTED
);
GO