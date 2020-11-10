SELECT
SCHEMA_NAME(v.schema_id) AS [Schema],
v.name AS [Name],
v.object_id AS [ID]
FROM
sys.all_views AS v
WHERE
(v.type = @_msparam_0)
ORDER BY
[Schema] ASC,[Name] ASC
