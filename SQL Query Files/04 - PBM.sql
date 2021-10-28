/*
-	Right-click Database Performance facet and select “New Condition”
-	Type “Database Healthcheck Condition” in the Name box
-	 Add the following expressions:
o	@AutoClose = False
o	@AutoShrink = False
o	@CollationMatchesModelOrMaster = True
o	@DataAndLogFilesOnSeparateLogicalVolumes = True
-	Click OK to create the Condition
-	Right-click Policies and select New Policy
*/