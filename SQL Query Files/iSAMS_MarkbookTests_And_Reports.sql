with GradeMarkbookTestCounts as (
		select 
			TblMarkBooksOASSynchronisationDataSourceReport.intReportCycle as [ReportCycle],
			TblMarkBooksOASSynchronisationMapping.intReportGradeElement as [GradeElement],
			count(1) as [Count]
		from 
			TblMarkBooksOASSynchronisationDataSourceReport
			
			inner join TblMarkBooksOASSynchronisationMapping
				on TblMarkBooksOASSynchronisationDataSourceReport.TblMarkBooksOASSynchronisationDataSourceReportId = 
					TblMarkBooksOASSynchronisationMapping.intDataSourceReport
					
			inner join TblMarkBooksOASSynchronisationMappingMarkbookTest
				on TblMarkBooksOASSynchronisationMapping.TblMarkBooksOASSynchronisationMappingId = 
					TblMarkBooksOASSynchronisationMappingMarkbookTest.intmapping
					
			inner join TblMarkBooksTest 
				on TblMarkBooksOASSynchronisationMappingMarkbookTest.intMarkbookTest = TblMarkBooksTest.TblMarkBooksTestId
		
		where
			TblMarkBooksOASSynchronisationDataSourceReport.intPlan = @intMarkbookPlan
		
		group by TblMarkBooksOASSynchronisationDataSourceReport.intReportCycle,	TblMarkBooksOASSynchronisationMapping.intReportGradeElement

	), ResultMarkbookTestCounts as ( 
		select 
			TblMarkBooksOASSynchronisationDataSourceReport.intReportCycle as [ReportCycle],
			TblMarkBooksOASSynchronisationMapping.intReportResultElement as [ResultElement],
			count(1) as [Count]
		from 
			TblMarkBooksOASSynchronisationDataSourceReport
			
			inner join TblMarkBooksOASSynchronisationMapping
				on TblMarkBooksOASSynchronisationDataSourceReport.TblMarkBooksOASSynchronisationDataSourceReportId = 
					TblMarkBooksOASSynchronisationMapping.intDataSourceReport
					
			inner join TblMarkBooksOASSynchronisationMappingMarkbookTest
				on TblMarkBooksOASSynchronisationMapping.TblMarkBooksOASSynchronisationMappingId = 
					TblMarkBooksOASSynchronisationMappingMarkbookTest.intmapping			
			
			inner join TblMarkBooksTest 
				on TblMarkBooksOASSynchronisationMappingMarkbookTest.intMarkbookTest = TblMarkBooksTest.TblMarkBooksTestId
				
		where
			TblMarkBooksOASSynchronisationDataSourceReport.intPlan = @intMarkbookPlan
	
		group by TblMarkBooksOASSynchronisationDataSourceReport.intReportCycle,	TblMarkBooksOASSynchronisationMapping.intReportResultElement
		 
	), PositionMarkbookTestCounts as (
		select 
			TblMarkBooksOASSynchronisationDataSourceReport.intReportCycle as [ReportCycle],
			TblMarkBooksOASSynchronisationMapping.intReportPositionElement as [PositionElement],
			count(1) as [Count]
		from 
			TblMarkBooksOASSynchronisationDataSourceReport
			
			inner join TblMarkBooksOASSynchronisationMapping
				on TblMarkBooksOASSynchronisationDataSourceReport.TblMarkBooksOASSynchronisationDataSourceReportId = 
					TblMarkBooksOASSynchronisationMapping.intDataSourceReport
					
			inner join TblMarkBooksOASSynchronisationMappingMarkbookTest
				on TblMarkBooksOASSynchronisationMapping.TblMarkBooksOASSynchronisationMappingId = 
					TblMarkBooksOASSynchronisationMappingMarkbookTest.intmapping			
			
			inner join TblMarkBooksTest 
				on TblMarkBooksOASSynchronisationMappingMarkbookTest.intMarkbookTest = TblMarkBooksTest.TblMarkBooksTestId
				
		where
			TblMarkBooksOASSynchronisationDataSourceReport.intPlan = @intMarkbookPlan

		group by TblMarkBooksOASSynchronisationDataSourceReport.intReportCycle,	TblMarkBooksOASSynchronisationMapping.intReportPositionElement

	)

	select distinct
		TblReportsManagementCycle.TblReportsManagementCycleID as [ReportCycleId]
		, TblReportsManagementCycle.txtReportName as [ReportCycleName]
		
		, TblReportsManagementCycle.intReportYear
		, TblSchoolManagementTermNames.intOrder
		, TblReportsManagementCycle.txtStartReports 
		, TblReportsManagementCycleAllocations.TblReportsManagementCycleAllocationsId as [ReportAllocationsId]
		
		, TblReportsManagementTemplates.TblReportsManagementTemplatesId as [ReportTemplatesId]
		, TblReportsManagementTemplates.txtTemplateName as [ReportTemplatesName]
		, TblReportsManagementTemplates.blnStatus2Enabled as [ReportTemplatesStatusIncompleteEnabled]
		, TblReportsManagementTemplates.txtStatus2Caption as [ReportTemplatesStatusIncompleteCaption]
		, TblReportsManagementTemplates.blnStatus3Enabled as [ReportTemplatesStatusCompleteEnabled]
		, TblReportsManagementTemplates.txtStatus3Caption as [ReportTemplatesStatusCompleteCaption]
		
		, TblReportsManagementTemplatesGrading.TblReportsManagementTemplatesGradingId as [ReportGradingId]
		, TblReportsManagementTemplatesGrading.txtGradingName as [ReportGradingName]
		
		, TblReportsManagementTemplatesResults.TblReportsManagementTemplatesResultsId as [ReportResultId]
		, TblReportsManagementTemplatesResults.txtResultName as [ReportResultName]
		
		, TblReportsManagementTemplatesPositions.TblReportsManagementTemplatesPositionsId as [ReportPositionId]
		, TblReportsManagementTemplatesPositions.txtPositionName as [ReportPositionName]
		
		, TblReportsManagementTemplatesComments.TblReportsManagementTemplatesCommentsId as [ReportCommentId]
		
		,TblSchoolManagementTermNames.txtName as [ReportTerm]
		,DataSourceReport.TblMarkBooksOASSynchronisationDataSourceReportID as [DataSourceReportID]
		
		,case when TblReportsManagementTemplatesGrading.TblReportsManagementTemplatesGradingId is not null then
			'Certificate'
		end as [ReportGradingImage]
		
		,case when TblReportsManagementTemplatesResults.TblReportsManagementTemplatesResultsId is not null then
			'Calculator'
		end as [ReportResultImage]
		
		,case when TblReportsManagementTemplatesPositions.TblReportsManagementTemplatesPositionsId is not null then
			'Sort_az_descending'
		end as [ReportPositionImage]
		
		,case when TblReportsManagementTemplatesGrading.TblReportsManagementTemplatesGradingId is not null then
			case when TblReportsManagementTemplatesGrading.txtGradingOptions is not null then
				replace(TblReportsManagementTemplatesGrading.txtGradingOptions,'@',',')
			end
		end as [ReportGradingDescription]
		
		,case when TblReportsManagementTemplatesResults.TblReportsManagementTemplatesResultsId is not null then
			case when TblReportsManagementTemplatesResults.blnIsNumericValue is not null then
				'*Numeric'
			end
		end as [ReportResultDescription]
		
		,case when TblReportsManagementCycle.intType = 0 then
			'folder_document.gif'
			when TblReportsManagementCycle.intType = 1 then
			'clipboard.gif'
			end as [ReportIcon]
		 
		,case when TblReportsManagementCycle.intReportYear is not null then
			case when len(TblReportsManagementCycle.intReportYear) = 4 then
				cast(TblReportsManagementCycle.intReportYear as nvarchar(4)) + '/' + cast(right(TblReportsManagementCycle.intReportYear +1 ,2) as nvarchar(4))
			else
				cast(TblReportsManagementCycle.intReportYear as nvarchar(4))
			end
		else
			cast(TblReportsManagementCycle.intReportYear as nvarchar(4))
		end as [ReportAcademicYear]
		 
		,	dbo.f_GetDayWithSuffix(DAY(TblReportsManagementCycle.txtStartReports)) + ' ' + 
			DATENAME(MONTH,TblReportsManagementCycle.txtStartReports) 
		as [ReportStartDateString]

		,	dbo.f_GetDayWithSuffix(DAY(TblReportsManagementCycle.txtFinishReports)) + ' ' + 
			DATENAME(MONTH,TblReportsManagementCycle.txtFinishReports) 
		as [ReportFinishDateString]
		
		,ISNULL([GradeMarkbookTestCounts].[Count], 0) as [GradeMarkbookTestCount]
		,ISNULL([ResultMarkbookTestCounts].[Count], 0) as [ResultMarkbookTestCount]
		,ISNULL([PositionMarkbookTestCounts].[Count], 0) as [PositionMarkbookTestCount]
	
		,case when TblReportsManagementTemplatesGrading.TblReportsManagementTemplatesGradingId is not null then
			(select 
					top 1 TblMarkBooksOASSynchronisationMapping.TblMarkBooksOASSynchronisationMappingId
				from 
					TblMarkBooksOASSynchronisationDataSourceReport
					
					inner join TblMarkBooksOASSynchronisationMapping
						on TblMarkBooksOASSynchronisationDataSourceReport.TblMarkBooksOASSynchronisationDataSourceReportId = 
							TblMarkBooksOASSynchronisationMapping.intDataSourceReport			
					
				where
					TblMarkBooksOASSynchronisationDataSourceReport.intPlan = @intMarkbookPlan
					and TblMarkBooksOASSynchronisationDataSourceReport.intReportCycle = TblReportsManagementCycle.TblReportsManagementCycleId
					and TblMarkBooksOASSynchronisationMapping.intReportGradeElement = TblReportsManagementTemplatesGrading.TblReportsManagementTemplatesGradingId
			)
		end as [GradeMarkBooksOASSynchronisationMappingId]
		
		,case when TblReportsManagementTemplatesResults.TblReportsManagementTemplatesResultsId is not null then
			(select 
					top 1 TblMarkBooksOASSynchronisationMapping.TblMarkBooksOASSynchronisationMappingId
				from 
					TblMarkBooksOASSynchronisationDataSourceReport
					
					inner join TblMarkBooksOASSynchronisationMapping
						on TblMarkBooksOASSynchronisationDataSourceReport.TblMarkBooksOASSynchronisationDataSourceReportId = 
							TblMarkBooksOASSynchronisationMapping.intDataSourceReport			
					
				where
					TblMarkBooksOASSynchronisationDataSourceReport.intPlan = @intMarkbookPlan
					and TblMarkBooksOASSynchronisationDataSourceReport.intReportCycle = TblReportsManagementCycle.TblReportsManagementCycleId
					and TblMarkBooksOASSynchronisationMapping.intReportResultElement = TblReportsManagementTemplatesResults.TblReportsManagementTemplatesResultsId
			) 
		end as [ResultMarkBooksOASSynchronisationMappingId]
		
		,case when TblReportsManagementTemplatesPositions.TblReportsManagementTemplatesPositionsId is not null then
			(select 
					top 1 TblMarkBooksOASSynchronisationMapping.TblMarkBooksOASSynchronisationMappingId
				from 
					TblMarkBooksOASSynchronisationDataSourceReport
					
					inner join TblMarkBooksOASSynchronisationMapping
						on TblMarkBooksOASSynchronisationDataSourceReport.TblMarkBooksOASSynchronisationDataSourceReportId = 
							TblMarkBooksOASSynchronisationMapping.intDataSourceReport		
					
				where
					TblMarkBooksOASSynchronisationDataSourceReport.intPlan = @intMarkbookPlan
					and TblMarkBooksOASSynchronisationDataSourceReport.intReportCycle = TblReportsManagementCycle.TblReportsManagementCycleId
					and TblMarkBooksOASSynchronisationMapping.intReportPositionElement = TblReportsManagementTemplatesPositions.TblReportsManagementTemplatesPositionsId
			) 
		end as [PositionMarkBooksOASSynchronisationMappingId]
		
	from 
		TblReportsManagementCycle
		
		inner join TblMarkBooksOASSynchronisationDataSourceReport DataSourceReport
			on TblReportsManagementCycle.TblReportsManagementCycleId = DataSourceReport.intReportCycle
			and DataSourceReport.intPlan = @intMarkbookPlan
		
		left outer join TblSchoolManagementTermNames 
			on TblReportsManagementCycle.intReportTerm = TblSchoolManagementTermNames.TblSchoolManagementTermNamesId
				
		inner join TblReportsManagementCycleAllocations 
			on TblReportsManagementCycle.TblReportsManagementCycleId = TblReportsManagementCycleAllocations.intReportCycle
		inner join TblReportsManagementTemplates
			on TblReportsManagementCycleAllocations.intTemplate = TblReportsManagementTemplates.TblReportsManagementTemplatesId
			
		left outer join TblReportsManagementTemplatesGrading
			on TblReportsManagementTemplates.TblReportsManagementTemplatesId = TblReportsManagementTemplatesGrading.intTemplateId
		left outer join TblReportsManagementTemplatesResults
			on TblReportsManagementTemplates.TblReportsManagementTemplatesId = TblReportsManagementTemplatesResults.intTemplateId
		left outer join TblReportsManagementTemplatesPositions
			on TblReportsManagementTemplates.TblReportsManagementTemplatesId = TblReportsManagementTemplatesPositions.intTemplateId
		left outer join TblReportsManagementTemplatesComments
			on TblReportsManagementTemplates.TblReportsManagementTemplatesId = TblReportsManagementTemplatesComments.intTemplateId
		left outer join GradeMarkbookTestCounts 
			on GradeMarkbookTestCounts.ReportCycle = TblReportsManagementCycle.TblReportsManagementCycleId
			and GradeMarkbookTestCounts.GradeElement = TblReportsManagementTemplatesGrading.TblReportsManagementTemplatesGradingId
		left outer join ResultMarkbookTestCounts 
			on ResultMarkbookTestCounts.ReportCycle = TblReportsManagementCycle.TblReportsManagementCycleId
			and ResultMarkbookTestCounts.ResultElement = TblReportsManagementTemplatesResults.TblReportsManagementTemplatesResultsId
		left outer join PositionMarkbookTestCounts 
			on PositionMarkbookTestCounts.ReportCycle = TblReportsManagementCycle.TblReportsManagementCycleId
			and PositionMarkbookTestCounts.PositionElement = TblReportsManagementTemplatesPositions.TblReportsManagementTemplatesPositionsID
		
	where
		TblReportsManagementCycleAllocations.intReportType = 1 -- filter subject reports
		
	order by 
		TblReportsManagementCycle.intReportYear desc
		, TblSchoolManagementTermNames.intOrder desc
		, TblReportsManagementCycle.txtStartReports desc
		, TblReportsManagementCycle.txtReportName
		, TblReportsManagementCycle.TblReportsManagementCycleID
		
		, TblReportsManagementTemplates.txtTemplateName	
		, TblReportsManagementTemplates.TblReportsManagementTemplatesId
		
		, TblReportsManagementTemplatesGrading.TblReportsManagementTemplatesGradingId
		, TblReportsManagementTemplatesGrading.txtGradingName
		, TblReportsManagementTemplatesResults.TblReportsManagementTemplatesResultsId
		, TblReportsManagementTemplatesResults.txtResultName
		, TblReportsManagementTemplatesPositions.TblReportsManagementTemplatesPositionsId
		, TblReportsManagementTemplatesPositions.txtPositionName


