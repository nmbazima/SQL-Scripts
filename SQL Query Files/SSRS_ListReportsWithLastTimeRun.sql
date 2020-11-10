SELECT c.Name,
       c.[Path],
       MAX(l.TimeStart) AS [LastRun]
FROM [ReportServer].[dbo].[ExecutionLog] AS l WITH (NOLOCK)
INNER JOIN [ReportServer].[dbo].[Catalog] AS c WITH (NOLOCK) ON l.ReportID = C.ItemID
WHERE c.Type = 2 -- Only show reports 1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
GROUP BY l.ReportId,
         c.Name,
         c.[Path]
ORDER BY [LastRun] DESC;