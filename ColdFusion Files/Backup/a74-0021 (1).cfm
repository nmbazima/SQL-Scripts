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
    SELECT S.StaffID, S.Title, S.FirstName, S.LastName, S.SignFile, T.RepData, T.RepData2, T.RepData3, T.RepData4, T.Date1
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
	AND C.Reference = 'B' AND C.Type = 1
	ORDER BY C.Seq
</cfquery>

<table cellpadding="0" cellspacing="0" style="width:100%; height:28cm" align="center">
<tr valign="top">
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="left" class="txtRep8">
<td width="50%" style="color:##585858;">#getCF.RepData#</td>
<td width="50%" align="right"><img src="#fileService.getFile(fileDir = "/keydoc/images", filename = "Sentinel_Kabitaka.png", includeHTTP = "https:")#" style="height:2cm;"/></td>
</tr>
</table>
</td>
</tr>

<tr>
<td style="height:20px;"></td>
</tr>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="left" class="txtRep16Bold">
<td colspan="2">END OF TERM REPORT: #DateFormat(getTerm.EndDate, "MMMM YYYY")#</td>
</tr>

<tr>
<td style="height:20px;"></td>
</tr>

<tr align="left" class="txtRep16">
<td width="60%">Student: <b>#getList.FirstName[i]#<cfif getList.MiddleName[i] NEQ ""> #getList.MiddleName[i]#</cfif> #getList.LastName[i]#</b></td>
<td width="40%" align="right">Class: <b>Year #ListFirst(Replace(getList.AcYear[i], "Yr", ""), "_")#</b></td>
</tr>

<tr>
<td style="height:10px;"></td>
</tr>

<tr align="left" class="txtRep10">
<td colspan="2">#getCF.RepData4#</td>
</tr>
</table>
</td>
</tr>

<cfquery name="getOpt" datasource="#dsn#">
    SELECT A.SetName, B.OptCode, B.OptName, B.OptDescript, B.OptDefinition
    FROM SSTSet A
    LEFT JOIN SSTSetOption B ON B.SetID = A.SetID
    WHERE A.SetName = 'Effort Cambridge'
    ORDER BY B.Seq
</cfquery>

<cfif ListFind('Yr8_SKABS,Yr10_SKABS,Yr11_SKABS', getList.AcYear[i])>
<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr valign="top">
<td width="65%" class="ball" style="background-color:##0061b0;padding:8px 5px;">
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="left" class="txtRep12Bold" style="color:##FFFFFF;">
<td colspan="2">Achievement</td>
</tr>

<cfloop query="getGrades">
<tr valign="left" class="txtRep9Bold" style="color:##FFFFFF;">
<td width="5%">#Grade#</td>
<td width="95%">#GradeDesc#</td>
</tr>
</cfloop>
</table>
</td>
<td width="35%" class="btop bright bbottom" style="background-color:##818285;padding:8px 5px;">
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="left" class="txtRep12Bold" style="color:##FFFFFF;">
<td colspan="2">Effort (E)</td>
</tr>

<cfloop query="getOpt">
<tr valign="left" class="txtRep9Bold" style="color:##FFFFFF;">
<td width="5%">#OptCode#</td>
<td width="95%">#OptName#</td>
</tr>
</cfloop>
</table>
</td>
</tr>
</table>
</td>
</tr>
</cfif>

<cfif ListFind('Yr7_SKABS,Yr9_SKABS', getList.AcYear[i])>
<tr>
<td style="height:10px;"></td>
</tr>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="center" class="txtRep10Bold" style="background-color:##0061b0;">
<td width="24%" style="padding:2px 0px;color:##FFFFFF;" class="ball">Division</td>
<td width="24%" style="color:##FFFFFF;" class="btop bright bbottom">Effort</td>
<td width="24%" style="color:##FFFFFF;" class="btop bright bbottom">Grade</td>
<td width="28%" style="color:##FFFFFF;" class="btop bright bbottom">Grade Description</td>
</tr>

<cfloop index="k" from="1" to="#getOpt.RecordCount#">
<tr align="center" class="txtRep10">
<td style="padding:2px 0px;" class="bleft bright bbottom"><cfif getGrades.Grade[k] NEQ "">Division #getGrades.Grade[k]#</cfif> </td>
<td class="bright bbottom">#getOpt.OptCode[k]#</td>
<td class="bright bbottom">#Replace(ListLast(getGrades.GradeDesc[k], " ("), ")", "")#</td>
<td class="bright bbottom"><cfif getGrades.Grade[k] EQ "F">#ListFirst(getGrades.GradeDet[k], " (")#<cfelse>#getGrades.GradeDet[k]#</cfif></td>
</tr>
</cfloop>
</table>
</td>
</tr>
</cfif>

<tr>
<td style="height:20px;"></td>
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
<tr align="center" class="txtRep10Bold" style="background-color:##818285;color:##FFFFFF;">
<td width="24%" style="padding:2px 0px;" class="ball">Subject</td>
<td width="14%" class="btop bright bbottom"><cfif ListFind('Yr7_SKABS,Yr9_SKABS', getList.AcYear[i])>Division<cfelse>Achievement</cfif></td>
<td width="14%" class="btop bright bbottom">Effort</td>
<td width="24%" class="btop bright bbottom">Exam %</td>
<td width="24%" class="btop bright bbottom">Teacher</td>
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

<cfquery name="THREAD.getDet" datasource="#ATTRIBUTES.dsn#">
    SELECT Nbr, A1.Sumval, CASE WHEN A.IsHeader = 1 THEN C.Mark ELSE A.Mark END AS Mark,
    CASE WHEN A.IsHeader = 1 THEN C.Grade ELSE A.Grade END AS Grade, 
    CASE WHEN A.IsHeader = 1 THEN C.ExamMark ELSE D2.Mark END AS ExamMark,
    CASE WHEN A.IsHeader = 1 THEN C.ExamGrade ELSE D2.Grade END AS ExamGrade

    FROM UTLNumbers N
    LEFT JOIN vARSubjAcads A ON A.Term = N.Nbr AND A.TermYear = #ATTRIBUTES.tData.year# AND A.Term = #ATTRIBUTES.tData.term# AND A.StudID = #ATTRIBUTES.tData.RecNo# AND A.SCode = N'#ATTRIBUTES.tData.SCode#'

    LEFT JOIN ARAssCol C2 ON C2.ARSID = A.ARSID AND C2.Lvl = 1 AND C2.ColHeading LIKE '%Assess 2%'
    LEFT JOIN ARAssColData D2 ON D2.ARAssColID = C2.ARAssColID AND D2.AcadID = A.AcadID

    LEFT JOIN (
    SELECT PSSID, ROUND(SUM(ROUND(A.Mark, 2) * A.SubjWeight) / SUM(CASE WHEN A.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 2) AS Mark, (
    SELECT TOP 1 Grade FROM StudYearGrade G
    WHERE G.MinPercent <= ROUND(SUM(ROUND(A.Mark, 2) * A.SubjWeight) / SUM(CASE WHEN A.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 2)
    AND G.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
    AND G.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
    AND G.StudYear = '#ATTRIBUTES.tData.AcYear#'
    ORDER BY G.MinPercent DESC
    ) AS Grade, 
    ROUND(SUM(ROUND(D2.Mark, 2) * A.SubjWeight) / SUM(CASE WHEN D2.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 2) AS ExamMark, (
    SELECT TOP 1 Grade FROM StudYearGrade G
    WHERE G.MinPercent <= ROUND(SUM(ROUND(D2.Mark, 2) * A.SubjWeight) / SUM(CASE WHEN D2.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 2)
    AND G.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
    AND G.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
    AND G.StudYear = '#ATTRIBUTES.tData.AcYear#'
    ORDER BY G.MinPercent DESC
    ) AS ExamGrade
    FROM vARSubjAcads A

    LEFT JOIN ARAssCol C2 ON C2.ARSID = A.ARSID AND C2.Lvl = 1 AND C2.ColHeading LIKE '%Assess 2%'
    LEFT JOIN ARAssColData D2 ON D2.ARAssColID = C2.ARAssColID AND D2.AcadID = A.AcadID

    WHERE A.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
    AND A.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
    AND A.StudID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.tData.RecNo#">
    AND A.PSSID IS NOT NULL
    GROUP BY PSSID
    ) AS C ON C.PSSID = A.SSID

	LEFT JOIN ARCommSetup C1 ON C1.TermYear = A.TermYear AND C1.Term = A.Term AND C1.StudYear = A.AcYear AND C1.Type = 52 AND C1.Reference = 'A'
	LEFT JOIN ARAcadComm A1 ON A1.CommSetupID = C1.CommSetupID AND A1.AcadID = A.AcadID
                               
    WHERE N.Nbr = #ATTRIBUTES.tData.term#
    ORDER BY N.Nbr
</cfquery>

</cfthread>
</cfloop>

<cfif listLen(listThreadName)>
<cfthread action="join" name="#listThreadName#" />
<cfloop list="#listThreadName#" item="t">
<cfif structKeyExists(cfthread, t)>
<cfset threadResult = cfthread[t]>

<cfif threadResult.SCode NEQ getSubj.SCode[threadResult.CurrentRow-1]>
<tr align="center" class="txtRep9">
<td style="padding:2px;" class="bleft bright bbottom">#threadResult.SubjName#</td>
<td class="bright bbottom"><cfif threadResult.getDet.ExamMark NEQ "">#threadResult.getDet.ExamGrade#</cfif></td>
<td class="bright bbottom">#threadResult.getDet.Sumval#</td>
<td class="bright bbottom"><cfif threadResult.getDet.ExamMark NEQ "">#NumberFormat(threadResult.getDet.ExamMark)#</cfif></td>
<td class="bright bbottom">#ucFirst(threadResult.T1Title, true, true)#<cfif threadResult.T1Title NEQ "">.</cfif> #LEFT(threadResult.T1FName, 1)#<cfif threadResult.T1FName NEQ "">.</cfif> #ucFirst(threadResult.T1LName, true, true)#</td>
</tr>
</cfif>
</cfif>
</cfloop>
</cfif>
</table>
</td>
</tr>

<tr>
<td style="height:20px;"></td>
</tr>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="left" class="txtRep10Bold" style="background-color:##818285;color:##FFFFFF;">
<td width="70%" style="padding:2px 5px;" class="bleft btop bbottom"><b>#getComms.HeadingRep#</b></td>
<td width="30%" class="btop bright bbottom" align="center">#ucFirst(getList.Title, true, true)#<cfif getList.Title NEQ "">.</cfif> #LEFT(getList.TFName, 1)#. #ucFirst(getList.TLName, true, true)#</td>
</tr>
<tr align="left" class="txtRep9" valign="top">
<td colspan="2" class="bleft bright bbottom" style="padding:2px 5px;height:1.5cm;">#Replace(getComms.Comment, Chr(13), "<br />", "All")#</td>
</tr>
</table>
</td>
</tr>


</table>
</td>
</tr>
<tr valign="bottom">
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="left" class="txtRep8">
<td width="33%"></td>
<td width="34%" align="center"><img src="#fileService.getFile(fileDir = "/keydoc/images", filename = "replogo.png", includeHTTP = "https:")#" style="height:1.5cm;"/></td>
<td width="33%">#getCF.RepData2#</td>
</tr>
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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
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

<cfdocument format="PDF" pagetype="a4" orientation="portrait" scale="100" unit="cm" marginbottom="0.5" margintop="0.5" 
marginleft="0.4" marginright="0.4" localurl="yes" fontembed="yes" fontdirectory="/superfonts/" name="MyPDFFile">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
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

</cfif>
</cfif>
</html> 