WITH ModOnTheseTypes ( intTypeID ) AS  (SELECT DISTINCT intTypeID 
FROM TblSchoolCalendarModerators 
WHERE txtUserCode = @P1),  mainquery (TblSchoolCalendarID,txtStartDate,txtEndDate,intAllDayEvent,txtStartTime,txtEndTime,txtDescription,intCategory,intSubcategory,txtLocation,intNCYear,txtGender,txtNotes,intImport,intHide,intRecurID,intOrder,intEdited,intLate,txtCreatedBy,txtCreatedDateTime,txtSubmitBy,txtSubmitDateTime,CategoryName,txtImage,CategoryColour,TblSchoolCalendarPublicationOverrideID,intViewiSAMS,intViewStudentPortal,intViewBXI,intViewParentPortal,intAuthorised,IsMod,intAbsenseCount,IsModeratorOnThisType)  
AS (  SELECT DISTINCT  TblSchoolCalendar.*, TblSchoolCalendarCategory.txtName As CategoryName, TblSchoolCalendarCategory.txtImage, TblSchoolCalendarCategory.txtColour As [CategoryColour], TblSchoolCalendarPublicationOverrideID, 
(SELECT CASE WHEN EXISTS (SELECT intViewiSAMS FROM TblSchoolCalendarPublicationOverride WHERE intEventID = TblSchoolCalendar.TblSchoolCalendarID) 
THEN (SELECT intViewiSAMS FROM TblSchoolCalendarPublicationOverride WHERE intEventID = TblSchoolCalendar.TblSchoolCalendarID) 
ELSE (SELECT CASE WHEN SUM(intViewiSAMS) > 0 THEN 1 
ELSE 0 END 
FROM tblSchoolCalendarTypes 
WHERE tblSchoolCalendarTypesID IN (SELECT intTypeID FROM TblSchoolCalendarEventsLink WHERE intEventID = TblSchoolCalendar.TblSchoolCalendarID)) END) AS intViewiSAMS, 
(SELECT CASE WHEN EXISTS (SELECT intViewStudentPortal FROM TblSchoolCalendarPublicationOverride WHERE intEventID = TblSchoolCalendar.TblSchoolCalendarID) 
THEN (SELECT intViewStudentPortal FROM TblSchoolCalendarPublicationOverride WHERE intEventID = TblSchoolCalendar.TblSchoolCalendarID) 
ELSE (SELECT CASE WHEN SUM(intViewStudentPortal) > 0 THEN 1 ELSE 0 END 
FROM tblSchoolCalendarTypes 
WHERE tblSchoolCalendarTypesID IN (SELECT intTypeID FROM TblSchoolCalendarEventsLink WHERE intEventID = TblSchoolCalendar.TblSchoolCalendarID)) END) AS intViewStudentPortal, (SELECT CASE WHEN EXISTS (SELECT intViewBXI FROM TblSchoolCalendarPublicationOverride WHERE intEventID = TblSchoolCalendar.TblSchoolCalendarID) THEN (SELECT intViewBXI FROM TblSchoolCalendarPublicationOverride WHERE intEventID = TblSchoolCalendar.TblSchoolCalendarID) ELSE (SELECT CASE WHEN SUM(intViewBXI) > 0 THEN 1 ELSE 0 END FROM tblSchoolCalendarTypes WHERE tblSchoolCalendarTypesID IN (SELECT intTypeID FROM TblSchoolCalendarEventsLink WHERE intEventID = TblSchoolCalendar.TblSchoolCalendarID)) END) AS intViewBXI, (SELECT CASE WHEN EXISTS (SELECT intViewParentPortal FROM TblSchoolCalendarPublicationOverride WHERE intEventID = TblSchoolCalendar.TblSchoolCalendarID) THEN (SELECT intViewParentPortal FROM TblSchoolCalendarPublicationOverride WHERE intEventID = TblSchoolCalendar.TblSchoolCalendarID) ELSE (SELECT CASE WHEN SUM(intViewParentPortal) > 0 THEN 1 ELSE 0 END FROM tblSchoolCalendarTypes WHERE tblSchoolCalendarTypesID IN (SELECT intTypeID FROM TblSchoolCalendarEventsLink WHERE intEventID = TblSchoolCalendar.TblSchoolCalendarID)) END) AS intViewParentPortal, (SELECT CASE (cast(SUM(intAuthorised) as float)/cast(COUNT(intAuthorised) as float)) WHEN 1 THEN 1 ELSE 0 END FROM TblSchoolCalendarEventsLink WHERE intEventID = tblSchoolCalendar.tblSchoolCalendarID) AS intAuthorised,CASE WHEN (SELECT COUNT(*) from TblSchoolCalendarEventsLink Link2 INNER JOIN TblSchoolCalendarModerators Mods on Mods.inttypeid = Link2.inttypeid WHERE inteventid = Link2.intEventID AND Mods.txtUserCode = @P2 ) > 0 THEN 1 ELSE 0 END As IsMod ,(SELECT COUNT(A.TblStaffManagementAbsencesID) as intAbsenseCount FROM TblStaffManagementAbsences A INNER JOIN	TblStaffManagementAbsencesObjects AO ON A.intCategory = AO.TblStaffManagementAbsencesObjectsID WHERE TblSchoolCalendar.txtStartDate BETWEEN txtStartDate AND txtEndDate ) as intAbsenseCount ,CASE WHEN ModOnTheseTypes.intTypeID IS NULL THEN 0 ELSE 1 END AS IsModeratorOnThisType  FROM TblSchoolCalendar INNER JOIN TblSchoolCalendarEventsLink ON TblSchoolCalendar.TblSchoolCalendarID = TblSchoolCalendarEventsLink.intEventID INNER JOIN TblSchoolCalendarTypes ON TblSchoolCalendarEventsLink.intTypeID = TblSchoolCalendarTypes.TblSchoolCalendarTypesID INNER JOIN TblSchoolCalendarCategory ON TblSchoolCalendar.intCategory = TblSchoolCalendarCategory.TblSchoolCalendarCategoryID LEFT OUTER JOIN TblSchoolCalendarSubCategories ON TblSchoolCalendar.intSubCategory = TblSchoolCalendarSubCategories.intCategoryID LEFT OUTER JOIN TblSchoolCalendarPublicationOverride ON TblSchoolCalendar.TblSchoolCalendarID = TblSchoolCalendarPublicationOverride.intEventID LEFT JOIN	ModOnTheseTypes  ON ModOnTheseTypes.intTypeID = TblSchoolCalendarTypes.TblSchoolCalendarTypesID  WHERE 1 = 1  AND txtStartDate BETWEEN @P3 AND @P4 )  SELECT TblSchoolCalendarID,txtStartDate,txtEndDate,intAllDayEvent,txtStartTime,txtEndTime,txtDescription,intCategory,intSubcategory,txtLocation,intNCYear,txtGender,txtNotes,intImport,intHide,intRecurID,intOrder,intEdited,intLate,txtCreatedBy,txtCreatedDateTime,txtSubmitBy,txtSubmitDateTime,CategoryName,txtImage,CategoryColour,TblSchoolCalendarPublicationOverrideID,intViewiSAMS,intViewStudentPortal,intViewBXI,intViewParentPortal,intAuthorised,IsMod,intAbsenseCount,  MAX(IsModeratorOnThisType) as IsModeratorOnThisType  FROM MainQuery  GROUP BY TblSchoolCalendarID,txtStartDate,txtEndDate,intAllDayEvent,txtStartTime,txtEndTime,txtDescription,intCategory,intSubcategory,txtLocation,intNCYear,txtGender,txtNotes,intImport,intHide,intRecurID,intOrder,intEdited,intLate,txtCreatedBy,txtCreatedDateTime,txtSubmitBy,txtSubmitDateTime,CategoryName,txtImage,CategoryColour,TblSchoolCalendarPublicationOverrideID,intViewiSAMS,intViewStudentPortal,intViewBXI,intViewParentPortal,intAuthorised,IsMod,intAbsenseCount  ORDER by txtStartDate, txtStartTime, intOrder ASC; 
