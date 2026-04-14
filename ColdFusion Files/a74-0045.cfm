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


<cfquery name="getStudAtt" datasource="#dsn#">
	SELECT SUM(Absent) AS Absent, SUM(Late) AS Late, SUM(Present) AS Present
	FROM vATDStudAttTerm
	WHERE StudentID = #RecNo# AND TermYear = #year# AND Term = #term#
</cfquery>

<cfset color = "##9f1f63">

<table cellpadding="0" cellspacing="0" align="center" style="width:18.7cm;height:28cm;">
<tr style="vertical-align:top;">
<td>
<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">

<tr>
<td>
<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
<tr style="vertical-align:top;">
<td width="52%">
<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
<tr align="left">
<td style="font:normal 22pt 'Arial';">End of Term Report</td>
</tr>
<tr align="left">
<td style="font:normal 20pt 'Arial';">Term #term#, #year#</td>
</tr>

<tr>
<td style="height:45px;"></td>
</tr>

<tr align="left" class="txtRep14Bold">
<td style="padding:3px 5px;background-color:##d3d3d3;" class="ball">#getList.FirstName[i]# #getList.LastName[i]#</td>
</tr>
</table>
</td>
<td align="center" width="48%"><img src="#fileService.getFile(fileDir = "/keydoc/images", filename = "Little_Ants_Logo.png", includeHTTP = "https:")#" style="height:4.5cm;"></td>
</tr>
</table>
</td>
</tr>

<tr><td style="height:5px;"></td></tr>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="center" class="txtRep11">
<td width="33%" class="ball" style="padding:3px;"><b>Child’s Age:</b> #Replace(Replace(getList.Age[i],'-0','.'),'-','.')#</td>
<td width="34%" class="btop bbottom bright" style="padding:3px;"><b>Average Age:</b> #AvgYR#.#AvgMT#</td>
<td width="33%" class="btop bbottom bright" style="padding:3px;"><b>Days Present:</b> #NumberFormat(getStudAtt.Present)#</td>
</tr>
</table>
</td>
</tr>

<tr><td style="height:20px;"></td></tr>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
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

<tr><td style="height:20px;"></td></tr>

<cfquery name="getSubj" datasource="#dsn#">
	SELECT A.SCode, A.SubjName, A.Page, A.Mark, A.Grade, A.T1Title, A.T1FName, A.T1LName, SS.Comment
	FROM vARSubjAcads A
	LEFT JOIN ARCommSetup CS ON CS.TermYear = A.TermYear AND CS.Term = A.Term AND CS.StudYear = A.AcYear AND CS.Type = 2 AND CS.Reference = 'A'
	LEFT JOIN ARAcadComm SS ON SS.CommSetupID = CS.CommSetupID AND SS.AcadID = A.AcadID
	WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.RepCard = 0 AND A.SType <> 'R'
	ORDER BY A.Seq
</cfquery>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">

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
<cfset tData['Comment'] = Comment>
<cfset tData['CurrentRow'] = CurrentRow>
<cfset tData['T1Title'] = T1Title>
<cfset tData['T1FName'] = T1FName>
<cfset tData['T1LName'] = T1LName>
<cfset tData['RecordCount'] = RecordCount>

<cfthread name="#tName#" action="run" tData="#tData#" dsn="#dsn#">

<cfset THREAD.SubjName = ATTRIBUTES.tData.SubjName>
<cfset THREAD.SCode = ATTRIBUTES.tData.SCode>
<cfset THREAD.Comment = ATTRIBUTES.tData.Comment>
<cfset THREAD.CurrentRow = ATTRIBUTES.tData.CurrentRow>
<cfset THREAD.T1Title = ATTRIBUTES.tData.T1Title>
<cfset THREAD.T1FName = ATTRIBUTES.tData.T1FName>
<cfset THREAD.T1LName = ATTRIBUTES.tData.T1LName>
<cfset THREAD.RecordCount = ATTRIBUTES.tData.RecordCount>

<cfquery name="THREAD.getDet" datasource="#ATTRIBUTES.dsn#">
	SELECT A.SCode, A.SubjName, S.GroupName, S.Description, G.Grade
	FROM vARSubjAcads A
    LEFT JOIN ARRepSetup S ON S.SSID = A.SSID
    LEFT JOIN ARAcad6Grade G ON G.ARRepSetupID = S.ARRepSetupID AND G.AcadID = A.AcadID
	WHERE A.TermYear = #ATTRIBUTES.tData.year# AND A.Term = #ATTRIBUTES.tData.term# AND A.StudID = #ATTRIBUTES.tData.RecNo# AND A.SCode = '#ATTRIBUTES.tData.SCode#'
	ORDER BY S.Seq
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
<tr align="left" class="txtRep11Bold" style="background-color:##9F1F63;color:##FFFFFF;">
<td colspan="2" style="padding:2px 5px;" class="bleft btop bbottom"><b>#threadResult.SubjName#</b></td>
<td class="btop bright bbottom" style="padding:2px 5px;" align="center">#ucFirst(threadResult.T1Title, true, true)#<cfif threadResult.T1Title NEQ "">.</cfif> #LEFT(threadResult.T1FName, 1)# #ucFirst(threadResult.T1LName, true, true)#</td>
</tr>

<cfloop query="threadResult.getDet">
<tr align="center" class="txtRep11">
<cfloop query="getOpt"><td class="<cfif CurrentRow EQ 1>bleft </cfif>bright bbottom" style="padding:2px 0px;"><cfif Grade EQ OptCode><img src="#fileService.getFile(fileDir = "/keydoc/images", filename = "tick_black.png", includeHTTP = "https:")#" style="height:12px;position:relative;top:2px;">&nbsp;&nbsp;</cfif>#OptName#</td></cfloop>
</tr>
</cfloop>

<cfif threadResult.Comment NEQ "">
<tr align="left" class="txtRep10" valign="top">
<td colspan="3" class="bleft bright bbottom" style="padding:2px 5px;height:20px;">#Replace(threadResult.Comment, Chr(13), "<br />", "All")#&nbsp;</td>
</tr>
</cfif>
</cfif>

<cfif threadResult.SCode NEQ getSubj.SCode[threadResult.CurrentRow+1]>
<tr>
<td width="33%" style="height:20px;"></td>
<td width="34%"></td>
<td width="33%"></td>
</tr>
</cfif>
</table>
</td>
</tr>
</cfif>
</cfloop>
</cfif>
</table>
</td>
</tr>

<cfquery name="getComms1" datasource="#dsn#">
    SELECT C.Seq, C.HeadingRep, C.Heading, S.Comment, C.CommPerson
    FROM ARCommSetup C
    LEFT JOIN ARCommStudent S ON S.CommSetupID = C.CommSetupID AND S.StudentID = #RecNo#
    WHERE C.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#year#">
    AND C.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#term#">
    AND C.StudYear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getList.AcYear#">
    AND C.Reference = 'C' AND C.Type = 1
    ORDER BY C.Seq
</cfquery>

<cfquery name="getComms2" datasource="#dsn#">
    SELECT C.Seq, C.HeadingRep, C.Heading, S.Comment, C.CommPerson
    FROM ARCommSetup C
    LEFT JOIN ARCommStudent S ON S.CommSetupID = C.CommSetupID AND S.StudentID = #RecNo#
    WHERE C.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#year#">
    AND C.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#term#">
    AND C.StudYear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getList.AcYear#">
    AND C.Reference = 'B' AND C.Type = 1
    ORDER BY C.Seq
</cfquery>

<cfif getComms1.Comment NEQ "">
<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center" class="print-friendly">
<tr align="left" class="txtRep11Bold" style="background-color:##9F1F63;color:##FFFFFF;">
<td width="67%" style="padding:2px 5px;" class="bleft btop bbottom"><b>#getComms1.HeadingRep#</b></td>
<td width="33%" class="btop bright bbottom" style="padding:2px 0px;" align="center">#ucFirst(getList.Title, true, true)#<cfif getList.Title NEQ "">.</cfif> #LEFT(getList.TFName, 1)# #ucFirst(getList.TLName, true, true)#</td>
</tr>
<tr align="left" class="txtRep10" valign="top">
<td colspan="2" class="bleft bright bbottom" style="padding:2px 5px;height:20px;">#Replace(getComms1.Comment, Chr(13), "<br />", "All")#&nbsp;</td>
</tr>
<tr>
<td colspan="2" style="height:20px;"></td>
</tr>
</table>
</td>
</tr>
</cfif>

<cfif getComms2.Comment NEQ "">
<tr>
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center" class="print-friendly">
<tr align="left" class="txtRep11Bold" style="background-color:##9F1F63;color:##FFFFFF;">
<td width="67%" style="padding:2px 5px;" class="bleft btop bbottom"><b>#getComms2.HeadingRep#</b></td>
<td width="33%" class="btop bright bbottom" style="padding:2px 0px;" align="center">#ucFirst(getCF.Title, true, true)#<cfif getCF.Title NEQ "">.</cfif> #LEFT(getCF.FirstName, 1)# #ucFirst(getCF.LastName, true, true)#</td>
</tr>
<tr align="left" class="txtRep10" valign="top">
<td colspan="2" class="bleft bright bbottom" style="padding:2px 5px;height:20px;">#Replace(getComms2.Comment, Chr(13), "<br />", "All")#&nbsp;</td>
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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Report Card</title>
<link rel="stylesheet" href="<cfoutput>#varSiteHome#</cfoutput>css/stylesheet.css" type="text/css">
<style type="text/css">
.txtRep8, .txtRep8Bold, .txtRep9, .txtRep9Bold, .txtRep10, .txtRep10Bold, .txtRep11, .txtRep11Bold, .txtRep12, .txtRep13, .txtRep13Bold, .txtRep12Bold, .txtRep14, .txtRep14Bold, 
.txtRep16, .txtRep16Bold, .txtRep18, .txtRep18Bold, .txtRep20, .txtRep20Bold, .txtRep22, .txtRep22Bold, .txtRep24, .txtRep24Bold, .txtRep26, .txtRep26Bold, 
.txtRep28, .txtRep28Bold {font-family:Arial !important;}

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