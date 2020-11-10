CREATE VIEW [tracking].[vwMarkbooks]
AS 
SELECT DISTINCT
	[Model].id,
	[Model].[Name]
FROM
	tracking.Model [Model];