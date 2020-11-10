-- Written by Steve Stedman http://SteveStedman.com
SELECT c.Name,
       c.[Path],
       COUNT(*) AS TimesRun,
       MAX(l.TimeStart) AS [LastRun],
(
    SELECT SUBSTRING(
                    (
                        SELECT CAST(', ' AS VARCHAR(MAX))+CAST(c1.Name AS VARCHAR(MAX))
                        FROM [ReportServer].[dbo].[Catalog] AS c
                        INNER JOIN [ReportServer].[dbo].[DataSource] AS d ON c.ItemID = d.ItemID
                        INNER JOIN [ReportServer].[dbo].[Catalog] c1 ON d.Link = c1.ItemID
                        WHERE c.Type = 2
                              AND c.ItemId = l.ReportId
                        FOR XML PATH('')
                    ), 3, 10000000) AS list
) AS DataSources
FROM [ReportServer].[dbo].[ExecutionLog](NOLOCK) AS l
INNER JOIN [ReportServer].[dbo].[Catalog](NOLOCK) AS c ON l.ReportID = C.ItemID
WHERE c.Type = 2 -- Only show reports 1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
GROUP BY l.ReportId,
         c.Name,
         c.[Path];