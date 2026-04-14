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
	ORDER BY FirstName, LastName
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


<cfquery name="getLBM" datasource="#dsn#">
	SELECT L.Reason, L.LogDate, L.CreatedBy, T.TypeName, S.Title, S.FirstName, S.LastName, C.Category, C.CategoryType, S.SignFile, S.StaffID
	FROM BHMLogs AS L 
		INNER JOIN TermDates D ON D.StartDate <= L.LogDate AND D.EndDate >= L.LogDate 
		INNER JOIN BHMTypes T ON T.TypeID = L.TypeID 
		INNER JOIN BHMCategory C ON C.CategoryID = T.CategoryID
		LEFT JOIN Staff S ON S.StaffID = L.RepBy
	WHERE D.TermYear = #year# AND D.Term = #term# AND L.StudentID = #RecNo# AND C.CategoryType = 'Reward' AND C.Category = 'SKALP Certificates' AND T.TypeName = 'Most Outstanding Academic Award' AND L.Status = 'Awarded'
	ORDER BY L.LogDate
</cfquery>


<cfloop query="getLBM">
<cfif CurrentRow GT 1><div class="pagebreak"></div><div style="height:0.2cm;"></div></cfif>

<table cellpadding="0" cellspacing="0" align="center" style="width:28cm;height:20cm;padding-top:20px;" class="watermark">

<tr style="vertical-align:top;">
<td>
<table cellpadding="0" cellspacing="0" align="center" style="width:100%">

	<tr><td align="center" style="font:normal 36pt 'Georgia';color:##C00000;padding-top:3.7cm;"><b>Most Outstanding Academic Award</b></td></tr>
    <tr><td align="center" style="font:normal 12pt 'Arial';color:##C09100;padding-top:0.9cm;"><b>IS PRESENTED TO</b></td></tr>
    <tr><td align="center" style="font:normal 32pt 'Georgia';color:##818285;padding-top:0.7cm;"><b>#UCASE(getList.FirstName[i])# #UCASE(getList.MiddleName[i])# #UCASE(getList.LastName[i])#</b></td></tr>
	<tr><td align="center" style="font:normal 12pt 'Arial';color:##C09100;padding-top:0.8cm;"><b>FOR</b></td></tr>
	<tr><td align="center" style="font:normal 18pt 'Georgia';color:##818285;padding:20px 35px 0px 35px;height:160px;"><b>#Reason# in <span style="font:normal 22pt 'Georgia';"><b>#Replace(Replace(Replace(getList.AcYear[i],'_SKALP',''),'Yr','Year '),'_KAL','')#</b> in <span style="font:normal 22pt 'Georgia';"><b>#year#</b></span></b></td></tr>
	

	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%">
		
		<tr>
			<td style="width:33%;color:##818285;font:normal 12pt 'Arial';padding:63px 0px 0px 47px;" align="left"><b>#DateFormat(getCF.Date1,'D MMMM YYYY')#</b></td>
			<td style="width:34%;color:##C09100;font:normal 12pt 'Arial';padding:10px 0px 0px 0px;" align="center"><b>CLASS TEACHER<br />#Title#. #LEFT(FirstName, 1)# #LastName#</b></td>
			<td style="width:33%;color:##C09100;font:normal 12pt 'Arial';padding:10px 0px 0px 0px;" align="center"><b>Head Teacher<br />#getCF.Title#. #LEFT(getCF.FirstName, 1)# #getCF.LastName#</b></td>
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
background-image: url("https://s3-eu-west-1.amazonaws.com/client-z5n97j6prh/Public%20folder/SKALP_AwardsBackground.png");
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

<cfdocument format="PDF" pagetype="a4" orientation="landscape" scale="100" unit="cm" marginbottom="0" margintop="0" marginleft="0" marginright="0" localurl="yes" fontembed="yes" fontdirectory="/superfonts/" name="MyPDFFile">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Report Card</title>
<link rel="stylesheet" href="<cfoutput>#varSiteHome#</cfoutput>css/stylesheet.css" type="text/css">
<style type="text/css">
.txtRep8, .txtRep8Bold, .txtRep9, .txtRep9Bold, .txtRep10, .txtRep10Bold, .txtRep11, .txtRep11Bold, .txtRep12, .txtRep13, .txtRep13Bold, .txtRep12Bold, .txtRep14, .txtRep14Bold, 
.txtRep16, .txtRep16Bold, .txtRep18, .txtRep18Bold, .txtRep20, .txtRep20Bold, .txtRep22, .txtRep22Bold, .txtRep24, .txtRep24Bold, .txtRep26, .txtRep26Bold, 
.txtRep28, .txtRep28Bold {font-family:Calibri !important;}

.watermark{
background-image: url("https://s3-eu-west-1.amazonaws.com/client-z5n97j6prh/Public%20folder/SKALP_AwardsBackground.png");
background-repeat: no-repeat;
background-position: center;
background-size: 28cm 19.5cm;
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