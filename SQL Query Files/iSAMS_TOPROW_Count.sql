WITH PageIndex AS (
					SELECT TOP 100000 row_number() over (order by [txtSurname], [txtForename]) AS RowIndex
					, [TblPupilManagementPupilsID]
					, [intPersonID]
					, [txtSchoolID]
					, [txtPreviousMISID]
					, [intPreviousMISADMID]
					, [intPreviousMISLVID]
					, [txtAutoADMNo]
					, [txtPhoenixLVCode]
					, [txtSchoolCode]
					, [txtUPN]
					, [txtUserCode]
					, [txtUsername]
					, [txtOfficialName]
					, [txtTitle]
					, [txtForename]
					, [txtSurname]
					, [txtMiddleNames]
					, [txtInitials]
					, [txtPreName]
					, [txtPreferredSurname]
					, [txtFullName]
					, [txtLabelSalutation]
					, [txtLetterSalutation]
					, [txtGender]
					, [txtDOB]
					, [txtDeceasedDate]
					, [txtForm]
					, [intNCYear]
					, [txtYearBlock]
					, [txtLevel]
					, [txtTutor]
					, [txtType]
					, [txtAcademicHouse]
					, [txtBoardingHouse]
					, [txtPegNumber]
					, [txtPassportNumber]
					, [txtPassportType]
					, [txtCountryofResidence]
					, [txtNationality]
					, [txtLanguage]
					, [txtReligion]
					, [blnBaptised]
					, [blnConfirmation]
					, [txtEthnicGroup]
					, [intPreviousSchool]
					, [txtBirthPlace]
					, [txtBirthCounty]
					, [txtBirthCountry]
					, [txtEmailAddress]
					, [txtHomeEmailAddress]
					, [txtMobileNumber]
					, [txtPagerNumber]
					, [txtContactNotes]
					, [ParentID]
					, [txtDeceasedMother]
					, [txtDeceasedFather]
					, [txtLeftRight]
					, [intGlasses]
					, [txtNHSNumber]
					, [txtEHICNumber]
					, [txtBloodGroup]
					, [txtMedicalTripNotes]
					, [txtMedicalTripBadge1]
					, [txtMedicalTripBadge2]
					, [txtMedicalTripBadge3]
					, [txtMedicalDentalNotes]
					, [txtDoctor]
					, [txtDoctorsPhoneNo]
					, [txtInsuranceNumber]
					, [txtInsuranceCompany]
					, [txtInsuranceExpDate]
					, [intMedicalFlag]
					, [txtDisabilities]
					, [txtAdditionalHealth]
					, [intAsthmatic]
					, [txtAsthmaticNotes]
					, [intAllergy]
					, [txtAllergyNotes]
					, [intDiabetes]
					, [txtDiabetesNotes]
					, [intEpilepsy]
					, [txtEpilepsyNotes]
					, [intTravelSickness]
					, [txtTravelSicknessNotes]
					, [intHeadachesMigraines]
					, [txtHeadachesMigrainesNotes]
					, [txtVaccineInformation]
					, [intTetanus]
					, [txtDental]
					, [txtDentalInformation]
					, [txtMedicalOphthalmicNotes]
					, [txtMedicalHearingNotes]
					, [txtOtherMedical]
					, [txtOtherMedicalInformation]
					, [txtVerification]
					, [txtEntryType]
					, [txtEnrolmentDate]
					, [intEnrolmentSchoolYear]
					, [intEnrolmentNCYear]
					, [txtEnrolmentHouse]
					, [txtEnrolmentAcademicHouse]
					, [txtEnrolmentTerm]
					, [txtEnrolmentForm]
					, [txtEnquiryDate]
					, [txtEnquiryType]
					, [txtEnquiryReason]
					, [txtEnquiryNotes]
					, [txtAdmissionsDate]
					, [txtAdmissionsStatus]
					, [txtScholarshipNotes]
					, [txtScholarshipList]
					, [txtScholarshipInterest]
					, [txtScholarshipInterestList]
					, [txtReferenceRequestedDate]
					, [txtReferenceReceivedDate]
					, [txtLearningSupportReceived]
					, [txtInterviewDate]
					, [txtInterviewTime]
					, [txtWithdrawnDate]
					, [txtWithdrawnReason]
					, [txtWithdrawnReasonNote]
					, [txtRejectedDate]
					, [txtRejectedReason]
					, [txtRejectedReasonNote]
					, [intSchoolAttending]
					, [txtInterviewNotes]
					, [txtDepositDate]
					, [txtDepositAmount]
					, [txtDepositSignatory]
					, [txtEntranceFeeDate]
					, [txtEntranceFeeAmount]
					, [txtEntranceFeeSignatory]
					, [txtEntranceExamDate]
					, [txtEntranceExamAmount]
					, [txtEntranceExamSignatory]
					, [txtRegisteredDate]
					, [txtPreviousSchoolType]
					, [txtLeavingReason]
					, [txtLeavingDate]
					, [intLeavingNCYear]
					, [intLeavingSchoolYear]
					, [txtLeavingTerm]
					, [txtLeavingForm]
					, [txtLeavingBoardingHouse]
					, [txtLeavingAcademicHouse]
					, [intFutureSchool]
					, [txtFutureSchoolType]
					, [txtSchoolPupilType]
					, [txtProspectusEnquiryDate]
					, [txtProspectusSentDate]
					, [intProspectusSent]
					, [txtProspectusNotes]
					, [txtVisitDate]
					, [txtVisitNotes]
					, [txtAcedemicCategory]
					, [txtCandidateNumber]
					, [txtCandidateCode]
					, [txtCandidateForenames]
					, [txtCandidateSurname]
					, [intIsCandidate]
					, [txtAdditionalTime]
					, [txtSpecialRequirements]
					, [txtSchoolLink]
					, [txtHouseVisits]
					, [intFamily]
					, [intDuplicateReports]
					, [txtEntranceExamEnglish]
					, [txtEntranceExamMathematics]
					, [txtEntranceExamNVR]
					, [txtEntranceExamVR]
					, [txtEntranceExamEAL]
					, [txtSiblingsIDList]
					, [txtSiblingsNameList]
					, [txtSiblingsFormList]
					, [txtSiblingsYearList]
					, [txtOfferType]
					, [txtFutureForm]
					, [txtFutureHouse]
					, [txtFutureAcademicHouse]
					, [intFlagged]
					, [txtSubmitBy]
					, [txtSubmitDateTime]
					, [intSystemStatus]
					, [txtTransportNotes]
					, [txtJointLabelSalutation]
					, [txtJointLetterSalutation]
					, [blnDiplomaticAndForces2]
					, [blnDiplomaticAndForces]
					, [txtInternalExamCode]
					, [blnIsInternalExamCandidate]
					, [blnFirstChoice]
					, [txtPreviousSchoolAttendance]
					, [blnFirstChoice2]
					, [txtCompetitionNotes]
					, [blnVisaRequired]
					, [txtFormerUPN]
					, [txtFormerSurname]
					, [txtEthnicitySource]
					, [decCensusFundedHours]
					, [decCensusHoursAtSetting]
					, [txtCensusYouthSupportServiceAgreement]
					, [txtCensusTypeOfClass]
					, [blnCensusPartTime]
					, [txtEnrolmentStatus]
					, [blnCensusTopupFunding]
					, [txtCensusServiceChild]
					, [blnCensusSchoolLunchTaken]
					, [blnCensusFullTimeEmployment]
					, [intCensusPlannedLearningHours]
					, [intCensusPlannedNonLearningHours]
					, [intCensusPreviousPlannedLearningHours]
					, [intCensusPreviousPlannedNonLearningHours]
					, [intAutoSchoolCodeNumericPart]
					, [txtCensusMathsGCSEHighestPriorAttainment]
					, [txtCensusMathsGCSEHighestPriorAttainmentYearGroup]
					, [txtCensusEnglishGCSEHighestPriorAttainment]
					, [txtCensusEnglishGCSEHighestPriorAttainmentYearGroup]
					, [txtCensusEnglishFundingExemption]
					, [txtCensusMathsFundingExemption]
					, [txtCensusEarlyYearsPupilPremiumEligibilityBasis]
					, [txtFutureSchoolEnrolmentDate]
					, [intDeferredUniversityId]
					FROM [dbo].[TblPupilManagementPupils] where ( (  (intSystemStatus = @Param0))OR (  (intSystemStatus = @Param1))) AND (txtSchoolID IN ('082000410839','114214718517','123732705547','3328922991','3345164453','075016916347','080250393016','153316849498','125639696697','133332705547','095928705547','3331375512','081648705547','161223384746','162821817501','153345719768','3314345479','084507403255','132907699123'))
				)
				SELECT
				       [TblPupilManagementPupilsID],
				       [intPersonID],
				       [txtSchoolID],
				       [txtPreviousMISID],
				       [intPreviousMISADMID],
				       [intPreviousMISLVID],
				       [txtAutoADMNo],
				       [txtPhoenixLVCode],
				       [txtSchoolCode],
				       [txtUPN],
				       [txtUserCode],
				       [txtUsername],
				       [txtOfficialName],
				       [txtTitle],
				       [txtForename],
				       [txtSurname],
				       [txtMiddleNames],
				       [txtInitials],
				       [txtPreName],
				       [txtPreferredSurname],
				       [txtFullName],
				       [txtLabelSalutation],
				       [txtLetterSalutation],
				       [txtGender],
				       [txtDOB],
				       [txtDeceasedDate],
				       [txtForm],
				       [intNCYear],
				       [txtYearBlock],
				       [txtLevel],
				       [txtTutor],
				       [txtType],
				       [txtAcademicHouse],
				       [txtBoardingHouse],
				       [txtPegNumber],
				       [txtPassportNumber],
				       [txtPassportType],
				       [txtCountryofResidence],
				       [txtNationality],
				       [txtLanguage],
				       [txtReligion],
				       [blnBaptised],
				       [blnConfirmation],
				       [txtEthnicGroup],
				       [intPreviousSchool],
				       [txtBirthPlace],
				       [txtBirthCounty],
				       [txtBirthCountry],
				       [txtEmailAddress],
				       [txtHomeEmailAddress],
				       [txtMobileNumber],
				       [txtPagerNumber],
				       [txtContactNotes],
				       [ParentID],
				       [txtDeceasedMother],
				       [txtDeceasedFather],
				       [txtLeftRight],
				       [intGlasses],
				       [txtNHSNumber],
				       [txtEHICNumber],
				       [txtBloodGroup],
				       [txtMedicalTripNotes],
				       [txtMedicalTripBadge1],
				       [txtMedicalTripBadge2],
				       [txtMedicalTripBadge3],
				       [txtMedicalDentalNotes],
				       [txtDoctor],
				       [txtDoctorsPhoneNo],
				       [txtInsuranceNumber],
				       [txtInsuranceCompany],
				       [txtInsuranceExpDate],
				       [intMedicalFlag],
				       [txtDisabilities],
				       [txtAdditionalHealth],
				       [intAsthmatic],
				       [txtAsthmaticNotes],
				       [intAllergy],
				       [txtAllergyNotes],
				       [intDiabetes],
				       [txtDiabetesNotes],
				       [intEpilepsy],
				       [txtEpilepsyNotes],
				       [intTravelSickness],
				       [txtTravelSicknessNotes],
				       [intHeadachesMigraines],
				       [txtHeadachesMigrainesNotes],
				       [txtVaccineInformation],
				       [intTetanus],
				       [txtDental],
				       [txtDentalInformation],
				       [txtMedicalOphthalmicNotes],
				       [txtMedicalHearingNotes],
				       [txtOtherMedical],
				       [txtOtherMedicalInformation],
				       [txtVerification],
				       [txtEntryType],
				       [txtEnrolmentDate],
				       [intEnrolmentSchoolYear],
				       [intEnrolmentNCYear],
				       [txtEnrolmentHouse],
				       [txtEnrolmentAcademicHouse],
				       [txtEnrolmentTerm],
				       [txtEnrolmentForm],
				       [txtEnquiryDate],
				       [txtEnquiryType],
				       [txtEnquiryReason],
				       [txtEnquiryNotes],
				       [txtAdmissionsDate],
				       [txtAdmissionsStatus],
				       [txtScholarshipNotes],
				       [txtScholarshipList],
				       [txtScholarshipInterest],
				       [txtScholarshipInterestList],
				       [txtReferenceRequestedDate],
				       [txtReferenceReceivedDate],
				       [txtLearningSupportReceived],
				       [txtInterviewDate],
				       [txtInterviewTime],
				       [txtWithdrawnDate],
				       [txtWithdrawnReason],
				       [txtWithdrawnReasonNote],
				       [txtRejectedDate],
				       [txtRejectedReason],
				       [txtRejectedReasonNote],
				       [intSchoolAttending],
				       [txtInterviewNotes],
				       [txtDepositDate],
				       [txtDepositAmount],
				       [txtDepositSignatory],
				       [txtEntranceFeeDate],
				       [txtEntranceFeeAmount],
				       [txtEntranceFeeSignatory],
				       [txtEntranceExamDate],
				       [txtEntranceExamAmount],
				       [txtEntranceExamSignatory],
				       [txtRegisteredDate],
				       [txtPreviousSchoolType],
				       [txtLeavingReason],
				       [txtLeavingDate],
				       [intLeavingNCYear],
				       [intLeavingSchoolYear],
				       [txtLeavingTerm],
				       [txtLeavingForm],
				       [txtLeavingBoardingHouse],
				       [txtLeavingAcademicHouse],
				       [intFutureSchool],
				       [txtFutureSchoolType],
				       [txtSchoolPupilType],
				       [txtProspectusEnquiryDate],
				       [txtProspectusSentDate],
				       [intProspectusSent],
				       [txtProspectusNotes],
				       [txtVisitDate],
				       [txtVisitNotes],
				       [txtAcedemicCategory],
				       [txtCandidateNumber],
				       [txtCandidateCode],
				       [txtCandidateForenames],
				       [txtCandidateSurname],
				       [intIsCandidate],
				       [txtAdditionalTime],
				       [txtSpecialRequirements],
				       [txtSchoolLink],
				       [txtHouseVisits],
				       [intFamily],
				       [intDuplicateReports],
				       [txtEntranceExamEnglish],
				       [txtEntranceExamMathematics],
				       [txtEntranceExamNVR],
				       [txtEntranceExamVR],
				       [txtEntranceExamEAL],
				       [txtSiblingsIDList],
				       [txtSiblingsNameList],
				       [txtSiblingsFormList],
				       [txtSiblingsYearList],
				       [txtOfferType],
				       [txtFutureForm],
				       [txtFutureHouse],
				       [txtFutureAcademicHouse],
				       [intFlagged],
				       [txtSubmitBy],
				       [txtSubmitDateTime],
				       [intSystemStatus],
				       [txtTransportNotes],
				       [txtJointLabelSalutation],
				       [txtJointLetterSalutation],
				       [blnDiplomaticAndForces2],
				       [blnDiplomaticAndForces],
				       [txtInternalExamCode],
				       [blnIsInternalExamCandidate],
				       [blnFirstChoice],
				       [txtPreviousSchoolAttendance],
				       [blnFirstChoice2],
				       [txtCompetitionNotes],
				       [blnVisaRequired],
				       [txtFormerUPN],
				       [txtFormerSurname],
				       [txtEthnicitySource],
				       [decCensusFundedHours],
				       [decCensusHoursAtSetting],
				       [txtCensusYouthSupportServiceAgreement],
				       [txtCensusTypeOfClass],
				       [blnCensusPartTime],
				       [txtEnrolmentStatus],
				       [blnCensusTopupFunding],
				       [txtCensusServiceChild],
				       [blnCensusSchoolLunchTaken],
				       [blnCensusFullTimeEmployment],
				       [intCensusPlannedLearningHours],
				       [intCensusPlannedNonLearningHours],
				       [intCensusPreviousPlannedLearningHours],
				       [intCensusPreviousPlannedNonLearningHours],
				       [intAutoSchoolCodeNumericPart],
				       [txtCensusMathsGCSEHighestPriorAttainment],
				       [txtCensusMathsGCSEHighestPriorAttainmentYearGroup],
				       [txtCensusEnglishGCSEHighestPriorAttainment],
				       [txtCensusEnglishGCSEHighestPriorAttainmentYearGroup],
				       [txtCensusEnglishFundingExemption],
				       [txtCensusMathsFundingExemption],
				       [txtCensusEarlyYearsPupilPremiumEligibilityBasis],
				       [txtFutureSchoolEnrolmentDate],
				       [intDeferredUniversityId]
				  FROM PageIndex
				 WHERE RowIndex > 0
				   AND RowIndex <= 100000
				ORDER BY [txtSurname], [txtForename];
				

				-- get total count
				
