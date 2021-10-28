-- load generation script 1
-- loops for up to 60 seconds, or until the ##stopload shared temp table is created
DROP TABLE IF EXISTS ##stopload;

USE AdventureWorks;
GO

DECLARE @start datetime2 = GETDATE(), @campaignID int;
WHILE DATEDIFF(ss,@start,GETDATE()) < 60 AND OBJECT_ID('tempdb..##stopload') IS NULL
BEGIN 
	IF DATEPART(ms, SYSDATETIME()) % 10 < 5
	BEGIN
		
		SET @campaignID = (SELECT TOP(1) CampaignID FROM Proseware.Campaign ORDER BY NEWID());
		BEGIN TRANSACTION
			INSERT Proseware.CampaignMaterial (CampaignID,MaterialType,MaterialCost,DateAdded)
			VALUES (@campaignID, 'test',10.99, GETDATE());
			WAITFOR DELAY '00:00:05';
			SELECT * FROM Proseware.CampaignMaterial;
		COMMIT	
		
	END
	ELSE
	BEGIN
		SELECT * FROM Proseware.CampaignMaterial
		WAITFOR DELAY '00:00:03'
	END
END


