BEGIN TRY
DROP TABLE #temp01
END TRY
BEGIN CATCH
END CATCH
SELECT DISTINCT
SUBSTRING(t2.Path,1,LEN(t2.Path)-LEN(t2.Name)) AS Folder
,t2.Name
,REPLACE(t1.UserName,'JACKPOT\','') AS UserName2
,MAX(t1.TimeStart) AS LastExecuted
INTO #temp01
FROM ReportServer.dbo.ExecutionLog t1
JOIN ReportServer.dbo.Catalog t2 ON t1.ReportID = t2.ItemID
GROUP BY t2.Path,t2.Name,t1.UserName
ORDER BY Folder,UserName2 --,t1.UserName
SELECT DISTINCT
Folder AS ReportFolder
,Name AS ReportName
,COUNT(Name) AS TimesExecuted
,MAX(LastExecuted) AS LastExcecutedDate
,ExecutedBy = STUFF((
   SELECT ', ' + UserName2 FROM #temp01
WHERE Name = x.[Name]
FOR XML PATH(''), TYPE).value('.[1]', 'nvarchar(max)'), 1, 2, '')
FROM #temp01 x
WHERE Name <> ''
GROUP BY Folder,Name
ORDER BY TimesExecuted DESC,ReportFolder,Name