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

<cfquery name="getTermNext" datasource="#dsn#">
	SELECT * FROM TermDates
	<cfif getTerm.Term EQ MaxTerm>WHERE TermYear = #year# +1 AND Term  = 1<cfelse>WHERE TermYear = #year# AND Term  = #term# +1</cfif>
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
	AND C.Reference = 'A' AND C.Type = 1
	ORDER BY C.Seq
</cfquery>

<cfquery name="getStudAtt" datasource="#dsn#">
    SELECT SUM(Absent) AS Absent, SUM(Present) AS Present 
    FROM vATDStudAttTerm
    WHERE StudentID = #RecNo# AND TermYear = #year# AND Term = #term#
</cfquery>

<table cellpadding="0" cellspacing="0" style="width:100%; height:28cm" align="center">
<tr valign="top">
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="left" class="txtRep8" valign="top">
<td width="50%" style="color:##818285;">#getCF.RepData#</td>
<td width="50%" align="right"><img src="#fileService.getFile(fileDir = "/keydoc/images", filename = "Frontier_Nkisu_Logo.png", includeHTTP = "https:")#" style="height:2cm;"/></td>
</tr>
</table>
</td>
</tr>

<tr>
<td style="height:15px;"></td>
</tr>

<tr align="left" class="txtRep16Bold">
<td>END OF TERM REPORT: #DateFormat(getTerm.EndDate, "MMMM YYYY")#</td>
</tr>

<tr>
<td style="height:15px;"></td>
</tr>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="95%" align="center">
<tr align="left" class="txtRep12">
<td width="60%">Student Name: <b>#getList.FirstName[i]#<cfif getList.MiddleName[i] NEQ ""> #getList.MiddleName[i]#</cfif> #getList.LastName[i]#</b></td>
<td width="40%">Year Group: <b>Year #ListFirst(Replace(getList.Class[i], "Yr", ""), "_")#</b></td>
</tr>

<tr align="left" class="txtRep12">
<td>Class Teacher: <b>#getList.Title[i]# #getList.TLName[i]#</b></td>
<td>Repeated to: <!---<b>Year #ListFirst(Replace(getList.Class[i], "Yr", ""), "_")#</b>---></td>
</tr>
<cfset gradeyear = '#ListFirst(Replace(getList.AcYear[i], "Yr", ""), "_")#'>
<tr align="left" class="txtRep12">
<td>Days Present: <b>#NumberFormat(getStudAtt.Present)#</b></td>
<td>Promoted to: <!---<b>Year #LEFT(ListFirst(Replace(getList.Class[i], "Yr", ""), "_"), 1)+1##LEFT(Replace(ListFirst(Replace(getList.Class[i], "Yr", ""), "_"), "#gradeyear#", ""), 1)#</b>---></td>
</tr>

<tr align="left" class="txtRep12">
<td>Days Absent: <b>#NumberFormat(getStudAtt.Absent)#</b></td>
<td></td>
</tr>

<tr>
<td style="height:15px;"></td>
</tr>
</table>
</td>
</tr>

<cfquery name="getOpt" datasource="#dsn#">
    SELECT A.SetName, B.OptCode, B.OptName, B.OptDescript, B.OptDefinition
    FROM SSTSet A
    LEFT JOIN SSTSetOption B ON B.SetID = A.SetID
    WHERE A.SetName = 'Effort FNkisu'
    ORDER BY B.Seq
</cfquery>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr valign="top">
<td width="65%" style="background-color:##e2871b;padding:5px;">
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="left" class="txtRep10Bold" style="color:##FFFFFF;">
<td colspan="2" style="padding-left:10px;">Achievement (%)</td>
</tr>

<cfloop query="getGrades">
<tr valign="left" class="txtRep9" style="color:##FFFFFF;">
<td width="18%"><b>#NumberFormat(MinPercent)#%-#NumberFormat(MaxPercent)#%</b></td>
<td width="82%"><i>#GradeDesc#</i></td>
</tr>
</cfloop>
</table>
</td>
<td width="35%" style="background-color:##818285;padding:5px;">
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="left" class="txtRep10Bold" style="color:##FFFFFF;">
<td></td>
<td>Effort (E)</td>
</tr>

<cfloop query="getOpt">
<tr valign="left" class="txtRep9" style="color:##FFFFFF;">
<td width="7%"><b>#OptCode#</b></td>
<td width="93%">#OptName#</td>
</tr>
</cfloop>
</table>
</td>
</tr>
</table>
</td>
</tr>

<tr>
<td style="height:15px;"></td>
</tr>

<cfquery name="getSubj" datasource="#dsn#">
    SELECT A.Seq, A.SCode, A.SubjName, A.Page, A.Mark, A.Grade, A.T1Title, A.T1FName, A.T1LName, SS.Comment
    FROM vARSubjAcads A
	LEFT JOIN ARCommSetup CS ON CS.TermYear = A.TermYear AND CS.Term = A.Term AND CS.StudYear = A.AcYear AND CS.Type = 2 AND CS.Reference = 'B'
	LEFT JOIN ARAcadComm SS ON SS.CommSetupID = CS.CommSetupID AND SS.AcadID = A.AcadID
    WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.RepCard = 0 AND A.SType <> 'R' AND A.Page <> 0
    ORDER BY A.Seq
</cfquery>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="center" class="txtRep10Bold" style="background-color:##e2871b;color:##FFFFFF;">
<td width="55%" rowspan="2" style="padding:0px 5px;" class="ball" align="left">Subject</td>
<td colspan="2" class="btop bright bbottom" style="padding:3px;">Achievement</td>
<td width="15%" rowspan="2" class="btop bright bbottom">Effort</td>
</tr>

<tr align="center" class="txtRep9Bold" style="background-color:##e2871b;color:##FFFFFF;">
<td width="15%" class="bright bbottom" style="padding:3px;">Marks Awarded</td>
<td width="15%" class="bright bbottom">Total Marks</td>
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
<cfset tData['Comment'] = Comment>
<cfset tData['RecordCount'] = RecordCount>

<cfthread name="#tName#" action="run" tData="#tData#" dsn="#dsn#">

<cfset THREAD.SubjName = ATTRIBUTES.tData.SubjName>
<cfset THREAD.SCode = ATTRIBUTES.tData.SCode>
<cfset THREAD.CurrentRow = ATTRIBUTES.tData.CurrentRow>
<cfset THREAD.Comment = ATTRIBUTES.tData.Comment>
<cfset THREAD.RecordCount = ATTRIBUTES.tData.RecordCount>

<cfquery name="THREAD.getDet" datasource="#ATTRIBUTES.dsn#">
    SELECT Nbr, CASE WHEN A.IsHeader = 1 THEN C.Mark ELSE A.Mark END AS Mark

    FROM UTLNumbers N
    LEFT JOIN vARSubjAcads A ON A.Term = N.Nbr AND A.TermYear = #ATTRIBUTES.tData.year# AND A.Term = #ATTRIBUTES.tData.term# AND A.StudID = #ATTRIBUTES.tData.RecNo# AND A.SCode = N'#ATTRIBUTES.tData.SCode#'

    LEFT JOIN (
    SELECT PSSID, ROUND(SUM(ROUND(A.Mark, 2) * A.SubjWeight) / SUM(CASE WHEN A.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 2) AS Mark
    FROM vARSubjAcads A

    WHERE A.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
    AND A.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
    AND A.StudID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.tData.RecNo#">
    AND A.PSSID IS NOT NULL
    GROUP BY PSSID
    ) AS C ON C.PSSID = A.SSID
    
    WHERE N.Nbr = #ATTRIBUTES.tData.term#
    ORDER BY N.Nbr
</cfquery>

<cfquery name="THREAD.getSubjSum" datasource="#ATTRIBUTES.dsn#">
    SELECT A1.SumVal
    FROM vARSubjAcads A
    LEFT JOIN ARCommSetup C1 ON C1.TermYear = A.TermYear AND C1.Term = A.Term AND C1.StudYear = A.AcYear AND C1.Type = 52 AND C1.Reference = 'A'
    LEFT JOIN ARAcadComm A1 ON A1.CommSetupID = C1.CommSetupID AND A1.AcadID = A.AcadID
    WHERE A.TermYear = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.tData.year#">
    AND A.Term = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.tData.term#">
    AND A.SCode = '#ATTRIBUTES.tData.SCode#' AND A.StudID = #ATTRIBUTES.tData.RecNo#
    ORDER BY A.Seq
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
<td style="padding:2px;" class="bleft bright bbottom" style="padding:2px 5px;" align="left">#threadResult.SubjName#</td>
<td class="bright bbottom"><cfif threadResult.getDet.Mark NEQ "">#NumberFormat(threadResult.getDet.Mark)#</cfif></td>
<td class="bright bbottom">100</td>
<td class="bright bbottom">#threadResult.getSubjSum.Sumval#</td>
</tr>
</cfif>
</cfif>
</cfloop>
</cfif>

<cfquery name="getTotalMark" datasource="#dsn#">
    SELECT Nbr, SUM(CASE WHEN A.IsHeader = 1 THEN C.Mark ELSE A.Mark END) AS Mark
    FROM UTLNumbers N
    LEFT JOIN vARSubjAcads A ON A.Term = N.Nbr AND A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.Page <> 0
    LEFT JOIN (
    SELECT PSSID, ROUND(SUM(ROUND(A.Mark, 0) * A.SubjWeight) / SUM(CASE WHEN A.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 0) AS Mark
    FROM vARSubjAcads A
    WHERE A.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#year#">
    AND A.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#term#">
    AND A.StudID = <cfqueryparam cfsqltype="cf_sql_integer" value="#RecNo#">
    AND A.PSSID IS NOT NULL
    AND A.Page <> 0
    GROUP BY PSSID
    ) AS C ON C.PSSID = A.SSID
    WHERE N.Nbr = #term#
    GROUP BY Nbr
    ORDER BY Nbr
</cfquery>

<cfset totalmark = 0>
<cfif getSubj.RecordCount GT 0>
<cfset totalmark = 100 * getSubj.RecordCount>
</cfif>
<tr align="center" class="txtRep9Bold">
<td style="padding:2px;" class="bleft bright bbottom" style="padding:2px 5px;">Total</td>
<td class="bright bbottom"><cfif getTotalMark.Mark NEQ "">#NumberFormat(getTotalMark.Mark)#</cfif></td>
<td class="bright bbottom"><cfif totalmark GT 0>#NumberFormat(totalmark)#</cfif></td>
<td class="bright bbottom"></td>
</tr>
</table>
</td>
</tr>

<tr>
<td style="height:15px;"></td>
</tr>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="left" class="txtRep10Bold" style="background-color:##e2871b;color:##FFFFFF;">
<td width="50%" style="padding:2px 5px;" class="ball"><b>#getComms.HeadingRep#</b></td>
<td width="50%" class="btop bright bbottom" align="center">#ucFirst(getList.Title, true, true)#<cfif getList.Title NEQ "">.</cfif> #LEFT(getList.TFName, 1)#. #ucFirst(getList.TLName, true, true)#</td>
</tr>
<tr align="left" class="txtRep9" valign="top">
<td colspan="2" class="bleft bright bbottom" style="padding:2px 5px;height:20px;">#Replace(getComms.Comment, Chr(13), "<br />", "All")#</td>
</tr>
</table>
</td>
</tr>

<tr>
<td style="height:15px;"></td>
</tr>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="left" class="txtRep10">
<td width="60%">#getCF.Title#<cfif getCF.Title NEQ "">. </cfif>#LEFT(getCF.FirstName, 1)#<cfif getCF.FirstName NEQ "">. </cfif>#getCF.LastName#</td>
<td width="40%">#DateFormat(getTermNext.StartDate, "d mmmm yyyy")#</td>
</tr>
<tr align="left" class="txtRep10Bold">
<td>Head Teacher</td>
<td>Date for Start of Next Term </td>
</tr>
</table>
</td>
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
color:#818285;
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
color:#818285;
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