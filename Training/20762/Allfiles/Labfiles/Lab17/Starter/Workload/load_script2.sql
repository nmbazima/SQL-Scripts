-- load generation script 2
-- loops for up to 1 minute, or until the ##stopload shared temp table is created
DROP TABLE IF EXISTS ##stopload;
SET NOCOUNT ON;
USE AdventureWorks;
GO


DECLARE @start datetime2 = GETDATE();

WHILE DATEDIFF(ss,@start,GETDATE()) < 60 AND OBJECT_ID('tempdb..##stopload') IS NULL
BEGIN
	IF @@SPID % 10 = 9
	BEGIN
		BEGIN TRAN

			UPDATE TOP (20000) 
			Proseware.CampaignResponsePartitioned
			SET ConvertedSaleValueUSD = ConvertedSaleValueUSD + 0.01
			WHERE ResponseDate BETWEEN '2011-01-01' AND '2011-12-31'
			OPTION (RECOMPILE);


			WAITFOR DELAY '00:00:05';
		COMMIT
	END
	ELSE
	BEGIN
		SELECT SUM(ConvertedSaleValueUSD)
		FROM Proseware.CampaignResponsePartitioned
		WHERE ResponseDate BETWEEN '2015-01-01' AND '2015-12-31' 
		OPTION (RECOMPILE);

		WAITFOR DELAY '00:00:00.100';
	END
END


