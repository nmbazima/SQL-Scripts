-- load generation script 1
-- loops for up to 60 minutes, or until the ##stopload shared temp table is created
DROP TABLE IF EXISTS ##stopload;

USE AdventureWorks;
GO

DECLARE @sql nvarchar(MAX), @delay varchar(20), @split int = @@SPID % 5


SELECT @sql =	CASE	WHEN @split = 0 THEN N'EXEC dbo.uspGetOrderTrackingBySalesOrderID @i1'
						WHEN @split = 1 THEN N'EXEC dbo.uspGetManagerEmployees @i1'
						WHEN @split = 2 THEN N'EXEC HumanResources.sp_GetEmployee_Person_Info_AsOf @dt1'
						ELSE N'EXEC dbo.uspGetOrderTrackingByTrackingNumber @vc1'
				END;

DECLARE @start datetime2 = GETDATE(), @i int, @dt datetime2, @vc nvarchar(25) ;
WHILE DATEDIFF(ss,@start,GETDATE()) < 3600 AND OBJECT_ID('tempdb..##stopload') IS NULL
BEGIN
	SET @i = RAND()*10000;

	IF @split = 2
	BEGIN
		SET @dt = DATEADD(dd,@i,'2005-01-01');
		EXEC sp_executesql @sql, N'@dt1 datetime2', @dt1 = @dt;
	END
	ELSE
	IF @split > 2
	BEGIN
		SET @vc = CAST(@i AS nvarchar(25));
		EXEC sp_executesql @sql, N'@vc1 nvarchar(25)', @vc1 = @vc;
	END
	ELSE
	BEGIN
		EXEC sp_executesql @sql, N'@i1 int', @i1 = @i;
	END
		
	WAITFOR DELAY '00:00:01';
END
