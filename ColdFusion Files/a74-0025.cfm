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
    C.Class, T.FirstName AS TFName, T.LastName AS TLName, T.Title, T.TeacherID, T.T1SignFile, G.Height, G.Weight, A.Age
    FROM vARSubjAcads A
    LEFT JOIN TTClassStud C ON C.TermYear = A.TermYear AND C.Term = A.Term
    AND C.AcYear = A.AcYear AND C.StudID = A.StudID
    LEFT JOIN vTTClasses T ON T.Class = C.Class AND T.ClYear = C.TermYear AND T.ClTerm = C.Term
    LEFT JOIN vMedicalInfo G ON G.StudentID = A.StudID
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

<table cellpadding="0" cellspacing="0" style="width:100%; height:28cm" align="center">
<tr valign="top">
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="left" class="txtRep8">
<td width="50%">#getCF.RepData#</td>
<td width="50%" align="right"><img src="#fileService.getFile(fileDir = "/keydoc/images", filename = "Sentinel_Kabitaka.png", includeHTTP = "https:")#" style="height:2.3cm;"/></td>
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
<td colspan="2">End of Term Report: #DateFormat(getTerm.EndDate, "MMMM YYYY")#</td>
</tr>

<tr>
<td style="height:40px;"></td>
</tr>

<tr align="left" class="txtRep14">
<td width="60%">Student: <b>#getList.FirstName[i]# #getList.LastName[i]#</b></td>
<td width="40%" align="right">Class: <b>Year #ListFirst(Replace(getList.AcYear[i], "Yr", ""), "_")#</b></td>
</tr>

<tr>
<td style="height:20px;"></td>
</tr>

<tr align="left" class="txtRep10">
<td colspan="2">#getCF.RepData3#</td>
</tr>
</table>
</td>
</tr>

<tr>
<td style="height:10px;"></td>
</tr>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="center" class="txtRep10Bold" style="background-color:##0060af;">
<td width="20%" style="padding:2px 0px;color:##FFFFFF;" class="ball">Grade</td>
<td width="20%" style="color:##FFFFFF;" class="btop bright bbottom">Attainment</td>
<td width="60%" style="color:##FFFFFF;" class="btop bright bbottom">Descriptor</td>
</tr>

<cfloop query="getGrades">
<tr align="center" class="txtRep10">
<td style="padding:2px 0px;" class="bleft bright bbottom">#Grade#</td>
<td class="bright bbottom">#NumberFormat(MinPercent)# - #NumberFormat(MaxPercent)#%</td>
<td class="bright bbottom" align="left" style="padding:2px 5px;">#GradeDesc#</td>
</tr>
</cfloop>
</table>
</td>
</tr>

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
<tr align="center" class="txtRep10Bold" style="background-color:##0060af;" valign="top">
<td width="27%" style="padding:2px 0px;color:##FFFFFF;" class="ball">Subject</td>
<td width="14%" style="color:##FFFFFF;" class="btop bright bbottom">Assessment 3<br/>Grade</td>
<td width="14%" style="color:##FFFFFF;" class="btop bright bbottom">Assessment 3<br/>Attainment %</td>
<td width="14%" style="color:##FFFFFF;" class="btop bright bbottom">Assessment 4<br/>Grade</td>
<td width="14%" style="color:##FFFFFF;" class="btop bright bbottom">Assessment 4<br/>Attainment %</td>
<td width="17%" style="color:##FFFFFF;" class="btop bright bbottom">Teacher</td>
</tr>

<cfloop query="getSubj">

<cfquery name="getDetA1" datasource="#dsn#">
	SELECT A.SCode, A.SubjName, C0.Title, ((D.Mark / C0.OutOf) * 100) AS Mark, (
    SELECT Top 1 Grade 
    FROM StudYearGrade G 
    WHERE G.TermYear = #year# 
	AND G.Term = #term#
	AND G.StudYear = '#getList.AcYear[i]#'
	AND G.MinPercent <= ((D.Mark / C0.OutOf) * 100)
	ORDER BY MinPercent DESC) AS Grade
	FROM vARSubjAcads A
    LEFT JOIN ARAssCol C0 ON C0.ARSID = A.ARSID AND C0.Lvl = 0 AND C0.ColHeading = 'A3'
    LEFT JOIN ARAssColData D ON D.ARAssColID = C0.ARAssColID AND D.AcadID = A.AcadID
	WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.SCode = '#SCode#'
</cfquery>

<cfquery name="getDetA2" datasource="#dsn#">
	SELECT A.SCode, A.SubjName, C0.Title, ((D.Mark / C0.OutOf) * 100) AS Mark, (
    SELECT Top 1 Grade 
    FROM StudYearGrade G 
    WHERE G.TermYear = #year# 
	AND G.Term = #term#
	AND G.StudYear = '#getList.AcYear[i]#'
	AND G.MinPercent <= ((D.Mark / C0.OutOf) * 100)
	ORDER BY MinPercent DESC) AS Grade
	FROM vARSubjAcads A
    LEFT JOIN ARAssCol C0 ON C0.ARSID = A.ARSID AND C0.Lvl = 0 AND C0.ColHeading = 'A4'
    LEFT JOIN ARAssColData D ON D.ARAssColID = C0.ARAssColID AND D.AcadID = A.AcadID
	WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.SCode = '#SCode#'
</cfquery>

<cfif SCode NEQ getSubj.SCode[CurrentRow-1]>
<tr align="center" class="txtRep9">
<td style="padding:2px;" class="bleft bright bbottom">#SubjName#</td>
<td class="bright bbottom"><cfif getDetA1.Mark NEQ "">#getDetA1.Grade#</cfif></td>
<td class="bright bbottom"><cfif getDetA1.Mark NEQ "">#NumberFormat(getDetA1.Mark)#</cfif></td>
<td class="bright bbottom"><cfif getDetA2.Mark NEQ "">#getDetA2.Grade#</cfif></td>
<td class="bright bbottom"><cfif getDetA2.Mark NEQ "">#NumberFormat(getDetA2.Mark)#</cfif></td>
<td class="bright bbottom" style="padding:2px;">#ucFirst(T1Title, true, true)#<cfif T1Title NEQ "">.</cfif> #LEFT(T1FName, 1)# #ucFirst(T1LName, true, true)#</td>
</tr>
</cfif>
</cfloop>
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
<td width="33%" valign="bottom">Page 1</td>
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
<InvalidTag http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Report Card</title>
<link rel="stylesheet" href="<cfoutput>#varSiteHome#</cfoutput>css/stylesheet.css" type="text/css">
<style type="text/css">
.txtRep20, .txtRep20Bold, .txtRep16, .txtRep16Bold, .txtRep14, .txtRep14Bold, .txtRep12, .txtRep12Bold, .txtRep11, 
.txtRep11Bold, .txtRep10, .txtRep10Bold, .txtRep9, .txtRep9Bold, .txtRep8, .txtRep8Bold, .txtRep7, .txtRep7Bold{
font-family:Arial !important;
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
<InvalidTag http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Report Card</title>
<link rel="stylesheet" href="<cfoutput>#varSiteHome#</cfoutput>css/stylesheet.css" type="text/css">
<style type="text/css">
.txtRep20, .txtRep20Bold, .txtRep16, .txtRep16Bold, .txtRep14, .txtRep14Bold, .txtRep12, .txtRep12Bold, .txtRep11, 
.txtRep11Bold, .txtRep10, .txtRep10Bold, .txtRep9, .txtRep9Bold, .txtRep8, .txtRep8Bold, .txtRep7, .txtRep7Bold{
font-family:Arial !important;
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