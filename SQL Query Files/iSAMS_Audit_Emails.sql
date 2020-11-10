WITH cte AS 
                (    
                	SELECT 'iSAMS_HRMANAGER' AS ModuleId, 'email.api.hr' AS FeatureToggleName
                	UNION ALL
                	SELECT 'iSAMS_CALENDARMANAGER' AS ModuleId, 'email.api.calendar' AS FeatureToggleName
                	UNION ALL
                	SELECT 'iSAMS_CALENDARWMANAGER' AS ModuleId, 'email.api.calendar' AS FeatureToggleName
                    UNION ALL
                	SELECT 'iSAMS_CONTROLPANEL' AS ModuleId, 'email.api.controlpanel' AS FeatureToggleName
                	UNION ALL
                    SELECT 'iSAMS_DAILYBULLETIN' AS ModuleId, 'email.api.dailybulletin' AS FeatureToggleName	
                	UNION ALL
                	SELECT 'iSAMS_DISCIPLINEMANAGER' AS ModuleId, 'email.api.dm' AS FeatureToggleName
                	UNION ALL
                	SELECT 'iSAMS_EMAILCLIENT' AS ModuleId, 'email.api.emailclient' AS FeatureToggleName
                	UNION ALL
                	SELECT 'iSAMS_NEWSMANAGER' AS ModuleId, 'email.api.newsmanager' AS FeatureToggleName
                	UNION ALL
                	SELECT 'iSAMS_REWARDSMANAGER' AS ModuleId, 'email.api.rewardsmanager' AS FeatureToggleName
                	UNION ALL
                	SELECT 'iSAMS_SCHOOLMANAGEMENT' AS ModuleId, 'email.api.schoolmanager' AS FeatureToggleName
                	UNION ALL
                	SELECT 'iSAMS_TEACHINGMANAGER' AS ModuleId, 'email.api.teachingmanager' AS FeatureToggleName
                	UNION ALL
                	SELECT 'iSAMS_TIMETABLEMANAGER' AS ModuleId, 'email.api.timetablemanager' AS FeatureToggleName
                	UNION ALL 
                	SELECT 'iSAMS_PARENTPORTALMANAGER' AS ModuleId, 'email.api.portals' AS FeatureToggleName
                )
                SELECT 
                    AEM2.txtModuleID as ModuleName,
                    SentSuccess = 
                        (
                            SELECT COUNT(intSent) FROM TblAuditEmailMessages AEM1 
                            WHERE intSent = 1 
                            AND AEM1.txtModuleID = AEM2.txtModuleID
                            AND CONVERT(datetime, AEM1.txtSentDateTime, 101) > @dateCutOff
                        ),
                    SentFail = 
                        (
                            SELECT COUNT(intSent) FROM TblAuditEmailMessages AEM1 
                            WHERE intSent = 0 
                            AND AEM1.txtModuleID = AEM2.txtModuleID
                            AND CONVERT(datetime, AEM1.txtSentDateTime, 101) > @dateCutOff
                        )
                FROM TblAuditEmailMessages AEM2
                inner join cte on AEM2.txtModuleID = cte.ModuleId
                inner join TblFrameworkFeatureToggle on cte.FeatureToggleName = txtKey and blnEnabled=1
                GROUP BY AEM2.txtModuleID
