CREATE OR ALTER PROCEDURE dbo.DropIndexes 
  @SchemaName NVARCHAR(255) = 'dbo', 
  @TableName NVARCHAR(255) = NULL, 
  @WhatToDrop VARCHAR(10) = 'Everything',
  @ExceptIndexNames NVARCHAR(MAX) = NULL
  AS
BEGIN
SET NOCOUNT ON;
 
CREATE TABLE #commands (ID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, Command NVARCHAR(2000));

CREATE TABLE #ExceptIndexNames (IndexName NVARCHAR(1000));
INSERT INTO #ExceptIndexNames(IndexName)
  SELECT UPPER(TRIM(value))
    FROM string_split(@ExceptIndexNames,',');
 
DECLARE @CurrentCommand NVARCHAR(2000);
 
IF ( UPPER(@WhatToDrop) LIKE 'C%' 
     OR UPPER(@WhatToDrop) LIKE 'E%' )
BEGIN
INSERT INTO #commands (Command)
SELECT   N'ALTER TABLE ' 
       + QUOTENAME(SCHEMA_NAME(o.schema_id))
       + N'.'
       + QUOTENAME(OBJECT_NAME(o.parent_object_id))
       + N' DROP CONSTRAINT '
       + QUOTENAME(o.name)
       + N';'
FROM sys.objects AS o
WHERE o.type IN ('C', 'F', 'UQ')
AND SCHEMA_NAME(o.schema_id) = COALESCE(@SchemaName, SCHEMA_NAME(o.schema_id)) COLLATE DATABASE_DEFAULT
AND OBJECT_NAME(o.parent_object_id) = COALESCE(@TableName,  OBJECT_NAME(o.parent_object_id)) COLLATE DATABASE_DEFAULT
AND UPPER(o.name) NOT IN (SELECT IndexName COLLATE DATABASE_DEFAULT FROM #ExceptIndexNames);
END;
 
IF ( UPPER(@WhatToDrop) LIKE 'I%' 
     OR UPPER(@WhatToDrop) LIKE 'E%' )
BEGIN
INSERT INTO #commands (Command)
SELECT 'DROP INDEX ' 
       + QUOTENAME(i.name) 
       + ' ON ' 
       + QUOTENAME(SCHEMA_NAME(t.schema_id)) 
       + '.' 
       + t.name 
       + ';'
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
WHERE i.type NOT IN (0, 1, 5)
AND SCHEMA_NAME(t.schema_id) = COALESCE(@SchemaName, SCHEMA_NAME(t.schema_id)) COLLATE DATABASE_DEFAULT
AND t.name = COALESCE(@TableName, t.name) COLLATE DATABASE_DEFAULT
AND UPPER(i.name) NOT IN (SELECT IndexName COLLATE DATABASE_DEFAULT FROM #ExceptIndexNames);

INSERT INTO #commands (Command)
SELECT 'DROP STATISTICS ' 
       + QUOTENAME(SCHEMA_NAME(t.schema_id)) 
       + '.'  
       + QUOTENAME(OBJECT_NAME(s.object_id)) 
       + '.' 
       + QUOTENAME(s.name)
       + ';'
FROM sys.stats AS s
INNER JOIN sys.tables AS t ON s.object_id = t.object_id
WHERE NOT EXISTS (SELECT * FROM sys.indexes AS i WHERE i.name = s.name) 
AND SCHEMA_NAME(t.schema_id) = COALESCE(@SchemaName, SCHEMA_NAME(t.schema_id))
AND t.name = COALESCE(@TableName, t.name)
AND OBJECT_NAME(s.object_id) NOT LIKE 'sys%';
END; 
 
DECLARE result_cursor CURSOR FOR
SELECT Command FROM #commands;
 
OPEN result_cursor;
FETCH NEXT FROM result_cursor INTO @CurrentCommand;
WHILE @@FETCH_STATUS = 0
BEGIN 
   
    PRINT @CurrentCommand;
	EXEC(@CurrentCommand);
 
FETCH NEXT FROM result_cursor INTO @CurrentCommand;
END;
--end loop
 
--clean up
CLOSE result_cursor;
DEALLOCATE result_cursor;
END;