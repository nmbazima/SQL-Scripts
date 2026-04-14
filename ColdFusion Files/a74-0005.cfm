<cfset varSiteHome = ""><cfif structKeyExists(SESSION, "SiteHome")><cfset varSiteHome = SESSION.SiteHome><cfif NOT FindNoCase("https", varSiteHome)><cfset varSiteHome = ReplaceNoCase(varSiteHome, "http", "https")></cfif></cfif><cfset varSiteHome = ""><cfif structKeyExists(SESSION, "SiteHome")><cfset varSiteHome = SESSION.SiteHome><cfif NOT FindNoCase("https", varSiteHome)><cfset varSiteHome = ReplaceNoCase(varSiteHome, "http", "https")></cfif></cfif><cfset varSiteHome = ""><cfif structKeyExists(SESSION, "SiteHome")><cfset varSiteHome = SESSION.SiteHome><cfif NOT FindNoCase("https", varSiteHome)><cfset varSiteHome = ReplaceNoCase(varSiteHome, "http", "https")></cfif></cfif><html>
<cfinclude template="/assessment/reportsec.cfm">

<cfparam name="ARSID" default="0">
<cfparam name="RecNo" default="0">
<cfparam name="term" default="0">
<cfparam name="year" default="#Year(Now())#">
<cfparam name="AsPDF" default="0">
<cfparam name="ReportFileName" default="">



<cfquery name="getList" datasource="#dsn#">
	SELECT A.AcadID, A.StudID, A.LastName, A.FirstName, A.TermYear, A.Term, A.AcYear, A.BirthDate, A.Age, A.PassNo, A.Photo,
		C.Class, T.FirstName AS TFName, T.LastName AS TLName, T.Title, T.TeacherID, T.T1SignFile
	FROM vARSubjAcads A
		LEFT JOIN TTClassStud C ON C.TermYear = A.TermYear AND C.Term = A.Term
			AND C.AcYear = A.AcYear AND C.StudID = A.StudID
		LEFT JOIN vTTClasses T ON T.Class = C.Class AND T.ClYear = C.TermYear AND T.ClTerm = C.Term
	WHERE ARSID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#ARSID#">
    <cfif RecNo NEQ 0>AND A.StudID = <cfqueryparam cfsqltype="cf_sql_integer" value="#RecNo#"></cfif>
	ORDER BY LastName, FirstName
</cfquery>

<cfquery name="getCF" datasource="#dsn#">
	SELECT S.StaffID, S.Title, S.FirstName, S.LastName, S.SignFile, S.Position, T.RepData, T.RepData2, T.RepData3, T.Date1
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

<cfquery name="getOpt" datasource="#dsn#">
	SELECT A.SetName, B.OptCode, B.OptDescript, B.OptDefinition, OptName, B.Seq, B.MinPercent, B.MaxPercent
	FROM SSTSet A
	LEFT JOIN SSTSetOption B ON B.SetID = A.SetID
	WHERE A.SetName = 'Pre-Primary'
	ORDER BY B.Seq ASC
</cfquery>

<cfquery name="getAAge" datasource="#dsn#">   
	SELECT AVG(DateDiff("y", A.BirthDate, getDate())) As AvgYear, AVG(DateDiff("m", A.BirthDate, getDate())) As AvgMonth
    FROM vARSubjAcads A
	WHERE A.AcYear = N'#getList.AcYear#' AND A.TermYear = #year# AND A.Term = #term#
</cfquery>
<cfset AvgYR = NumberFormat(Left((#getAAge.AvgYear# / 365),2)) >    
<cfset AvgMT = NumberFormat(#getAAge.AvgMonth# MOD 12) >

<cfsavecontent variable="myReport">
<cfoutput>
<cfloop index="i" from="1" to="#getList.RecordCount#">
<cfset RecNo = getList.StudID[i]>




<table cellpadding="0" cellspacing="0" align="center" style="width:18.7cm;height:27.5cm;">
<tr style="vertical-align:top;">
<td>
<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
	

	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
		<tr style="vertical-align:top;">
			<td align="left" class="txtRep9" style="width:55%;">#getCF.RepData#</td>
			<td align="right" style="width:45%;"><img src="#fileService.getFile(fileDir = "/keydoc/assessment", filename = "Sentinel_Kalumbila.png", includeHTTP = "https:")#" style="height:2.1cm;"></td>
		</tr>
	</table>
	</td>
	</tr>

	<tr><td style="height:10px;"></td></tr>
	<tr><td align="left" class="txtRep16Bold">END OF TERM REPORT: #UCASE(DateFormat(getTerm.EndDate,' MMMM YYYY'))#</td></tr>
	<tr><td style="height:10px;"></td></tr>

	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
		<tr>
			<td align="left" class="txtRep16">Student: <b>#getList.FirstName[i]# #getList.LastName[i]#</b></td>
			<td align="right" class="txtRep14">Class: <b>#Replace(getList.AcYear[i],'_KAL','')#</b></td>
		</tr>
	</table>
	</td>
	</tr>

	<tr><td style="height:10px;"></td></tr>

	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
		<tr>
			<td class="ball txtRep11" align="center" style="padding:3px;width:33%;"><b>Child’s Age:</b> #Replace(Replace(getList.Age[i],'-0','.'),'-','.')#</td>
			<td class="btop bbottom bright txtRep11" align="center" style="padding:3px;width:33%;"><b>Average Age:</b> #AvgYR#.#AvgMT#</td>
			<td class="btop bbottom bright txtRep11" align="center" style="padding:3px;width:33%;"><b>Date:</b> #DateFormat(getTerm.EndDate,'dd.mm.yyyy')#</td>
		</tr>
	</table>
	</td>
	</tr>

	<tr><td style="height:10px;"></td></tr>

	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
		<tr><td class="ball txtRep11Bold" colspan="2" style="background-color:##D2D2D2;padding:3px 5px;">Descriptor</td></tr>
		<cfloop query="getOpt">
			<tr>
				<td class="bleft bbottom bright txtRep11Bold" align="center" style="width:20%;">#OptName#</td>
				<td class="bbottom bright txtRep11" align="left" style="width:80%;padding:3px 5px;">#OptDefinition#</td>
			</tr>
		</cfloop>
	</table>
	</td>
	</tr>

	<cfquery name="getSubj" datasource="#dsn#">
		SELECT A.SCode, A.SubjName, A.Page, A.Mark, A.Grade, A.T1Title, A.T1FName, A.T1LName, SS.Comment, G.Grade AS AssessmentGrade
		FROM vARSubjAcads A
			LEFT JOIN ARCommSetup CS ON CS.TermYear = A.TermYear AND CS.Term = A.Term AND CS.StudYear = A.AcYear AND CS.Type = 2 AND CS.Reference = 'A'
			LEFT JOIN ARAcadComm SS ON SS.CommSetupID = CS.CommSetupID AND SS.AcadID = A.AcadID

			LEFT JOIN ARRepSetup S ON S.SSID = A.SSID
			LEFT JOIN ARAcad6Grade G ON G.ARRepSetupID = S.ARRepSetupID AND G.AcadID = A.AcadID
		WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.RepCard = 0 AND A.SType <> 'R' AND A.Page > 0
        ORDER BY A.Seq
	</cfquery>

	<tr><td style="height:20px;"></td></tr>

	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
		<tr>
			<td style="width:33%;"></td>
			<td style="width:34%;"></td>
			<td style="width:33%;"></td>
		</tr>
		<cfloop query="getSubj">
			<tr>
				<td class="bleft btop bbottom txtRep11Bold" colspan="2" style="color:##FFFFFF;background-color:##C00000;padding:1px 5px;">#SubjName#</td>
				<td class="btop bottom bright txtRep11Bold" style="color:##FFFFFF;background-color:##C00000;padding:1px 5px;">#T1Title# #LEFT(T1FName, 1)# #T1LName#</td>
			</tr>
			<tr><cfloop query="getOpt"><td class="<cfif CurrentRow EQ 1>bleft</cfif> bbottom bright txtRep11" align="left" style="padding:1px 0px 1px 80px;">#OptName# <cfif OptCode EQ AssessmentGrade><img src="#fileService.getFile(fileDir = "/keydoc/assessment", filename = "tick.png", includeHTTP = "https:")#" style="height:12pt;float:right;padding-right:50px;"></cfif></td></cfloop></tr>
			<tr><td style="height:10px;"></td></tr>
		</cfloop>
	</table>
	</td>
	</tr>

	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
		<cfquery name="getComms" datasource="#dsn#">
			SELECT C.HeadingRep, S.Comment, C.TextType
			FROM ARCommSetup C
				LEFT JOIN ARCommStudent S ON S.CommSetupID = C.CommSetupID AND S.StudentID = #RecNo#
			WHERE C.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#year#">
				AND C.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#term#">
				AND C.StudYear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getList.AcYear#">
				AND C.Reference IN ('B') AND C.Type = 1
			ORDER BY C.Seq
		</cfquery>
		<tr>
			<td style="width:33%;"></td>
			<td style="width:34%;"></td>
			<td style="width:33%;"></td>
		</tr>
		<tr>
			<td class="bleft btop bbottom txtRep11Bold" colspan="2" style="color:##FFFFFF;background-color:##C00000;padding:1px 5px;">#getComms.HeadingRep#</td>
			<td class="btop bottom bright txtRep11Bold" style="color:##FFFFFF;background-color:##C00000;padding:1px 5px;">#getList.Title# #LEFT(getList.TFName[i], 1)# #getList.TLName[i]#</td>
		</tr>
		<tr><td colspan="3" style="height:50px;vertical-align:top;padding:1px 5px;" class="bleft bbottom bright txtRep11">#Replace(getComms.Comment, Chr(13), "<br />", "All")# </td></tr>
		<tr><td style="height:10px;"></td></tr>
	</table>
	</td>
	</tr>


	<tr><td align="left" style="height:45px;"><cfif getCF.SignFile NEQ "" AND fileService.checkFileExist(fileDir  = "/keydoc/signatures/#getCF.StaffID#", filename = "#getCF.SignFile#")>
		<img src="#fileService.getFile(fileDir = "/keydoc/signatures/#getCF.StaffID#", filename = "#getCF.SignFile#", includeHTTP = "https:")#" style="height:45px;" /></cfif></td></tr>
	<tr><td align="left" class="txtRep11Bold">#getCF.Title# #LEFT(getCF.FirstName, 1)# #getCF.LastName#</td></tr>


</table>
</td>
</tr>





<tr style="vertical-align:bottom;">
<td>
<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
	<tr>
		<td style="width:60%" align="right"><img src="#fileService.getFile(fileDir = "/keydoc/assessment", filename = "EducoreServices.png", includeHTTP = "https:")#" style="height:1.6cm;"></td>
		<td style="width:40%;vertical-align:top;padding-left:30px;" align="left" class="txtRep9">#getCF.RepData2#</td>
	</tr>
</table>
</td>
</tr>


</table>








<cfif i NEQ getList.RecordCount><div class="pagebreak"></div></cfif>
<br class="noprint" />
</cfloop> <!--- Students --->
</cfoutput>
</cfsavecontent>


<cfif AsPDF EQ 0>

<head>
<invalidTag http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Report Card</title>
<link rel="stylesheet" href="<cfoutput>#varSiteHome#</cfoutput>css/stylesheet.css" type="text/css">
<style type="text/css">

.txtRep8, .txtRep8Bold, .txtRep9, .txtRep9Bold, .txtRep10, .txtRep10Bold, .txtRep11, .txtRep11Bold, .txtRep12, .txtRep13, .txtRep13Bold, .txtRep12Bold, .txtRep14, .txtRep14Bold, 
.txtRep16, .txtRep16Bold, .txtRep18, .txtRep18Bold, .txtRep20, .txtRep20Bold, .txtRep22, .txtRep22Bold, .txtRep24, .txtRep24Bold, .txtRep26, .txtRep26Bold, 
.txtRep28, .txtRep28Bold {font-family:Arial !important;}

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

<cfdocument format="PDF" pagetype="a4" orientation="portrait" scale="100" unit="cm" marginbottom="0" margintop="1" marginleft="1" marginright="1" localurl="yes" fontembed="yes" fontdirectory="/superfonts/" name="MyPDFFile">

<head>
<invalidTag http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Report Card</title>
<link rel="stylesheet" href="<cfoutput>#varSiteHome#</cfoutput>css/stylesheet.css" type="text/css">
<style type="text/css">
.txtRep8, .txtRep8Bold, .txtRep9, .txtRep9Bold, .txtRep10, .txtRep10Bold, .txtRep11, .txtRep11Bold, .txtRep12, .txtRep13, .txtRep13Bold, .txtRep12Bold, .txtRep14, .txtRep14Bold, 
.txtRep16, .txtRep16Bold, .txtRep18, .txtRep18Bold, .txtRep20, .txtRep20Bold, .txtRep22, .txtRep22Bold, .txtRep24, .txtRep24Bold, .txtRep26, .txtRep26Bold, 
.txtRep28, .txtRep28Bold {font-family:Arial !important;}

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