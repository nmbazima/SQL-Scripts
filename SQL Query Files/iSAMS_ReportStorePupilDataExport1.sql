WITH Pupils AS 
(SELECT DISTINCT txtSchoolID
FROM TblReportsStorePupilArchive 
WHERE (TblReportsStorePupilArchive.intReportCycle = @intReportCycle)
AND (TblReportsStorePupilArchive.intNCYear IN 
(SELECT ID FROM dbo.SplitCSV(@intNCYear) AS SplitCSV_1) OR @intNCYear IS NULL) 
AND (TblReportsStorePupilArchive.txtForm IN 
(SELECT ID FROM dbo.SplitCSV(@txtForm) AS SplitCSV_1) OR @txtForm IS NULL) 
AND (TblReportsStorePupilArchive.txtSchoolID IN 
(SELECT ID FROM dbo.SplitCSV(@txtSchoolID) AS SplitCSV_1) OR @txtSchoolID IS NULL) 
AND (TblReportsStorePupilArchive.txtBoardingHouse IN
(SELECT	ID	FROM dbo.SplitCSV(@txtHouse) AS SplitCSV_1) OR @txtHouse IS NULL 
OR
TblReportsStorePupilArchive.txtAcademicHouse IN
(SELECT ID FROM dbo.SplitCSV(@txtHouse) AS SplitCSV_1) OR @txtHouse IS NULL)
)

SELECT AcademicReports.*,DENSE_RANK() OVER 
    (PARTITION BY AcademicReports.txtSchoolID ORDER BY AcademicReports.intReportTypeID, AcademicReports.intSubjectOrder, AcademicReports.txtCurrentSubjectReportName,AcademicReports.txtSubmitBySurname, AcademicReports.txtSubmitByFirstname  ASC) AS intReportRank

FROM VwReportsManagementAcademicReports AS AcademicReports
INNER JOIN Pupils ON AcademicReports.txtSchoolID = Pupils.txtSchoolID
WHERE (AcademicReports.intReportProgress = 1) 
AND (AcademicReports.intReportCycleID = @intReportCycle)
AND (AcademicReports.txtID IN 
	(SELECT ID FROM dbo.SplitCSV(@txtSubject) AS SplitCSV_1) OR @txtSubject IS NULL)
