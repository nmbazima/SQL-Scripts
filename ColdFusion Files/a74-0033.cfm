<cfset varSiteHome = ""><cfif structKeyExists(SESSION, "SiteHome")><cfset varSiteHome = SESSION.SiteHome><cfif NOT FindNoCase("https", varSiteHome)><cfset varSiteHome = ReplaceNoCase(varSiteHome, "http", "https")></cfif></cfif><cfset varSiteHome = ""><cfif structKeyExists(SESSION, "SiteHome")><cfset varSiteHome = SESSION.SiteHome><cfif NOT FindNoCase("https", varSiteHome)><cfset varSiteHome = ReplaceNoCase(varSiteHome, "http", "https")></cfif></cfif><cfset varSiteHome = ""><cfif structKeyExists(SESSION, "SiteHome")><cfset varSiteHome = SESSION.SiteHome><cfif NOT FindNoCase("https", varSiteHome)><cfset varSiteHome = ReplaceNoCase(varSiteHome, "http", "https")></cfif></cfif><html>
<cfinclude template="/assessment/reportsec.cfm">

<cfparam name="ARSID" default="0">
<cfparam name="RecNo" default="0">
<cfparam name="term" default="0">
<cfparam name="year" default="#Year(Now())#">
<cfparam name="AsPDF" default="0">
<cfparam name="ReportFileName" default="">

<cfquery name="getList" datasource="#dsn#">
	SELECT A.AcadID, A.StudID, A.LastName, A.FirstName, A.MiddleName, A.TermYear, A.Term, A.AcYear, A.BirthDate, A.Age, A.PassNo, A.Photo,
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

<cfsavecontent variable="myReport">
<cfoutput>
<cfloop index="i" from="1" to="#getList.RecordCount#">
<cfset RecNo = getList.StudID[i]>



<cfquery name="getStudent" datasource="#dsn#">
    SELECT R.LeftDate
    From Students A
        LEFT JOIN Registration R ON R.StudentID = A.StudentID
    WHERE A.StudentID = #RecNo#
</cfquery>

<cfquery name="getLBM" datasource="#dsn#">
	SELECT L.*, T.TypeName, S.Title, S.FirstName, S.LastName, C.Category, C.CategoryType, S.SignFile, S.StaffID
	FROM BHMLogs AS L 
	 INNER JOIN TermDates D ON D.StartDate <= L.LogDate AND D.EndDate >= L.LogDate 
	 INNER JOIN BHMTypes T ON T.TypeID = L.TypeID 
	 INNER JOIN BHMCategory C ON C.CategoryID = T.CategoryID
	 LEFT JOIN Staff S ON S.StaffID = L.RepBy
	WHERE D.TermYear = #year# 
	 AND D.Term = #term# 
	 AND L.StudentID = #RecNo#
	 AND C.CategoryType = 'Reward' 
	 AND T.TypeName = 'General Certificate (A5)'
	 AND L.Status = 'Awarded'
	 ORDER BY L.LogDate
</cfquery>



<cfloop query="getLBM">
<cfif currentRow GT 1><div class="pagebreak"></div></cfif>
<table cellpadding="0" cellspacing="0" align="center" style="width:28cm;height:19cm;">

<tr style="vertical-align:top;">
<td>
<table cellpadding="0" cellspacing="0" align="center" style="width:100%">


    <tr><td align="center" style="font:normal 36pt 'Edwardian Script ITC';padding-top:8.2cm;">#getList.FirstName[i]# #getList.MiddleName[i]# #getList.LastName[i]#</td></tr>
	<tr><td align="center" style="font:normal 28pt 'Georgia';padding-top:2.2cm;padding-bottom:0.8cm;">#Reason#</td></tr>
	

	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%">
		<tr>
			<td align="center" style="font:normal 16pt 'Georgia';padding-top:0.3cm;width:34%;">#DateFormat(getStudent.LeftDate,'D MMMM YYYY')#</td>
			<td align="center" style="width:32%;"><cfif getCF.SignFile NEQ "" AND fileService.checkFileExist(fileDir  = "/keydoc/signatures/#getCF.StaffID#", filename = "#getCF.SignFile#")>
				<img src="#fileService.getFile(fileDir = "/keydoc/signatures/#getCF.StaffID#", filename = "#getCF.SignFile#", includeHTTP = "https:")#" style="height:90px;" /></cfif></td>
			<td style="width:34%;"></td>
		</tr>
	</table>
	</td>
	</tr>

</table>
</td>
</tr>
</table>
</cfloop>



<cfif i NEQ getList.RecordCount><div class="pagebreak"></div></cfif>
<br class="noprint" />
</cfloop> <!--- Students --->
</cfoutput>
</cfsavecontent>


<cfif AsPDF EQ 0>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Report Card</title>
<link rel="stylesheet" href="<cfoutput>#varSiteHome#</cfoutput>css/stylesheet.css" type="text/css">
<style type="text/css">

.txtRep8, .txtRep8Bold, .txtRep9, .txtRep9Bold, .txtRep10, .txtRep10Bold, .txtRep11, .txtRep11Bold, .txtRep12, .txtRep13, .txtRep13Bold, .txtRep12Bold, .txtRep14, .txtRep14Bold, 
.txtRep16, .txtRep16Bold, .txtRep18, .txtRep18Bold, .txtRep20, .txtRep20Bold, .txtRep22, .txtRep22Bold, .txtRep24, .txtRep24Bold, .txtRep26, .txtRep26Bold, 
.txtRep28, .txtRep28Bold {font-family:Calibri !important;}

.watermark{
background-image: url("https://s3-eu-west-1.amazonaws.com/client-z5n97j6prh/Public%20folder/Alumni_Certificate_2024.png");
background-repeat: no-repeat;
background-position: center;
background-size: 20cm 10cm;
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

<cfdocument format="PDF" pagetype="a4" orientation="landscape" scale="100" unit="cm" marginbottom="0.7" margintop="0.3" marginleft="0.7" marginright="0.7" localurl="yes" fontembed="yes" fontdirectory="/superfonts/" name="MyPDFFile">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Report Card</title>
<link rel="stylesheet" href="<cfoutput>#varSiteHome#</cfoutput>css/stylesheet.css" type="text/css">
<style type="text/css">
.txtRep8, .txtRep8Bold, .txtRep9, .txtRep9Bold, .txtRep10, .txtRep10Bold, .txtRep11, .txtRep11Bold, .txtRep12, .txtRep13, .txtRep13Bold, .txtRep12Bold, .txtRep14, .txtRep14Bold, 
.txtRep16, .txtRep16Bold, .txtRep18, .txtRep18Bold, .txtRep20, .txtRep20Bold, .txtRep22, .txtRep22Bold, .txtRep24, .txtRep24Bold, .txtRep26, .txtRep26Bold, 
.txtRep28, .txtRep28Bold {font-family:Calibri !important;}

.watermark{
background-image: url("https://s3-eu-west-1.amazonaws.com/client-z5n97j6prh/Public%20folder/Certificate_V1_2024.docx-1.png");
background-repeat: no-repeat;
background-position: center;
background-size: 28cm 19cm;
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