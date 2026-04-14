select 
		TblReportsStore.TblReportsStoreId as [ReportsStoreId]
		, TblReportsStore.intReportCycle as [ReportCycleId]
		, TblReportsStore.intID as [SubjectId]
		, TblReportsStore.txtSubId as [SetFormName]
		, TblReportsStore.intTemplate  as [Template]
		, TblReportsStore.txtSubmitBy  as [Teacher]
		, TblReportsStore.txtSchoolId  as [SchoolId]
		, TblReportsStore.intProgress  as [Progress]
		
		, TblReportsStoreGrades.TblReportsStoreGradesId as [ReportsStoreGradesId]
		, TblReportsStoreGrades.intGradeId as [GradeElementId]
		, TblReportsStoreGrades.txtGrade as [GradeValue]
		, TblReportsStoreResults.TblReportsStoreResultsId as [ReportsStoreResultsId]
		, TblReportsStoreResults.intResultId as [ResultElementId]
		, TblReportsStoreResults.txtResult as [ResultValue]
		, TblReportsStorePositions.TblReportsStorePositionsId as [ReportsStorePositionsId]
		, TblReportsStorePositions.intPositionId as [PositionElementId]
		, TblReportsStorePositions.txtPosition as [PositionValue]
		
		, TblReportsStoreComments.TblReportsStoreCommentsId as [ReportsStoreCommentsId]
		, TblReportsStoreComments.intCommentId as [CommentElementId]
		, TblReportsStoreComments.txtComment as [CommentValue]

		from 
			TblReportsStore

			inner join TblpupilManagementPupils on TblReportsStore.txtSchoolId = TblpupilManagementPupils.txtSchoolId

			left outer join TblReportsStoreGrades on TblReportsStore.TblReportsStoreId = TblReportsStoreGrades.intReportID
			left outer join TblReportsStoreResults on TblReportsStore.TblReportsStoreId = TblReportsStoreResults.intReportID
			left outer join TblReportsStorePositions on TblReportsStore.TblReportsStoreId = TblReportsStorePositions.intReportID
			left outer join TblReportsStoreComments on TblReportsStore.TblReportsStoreId = TblReportsStoreComments.intReportID
			
		where
			TblReportsStore.intReportCycle = @intCycleID
			and TblReportsStore.intReportType = 1
			
			and (TblReportsStore.intID in (SELECT * FROM dbo.SplitCSV(@sSubjectCsv)) or @sSubjectCsv is null)						
			and (TblReportsStore.txtSubId in (SELECT * FROM dbo.SplitCSV(@sSetCsv)) or @sSetCsv is null)	
			
			and (TblPupilManagementPupils.intNCYear in (SELECT * FROM dbo.SplitCSV(@iNCYearsCsv)) or @iNCYearsCsv is null)
			and (TblPupilManagementPupils.txtForm in (SELECT * FROM dbo.SplitCSV(@sFormsCsv)) or @sFormsCsv is null) 
			and (TblPupilManagementPupils.txtAcademicHouse in (SELECT * FROM dbo.SplitCSV(@sAHousesCsv)) or @sAHousesCsv is null) 
			and (TblPupilManagementPupils.txtBoardingHouse in (SELECT * FROM dbo.SplitCSV(@sBHousesCsv)) or @sBHousesCsv is null) 
			and (TblPupilManagementPupils.txtSurname like @sSurname+'%' or @sSurname is null)	
			and (TblPupilManagementPupils.txtPreName like @sPrefname+'%' or @sPrefname is null)	
			and (TblPupilManagementPupils.txtForename like @sForename+'%' or @sForename is null)	
			and (TblPupilManagementPupils.txtGender = @sGender or @sGender is null)	
			
		order by 
			TblReportsStore.intReportCycle
			, TblReportsStore.TblReportsStoreId
			, TblReportsStoreGrades.TblReportsStoreGradesId
			, TblReportsStoreResults.TblReportsStoreResultsId
			, TblReportsStorePositions.TblReportsStorePositionsId

