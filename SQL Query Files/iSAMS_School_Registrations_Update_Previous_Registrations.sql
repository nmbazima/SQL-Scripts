UPDATE TblRegistrationSchoolRegistrationPrevious  SET TblRegistrationSchoolRegistrationPrevious.xmlCombinedPrevious = (  (SELECT TOP (SELECT TOP 1 (con5.intFlags + 1 + (  SELECT COUNT(TblRegistrationSchoolRegistrationDateTimeId) AS PeriodsNotShownForToday  FROM TblRegistrationSchoolRegistrationDateTime  LEFT JOIN (SELECT TOP 1 blnAllowPreEnteringForDay  FROM TblRegistrationSchoolRegistrationConfiguration) con  ON con.blnAllowPreEnteringForDay IS NOT NULL  WHERE DAY(@date) = DAY(txtDateTime)  AND MONTH(@date) = MONTH(txtDateTime)  AND YEAR(@date) = YEAR(txtDateTime)  AND con.blnAllowPreEnteringForDay = 0  )) FROM TblRegistrationSchoolRegistrationConfiguration con5)  TblRegistrationSchoolRegistrationPrevious.txtSchoolId AS '@S',  dt.TblRegistrationSchoolRegistrationDateTimeID AS I,  CONVERT(varchar(11),dt.txtDateTime,113) AS D,  RIGHT(CONVERT(varchar(17),dt.txtDateTime,113),5) AS T,  RIGHT(CONVERT(varchar(17),DATEADD(n,-dt.intBack,dt.txtDateTime),113),5) AS S,  dt.txtAmPm AS A,  dt.txtFriendlyName AS F,  CASE WHEN NOT oosp.txtSchoolID IS NULL AND rp.blnRegistered = 0 THEN  4  ELSE  CASE WHEN rp.txtSubmitBy IS NULL THEN  2  ELSE  CASE WHEN (ISNULL(rp.blnLate, 0) = 1 AND rp.blnRegistered = 1) THEN  3  WHEN rp.blnRegistered = 0 THEN  0  WHEN rp.blnRegistered = 1 THEN  1  END  END  END AS Y,  CASE WHEN NOT oosp.txtSchoolID IS NULL AND rp.blnRegistered = 0 THEN  con.txtDefaultOOSColour  ELSE  CASE WHEN rp.txtSubmitBy IS NULL THEN  'FFFFFF'  ELSE  CASE WHEN (ISNULL(rp.blnLate, 0) = 1 AND rp.blnRegistered = 1) THEN  CASE WHEN (pc.txtColour IS NULL) OR (pc.txtColour = con.txtDefaultPresentColour) THEN  con.txtDefaultLateColour  ELSE  pc.txtColour  END  WHEN rp.blnRegistered = 0 THEN  CASE WHEN rc.txtColour IS NULL THEN  con.txtDefaultAbsentColour  ELSE  rc.txtColour  END  WHEN rp.blnRegistered = 1 THEN  CASE WHEN pc.txtColour IS NULL THEN  con.txtDefaultPresentColour  ELSE  pc.txtColour  END  END  END  END AS L,  CASE WHEN (rp.blnRegistered = 0 OR NOT oosp.txtSchoolID IS NULL) AND (NOT rc.txtCode IS NULL) THEN  rc.txtCode  WHEN NOT pc.txtCode IS NULL THEN  pc.txtCode  END AS C,  CASE WHEN (rp.blnRegistered = 0 OR NOT oosp.txtSchoolID IS NULL) AND (NOT rc.txtCode IS NULL) THEN  rc.txtName  WHEN NOT pc.txtCode IS NULL THEN  pc.txtName  END AS N,  rp.blnReason AS R,  CASE WHEN DATEDIFF(d,dt.txtDateTime,@date) < con.intNavigateRegistration THEN  1  ELSE  0  END AS V,  rpg.txtFieldName AS X, rpg.txtObject AS O, rpg.txtName AS J, rpg.txtValue AS Z  FROM TblRegistrationSchoolRegistrationDateTime dt  LEFT JOIN TblRegistrationSchoolRegistrationRegister rr  ON rr.intRegistrationDateTime = dt.TblRegistrationSchoolRegistrationDateTimeID  LEFT JOIN (SELECT CASE WHEN txtReason IS NULL THEN '0' ELSE '1' END AS blnReason, *  FROM TblRegistrationSchoolRegistrationPupils  WHERE txtSchoolID = TblRegistrationSchoolRegistrationPrevious.txtSchoolID) rp  ON rp.intRegister = rr.TblRegistrationSchoolRegistrationRegisterID  LEFT JOIN (SELECT DISTINCT txtSchoolID, txtStartDateTime, txtEndDateTime  FROM TblRegistrationOutOfSchoolPupils WHERE txtSchoolID = TblRegistrationSchoolRegistrationPrevious.txtSchoolID) oosp  ON dt.txtDateTime BETWEEN oosp.txtStartDateTime AND oosp.txtEndDateTime  LEFT JOIN TblRegistrationSchoolRegistrationCodes rc  ON rc.TblRegistrationSchoolRegistrationCodesID = rp.intCode  LEFT JOIN TblRegistrationSchoolRegistrationPresentCodes pc  ON pc.TblRegistrationSchoolRegistrationPresentCodesID = rp.intPresentCode  LEFT JOIN (SELECT g.intRegister, g.txtFieldName, g.txtObject, g.txtValue,  CASE WHEN g.txtFieldName = 'txtTutorGroup' THEN s.Initials ELSE g.txtValue END AS txtName  FROM TblRegistrationSchoolRegistrationPupilsGroups g  LEFT JOIN TblStaff s  ON s.User_Code = txtValue  WHERE g.txtSchoolID = TblRegistrationSchoolRegistrationPrevious.txtSchoolID) rpg  ON (rpg.intRegister = rr.TblRegistrationSchoolRegistrationRegisterId)  LEFT JOIN (SELECT TOP 1 TblRegistrationSchoolRegistrationConfigurationID, txtDefaultPresentColour,  txtDefaultAbsentColour, txtDefaultLateColour, txtDefaultOOSColour, intNavigateRegistration  FROM TblRegistrationSchoolRegistrationConfiguration) con  ON con.TblRegistrationSchoolRegistrationConfigurationID IS NOT NULL  WHERE dt.txtDateTime <= CAST(FLOOR(CAST(DATEADD(d,1,@date) AS FLOAT)) AS DATETIME)  ORDER BY dt.txtDateTime DESC  for xml path('E'), root('P'))  ),  TblRegistrationSchoolRegistrationPrevious.dteSubmitDateTime = @date  WHERE TblRegistrationSchoolRegistrationPrevious.txtSchoolId IN ('150948382122','102407020931','101928553631'); 
