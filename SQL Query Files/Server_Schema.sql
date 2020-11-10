SELECT
SCHEMA_NAME(sp.schema_id) AS [Schema],
sp.name AS [Name],
sp.object_id AS [ID],
CAST(
 case 
    when sp.is_ms_shipped = 1 then 1
    when (
        select 
            major_id 
        from 
            sys.extended_properties 
        where 
            major_id = sp.object_id and 
            minor_id = 0 and 
            class = 1 and 
            name = N'microsoft_database_tools_support') 
        is not null then 1
    else 0
end          
             AS bit) AS [IsSystemObject],
CASE WHEN sp.type = N'P' THEN 1 WHEN sp.type = N'PC' THEN 2 ELSE 1 END AS [ImplementationType],
CAST(CASE WHEN ISNULL(smsp.definition, ssmsp.definition) IS NULL THEN 1 ELSE 0 END AS bit) AS [IsEncrypted]
FROM
sys.all_objects AS sp
LEFT OUTER JOIN sys.sql_modules AS smsp ON smsp.object_id = sp.object_id
LEFT OUTER JOIN sys.system_sql_modules AS ssmsp ON ssmsp.object_id = sp.object_id
WHERE
(sp.type = @_msparam_0 OR sp.type = @_msparam_1 OR sp.type=@_msparam_2)
ORDER BY
[Schema] ASC,[Name] ASC
