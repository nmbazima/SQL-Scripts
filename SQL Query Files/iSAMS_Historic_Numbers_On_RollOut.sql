SELECT txtSchoolID, txtSurname, txtPreName, txtForm, txtBoardingHouse, intNCYear, dteSubmitDateTime
FROM dbo.TblPupilManagementPupilsArchive
WHERE 1=1
AND intNCYear IS NOT NULL