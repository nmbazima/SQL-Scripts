SELECT      @PASSALLSETS = 1
	FROM         TblReportsManagementCycleAllocations
	WHERE     (intReportCycle = @INTREPORTCYCLE) AND (intReportType = @REPORTTYPE) AND 
	(intAllType = 0) AND ((GETDATE() BETWEEN dtValidFrom AND dtValidTo) or (dtValidFrom is null and dtValidTo is null))

	-- If the allocation is for all pupils, we want to allow all sets so set result = 1
	-- also check that result is false, if it is true we dont want to overwrite it
	
