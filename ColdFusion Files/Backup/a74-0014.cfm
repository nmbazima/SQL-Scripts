<html>
<cfinclude template="/assessment/reportsec.cfm">

<cfparam name="ARSID" default="0">
<cfparam name="RecNo" default="0">
<cfparam name="term" default="0">
<cfparam name="year" default="#Year(Now())#">
<cfparam name="AsPDF" default="0">
<cfparam name="ReportFileName" default="">

<cfset MaxTerm = 4>

<cfquery name="getList" datasource="#dsn#">
	SELECT A.StudID, A.LastName, A.FirstName, A.TermYear, A.Term, A.AcYear, A.BirthDate, A.Age, A.Photo, A.AdmNo,
    A.Class, T.FirstName AS TFName, T.LastName AS TLName, T.Title, T.TeacherID, T.T1SignFile, T.T2Title, T.T2FName, T.T2LName, G.Lvl
	FROM vARSubjAcads A
    LEFT JOIN TTClassStud C ON C.TermYear = A.TermYear AND C.Term = A.Term
    AND C.AcYear = A.AcYear AND C.StudID = A.StudID
    LEFT JOIN vTTClasses T ON T.Class = C.Class AND T.ClYear = C.TermYear AND T.ClTerm = C.Term
    LEFT JOIN StudYear G ON G.StudYear = A.AcYear
	WHERE ARSID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#ARSID#">
    <cfif RecNo NEQ 0>AND A.StudID = <cfqueryparam cfsqltype="cf_sql_integer" value="#RecNo#"></cfif>
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

<cfsavecontent variable="myReport">
<cfoutput>
<cfloop index="i" from="1" to="#getList.RecordCount#">
<cfset RecNo = getList.StudID[i]>

<cfquery name="getNTDate" datasource="#dsn#">
    SELECT NT.ExclDate, NT.Explanation ,NT.StudYear, NT.ExamDay, NT.Type
    FROM TermExclDates NT
    WHERE NT.Explanation LIKE 'Mid%' AND NT.StudYear = '#getList.AcYear[i]#'
    ORDER BY NT.ExclDate
</cfquery>

<cfquery name="getAvg" datasource="#dsn#">
    SELECT ROUND(A.WAMark, 0) AS WAMark
    FROM ARAttend A  
    WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo#
</cfquery>

<cfif getNTDate.RecordCount GT 0>
<cfset middate = DateDiff("ww",DateFormat(getNTDate.ExclDate, "yyyymmdd"),DateFormat(Now(), "yyyymmdd"))>
<cfelse>
<cfset middate = 0> 
</cfif>

<cfif getAvg.WAMark GTE 75>
<div style="height:10px;"></div>
<table cellpadding="0" cellspacing="0" style="width:28.5cm;<cfif AsPDF EQ 1>height:20cm;<cfelse>height:100%;</cfif>" align="center" class="watermark2">
<tr>
<td>
<table cellpadding="0" cellspacing="0" style="width:28.5cm;" align="center" class="watermark">
<tr>
<td style="height:0.5cm;"></td>
</tr>
<tr>
<td>
<table cellpadding="0" cellspacing="0" style="width:27.5cm;<cfif AsPDF EQ 1>height:19cm;<cfelse>height:95%;</cfif>border:2pt solid ##2e3192;" align="center">
<tr>
<td>
<table cellpadding="0" cellspacing="0" width="96%" style="<cfif AsPDF EQ 1>height:19cm;<cfelse>height:95%;</cfif>" align="center">
<tr valign="top">
<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr>
<td style="height:20px;"></td>
</tr>
<tr>
<td align="right">
<img src="#fileService.getFile(fileDir = "/keydoc/images", filename = "Trident_College_Solwezi_Logo.png", includeHTTP = "https:")#" style="height:2.5cm;"/></td>
</tr>

<tr>
<td style="height:1cm;"></td>
</tr>

<tr align="center">
<td style="color:##2e3192;font:bold 36pt Times New Roman;">CERTIFICATE OF ACHIEVEMENT</td>
</tr>

<tr>
<td style="height:10px;"></td>
</tr>

<tr>
<td align="center" class="txtRep14">AWARDED TO</td>
</tr>

<tr>
<td style="height:5px;"></td>
</tr>

<tr align="center" class="txtRep10">
<td><u><span style="font:normal 34pt Segoe Script"><i>#getList.FirstName[i]# #getList.LastName[i]#</i></span></u></td>
</tr>

<tr>
<td style="height:5px;"></td>
</tr>

<tr>
<td align="center" class="txtRep14">FOR</td>
</tr>

<tr>
<td style="height:5px;"></td>
</tr>

<tr>
<td align="center" class="txtRep22Bold"><cfif getAvg.WAMark GTE 85>Outstanding Academic Achievement;<cfelseif getAvg.WAMark GTE 80 AND getAvg.WAMark LTE 84>Excellent Academic Achievement;<cfelseif getAvg.WAMark GTE 75 AND getAvg.WAMark LTE 79>Academic Achievement;</cfif> Cycle <cfif term EQ 1>1<cfelseif term EQ 2>2<cfelseif middate GT 0>3<cfelseif term EQ 3>4</cfif>, Year #ListFirst(Replace(getList.AcYear[i], "Yr", ""), "_")#, #year#</td>
</tr>


<tr>
<td style="height:5px;"></td>
</tr>

<tr>
<td align="center" class="txtRep22">#NumberFormat(getAvg.WAMark)#% Average</td>
</tr>

<tr>
<td style="height:10px;"></td>
</tr>

<tr>
<td>
<table cellpadding="0" cellspacing="0" width="86%" align="center">
<tr align="center" valign="bottom" class="txtRep12">
<td width="33%" class="bbottom" style="height:70px;">#DateFormat(getCF.Date1, "dd mmmm yyyy")#</td>
<td width="34%"></td>
<td width="33%" class="bbottom"><cfif getCF.SignFile NEQ "" AND fileService.checkFileExist(fileDir  = "/keydoc/signatures/#getCF.StaffID#", filename = "#getCF.SignFile#")>
<img src="#fileService.getFile(fileDir = "/keydoc/signatures/#getCF.StaffID#", filename = "#getCF.SignFile#", includeHTTP = "https:")#" style="position:relative;height:50px;padding-bottom:1px;" /></cfif></td>
</tr>

<tr>
<td colspan="3" style="height:5px;"></td>
</tr>

<tr align="center" class="txtRep12" valign="top">
<td>Date</td>
<td></td>
<td>Headmaster<br/>#getCF.FirstName# #getCF.LastName#</td>
</tr>
<tr>
<td colspan="3" style="height:20px;"></td>
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
<tr>
<td align="right">
<img src="#fileService.getFile(fileDir = "/keydoc/images", filename = "replogo.jpg", includeHTTP = "https:")#" style="height:1.5cm;"/></td>
</tr>

<tr>
<td style="height:5px;"></td>
</tr>
</table>
</td>
</tr>

</table>
</td>
</tr>

</table>
</td>
</tr>

<tr>
<td style="height:0.5cm;"></td>
</tr>
</table>
</td>
</tr>
</table>
</cfif>

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
.txtRep6 {
	font-family: Arial !important;
	font-size: 6pt !important;
}
.txtRep6Bold {
	font-family: Arial !important;
	font-size: 6pt !important;
	font-weight:bold !important;
}

.watermark  {
    background-image: url("https://s3-eu-west-1.amazonaws.com/client-z5n97j6prh/Public%20folder/Trident_College_Badge_Watermark.png");
    background-repeat: no-repeat;
    background-position: center center;
    background-size: 12cm;
	}

.watermark2  {
    background-image: url("https://s3-eu-west-1.amazonaws.com/client-z5n97j6prh/Public%20folder/TC_BG_Watermark.png");
    background-repeat: no-repeat;
    background-position: left top;
    background-size: 12cm 6cm;
	}
</style>
</head>

<body>
<div align="right" class="noprint">
<img src="<cfoutput>#varSiteHome#</cfoutput>images/print.gif" style="cursor:pointer" onClick="window.print()">
</div>
<cfoutput>#myReport#</cfoutput>

<div align="right" class="noprint" style="clear:both"><input type="button" class="stdButton" value="Close" onClick="window.close()" /></div>
<invalidTag defer src="https://static.cloudflareinsights.com/beacon.min.js/vcd15cbe7772f49c399c6a5babf22c1241717689176015" integrity="sha512-ZpsOmlRQV6y907TI0dKBHq9Md29nnaEIPlkf84rnaERnq6zvWvPUqr2ft8M1aS28oN72PdrCzSjY4U6VaAw1EQ==" data-cf-beacon='{"rayId":"8a082b5b2a3095f5","r":1,"version":"2024.4.1","token":"24487d2a7ed944b994f951dd5266a78e"}' crossorigin="anonymous"></script>
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
.txtRep28, .txtRep28Bold {font-family:Arial !important;}
.txtRep6 {
	font-family: Arial !important;
	font-size: 6pt !important;
}
.txtRep6Bold {
	font-family: Arial !important;
	font-size: 6pt !important;
	font-weight:bold !important;
}

.watermark  {
    background-image: url("https://s3-eu-west-1.amazonaws.com/client-z5n97j6prh/Public%20folder/Trident_College_Badge_Watermark.png");
    background-repeat: no-repeat;
    background-position: center center;
    background-size: 12cm;
	}

.watermark2  {
    background-image: url("https://s3-eu-west-1.amazonaws.com/client-z5n97j6prh/Public%20folder/TC_BG_Watermark.png");
    background-repeat: no-repeat;
    background-position: left top;
    background-size: 9cm 19cm;
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