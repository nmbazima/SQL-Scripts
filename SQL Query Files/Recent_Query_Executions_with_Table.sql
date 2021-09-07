--create the table
CREATE TABLE #Radhe (logdate datetime not null default (getdate()), 
                     processinfo varchar(108) not null default ('Radhe'),
                     the_text varchar(4000))


-- create a non-unique clustered index
CREATE CLUSTERED INDEX IXC_RADHE_RADHE ON #RADHE(logdate desc, processinfo  asc)


-- load the table
INSERT #Radhe EXEC xp_readerrorlog


-- read the data
SELECT * FROM #Radhe with (index(IXC_RADHE_RADHE))
WHERE LOGDATE > (GETDATE() - 1)
  AND processinfo LIKE 'SPID%'
order by logdate desc