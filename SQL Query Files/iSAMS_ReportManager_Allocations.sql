SELECT      @PASSALLSETS = 1
	FROM         TblReportsManagementCycleAllocations
	WHERE     (intReportCycle = @intReportCycle) AND (intReportType = @REPORTTYPE) AND 
	((intAllType = 3) AND (txtAllValue = @TXTFORM) AND (blnExclusion = 1))

	
