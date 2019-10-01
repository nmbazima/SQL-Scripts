USE AdventureWork
GO
CREATE TABLE #GetLargest 
(
  table_name    sysname ,
  row_count     INT,
  reserved_size VARCHAR(50),
  data_size     VARCHAR(50),
  index_size    VARCHAR(50),
  unused_size   VARCHAR(50)
)

SET NOCOUNT ON

INSERT #GetLargest

EXEC sp_msforeachtable 'sp_spaceused ''?'''

SELECT 
  a.table_name,
  a.row_count,
  COUNT(*) AS col_count,
  a.data_size
  FROM #GetLargest a
     INNER JOIN information_schema.columns b
     ON a.table_name collate database_default
     = b.table_name collate database_default
       GROUP BY a.table_name, a.row_count, a.data_size
       ORDER BY CAST(REPLACE(a.data_size, ' KB', '') AS integer) DESC

DROP TABLE #GetLargest