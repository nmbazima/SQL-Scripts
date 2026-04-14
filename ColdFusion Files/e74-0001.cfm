<cfset varSiteHome = ""><cfif structKeyExists(SESSION, "SiteHome")><cfset varSiteHome = SESSION.SiteHome><cfif NOT FindNoCase("https", varSiteHome)><cfset varSiteHome = ReplaceNoCase(varSiteHome, "http", "https")></cfif></cfif><cfset varSiteHome = ""><cfif structKeyExists(SESSION, "SiteHome")><cfset varSiteHome = SESSION.SiteHome><cfif NOT FindNoCase("https", varSiteHome)><cfset varSiteHome = ReplaceNoCase(varSiteHome, "http", "https")></cfif></cfif> 
<html>
<cfinclude template="/assessment/reportsec.cfm">

<cfparam name="ARSID" default="0">
<cfparam name="RecNo" default="0">
<cfparam name="term" default="0">
<cfparam name="year" default="#Year(Now())#">
<cfparam name="AsPDF" default="0">
<cfparam name="ReportFileName" default="">
<cfparam name="ActID" default="0">

<cfquery name="getList" datasource="#dsn#">
	SELECT C.TermYear, C.Term, C.ActName, C.ActID, C.ActAbbr, A.StudentID, A.ASID, C.ActSign,
		S.LastName, S.FirstName, S.BirthDate, S.StudYear, S.Class, S.HouseName, C.GroupID, C.ActType, C.ActID, C.ActRepID
	FROM ACMActivity C
		INNER JOIN ACMActivityStud A ON A.ActID = C.ActID
		INNER JOIN vStudentTerm S ON S.StudentID = A.StudentID AND S.TermYear = C.TermYear AND S.Term = C.Term
		LEFT JOIN StudYear Y ON Y.StudYear = S.StudYear
	WHERE A.ActID = #ActID# <cfif RecNo NEQ 0> AND A.StudentID = #RecNo#</cfif>
	ORDER BY Y.Seq, S.Class, S.LastName, S.FirstName
</cfquery>


<cfset term = getList.term>

<cfsavecontent variable="myReport">
<cfoutput>
<cfloop index="i" from="1" to="#getList.RecordCount#">
<cfset RecNo = getList.StudentID[i]>


<cfquery name="getAct" datasource="#dsn#">
	SELECT A.ActName, G.GroupName, T.Category
	FROM ACMActivity A
		INNER JOIN ACMActivityStud N ON N.ActID = A.ActID
		INNER JOIN ACMGroup G ON G.GroupID = A.GroupID
		INNER JOIN ACMCategory T ON T.CategoryID = A.CategoryID
	WHERE A.TermYear = #year# AND A.Term = #term# AND N.StudentID = #RecNo# AND A.ActID = #ActID#
	ORDER BY A.ActName
</cfquery>



<table cellspacing="0" cellpadding="0" align="center" style="width:18.7cm;height:27cm;">
<tr style="vertical-align:top;">
<td>
<table cellspacing="0" cellpadding="0" align="center" style="width:100%;">

	<tr><td align="left" class="txtRep9" colspan="2">#getList.FirstName[i]# #getlist.LastName[i]# | #RecNo#</td></tr>
	<tr><td align="left" class="txtRep9" colspan="2">#DateFormat(Now(),'D MMMM YYYY')# | #DateTimeFormat(Now(),"HH")+2#:#DateTimeFormat(Now(),"NN")#</td></tr>
	<tr><td align="left" class="txtRep9" colspan="2">#getAct.Category#</td></tr>

	<tr>
		<td align="left" class="txtRep9Bold" style="vertical-align:top;width:17%;"><i>Meal Voucher</i></td>
		<td align="left" class="txtRep9Bold" style="vertical-align:top;width:85%;"><img src="#fileService.getFile(fileDir = "/keydoc/images", filename = "EducoreServices_Logotype_Mono.png", includeHTTP = "https:")#" style="height:0.7cm;padding-top:7px;"></td>
	</tr>

</table>
</td>
</tr>
</table>









<cfif i NEQ getList.RecordCount><div class="pagebreak"> </div></cfif>

</cfloop> <!--- Students --->
</cfoutput>
</cfsavecontent>

<cfif AsPDF EQ 0>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Music Report</title>
<link rel="stylesheet" href="<cfoutput>#varSiteHome#</cfoutput>css/stylesheet.css" type="text/css">
<style type="text/css">
.txtRep8, .txtRep8Bold, .txtRep9, .txtRep9Bold, .txtRep10, .txtRep10Bold, .txtRep11, .txtRep11Bold, .txtRep12, .txtRep13, .txtRep13Bold, .txtRep12Bold, .txtRep14, .txtRep14Bold, 
.txtRep16, .txtRep16Bold, .txtRep18, .txtRep18Bold, .txtRep20, .txtRep20Bold, .txtRep22, .txtRep22Bold, .txtRep24, .txtRep24Bold, .txtRep26, .txtRep26Bold, 
.txtRep28, .txtRep28Bold {font-family:Georgia !important;}

</style>
</head>

<body class="txtRepFont">
<div align="right"><img src="<cfoutput>#varSiteHome#</cfoutput>images/print.gif" style="cursor:pointer" onClick="window.print()" class="noprint"></div>
<div align="center"><cfoutput>#myReport#</cfoutput></div>
<div align="right" class="noprint"><input type="button" class="stdButton" value="Close" onClick="window.close()" /></div>
</body>

<cfelse> <!--- ************** PDF ***************** --->

<cfdocument format="PDF" pagetype="a4" orientation="portrait" scale="100" unit="cm" marginbottom="0.5" margintop="1" marginleft="1" marginright="1" localurl="yes" fontembed="yes" fontdirectory="/superfonts/" name="MyPDFFile">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Music Report</title>
<link rel="stylesheet" href="<cfoutput>#varSiteHome#</cfoutput>css/stylesheet.css" type="text/css">
<style type="text/css">
.txtRep8, .txtRep8Bold, .txtRep9, .txtRep9Bold, .txtRep10, .txtRep10Bold, .txtRep11, .txtRep11Bold, .txtRep12, .txtRep13, .txtRep13Bold, .txtRep12Bold, .txtRep14, .txtRep14Bold, 
.txtRep16, .txtRep16Bold, .txtRep18, .txtRep18Bold, .txtRep20, .txtRep20Bold, .txtRep22, .txtRep22Bold, .txtRep24, .txtRep24Bold, .txtRep26, .txtRep26Bold, 
.txtRep28, .txtRep28Bold {font-family:Georgia !important;}

</style>
</head>

<body class="txtRepFont">
<div align="right"><img src="<cfoutput>#varSiteHome#</cfoutput>images/print.gif" style="cursor:pointer" onClick="window.print()" class="noprint"></div>
<cfoutput>#myReport#</cfoutput>
</body>
</cfdocument>
<cfif ReportFileName EQ "">
	<cfheader name="Content-Disposition" value="inline; filename=reportcard.pdf">
	<cfcontent type="application/pdf" variable="#toBinary(MyPDFFile)#" />

</cfif>
</cfif>
</html>