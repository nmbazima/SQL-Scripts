/*
Why is the Same Query Sometimes Slow?

v1.8 - 2019-08-27

I'm going to teach you 4 things:

1. What parameter sniffing is
2. How to react to parameter sniffing emergencies
3. How to test a query with sniffing problems
4. Options to fix the query long term

Learn more later at:
https://www.BrentOzar.com/go/sniff


This demo requires:

* Any supported version of SQL Server or Azure SQL DB
* Any Stack Overflow database: https://www.BrentOzar.com/go/querystack
* DropIndexes proc: https://www.BrentOzar.com/go/dropindexes
* sp_BlitzCache: https://www.BrentOzar.com/blitzcache
*/
USE StackOverflow2013;
GO
ALTER DATABASE CURRENT SET COMPATIBILITY_LEVEL = 140;
GO
EXEC sys.sp_configure N'cost threshold for parallelism', N'50'
GO
EXEC sys.sp_configure N'max degree of parallelism', N'4'
GO
RECONFIGURE
GO
DropIndexes;
GO
/* Turn on actual execution plans and: */
SET STATISTICS IO, TIME ON;
GO

CREATE INDEX IX_Reputation ON dbo.Users(Reputation)
GO
SELECT TOP 10000 *
FROM dbo.Users
WHERE Reputation=2
ORDER BY DisplayName;
GO

SELECT TOP 10000 * 
FROM dbo.Users
WHERE Reputation=1
ORDER BY DisplayName;
GO



CREATE OR ALTER PROCEDURE dbo.usp_UsersByReputation
  @Reputation int
AS
SELECT TOP 10000 *
FROM dbo.Users
WHERE Reputation=@Reputation
ORDER BY DisplayName;
GO

EXEC dbo.usp_UsersByReputation @Reputation =1;
GO
EXEC dbo.usp_UsersByReputation @Reputation =2;
GO

DBCC FREEPROCCACHE
GO
EXEC dbo.usp_UsersByReputation @Reputation =2;
GO
EXEC dbo.usp_UsersByReputation @Reputation =1;
GO
sp_BlitzCache




DECLARE @Reputation INT = 2

--CREATE PROCEDURE dbo.usp_UsersByReputation
--  @Reputation int
--AS
SELECT TOP 10000 *
FROM dbo.Users
WHERE Reputation=@Reputation
ORDER BY DisplayName;
GO

DBCC SHOW_STATISTICS('dbo.Users', 'IX_Reputation')
GO



CREATE PROCEDURE #usp_UsersByReputation @Reputation int AS
SELECT * FROM dbo.Users
WHERE Reputation= @Reputation
GO

EXEC #usp_UsersByReputation 2
GO




/* "Normal" dynamic SQL: */
CREATE OR ALTER PROCEDURE dbo.usp_UsersByReputation
  @Reputation int
AS
BEGIN
DECLARE @StringToExecute NVARCHAR(4000);
SET @StringToExecute = N'SELECT TOP 10000 * FROM dbo.Users WHERE Reputation=@Reputation ORDER BY DisplayName;';

EXEC sp_executesql @StringToExecute, N'@Reputation INT', @Reputation;
END
GO

DBCC FREEPROCCACHE;
GO
EXEC usp_UsersByReputation @Reputation = 1;
GO
EXEC usp_UsersByReputation @Reputation = 2;
GO
sp_BlitzCache;
GO


/* "Bad" dynamic SQL building unparameterized strings: */
CREATE OR ALTER PROCEDURE dbo.usp_UsersByReputation
  @Reputation int
AS
BEGIN
DECLARE @StringToExecute NVARCHAR(4000);
SET @StringToExecute = N'SELECT TOP 10000 * FROM dbo.Users WHERE Reputation= '
	+ CAST(@Reputation AS NVARCHAR(10))
	+ N' ORDER BY DisplayName;';

EXEC sp_executesql @StringToExecute;
END
GO

DBCC FREEPROCCACHE;
GO
EXEC usp_UsersByReputation @Reputation = 1;
GO
EXEC usp_UsersByReputation @Reputation = 2;
GO
sp_BlitzCache;
GO



/* Parameterized, but with comment injection: */
CREATE OR ALTER PROCEDURE dbo.usp_UsersByReputation
  @Reputation int
AS
BEGIN
DECLARE @StringToExecute NVARCHAR(4000);
SET @StringToExecute = N'SELECT TOP 10000 * FROM dbo.Users WHERE Reputation=@Reputation ORDER BY DisplayName;';

IF @Reputation = 1
	SET @StringToExecute = @StringToExecute + N' /* Big data */';

EXEC sp_executesql @StringToExecute, N'@Reputation INT', @Reputation;
END
GO

DBCC FREEPROCCACHE;
GO
EXEC usp_UsersByReputation @Reputation = 1;
GO
EXEC usp_UsersByReputation @Reputation = 2;
GO
sp_BlitzCache;
GO




/* And for bonus points, this is how real-life complex IF branches
can be way worse than single-query procs: */
CREATE OR ALTER PROC dbo.usp_QueryStuff
    @TableToQuery NVARCHAR(50) = NULL,
    @UserReputation INT = NULL,
    @BadgeName NVARCHAR(40) = NULL AS
BEGIN
IF @TableToQuery = 'Users'
    SELECT TOP 10000 *
        FROM dbo.Users
        WHERE Reputation = @UserReputation
        ORDER BY DisplayName;
ELSE IF @TableToQuery = 'Badges'
    SELECT TOP 200 *
        FROM dbo.Badges
        WHERE Name = @BadgeName
        ORDER BY Date;
END
GO

DBCC FREEPROCCACHE

/* And here's a few sets of parameters that cause wildly different plans */
EXEC dbo.usp_QueryStuff @TableToQuery = 'Users', @UserReputation = 1;
GO
EXEC dbo.usp_QueryStuff @TableToQuery = 'Users', @UserReputation = 2;
GO
EXEC dbo.usp_QueryStuff @TableToQuery = 'Badges', @BadgeName = 'Student';
GO
EXEC dbo.usp_QueryStuff @TableToQuery = 'Badges', @BadgeName = 'dynamic-sql';
GO
EXEC dbo.usp_QueryStuff;
GO





/*
Learn more later at:
https://www.BrentOzar.com/go/sniff


License: Creative Commons Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)
More info: https://creativecommons.org/licenses/by-sa/3.0/

You are free to:
* Share - copy and redistribute the material in any medium or format
* Adapt - remix, transform, and build upon the material for any purpose, even 
  commercially

Under the following terms:
* Attribution - You must give appropriate credit, provide a link to the license,
  and indicate if changes were made.
* ShareAlike - If you remix, transform, or build upon the material, you must
  distribute your contributions under the same license as the original.
*/