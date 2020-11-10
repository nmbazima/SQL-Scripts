SELECT

COUNT( DISTINCT TblRegistrationSchoolRegistrationPupils.txtSchoolID ) AS RollCount

FROM

TblRegistrationSchoolRegistrationPupils -- use the AM registration on the specified day to count the pupils on Roll

INNER JOIN TblRegistrationSchoolRegistrationRegister

INNER JOIN TblRegistrationSchoolRegistrationDateTime

ON TblRegistrationSchoolRegistrationRegister.intRegistrationDateTime = TblRegistrationSchoolRegistrationDateTime.TblRegistrationSchoolRegistrationDateTimeID

ON TblRegistrationSchoolRegistrationPupils.intRegister = TblRegistrationSchoolRegistrationRegister.TblRegistrationSchoolRegistrationRegisterID

WHERE

CAST( TblRegistrationSchoolRegistrationDateTime.txtDateTime AS date) = @RollDate

AND TblRegistrationSchoolRegistrationDateTime.txtAmPm = N'am'
