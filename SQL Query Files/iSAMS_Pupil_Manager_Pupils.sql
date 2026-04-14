SELECT  
	                pupils.txtSchoolID,
	                pupils.txtLeavingDate AS LeavingDate,
	                institution.txtName AS DeferredUniversity 
	                FROM TblPupilManagementPupils pupils 
	                LEFT JOIN TblUniversityManagerInstitutions institution ON institution.TblUniversityManagerInstitutionsID = pupils.intDeferredUniversityId  
	                WHERE pupils.txtLeavingDate > '2018-01-17 00:00:00' AND pupils.intDeferredUniversityId IS NOT NULL;
