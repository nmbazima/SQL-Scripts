SELECT  y.txtYearCode,  p.txtForename, p.txtPreName, p.txtSurname,  UPPER(p.txtGender), p.txtForm,  p.txtAcademicHouse, p.txtBoardingHouse,  p.txtschoolid, p.txtNationality, p.txtMiddleNames,  oos.TblRegistrationOutOfSchoolPupilsID, oos.txtStartDateTime AS oosStartDateTime,  oos.txtEndDateTime AS oosEndDateTime, oos.txtReason AS oosReason, oos.intCode AS oosCode,  oos.txtNotes AS oosNotes, oos.txtSubmitBy AS oosSubmitBy, oos.txtSubmitDateTime AS oosSubmitDateTime,  oosrc.txtCode + ' - ' + oosrc.txtName AS oosCodeName,  rp.TblRegistrationSchoolRegistrationPupilsID, rp.txtSubmitBy, rp.blnRegistered, rp.intCode,  rp.intPresentCode, rp.txtReason, ISNULL(rp.blnLate, 0) AS blnLate, rp.intMinutesLate, rp.blnAlert, rp.dtLeavingEarly,  rc.txtCode + ' - ' + rc.txtName AS txtCodeName,  pc.txtCode + ' - ' + pc.txtName AS txtPresentCodeName,  r.TblRegistrationSchoolRegistrationRegisterId AS intRegister,  s.FullName,  s1.Initials AS txtPastoralTutor,  (SELECT TOP 1 pp.txtPath   FROM TblPupilManagementPictures pp  WHERE pp.txtSchoolId = p.txtSchoolId ORDER BY pp.intOrder DESC) AS txtPupilImage,  p.intMedicalFlag, p.txtAdditionalHealth,  sen.intSENFlag, sen.txtNotes AS txtSENNote,  d.txtAMPM,  p.intpersonID  FROM TblPupilManagementPupils p  INNER JOIN (SELECT DISTINCT g1.txtSchoolId, g1.txtFieldName, g1.txtValue, g1.intRegister  FROM TblRegistrationSchoolRegistrationPupilsGroups g1  WHERE g1.txtFieldName = 'txtTutorGroup'  AND g1.txtValue = 'SMK18233974181440005'  ) g  ON p.txtSchoolId = g.txtSchoolID  INNER JOIN TblRegistrationSchoolRegistrationPupils rp  ON (rp.intRegister = g.intRegister  AND rp.txtSchoolID = g.txtSchoolID)  INNER JOIN TblRegistrationSchoolRegistrationRegister r  ON r.TblRegistrationSchoolRegistrationRegisterId = g.intRegister  INNER JOIN TblRegistrationSchoolRegistrationDateTime d  ON d.TblRegistrationSchoolRegistrationDateTimeID = r.intRegistrationDateTime  LEFT JOIN TblRegistrationSchoolRegistrationCodes rc  ON rc.TblRegistrationSchoolRegistrationCodesID = rp.intCode  LEFT JOIN TblRegistrationSchoolRegistrationPresentCodes pc  ON pc.TblRegistrationSchoolRegistrationPresentCodesID = rp.intPresentCode  LEFT JOIN (SELECT * FROM TblRegistrationOutOfSchoolPupils  WHERE '16-Oct-2019 07:20:00' BETWEEN txtStartDateTime AND txtEndDateTime) oos  ON oos.txtSchoolID = p.txtSchoolID  LEFT JOIN TblRegistrationSchoolRegistrationCodes oosrc  ON oosrc.TblRegistrationSchoolRegistrationCodesID = oos.intCode  LEFT JOIN TblStaff s  ON s.User_code = oos.txtSubmitBy  LEFT JOIN TblStaff s1  ON s1.User_Code = p.txtTutor  LEFT JOIN (SELECT txtYearCode, intNCYear AS iNCYear FROM TblSchoolManagementYears) y  ON y.iNCYear = p.intNCYear  LEFT JOIN TblSENManagerRegister sen  ON sen.txtSchoolId = p.txtSchoolId  WHERE d.txtDateTime = '16-Oct-2019 07:20:00'  ORDER BY txtSurname ASC, p.txtForename ASC 