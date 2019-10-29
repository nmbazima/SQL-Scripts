-- Reports by count that have been run in the last 24 hours
SELECT c.Name,
       c.[Path],
       COUNT(*) AS TimesRun,
       MAX(l.TimeStart) AS [LastRun]
FROM [ReportServer].[dbo].[ExecutionLog](NOLOCK) AS l
INNER JOIN [ReportServer].[dbo].[Catalog](NOLOCK) AS c ON l.ReportID = C.ItemID
WHERE c.Type = 2 -- Only show reports 1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
      AND l.TimeStart &gt; GETDATE() - 1
GROUP BY l.ReportId,
         c.Name,
         c.[Path];