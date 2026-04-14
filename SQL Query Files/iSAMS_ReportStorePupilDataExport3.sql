SELECT DISTINCT TblReportsManagementTemplatesGrading.txtGradingName as txtName, TblReportsManagementTemplatesGradingID as intOrder , 
1 as [type] 
FROM TblReportsStore 
LEFT OUTER JOIN TblReportsManagementTemplatesGrading ON TblReportsStore.intTemplate = TblReportsManagementTemplatesGrading.intTemplateID 
WHERE (TblReportsStore.intTemplate = 1075) AND txtGradingName IS NOT NULL AND (TblReportsStore.intProgress = 1) 
ORDER BY [type], intOrder ASC
