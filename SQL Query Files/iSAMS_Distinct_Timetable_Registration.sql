SELECT DISTINCT  TblRegistrationSchoolRegistrationDateTimeObjects.txtObject,  TblRegistrationSchoolRegistrationDateTimeObjects.txtFieldName,  CASE  WHEN (TblRegistrationSchoolRegistrationDateTimeObjects.txtObject = 'Set') THEN  (SELECT TOP 1 s.txtCode  FROM TblTimetableManagerSchedule s  INNER JOIN (SELECT TblTimetableManagerTimetablesID  FROM TblTimetableManagerTimetables  WHERE intPublished = 1) t  ON t.TblTimetableManagerTimetablesID = s.intTimetableID  INNER JOIN (SELECT TOP 1 p.TblTimetableManagerPeriodsID  FROM TblTimetableManagerPeriods p  INNER JOIN TblTimetableManagerDays d  ON d.TblTimetableManagerDaysID = p.intDay  INNER JOIN TblTimetableManagerWeeks w  ON w.TblTimetableManagerWeeksId = d.intWeek  INNER JOIN TblTimetableManagerWeeksAllocations a  ON a.intWeek = w.TblTimetableManagerWeeksID  WHERE convert(datetime, RIGHT(DATEADD(n, -5, '17-Oct-2019 07:20:00'), 8),8) = CONVERT(datetime, p.txtStartTime, 8)  AND convert(datetime, RIGHT(DATEADD(n, (10 + 1), '17-Oct-2019 07:20:00'), 8),8) = CONVERT(datetime, p.txtEndTime, 8)  AND d.intDay = DATEPART(WEEKDAY, '17-Oct-2019')  AND w.intActive = 1  AND a.intWeek = '2'  AND a.intYear = YEAR(DATEADD(d, (-1 * CAST(CAST('17-Oct-2019' AS DATETIME) as integer) % 7), '17-Oct-2019'))  AND a.intYearWeek = DATEPART(ww, '17-Oct-2019') ) p  ON p.TblTimetableManagerPeriodsID = s.intPeriod  WHERE s.txtCode = TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue)  WHEN (TblRegistrationSchoolRegistrationDateTimeObjects.txtObject = 'Tutor Group') THEN  (SELECT TOP 1 (TblStaff.Surname + ', ' + TblStaff.firstname) As TutorName  FROM TblStaff  INNER JOIN TblPupilManagementPupils  ON TblPupilManagementPupils.txtTutor = TblStaff.User_Code  WHERE TblStaff.User_Code = TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue AND TblStaff.SystemStatus <> -1)  ELSE  TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue  END AS txtName,  CASE WHEN TblRegistrationSchoolRegistrationDateTimeObjects.txtObject = 'Set' AND TblRegistrationSchoolRegistrationDateTimeObjects.blnUsesCurriculumManager = 1 THEN  (SELECT DISTINCT  CASE WHEN  (SELECT COUNT(TblCurriculumManagerModuleGroupTeacher.txtTeacher)  FROM TblCurriculumManagerModuleGroupTeacher  WHERE TblCurriculumManagerModuleGroupTeacher.intGroupId = TblCurriculumManagerModuleGroup.TblCurriculumManagerModuleGroupId  AND (TblCurriculumManagerModuleGroupTeacher.dteRemovedOn is NULL OR TblCurriculumManagerModuleGroupTeacher.dteRemovedOn > @date)  AND TblCurriculumManagerModuleGroupTeacher.txtTeacher = 'TUS22906368959622404') > 0  THEN  CASE WHEN  (SELECT COUNT(TblCurriculumManagerModuleGroupTeacher.txtTeacher)  FROM TblCurriculumManagerModuleGroupTeacher  WHERE TblCurriculumManagerModuleGroupTeacher.intGroupId = TblCurriculumManagerModuleGroup.TblCurriculumManagerModuleGroupId  AND (TblCurriculumManagerModuleGroupTeacher.dteRemovedOn is NULL OR TblCurriculumManagerModuleGroupTeacher.dteRemovedOn > @date)  AND TblCurriculumManagerModuleGroupTeacher.blnPrimary = 1  AND TblCurriculumManagerModuleGroupTeacher.txtTeacher = 'TUS22906368959622404') > 0  THEN  'Primary'  ELSE  'True'  END  ELSE  'False'  END AS txtIsTeacher  FROM TblCurriculumManagerModuleGroup  INNER JOIN TblCurriculumManagerModuleCourseLink  ON TblCurriculumManagerModuleCourseLink.TblCurriculumManagerModuleCourseLinkId = TblCurriculumManagerModuleGroup.intModuleCourseId  INNER JOIN TblCurriculumManagerCourseScheduleLink  ON TblCurriculumManagerCourseScheduleLink.TblCurriculumManagerCourseScheduleLinkId = TblCurriculumManagerModuleCourseLink.intCourseScheduleLinkId  INNER JOIN TblCurriculumManagerCourseSchedule  ON TblCurriculumManagerCourseSchedule.TblCurriculumManagerCourseScheduleId = TblCurriculumManagerCourseScheduleLink.intCourseScheduleId  WHERE TblCurriculumManagerModuleGroup.intGroupListId = TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue  AND @date BETWEEN  COALESCE(TblCurriculumManagerModuleCourseLink.dteStartTime, DATEADD(dd,1,TblCurriculumManagerCourseSchedule.dteStartDate), DATEADD(n,-1,@date))  AND COALESCE(TblCurriculumManagerModuleCourseLink.dteEndTime, DATEADD(dd,1,TblCurriculumManagerCourseSchedule.dteEndDate), DATEADD(n,1,@date)))  WHEN TblRegistrationSchoolRegistrationDateTimeObjects.txtObject = 'Form' AND TblRegistrationSchoolRegistrationDateTimeObjects.blnUsesCurriculumManager = 1 THEN  (SELECT DISTINCT  CASE WHEN  (SELECT COUNT(TblCurriculumManagerModuleGroupTeacher.txtTeacher)  FROM TblCurriculumManagerModuleGroupTeacher  WHERE TblCurriculumManagerModuleGroupTeacher.intGroupId = TblCurriculumManagerModuleGroup.TblCurriculumManagerModuleGroupId  AND (TblCurriculumManagerModuleGroupTeacher.dteRemovedOn is NULL OR TblCurriculumManagerModuleGroupTeacher.dteRemovedOn > @date)  AND TblCurriculumManagerModuleGroupTeacher.txtTeacher = 'TUS22906368959622404') > 0  THEN  CASE WHEN  (SELECT COUNT(TblCurriculumManagerModuleGroupTeacher.txtTeacher)  FROM TblCurriculumManagerModuleGroupTeacher  WHERE TblCurriculumManagerModuleGroupTeacher.intGroupId = TblCurriculumManagerModuleGroup.TblCurriculumManagerModuleGroupId  AND (TblCurriculumManagerModuleGroupTeacher.dteRemovedOn is NULL OR TblCurriculumManagerModuleGroupTeacher.dteRemovedOn > @date)  AND TblCurriculumManagerModuleGroupTeacher.blnPrimary = 1  AND TblCurriculumManagerModuleGroupTeacher.txtTeacher = 'TUS22906368959622404') > 0  THEN  'Primary'  ELSE  'True'  END  ELSE  'False'  END AS txtIsTeacher  FROM TblCurriculumManagerModuleGroup  INNER JOIN TblCurriculumManagerModuleCourseLink  ON TblCurriculumManagerModuleCourseLink.TblCurriculumManagerModuleCourseLinkId = TblCurriculumManagerModuleGroup.intModuleCourseId  INNER JOIN TblCurriculumManagerCourseScheduleLink  ON TblCurriculumManagerCourseScheduleLink.TblCurriculumManagerCourseScheduleLinkId = TblCurriculumManagerModuleCourseLink.intCourseScheduleLinkId  INNER JOIN TblCurriculumManagerCourseSchedule  ON TblCurriculumManagerCourseSchedule.TblCurriculumManagerCourseScheduleId = TblCurriculumManagerCourseScheduleLink.intCourseScheduleId  WHERE TblCurriculumManagerModuleGroup.txtForm = TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue  AND @date BETWEEN  COALESCE(TblCurriculumManagerModuleCourseLink.dteStartTime, DATEADD(dd,1,TblCurriculumManagerCourseSchedule.dteStartDate), DATEADD(n,-1,@date))  AND COALESCE(TblCurriculumManagerModuleCourseLink.dteEndTime, DATEADD(dd,1,TblCurriculumManagerCourseSchedule.dteEndDate), DATEADD(n,1,@date)))  WHEN (TblRegistrationSchoolRegistrationDateTimeObjects.txtObject = 'Form') AND (TblRegistrationSchoolRegistrationDateTimeObjects.blnUsesCurriculumManager = 0) THEN  CASE WHEN  (SELECT COUNT(TblSchoolManagementForms.txtForm)  FROM TblSchoolManagementForms  WHERE TblSchoolManagementForms.txtForm = TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue  AND TblSchoolManagementForms.txtFormTutor = 'TUS22906368959622404') > 0  THEN  'Primary'  ELSE  'False'  END  WHEN (TblRegistrationSchoolRegistrationDateTimeObjects.txtObject = 'Set') AND (TblRegistrationSchoolRegistrationDateTimeObjects.blnUsesCurriculumManager = 0) THEN  CASE WHEN  (SELECT COUNT(TblTimetableManagerSchedule.intPeriod)  FROM TblTimetableManagerSchedule  WHERE TblTimetableManagerSchedule.intTimetableID = (SELECT TblTimetableManagerTimetablesID FROM TblTimetableManagerTimetables WHERE intPublished = 1)  AND TblTimetableManagerSchedule.txtTeacher = 'TUS22906368959622404'  AND TblTimetableManagerSchedule.txtCode = TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue  AND TblTimetableManagerSchedule.intPeriod IN (  SELECT TblTimetableManagerPeriods.TblTimetableManagerPeriodsID  FROM TblTimetableManagerPeriods  INNER JOIN TblTimetableManagerDays ON TblTimetableManagerDays.TblTimetableManagerDaysID = TblTimetableManagerPeriods.intDay  INNER JOIN TblTimetableManagerWeeks ON TblTimetableManagerDays.intWeek = TblTimetableManagerWeeks.TblTimetableManagerWeeksID  INNER JOIN TblTimetableManagerWeeksAllocations ON TblTimetableManagerWeeksAllocations.intWeek = TblTimetableManagerWeeks.TblTimetableManagerWeeksID  WHERE convert(datetime, RIGHT(DATEADD(n, -5, '17-Oct-2019 07:20:00'), 8),8) = CONVERT(datetime, TblTimetableManagerPeriods.txtStartTime, 8)  AND convert(datetime, RIGHT(DATEADD(n, (10 + 1), '17-Oct-2019 07:20:00'), 8),8) = CONVERT(datetime, TblTimetableManagerPeriods.txtEndTime, 8)  AND TblTimetableManagerDays.intDay = DATEPART(WEEKDAY, '17-Oct-2019')  AND TblTimetableManagerWeeks.intActive = 1  AND TblTimetableManagerWeeksAllocations.intWeek = '2'  AND TblTimetableManagerWeeksAllocations.intYear = YEAR('17-Oct-2019')  AND TblTimetableManagerWeeksAllocations.intYearWeek = DATEPART(WEEK, '17-Oct-2019')  )) > 0  THEN  'Primary'  ELSE  'False'  END  WHEN (TblRegistrationSchoolRegistrationDateTimeObjects.txtObject = 'Tutor Group') THEN  CASE WHEN  (SELECT COUNT(TblPupilManagementPupils.TblPupilManagementPupilsId)  FROM TblPupilManagementPupils  WHERE TblPupilManagementPupils.txtTutor = TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue  AND TblPupilManagementPupils.txtTutor = 'TUS22906368959622404') > 0  THEN  'Primary'  ELSE  'False'  END  WHEN (TblRegistrationSchoolRegistrationDateTimeObjects.txtObject = 'Year') THEN  CASE WHEN  (SELECT COUNT(TblSchoolManagementYears.intNCYear)  FROM TblSchoolManagementYears  WHERE TblSchoolManagementYears.txtYearCode = TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue  AND TblSchoolManagementYears.txtYearTutor = 'TUS22906368959622404') > 0  THEN  'Primary'  WHEN  (SELECT COUNT(TblSchoolManagementYears.intNCYear)  FROM TblSchoolManagementYears  WHERE TblSchoolManagementYears.txtYearCode = TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue  AND TblSchoolManagementYears.txtAsstYearTutor = 'TUS22906368959622404') > 0  THEN  'True'  ELSE  'False'  END  WHEN (TblRegistrationSchoolRegistrationDateTimeObjects.txtObject = 'Boarding House') THEN  CASE WHEN  (SELECT COUNT(TblSchoolManagementHouses.txtHouseName)  FROM TblSchoolManagementHouses  WHERE TblSchoolManagementHouses.txtHouseName = TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue  AND txtHouseType = 'Boarding'  AND TblSchoolManagementHouses.txtHouseMaster = 'TUS22906368959622404') > 0  THEN  'Primary'  WHEN  (SELECT COUNT(TblSchoolManagementHouses.txtHouseName)  FROM TblSchoolManagementHouses  WHERE TblSchoolManagementHouses.txtHouseName = TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue  AND txtHouseType = 'Boarding'  AND TblSchoolManagementHouses.txtAssistantHouseMaster = 'TUS22906368959622404') > 0  THEN  'True'  ELSE  'False'  END  WHEN (TblRegistrationSchoolRegistrationDateTimeObjects.txtObject = 'Academic House') THEN  CASE WHEN  (SELECT COUNT(TblSchoolManagementHouses.txtHouseName)  FROM TblSchoolManagementHouses  WHERE TblSchoolManagementHouses.txtHouseName = TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue  AND txtHouseType = 'Academic'  AND TblSchoolManagementHouses.txtHouseMaster = 'TUS22906368959622404') > 0  THEN  'Primary'  WHEN  (SELECT COUNT(TblSchoolManagementHouses.txtHouseName)  FROM TblSchoolManagementHouses  WHERE TblSchoolManagementHouses.txtHouseName = TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue  AND txtHouseType = 'Academic'  AND TblSchoolManagementHouses.txtAssistantHouseMaster = 'TUS22906368959622404') > 0  THEN  'True'  ELSE  'False'  END  ELSE  'False'  END  AS txtIsTeacher,  TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue  FROM TblRegistrationSchoolRegistrationDateTimeRulesObjects  INNER JOIN TblRegistrationSchoolRegistrationDateTimeObjects  ON TblRegistrationSchoolRegistrationDateTimeObjects.TblRegistrationSchoolRegistrationDateTimeObjectsID = TblRegistrationSchoolRegistrationDateTimeRulesObjects.intObject  INNER JOIN TblRegistrationSchoolRegistrationDateTimeRules  ON TblRegistrationSchoolRegistrationDateTimeRules.TblRegistrationSchoolRegistrationDateTimeRulesID = TblRegistrationSchoolRegistrationDateTimeRulesObjects.intRule  WHERE intRule = '7'  ORDER BY TblRegistrationSchoolRegistrationDateTimeObjects.txtObject, txtName,  TblRegistrationSchoolRegistrationDateTimeRulesObjects.txtValue 