SELECT c.Name,
       c.[Path]
FROM [ReportServer].[dbo].[ExecutionLog](NOLOCK) AS l
RIGHT OUTER JOIN [ReportServer].[dbo].[Catalog](NOLOCK) AS c ON l.ReportID = C.ItemID
WHERE c.Type = 2 -- Only show reports 1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
      AND l.ReportID IS NULL;