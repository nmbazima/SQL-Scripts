-- load generation script 2
-- loops for up to 60 seconds, or until the ##stopload shared temp table is created
DROP TABLE IF EXISTS ##stopload;

USE AdventureWorks;
GO
TRUNCATE TABLE Proseware.WebAdvertHit;
TRUNCATE TABLE Proseware.WebAdvert;
GO


DECLARE @start datetime2 = GETDATE();
WHILE DATEDIFF(ss,@start,GETDATE()) < 60 AND OBJECT_ID('tempdb..##stopload') IS NULL
BEGIN 
	IF @@SPID % 2 = 1
	BEGIN
		EXEC Proseware.up_WebAdvert_Add;
		WAITFOR DELAY '00:00:00.010';
	END
	ELSE
	BEGIN
		EXEC Proseware.up_WebAdvertHit_Add;
		WAITFOR DELAY '00:00:00.010';
	END
END


