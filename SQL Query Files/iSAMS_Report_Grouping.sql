INSERT INTO #TblPupilsGroups (intRegister, intRule, txtFieldName, txtObject, txtValue,
									  intSubject, txtTeacher, txtSchoolId, dteSubmitDateTime, intOrder)

		SELECT DISTINCT r.TblRegistrationSchoolRegistrationRegisterID AS intRegister,
		d.intRule, 
		o.txtFieldName, 
		o.txtObject, 
		ro.txtValue,
		a.intSubject,
		CASE 
			WHEN 
				o.txtObject = 'Set' AND tt.txtTeacher IS NOT NULL
			THEN 
				tt.txtTeacher 
			ELSE
				a.txtUserCode
			END AS txtTeacher, 
		a.txtSchoolId,
		@submitdate AS dteSubmitDateTime,

		CASE WHEN
			-- Check if the rules are ordered, rules created and 
			-- not updated since this code was introduced won't be
			(SELECT intOrder 
			FROM TblRegistrationSchoolRegistrationDateTimeRulesObjectsOrder 
			WHERE intObject = o.TblRegistrationSchoolRegistrationDateTimeObjectsID
			AND intRule = d.intRule) IS NULL 
		THEN
			-- An order hasn't been specified, use the default ordering (for old rules)
			-- if updated, update the rules page to match the ordering.
			CASE
				-- This default order can be changed by the user
				WHEN o.txtFieldName = 'txtSetCode' THEN 0
				WHEN o.txtFieldName = 'txtForm' THEN 1
				WHEN o.txtFieldName = 'txtBoardingHouse' THEN 2
				WHEN o.txtFieldName = 'txtAcademicHouse' THEN 3
				WHEN o.txtFieldName = 'txtYearCode' THEN 4
				WHEN o.txtFieldName = 'txtTutorGroup' THEN 5
			END
		ELSE
			-- An order is specified for the rule items, retrieve it
			(SELECT intOrder 
			FROM TblRegistrationSchoolRegistrationDateTimeRulesObjectsOrder 
			WHERE intObject = o.TblRegistrationSchoolRegistrationDateTimeObjectsID
			AND intRule = d.intRule)
		END AS intOrder

		-- Groups will be created for the days registers
		FROM TblRegistrationSchoolRegistrationRegister r

		-- Only update groups for the current day
		-- Otherwise when rules are changed, for example for
		-- a new term, duplicates could be added in the past
		INNER JOIN (SELECT dt.TblRegistrationSchoolRegistrationDateTimeId, 
					dt.intRule, dt.txtDateTime, dt.intBack, dt.intForward 
					FROM TblRegistrationSchoolRegistrationDateTime dt
					WHERE DAY(dt.txtDateTime) = DAY(@date)
					AND MONTH(dt.txtDateTime) = MONTH(@date)
					AND YEAR(dt.txtDateTime) = YEAR(@date)
		) d
		ON d.TblRegistrationSchoolRegistrationDateTimeId = r.intRegistrationDateTime

		INNER JOIN TblRegistrationSchoolRegistrationDateTimeRulesObjects ro
		ON ro.intRule = d.intRule

		INNER JOIN TblRegistrationSchoolRegistrationDateTimeObjects o
		ON o.TblRegistrationSchoolRegistrationDateTimeObjectsID = ro.intObject

		-- Check if sets available in the rule also match those timetabled for the registration period
		LEFT JOIN (SELECT s.TblTimetableManagerScheduleId, s.txtCode, s.txtTeacher, 
					p.intYearWeek, p.intYear, p.intDay, p.txtStartTime, p.txtEndTime, p.intDivision
					FROM TblTimetableManagerSchedule s
					INNER JOIN (SELECT TblTimetableManagerTimetablesID FROM TblTimetableManagerTimetables
								WHERE intPublished = 1) t
					ON t.TblTimetableManagerTimetablesID = s.intTimetableID
					INNER JOIN (SELECT p.TblTimetableManagerPeriodsID, a.intYearWeek, 
								a.intYear, da.intDay, p.txtStartTime, p.txtEndTime, a.intDivision
								FROM TblTimetableManagerPeriods p
								INNER JOIN TblTimetableManagerDays da
								ON da.TblTimetableManagerDaysID = p.intDay
								INNER JOIN TblTimetableManagerWeeks w
								ON w.TblTimetableManagerWeeksId = da.intWeek
								INNER JOIN TblTimetableManagerWeeksAllocations a
								ON a.intWeek = w.TblTimetableManagerWeeksID AND a.intDivision IS NULL
								WHERE w.intActive = 1
								AND p.txtStartTime IS NOT NULL
								AND LTRIM(RTRIM(p.txtStartTime)) <> ':' 
								AND p.txtEndTime IS NOT NULL
								AND LTRIM(RTRIM(p.txtEndTime)) <> ':'
								) p
					ON p.TblTimetableManagerPeriodsID = s.intPeriod
				) tt
		ON (tt.txtCode = ro.txtValue
		AND convert(datetime, RIGHT(DATEADD(n, -d.intBack, d.txtDateTime), 8),8) = CONVERT(datetime, tt.txtStartTime, 8)
		AND convert(datetime, RIGHT(DATEADD(n, (d.intForward + 1), d.txtDateTime), 8),8) = CONVERT(datetime, tt.txtEndTime, 8)
		AND tt.intDay = DATEPART(WEEKDAY, d.txtDateTime)
		AND tt.intYearWeek = DATEPART(ww, d.txtDateTime)
		AND tt.intYear = DATEPART(yy, d.txtDateTime))

		-- RETURN ONLY THE MAIN TEACHER FOR EACH GROUP
		INNER JOIN (
			-- FORMS
			SELECT DISTINCT p1.txtSchoolId AS txtSchoolId, f1.txtFormTutor AS txtUserCode, 
			'txtForm' AS txtObject, f1.txtForm AS txtValue, NULL AS blnCM, NULL AS intSubject
			FROM TblSchoolManagementForms f1
			INNER JOIN TblPupilManagementPupils p1
			ON p1.txtForm = f1.txtForm
			WHERE f1.txtFormTutor IS NOT NULL
			AND p1.txtForm IS NOT NULL

			-- TUTOR GROUP
			UNION
			SELECT DISTINCT p.txtSchoolId AS txtSchoolId, p.txtTutor AS txtUserCode, 
			'txtTutorGroup' AS txtObject, p.txtTutor AS txtValue, NULL AS blnCM, NULL AS intSubject
			FROM TblPupilManagementPupils p
			WHERE p.txtTutor IS NOT NULL AND p.txtTutor <> ''
			AND p.txtTutor IS NOT NULL

			-- YEARS
			UNION
			SELECT DISTINCT p4.txtSchoolId AS txtSchoolId, y1.txtYearTutor AS txtUserCode, 
			'txtYearCode' AS txtObject, convert(nvarchar, y1.intNCYear) AS txtValue, NULL AS blnCM, NULL AS intSubject
			FROM TblSchoolManagementYears y1
			INNER JOIN TblPupilManagementPupils p4
			ON p4.intNCYear = y1.intNCYear
			WHERE y1.txtYearTutor IS NOT NULL AND y1.txtYearTutor <> ''
			AND p4.intNCYear IS NOT NULL
		
			-- BOARDING HOUSE
			UNION
			SELECT DISTINCT p6.txtSchoolId AS txtSchoolId, bh1.txtHouseMaster AS txtUserCode, 
			'txtBoardingHouse' AS txtObject, bh1.txtHouseName AS txtValue, NULL AS blnCM, NULL AS intSubject
			FROM TblSchoolManagementHouses bh1
			INNER JOIN TblPupilManagementPupils p6
			ON p6.txtBoardingHouse = bh1.txtHouseName
			WHERE bh1.txtHouseType = 'Boarding' AND bh1.txtHouseMaster IS NOT NULL
			AND p6.txtBoardingHouse IS NOT NULL

			-- ACADEMIC HOUSE
			UNION
			SELECT DISTINCT p8.txtSchoolId AS txtSchoolId, ah1.txtHouseMaster AS txtUserCode, 
			'txtAcademicHouse' AS txtObject, ah1.txtHouseName AS txtValue, NULL AS blnCM, NULL AS intSubject
			FROM TblSchoolManagementHouses ah1	
			INNER JOIN TblPupilManagementPupils p8
			ON p8.txtAcademicHouse = ah1.txtHouseName
			WHERE ah1.txtHouseType = 'Academic' AND ah1.txtHouseMaster IS NOT NULL
			AND p8.txtAcademicHouse IS NOT NULL

			-- SETS
			UNION
			SELECT DISTINCT p10.txtSchoolId AS txtSchoolId, s.txtTeacher AS txtUserCode,
			'txtSetCode' AS txtObject, s.txtSetCode AS txtValue, 0 AS blnCM, s.intSubject AS intSubject
			FROM TblTeachingManagerSets s
			INNER JOIN TblTeachingManagerSetLists sl
			ON sl.intSetID = s.TblTeachingManagerSetsID
			INNER JOIN TblPupilManagementPupils p10
			ON p10.txtSchoolID = sl.txtSchoolID
			WHERE s.txtTeacher IS NOT NULL

			-- CM SETS
			UNION
			SELECT DISTINCT glp1.txtSchoolId AS txtSchoolId, t1.txtTeacher AS txtUserCode, 
			'txtGroupCode' AS txtObject, gl1.txtRegisterName AS txtValue, 1 AS blnCM, NULL AS intSubject
			FROM TblCurriculumManagerModuleGroupTeacher t1
			INNER JOIN TblCurriculumManagerModuleGroup g1
			ON g1.TblCurriculumManagerModuleGroupId = t1.intGroupId
			INNER JOIN TblCurriculumManagerModuleGroupList gl1
			ON gl1.TblCurriculumManagerModuleGroupListId = g1.intGroupListId
			INNER JOIN TblCurriculumManagerModuleGroupListPupils glp1
			ON glp1.intGroupListId = gl1.TblCurriculumManagerModuleGroupListId

		) AS a
		ON (a.txtValue = ro.txtValue AND a.txtObject = o.txtFieldName AND (a.blnCM = o.blnUsesCurriculumManager OR a.blnCM IS NULL))

		-- Check the pupil will be enrolled during the selected registration period
		INNER JOIN (SELECT txtSchoolId
					FROM TblPupilManagementPupils	
					WHERE ((intSystemStatus = 1 AND (txtEnrolmentDate <= @date OR txtEnrolmentDate IS NULL))
					OR (intSystemStatus = -1 AND ((txtEnrolmentDate <= @date OR txtEnrolmentDate IS NULL) 
					AND DATEADD(d, 1, CAST(CONVERT(char(8), txtLeavingDate, 112) AS datetime)) > @date)))) p	
		ON p.txtSchoolId = a.txtSchoolId

		-- If set check the set also exists on the timetable
		WHERE ((NOT o.txtObject = 'Set') OR (o.txtObject = 'Set' AND tt.txtCode IS NOT NULL
			AND
			-- Check for exceptions for pupils on the timetable
			(SELECT TOP 1 e.TblTimetableManagerScheduleExceptionsId
			FROM TblTimetableManagerScheduleExceptions e
			WHERE e.txtId = a.txtSchoolID
			AND e.intSchedule = tt.TblTimetableManagerScheduleId) IS NULL
		))

		ORDER BY r.TblRegistrationSchoolRegistrationRegisterID, d.intRule, 
		o.txtObject, o.txtFieldName, ro.txtValue, a.txtSchoolId, dteSubmitDateTime;

		-- For testing which groups will be removed
		--SELECT t2.*
		--FROM #TblPupilsGroups t1, #TblPupilsGroups t2
		--WHERE t1.intRegister = t2.intRegister
		--AND t1.txtSchoolId = t2.txtSchoolId
		--AND t1.TblPupilsGroupsId < t2.TblPupilsGroupsId


		-- Delete all but the highest order grouping for each pupil (0 being the highest)
		-- This will leave only one grouping per pupil per registration period and prevent
		-- any duplicates in the groups table
		
