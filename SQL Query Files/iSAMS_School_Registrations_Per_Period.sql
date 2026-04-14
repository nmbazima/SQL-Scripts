UPDATE TblRegistrationSchoolRegistrationPupils 
 SET blnRegistered=@P1, 
 blnLate=@P2,  intMinutesLate=@P3,  txtGroupingRegisteredBy = @P4,  txtGroupNameRegisteredBy = @P5,  intCode=@P6,  intPresentCode=@P7,  txtSubmitBy=@P8,  txtSubmitDateTime = @submitDate
 WHERE TblRegistrationSchoolRegistrationPupils.intRegister=@P9 AND txtSchoolID=@P10;

 
