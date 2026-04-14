<html>

<cfinclude template="/assessment/reportsec.cfm">
<cfparam name="ARSID" default="0">
<cfparam name="RecNo" default="0">
<cfparam name="term" default="0">
<cfparam name="year" default="#Year(Now())#">
<cfparam name="AsPDF" default="0">
<cfparam name="ReportFileName" default="">

<cfset MaxTerm = 3>

<cfquery name="getList" datasource="#dsn#">
    SELECT A.StudID, A.LastName, A.FirstName, A.MiddleName, A.TermYear, A.Term, A.AcYear, A.BirthDate, A.Age, A.Photo, A.AdmNo,
    C.Class, T.FirstName AS TFName, T.LastName AS TLName, T.Title, T.TeacherID, T.T1SignFile, G.Height, G.Weight, A.Age, 
    H.Title AS H1Title, H.FirstName AS H1FName, H.LastName AS H1LName
    FROM vARSubjAcads A
    LEFT JOIN TTClassStud C ON C.TermYear = A.TermYear AND C.Term = A.Term
    AND C.AcYear = A.AcYear AND C.StudID = A.StudID
    LEFT JOIN vTTClasses T ON T.Class = C.Class AND T.ClYear = C.TermYear AND T.ClTerm = C.Term
    LEFT JOIN vMedicalInfo G ON G.StudentID = A.StudID
    
    LEFT JOIN (
    SELECT H.HouseName, HS.StudentID, S.Title, S.FirstName, S.LastName, S.SignFile, S.StaffID
    FROM HTGHouses H
    INNER JOIN HTGHouseStudents HS ON HS.HouseID = H.HouseID
    LEFT JOIN HTGHouseStaff GS ON GS.HouseID = H.HouseID AND GS.Seq = (SELECT Max(Seq) FROM HTGHouseStaff S2 WHERE S2.HouseID = H.HouseID)
    LEFT JOIN Staff S ON S.StaffID = GS.StaffID
    WHERE H.TermYear = #year# AND H.Term = #term# AND H.HousePID IS NULL
    ) AS H ON H.StudentID = A.StudID

    WHERE ARSID = #ARSID#<cfif RecNo NEQ 0> AND A.StudID = #RecNo#</cfif>
    ORDER BY LastName, FirstName
</cfquery>

<cfquery name="getGrades" datasource="#dsn#">
	SELECT * FROM StudYearGrade
	WHERE TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#year#">
    AND Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#term#">
    AND StudYear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getList.AcYear#">
	ORDER BY MinPercent DESC
</cfquery>

<cfquery name="getCF" datasource="#dsn#">
    SELECT S.StaffID, S.Title, S.FirstName, S.LastName, S.SignFile, T.RepData, T.RepData2, T.RepData3, T.Date1
    FROM TTAcYearDirector T
    LEFT JOIN Staff S ON S.StaffID = T.PrincipalID
    WHERE T.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#year#">
    AND T.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#term#">
    AND T.AcYear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getList.AcYear#">
</cfquery>

<cfquery name="getTerm" datasource="#dsn#">
    SELECT * FROM TermDates
    WHERE TermYear = #year# AND Term = #term#
</cfquery>

<cfsavecontent variable="myReport">
<cfoutput>
<cfloop index="i" from="1" to="#getList.RecordCount#">
<cfset RecNo = getList.StudID[i]>

<cfquery name="getComms" datasource="#dsn#">
	SELECT C.Seq, C.HeadingRep, C.Heading, S.Comment, C.CommPerson
	FROM ARCommSetup C
	LEFT JOIN ARCommStudent S ON S.CommSetupID = C.CommSetupID AND S.StudentID = #RecNo#
	WHERE C.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#year#">
	AND C.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#term#">
	AND C.StudYear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getList.AcYear#">
	AND C.Reference = 'C' AND C.Type = 1
	ORDER BY C.Seq
</cfquery>

<cfquery name="getBoard" datasource="#dsn#">
	SELECT ST.StaffID, ST.LastName, ST.FirstName, ST.Title
	FROM BHHouseStudent S
	INNER JOIN BHHouse B ON B.BHouseID = S.BHouseID
	LEFT JOIN BHHouseHead H ON H.BHouseID = B.BHouseID
	LEFT JOIN Staff ST ON ST.StaffID = H.StaffID
	WHERE TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#year#">
	AND Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#term#">
	AND StudentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#RecNo#">
    ORDER BY H.Seq
</cfquery>

<cfquery name="getBoardComms" datasource="#dsn#">
	SELECT C.HeadingRep, S.Comment
	FROM ARCommSetup C
	LEFT JOIN ARBoardingComm S ON S.CommSetupID = C.CommSetupID
	AND S.StudentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#RecNo#">
	WHERE C.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#year#">
	AND C.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#term#">
	AND C.Reference = 'A' AND C.Type = 21
</cfquery>

<cfquery name="getReg" datasource="#dsn#">
    SELECT A.SCode, A.SubjName, SS.Comment, CS.HeadingRep, A.T1Title, A.T1FName, A.T1LName
    FROM vARSubjAcads A
    LEFT JOIN ARCommSetup CS ON CS.TermYear = A.TermYear AND CS.Term = A.Term AND CS.StudYear = A.AcYear AND CS.Type = 2 AND CS.Reference = 'A'
    LEFT JOIN ARAcadComm SS ON SS.CommSetupID = CS.CommSetupID AND SS.AcadID = A.AcadID
    WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.SCode = 'TUTOR'
    ORDER BY A.Seq
</cfquery>

<table cellpadding="0" cellspacing="0" style="width:100%; height:27cm" align="center">
<tr valign="top">
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="center" class="txtRep14Bold">
<td width="30%" rowspan="2" valign="top"><img src="#fileService.getFile(fileDir = "/keydoc/images", filename = "Trident_College_Solwezi_Vert_Strapline_CROP.png", includeHTTP = "https:")#" style="height:5.8cm;"/></td>
<td width="40%" style="color:##2e3192;padding-top:1cm;">End of Cycle 1 Report<br/>#DateFormat(getTerm.EndDate, "mmmm yyyy")#</td>
<td width="30%" rowspan="2" class="watermark"><cfif getList.Photo[i] NEQ "" AND fileService.checkFileExist(fileDir  = "/keydoc/stphotos", filename = "#getList.Photo[i]#")>
<img src="#fileService.getFile(fileDir = "/keydoc/stphotos", filename = "#getList.Photo[i]#", includeHTTP = "https:")#" style="border:5pt solid white;height:4.6cm;width:3.2cm;position:relative;"></cfif></td>
</tr>

<tr align="center" class="txtRep12Bold">
<td style="color:##2e3192;padding-bottom:2cm;">#getList.FirstName[i]# #getList.LastName[i]#<br/>Year #ListFirst(Replace(getList.AcYear[i], "Yr", ""), "_")#</td>
</tr>
</table>
</td>
</tr>

<tr>
<td style="height:40px;"></td>
</tr>


<cfquery name="getSubj" datasource="#dsn#">
    SELECT A.Seq, A.SCode, A.SubjName, A.Page, A.Mark, A.Grade, A.T1Title, A.T1FName, A.T1LName
    FROM vARSubjAcads A
    WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.RepCard = 0 AND A.SType <> 'R' AND A.Page <> 0
    ORDER BY A.Seq
</cfquery>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="center" class="txtRep11Bold" style="background-color:##b4c5e7;" valign="top">
<td width="22%" style="padding:2px 0px;" class="ball">Subject</td>
<td width="27%" class="btop bright bbottom">Teacher</td>
<td width="17%" class="btop bright bbottom">Achievement<br/>%</td>
<td width="17%" class="btop bright bbottom">Effort</td>
<td width="17%" class="btop bright bbottom">Class<br/>Average</td>
</tr>

<cfset listThreadName = "">
<cfloop query="getSubj">

<cfset uid = replace(createUUID(),'-','_','all')>
<cfset tName = "thread_#uid#">
<cfset listThreadName = listAppend(listThreadName, tName)>

<cfset tData = structNew()>
<cfset tData['year'] = year>
<cfset tData['term'] = term>
<cfset tData['RecNo'] = RecNo>
<cfset tData['SCode'] = SCode>
<cfset tData['AcYear'] = getList.AcYear[i]>
<cfset tData['Class'] = getList.Class[i]>
<cfset tData['SubjName'] = SubjName>
<cfset tData['CurrentRow'] = CurrentRow>
<cfset tData['T1Title'] = T1Title>
<cfset tData['T1FName'] = T1FName>
<cfset tData['T1LName'] = T1LName>

<cfthread name="#tName#" action="run" tData="#tData#" dsn="#dsn#">

<cfset THREAD.SubjName = ATTRIBUTES.tData.SubjName>
<cfset THREAD.SCode = ATTRIBUTES.tData.SCode>
<cfset THREAD.CurrentRow = ATTRIBUTES.tData.CurrentRow>
<cfset THREAD.T1Title = ATTRIBUTES.tData.T1Title>
<cfset THREAD.T1FName = ATTRIBUTES.tData.T1FName>
<cfset THREAD.T1LName = ATTRIBUTES.tData.T1LName>

<cfquery name="THREAD.getDet" datasource="#ATTRIBUTES.dsn#">
    SELECT Nbr, A1.Sumval, CASE WHEN A.IsHeader = 1 THEN C.Mark ELSE A.Mark END AS Mark,
    CASE WHEN A.IsHeader = 1 THEN C.Grade ELSE A.Grade END AS Grade,
	CASE WHEN A.IsHeader = 1 THEN CM.AVGMark ELSE M.AVGMark END AS AvgMark

    FROM UTLNumbers N
    LEFT JOIN vARSubjAcads A ON A.Term = N.Nbr AND A.TermYear = #ATTRIBUTES.tData.year# AND A.Term = #ATTRIBUTES.tData.term# AND A.StudID = #RecNo# AND A.SCode = N'#ATTRIBUTES.tData.SCode#'

    LEFT JOIN (
    SELECT PSSID, ROUND(SUM(ROUND(A.Mark, 2) * A.SubjWeight) / SUM(CASE WHEN A.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 2) AS Mark, (
    SELECT TOP 1 Grade FROM StudYearGrade G
    WHERE G.MinPercent <= ROUND(SUM(ROUND(A.Mark, 2) * A.SubjWeight) / SUM(CASE WHEN A.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 2)
    AND G.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
    AND G.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
    AND G.StudYear = '#ATTRIBUTES.tData.AcYear#'
    ORDER BY G.MinPercent DESC
    ) AS Grade
    FROM vARSubjAcads A
    WHERE A.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
    AND A.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
    AND A.StudID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.tData.RecNo#">
    AND A.PSSID IS NOT NULL
    GROUP BY PSSID
    ) AS C ON C.PSSID = A.SSID

	LEFT JOIN (
	SELECT Term, AVG(Mark) AS AVGMark
	FROM vARSubjAcads
	WHERE TermYear = #ATTRIBUTES.tData.year# AND Term = #ATTRIBUTES.tData.term# AND Class = N'#ATTRIBUTES.tData.Class#' AND SCode = N'#ATTRIBUTES.tData.SCode#'
	GROUP BY Term
	) M ON M.Term = N.Nbr

	LEFT JOIN (
	SELECT PSSID, AVG(ROUND(Mark, 0)) AvgMark
	FROM (
	SELECT A.StudID, PSSID,
	ROUND(SUM(ROUND(A.Mark, 0) * A.SubjWeight) / SUM(CASE WHEN A.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 0) AS Mark
	FROM vARSubjAcads A
	WHERE A.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
	AND A.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
	AND A.Class = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.tData.Class#">
	AND A.PSSID IS NOT NULL
	GROUP BY A.StudID, PSSID
	) AS M
	GROUP BY PSSID
	) AS CM ON CM.PSSID = A.SSID

	LEFT JOIN ARCommSetup C1 ON C1.TermYear = A.TermYear AND C1.Term = A.Term AND C1.StudYear = A.AcYear AND C1.Type = 52 AND C1.Reference = 'A'
	LEFT JOIN ARAcadComm A1 ON A1.CommSetupID = C1.CommSetupID AND A1.AcadID = A.AcadID
                               
    WHERE N.Nbr = #ATTRIBUTES.tData.term#
    ORDER BY N.Nbr
</cfquery>

<cfquery name="THREAD.getAvg" datasource="#ATTRIBUTES.dsn#">
    SELECT S.ClassAvgMark, S.ClassAvgGrade, S.GradeAvgMark, S.GradeAvgGrade
    FROM vARSubjAcads A
    LEFT JOIN vARSubjects S ON S.ARSID = A.ARSID
    WHERE A.TermYear = #ATTRIBUTES.tData.year# AND A.Term = #ATTRIBUTES.tData.term# AND A.StudID = #ATTRIBUTES.tData.RecNo# AND A.SCode = '#ATTRIBUTES.tData.SCode#'
</cfquery>

</cfthread>
</cfloop>

<cfif listLen(listThreadName)>
<cfthread action="join" name="#listThreadName#" />
<cfloop list="#listThreadName#" item="t">
<cfif structKeyExists(cfthread, t)>
<cfset threadResult = cfthread[t]>

<cfif threadResult.SCode NEQ getSubj.SCode[threadResult.CurrentRow-1]>
<tr align="center" class="txtRep10">
<td style="padding:2px 5px;" class="bleft bright bbottom" align="left"><b>#threadResult.SubjName#</b></td>
<td class="bright bbottom" style="padding:2px 5px;" align="left">#ucFirst(threadResult.T1Title, true, true)#<cfif threadResult.T1Title NEQ "">.</cfif> #LEFT(threadResult.T1FName, 1)# #ucFirst(threadResult.T1LName, true, true)#</td>
<td class="bright bbottom"><cfif threadResult.getDet.Mark NEQ ""><b>#NumberFormat(threadResult.getDet.Mark)#</b></cfif></td>
<td class="bright bbottom"><cfif threadResult.getDet.Sumval NEQ "">#threadResult.getDet.Sumval#</cfif></td>
<td class="bright bbottom"><cfif threadResult.getAvg.ClassAvgMark NEQ "">#NumberFormat(threadResult.getAvg.ClassAvgMark)#<cfelseif threadResult.getDet.AvgMark NEQ "">#NumberFormat(threadResult.getDet.AvgMark)#</cfif></td>
</tr>
</cfif>

</cfif>
</cfloop>
</cfif>
</table>
</td>
</tr>

<tr>
<td style="height:10px;"></td>
</tr>

<cfquery name="getOpt" datasource="#dsn#">
    SELECT A.SetName, B.OptCode, B.OptName, B.OptDescript, B.OptDefinition
    FROM SSTSet A
    LEFT JOIN SSTSetOption B ON B.SetID = A.SetID
    WHERE A.SetName = 'Effort Cambridge'
    ORDER BY B.Seq
</cfquery>

<cfquery name="getStudAtt" datasource="#dsn#">
    SELECT SUM(Absent) AS Absent
    FROM vATDStudAttTerm
    WHERE StudentID = #RecNo# AND TermYear = #year# AND Term = #term#
</cfquery>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="left" valign="top">
<td width="14%" style="font:Bold 7pt Arial;"><u>Effort Grades:</u></td>
<td width="69%" style="font:Bold 7pt Arial;"><cfloop query="getOpt" startrow="1" endrow="4">#OptCode# #OptName#<cfif CurrentRow NEQ RecordCount>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</cfif></cfloop>
<br/><cfloop query="getOpt" startrow="5">#OptCode# #OptName#<cfif CurrentRow NEQ RecordCount>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</cfif></cfloop>
</td>
<td rowspan="2">
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="center" class="txtRep11Bold" style="background-color:##b4c5e7;">
<td class="ball" style="height:30px;">Days Absent</td>
</tr>

<tr align="center" class="txtRep11">
<td class="bleft bright bbottom" style="height:30px;">#NumberFormat(getStudAtt.Absent)#</td>
</tr>
</table>
</td>
</tr>

<tr align="left" valign="top">
<td style="font:Bold 7pt Arial;"><u>Progression Norms:</u></td>
<td style="font:Bold 7pt Arial;">#getCF.RepData#</td>
</tr>
</table>
</td>
</tr>

<tr>
<td style="height:10px;"></td>
</tr>

<cfquery name="getSubj" datasource="#dsn#">
    SELECT A.Seq, A.SCode, A.SubjName, A.Page, A.Mark, A.Grade, A.T1Title, A.T1FName, A.T1LName, SS.Comment
    FROM vARSubjAcads A
    LEFT JOIN ARCommSetup CS ON CS.TermYear = A.TermYear AND CS.Term = A.Term AND CS.StudYear = A.AcYear AND CS.Type = 2 AND CS.Reference = 'B'
    LEFT JOIN ARAcadComm SS ON SS.CommSetupID = CS.CommSetupID AND SS.AcadID = A.AcadID
    WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.RepCard = 0 AND A.SType <> 'R' AND A.Page = 1 AND SS.Comment <> ''
    ORDER BY A.Seq
</cfquery>


<cfset listThreadName = "">
<cfloop query="getSubj">

<cfset uid = replace(createUUID(),'-','_','all')>
<cfset tName = "thread_#uid#">
<cfset listThreadName = listAppend(listThreadName, tName)>

<cfset tData = structNew()>
<cfset tData['year'] = year>
<cfset tData['term'] = term>
<cfset tData['RecNo'] = RecNo>
<cfset tData['SCode'] = SCode>
<cfset tData['SubjName'] = SubjName>
<cfset tData['CurrentRow'] = CurrentRow>
<cfset tData['T1Title'] = T1Title>
<cfset tData['T1FName'] = T1FName>
<cfset tData['T1LName'] = T1LName>
<cfset tData['RecordCount'] = RecordCount>

<cfthread name="#tName#" action="run" tData="#tData#" dsn="#dsn#">

<cfset THREAD.SubjName = ATTRIBUTES.tData.SubjName>
<cfset THREAD.SCode = ATTRIBUTES.tData.SCode>
<cfset THREAD.CurrentRow = ATTRIBUTES.tData.CurrentRow>
<cfset THREAD.T1Title = ATTRIBUTES.tData.T1Title>
<cfset THREAD.T1FName = ATTRIBUTES.tData.T1FName>
<cfset THREAD.T1LName = ATTRIBUTES.tData.T1LName>
<cfset THREAD.RecordCount = ATTRIBUTES.tData.RecordCount>

<cfquery name="THREAD.getSubjCom" datasource="#ATTRIBUTES.dsn#">
    SELECT A.Seq, A.SCode, A.SubjName, SS.Comment
    FROM vARSubjAcads A
    LEFT JOIN ARCommSetup CS ON CS.TermYear = A.TermYear AND CS.Term = A.Term AND CS.StudYear = A.AcYear AND CS.Type = 2 AND CS.Reference = 'B'
    LEFT JOIN ARAcadComm SS ON SS.CommSetupID = CS.CommSetupID AND SS.AcadID = A.AcadID
    WHERE A.TermYear = #ATTRIBUTES.tData.year# AND A.Term = #ATTRIBUTES.tData.term# AND A.StudID = #ATTRIBUTES.tData.RecNo# AND A.SCode = '#ATTRIBUTES.tData.SCode#'
    ORDER BY A.Seq
</cfquery>

</cfthread>
</cfloop>

<cfif listLen(listThreadName)>
<cfthread action="join" name="#listThreadName#" />
<cfloop list="#listThreadName#" item="t">
<cfif structKeyExists(cfthread, t)>
<cfset threadResult = cfthread[t]>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center" class="print-friendly">
<cfif threadResult.SCode NEQ getSubj.SCode[threadResult.CurrentRow-1]>
<tr align="left" class="txtRep11Bold" style="background-color:##b4c5e7;">
<td width="50%" style="padding:2px 5px;" class="bleft btop bbottom"><b>#threadResult.SubjName#</b></td>
<td width="50%" class="btop bright bbottom" style="padding:2px 5px;" align="right">#ucFirst(threadResult.T1Title, true, true)#<cfif threadResult.T1Title NEQ "">.</cfif> #ucFirst(threadResult.T1FName, true, true)# #ucFirst(threadResult.T1LName, true, true)#</td>
</tr>
<tr align="left" class="txtRep10" valign="top">
<td colspan="2" class="bleft bright bbottom" style="padding:2px 5px;height:2cm;">#Replace(threadResult.getSubjCom.Comment, Chr(13), "<br />", "All")#</td>
</tr>
</cfif>

<cfif threadResult.SCode NEQ getSubj.SCode[threadResult.CurrentRow+1] AND threadResult.CurrentRow NEQ threadResult.RecordCount>
<tr>
<td colspan="2" style="height:20px;"></td>
</tr>
</cfif>
</table>
</td>
</tr>
</cfif>
</cfloop>
</cfif>

<cfif getReg.Comment NEQ "">
<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center" class="print-friendly">
<tr>
<td colspan="2" style="height:20px;"></td>
</tr>

<tr align="left" class="txtRep11Bold" style="background-color:##b4c5e7;">
<td style="padding:2px 5px;" class="bleft btop bbottom"><b>#getReg.HeadingRep#</b></td>
<td class="btop bright bbottom" style="padding:2px 5px;" align="right">#ucFirst(getReg.T1Title, true, true)#<cfif getReg.T1Title NEQ "">.</cfif> #ucFirst(getReg.T1FName, true, true)# #ucFirst(getReg.T1LName, true, true)#</td>
</tr>
<tr align="left" class="txtRep10" valign="top">
<td colspan="2" class="bleft bright bbottom" style="padding:2px 5px;height:2cm;">#Replace(getReg.Comment, Chr(13), "<br />", "All")#</td>
</tr>
</table>
</td>
</tr>
</cfif>

<cfif getBoardComms.Comment NEQ "">
<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center" class="print-friendly">
<tr>
<td colspan="2" style="height:20px;"></td>
</tr>

<tr align="left" class="txtRep11Bold" style="background-color:##b4c5e7;">
<td style="padding:2px 5px;" class="bleft btop bbottom"><b>#getBoardComms.HeadingRep#</b></td>
<td class="btop bright bbottom" style="padding:2px 5px;" align="right">#ucFirst(getBoard.Title, true, true)#<cfif getBoard.Title NEQ "">.</cfif> #ucFirst(getBoard.FirstName, true, true)# #ucFirst(getBoard.LastName, true, true)#</td>
</tr>
<tr align="left" class="txtRep10" valign="top">
<td colspan="2" class="bleft bright bbottom" style="padding:2px 5px;height:2cm;">#Replace(getBoardComms.Comment, Chr(13), "<br />", "All")#</td>
</tr>
</table>
</td>
</tr>
</cfif>

<cfif getComms.Comment NEQ "">
<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center" class="print-friendly">
<tr>
<td colspan="2" style="height:20px;"></td>
</tr>

<tr align="left" class="txtRep11Bold" style="background-color:##b4c5e7;">
<td style="padding:2px 5px;" class="bleft btop bbottom"><b>#getComms.HeadingRep#</b></td>
<td class="btop bright bbottom" style="padding:2px 5px;" align="right">#ucFirst(getCF.Title, true, true)#<cfif getCF.Title NEQ "">.</cfif> #ucFirst(getCF.FirstName, true, true)# #ucFirst(getCF.LastName, true, true)#</td>
</tr>
<tr align="left" class="txtRep10" valign="top">
<td colspan="2" class="bleft bright bbottom" style="padding:2px 5px;height:2cm;">#Replace(getComms.Comment, Chr(13), "<br />", "All")#</td>
</tr>
</table>
</td>
</tr>
</cfif>

</table>
</td>
</tr>
</table>



<cfif i NEQ getList.RecordCount><div class="pagebreak"></div></cfif>
<br class="noprint" />
</cfloop>
</cfoutput>
</cfsavecontent>


<cfif AsPDF EQ 0>

<head>
<InvalidTag http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Report Card</title>
<link rel="stylesheet" href="<cfoutput>#varSiteHome#</cfoutput>css/stylesheet.css" type="text/css">
<style type="text/css">
.txtRep20, .txtRep20Bold, .txtRep16, .txtRep16Bold, .txtRep14, .txtRep14Bold, .txtRep12, .txtRep12Bold, .txtRep11, 
.txtRep11Bold, .txtRep10, .txtRep10Bold, .txtRep9, .txtRep9Bold, .txtRep8, .txtRep8Bold, .txtRep7, .txtRep7Bold{
font-family:Arial !important;
}

.borders {
  border: 5px solid white; 
  outline: 1px solid black;
}

.watermark  {
   background-image: url("https://s3-eu-west-1.amazonaws.com/client-z5n97j6prh/Public%20folder/image_border.png");
    background-repeat: no-repeat;
    background-position: center center;
    background-size: 3.8cm 5.2cm;
}

table.print-friendly, table.print-friendly tr, table.print-friendly tr td {
        page-break-inside: avoid !important;
  }

</style>
</head>

<body>
<div align="right" class="noprint">
<img src="<cfoutput>#varSiteHome#</cfoutput>images/print.gif" style="cursor:pointer" onClick="window.print()">
</div>
<cfoutput>#myReport#</cfoutput>
<div align="right" class="noprint"><input type="button" class="stdButton" value="Close" onClick="window.close()" /></div>
</body>

<cfelse>

<cfdocument format="PDF" pagetype="a4" orientation="portrait" scale="100" unit="cm" marginbottom="0.3" margintop="1" 
marginleft="0.4" marginright="0.4" localurl="yes" fontembed="yes" fontdirectory="/superfonts/" name="MyPDFFile">

<head>
<InvalidTag http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Report Card</title>
<link rel="stylesheet" href="<cfoutput>#varSiteHome#</cfoutput>css/stylesheet.css" type="text/css">
<style type="text/css">
.txtRep20, .txtRep20Bold, .txtRep16, .txtRep16Bold, .txtRep14, .txtRep14Bold, .txtRep12, .txtRep12Bold, .txtRep11, 
.txtRep11Bold, .txtRep10, .txtRep10Bold, .txtRep9, .txtRep9Bold, .txtRep8, .txtRep8Bold, .txtRep7, .txtRep7Bold{
font-family:Arial !important;
}

.borders {
  border: 5px solid white; 
  outline: 1px solid black;
}


.watermark  {
   background-image: url("https://s3-eu-west-1.amazonaws.com/client-z5n97j6prh/Public%20folder/image_border.png");
    background-repeat: no-repeat;
    background-position: center center;
    background-size: 3.8cm 5.2cm;
}
table.print-friendly, table.print-friendly tr, table.print-friendly tr td {
        page-break-inside: avoid !important;
  }

</style>
</head>

<body>
<cfoutput>#myReport#</cfoutput>
</body>
</cfdocument>
<cfif ReportFileName EQ "">
<cfheader name="Content-Disposition" value="inline; filename=reportcard.pdf">
<cfcontent type="application/pdf" variable="#toBinary(MyPDFFile)#" />
<cfelse>
<cffile action="write" output="#MyPDFFile#" file="#ReportFileName#">
</cfif>
</cfif>
</html>  