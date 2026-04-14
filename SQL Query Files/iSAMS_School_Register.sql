UPDATE TblRegistrationSchoolRegistrationPupils 
 SET blnRegistered=@P1, 
 blnLate=@P2,  intMinutesLate=@P3,  txtGroupingRegisteredBy = @P4,  txtGroupNameRegisteredBy = @P5,  intCode=@P6,  txtSubmitBy=@P7,  txtSubmitDateTime = @submitDate
 WHERE TblRegistrationSchoolRegistrationPupils.intRegister=@P8 AND txtSchoolID=@P9;

 
