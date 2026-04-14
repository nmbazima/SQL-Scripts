select 

		TblMarkBooksOASSynchronisationDataSourceReport.intReportCycle as [ReportCycleId]
		, TblMarkBooksOASSynchronisationMapping.intReportTemplate as [Template]
		, TblMarkBooksOASSynchronisationMapping.intReportGradeElement as [GradeElementId]
		, TblMarkBooksOASSynchronisationMapping.intReportResultElement as [ResultElementId]
		, TblMarkBooksOASSynchronisationMapping.intReportPositionElement as [PositionElementId]
		, TblMarkBooksMarkbook.txtName as [MarkbookName]
		, TblMarkBooksTest.txtName as [TestName]
		, TblMarkBooksOASSynchronisationMappingMarkbookTest.intMarkbookTest as [MarkbookTestId]
		, TblMarkBooksEntry.txtSchoolId as [PupilSchoolId]
		, TblMarkBooksMark.txtMark as [Mark]
		, tblteachingmanagersets.txtSetCode as [SetCode]
		, tblteachingmanagersets.intSubject as [SubjectId]
		--,*

	from 
		TblMarkBooksOASSynchronisationDataSourceReport
		
	left outer join
		TblMarkBooksOASSynchronisationMapping
			on TblMarkBooksOASSynchronisationDataSourceReport.TblMarkBooksOASSynchronisationDataSourceReportId = TblMarkBooksOASSynchronisationMapping.intDataSourceReport

	left outer join
		TblMarkBooksOASSynchronisationMappingMarkbookTest
			on TblMarkBooksOASSynchronisationMapping.TblMarkBooksOASSynchronisationMappingId = TblMarkBooksOASSynchronisationMappingMarkbookTest.intMapping

	left outer join 
		TblMarkBooksEntry
			on TblMarkBooksOASSynchronisationMappingMarkbookTest.intMarkbookTest = TblMarkBooksEntry.intTest
			
	inner join 
		TblMarkBooksMark
			on TblMarkBooksEntry.TblMarkBooksEntryId = TblMarkBooksMark.intEntry	

	inner join 
		TblMarkBooksTest
			on TblMarkBooksEntry.intTest = TblMarkBooksTest.TblMarkBooksTestId	

	inner join 
		TblMarkBooksMarkbook
			on TblMarkBooksTest.intMarkbook = TblMarkBooksMarkbook.TblMarkBooksMarkbookId
						
	left outer join 
		TblMarkBooksLink
			on TblMarkBooksTest.intMarkbook = TblMarkBooksLink.intMarkBook

	inner join 
		tblteachingmanagersetlists
			on TblMarkBooksLink.intSetId = tblteachingmanagersetlists.intsetid
			and tblteachingmanagersetlists.txtschoolid = TblMarkBooksEntry.txtschoolid

	inner join
		tblteachingmanagersets
			on tblteachingmanagersetlists.intsetid = tblteachingmanagersets.tblteachingmanagersetsId

	inner join 
		tblpupilmanagementpupils
			on tblteachingmanagersetlists.txtschoolid = tblpupilmanagementpupils.txtschoolid
			
	where 
		TblMarkBooksOASSynchronisationDataSourceReport.intPlan = @intMarkbookPlan
		and TblMarkBooksOASSynchronisationDataSourceReport.intReportCycle = @intCycleID
		and (TblMarkBooksTest.intMarkbook = @iMarkbook or @iMarkbook is null)	
		
		and (tblteachingmanagersets.intSubject in (SELECT * FROM dbo.SplitCSV(@sSubjectCsv)) or @sSubjectCsv is null)						
		and (tblteachingmanagersets.txtSetCode in (SELECT * FROM dbo.SplitCSV(@sSetCsv)) or @sSetCsv is null)	
		
		--and (TblPupilManagementPupils.intNCYear in (SELECT * FROM dbo.SplitCSV(@iNCYearsCsv)) or @iNCYearsCsv is null)
		--and (TblPupilManagementPupils.txtForm in (SELECT * FROM dbo.SplitCSV(@sFormsCsv)) or @sFormsCsv is null) 
		--and (TblPupilManagementPupils.txtAcademicHouse in (SELECT * FROM dbo.SplitCSV(@sAHousesCsv)) or @sAHousesCsv is null) 
		--and (TblPupilManagementPupils.txtBoardingHouse in (SELECT * FROM dbo.SplitCSV(@sBHousesCsv)) or @sBHousesCsv is null) 
		--and (TblPupilManagementPupils.txtSurname like @sSurname+'%' or @sSurname is null)	
		--and (TblPupilManagementPupils.txtPreName like @sPrefname+'%' or @sPrefname is null)	
		--and (TblPupilManagementPupils.txtForename like @sForename+'%' or @sForename is null)	
		--and (TblPupilManagementPupils.txtGender = @sGender or @sGender is null)	

	order by
		TblMarkBooksOASSynchronisationDataSourceReport.intReportCycle
		, TblMarkBooksOASSynchronisationMapping.intReportTemplate
		, TblMarkBooksOASSynchronisationMapping.intReportGradeElement
		, TblMarkBooksOASSynchronisationMapping.intReportResultElement
		, TblMarkBooksOASSynchronisationMapping.intReportPositionElement
		, Tblteachingmanagersets.txtSetCode
		, TblMarkBooksOASSynchronisationMappingMarkbookTest.intMarkbookTest
		, TblMarkBooksEntry.txtSchoolId
		, TblMarkBooksMark.txtMark
		

