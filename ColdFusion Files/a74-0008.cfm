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

<cfquery name="getGradeSch" datasource="#dsn#">
    SELECT G.MinPercent, G.MaxPercent, G.Grade, G.GradeDesc, G.GradeDet
    From StudYearGrade G 
    WHERE G.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#getList.Term#">
    AND G.StudYear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getList.AcYear#">
    AND G.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#getList.TermYear#">
    ORDER BY G.Grade DESC
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

<cfquery name="getOpt2" datasource="#dsn#">
	SELECT A.SetName, B.OptCode, B.OptDescript, B.OptDefinition, OptName, B.Seq, B.MinPercent, B.MaxPercent
	FROM SSTSet A
	LEFT JOIN SSTSetOption B ON B.SetID = A.SetID
	WHERE A.SetName = 'Effort Trident EYFS & Y1-2'
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
	SELECT SUM(Absent) AS Absent, SUM(Late) AS Late 
	FROM vATDStudAttTerm
	WHERE StudentID = #RecNo# AND TermYear = #year# AND Term = #term#
</cfquery>

<table cellpadding="0" cellspacing="0" align="center" style="width:18.7cm;height:28cm;">
<tr style="vertical-align:top;">
<td>
<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
	

	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
		<tr style="vertical-align:top;">
			<td align="left" class="txtRep9" style="width:70%;">
			<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
				<tr>
				<td colspan="3">
				<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
					<cfif ListLast(getList.AcYear[i],'_') EQ 'TPL'><cfset color = "##2E3192">
					<cfelseif ListLast(getList.AcYear[i],'_') EQ 'TPK'><cfset color = "##004B23">
					<cfelseif ListLast(getList.AcYear[i],'_') EQ 'TPS'><cfset color = "##9f1f63">
					<cfelse><cfset color = "">
					</cfif>
					<tr>
						<td align="left" style="font:normal 24pt 'Arial';" align="left"><b>END OF TERM REPORT</b></td>
						<td align="right" rowspan="2"><img src="#fileService.getFile(fileDir = "/keydoc/stphotos", filename = "#getList.Photo[i]#", includeHTTP = "https:")#" style="height:85px;border:3px solid #color#;padding:1px;"></td>
					</tr>
					<tr>
						<td align="left" style="font:normal 20pt 'Arial';" align="left">#DateFormat(getTerm.EndDate,' MMMM YYYY')#</td>
					</tr>
				</table>
				</td>
				</tr>
				<tr><td style="height:10px;"></td></tr>
				<tr style="background-color:##d3d3d3;">
					<td align="left" colspan="2" style="padding:3px 5px;" class="txtRep12Bold btop bbottom bleft">Student: #getList.FirstName[i]# #getList.LastName[i]#</td>
					<td align="right" style="padding:3px 5px;" class="txtRep12Bold btop bbottom bright">Class: #ListFirst(getList.AcYear[i],'_')#</td>
				</tr>
				<tr><td style="height:10px;"></td></tr>
				<tr>
					<td class="ball txtRep11" align="center" style="padding:3px;width:33%;"><b>Child’s Age:</b> #Replace(Replace(getList.Age[i],'-0','.'),'-','.')#</td>
					<td class="btop bbottom bright txtRep11" align="center" style="padding:3px;width:33%;"><b>Average Age:</b> #AvgYR#.#AvgMT#</td>
					<td class="btop bbottom bright txtRep11" align="center" style="padding:3px;width:33%;"><b>Days Absent:</b> #NumberFormat(getStudAtt.Absent)#</td>
				</tr>
			</table>
			</td>
			<cfif ListLast(getList.AcYear[i],'_') EQ 'TPL'><cfset logo = "Trident_Prep_Lusaka.jpg">
			<cfelseif ListLast(getList.AcYear[i],'_') EQ 'TPK'><cfset logo = "Trident_Prep_Kalumbila.png">
			<cfelseif ListLast(getList.AcYear[i],'_') EQ 'TPS'><cfset logo = "Trident_Prep_Solwezi.png">
			<cfelse><cfset logo = "">
			</cfif>
			<td align="right" style="width:30%;"><img src="#fileService.getFile(fileDir = "/keydoc/images", filename = "#logo#", includeHTTP = "https:")#" style="height:4.5cm;"></td>
		</tr>
	</table>
	</td>
	</tr>

	<tr><td style="height:20px;"></td></tr>

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
		<tr><td style="height:20px;"></td></tr>
		<tr><td class="ball txtRep11Bold" colspan="2" style="background-color:##D2D2D2;padding:3px 5px;">Attainment</td></tr>
		<cfloop query="getGradeSch">
			<tr>
				<td class="bleft bbottom bright txtRep11Bold" align="center" style="width:20%;height:40px;">#Grade#</td>
				<td class="bbottom bright txtRep11" align="left" style="width:80%;padding:3px 5px;">#GradeDesc#</td>
			</tr>
		</cfloop>
	</table>
	</td>
	</tr>

	<tr><td style="height:20px;"></td></tr>

	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
		<tr><td class="ball txtRep11Bold" colspan="2" style="background-color:##D2D2D2;padding:3px 5px;">Effort</td></tr>
		<cfloop query="getOpt2">
			<tr>
				<td class="bleft bbottom bright txtRep11Bold" align="left" style="width:30%;padding:3px 5px;">#OptName#</td>
				<td class="bbottom bright txtRep11" align="left" style="width:70%;padding:3px 5px;">#OptDescript#</td>
			</tr>
		</cfloop>
	</table>
	</td>
	</tr>


</table>
</td>
</tr>



<tr style="vertical-align:bottom;">
<td>
<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
	<tr>
		<td style="width:53%" align="right" class="btop"><img src="#fileService.getFile(fileDir = "/keydoc/assessment", filename = "EducoreServices.png", includeHTTP = "https:")#" style="height:0.8cm;"></td>
		<td style="width:47%;vertical-align:top;padding-left:30px;font:normal 6pt 'Arial';" align="left" class="btop">#getCF.RepData2#</td>
	</tr>
</table>
</td>
</tr>
</table>



<cfquery name="getSubj" datasource="#dsn#">
	SELECT A.SCode, A.SubjName, A.Page, A.Mark, A.Grade, A.T1Title, A.T1FName, A.T1LName, O1.OptName AS Effort, SS.Comment
	FROM vARSubjAcads A
		LEFT JOIN ARCommSetup C1 ON C1.TermYear = A.TermYear AND C1.Term = A.Term AND C1.StudYear = A.AcYear AND C1.Type = 52 AND C1.Reference = 'B'
		LEFT JOIN ARAcadComm A1 ON A1.CommSetupID = C1.CommSetupID AND A1.AcadID = A.AcadID
		LEFT JOIN SSTSetOption O1 ON O1.SetID = C1.SetID AND O1.OptCode = A1.SumVal
		LEFT JOIN ARCommSetup CS ON CS.TermYear = A.TermYear AND CS.Term = A.Term AND CS.StudYear = A.AcYear AND CS.Type = 2 AND CS.Reference = 'A'
		LEFT JOIN ARAcadComm SS ON SS.CommSetupID = CS.CommSetupID AND SS.AcadID = A.AcadID
	WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.RepCard = 0 AND A.SType <> 'R' AND A.Page > 0 AND A.SCode NOT IN ('PerDev','SocDev','PhyDev') 
	ORDER BY A.Seq
</cfquery>
<cfquery name="getSubj2" datasource="#dsn#">
	SELECT A.SCode, A.SubjName, A.Page, A.Mark, A.Grade, A.T1Title, A.T1FName, A.T1LName
	FROM vARSubjAcads A
	WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.RepCard = 0 AND A.SType <> 'R' AND A.Page > 0 AND A.SCode IN ('PerDev','SocDev','PhyDev') 
	ORDER BY A.Seq
</cfquery>
<div class="pagebreak"></div>
<table cellpadding="0" cellspacing="0" align="center" style="width:18.7cm;height:28cm;">
<tr style="vertical-align:top;">
<td>
<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
	

	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
		<cfloop query="getSubj2">
			<cfquery name="getDet" datasource="#dsn#">
				SELECT S.GroupName, S.Description, G.Grade
				FROM vARSubjAcads A
					LEFT JOIN ARRepSetup S ON S.SSID = A.SSID
					LEFT JOIN ARAcad6Grade G ON G.ARRepSetupID = S.ARRepSetupID AND G.AcadID = A.AcadID
				WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.SType <> 'R' AND A.RepCard = 0 AND A.SCode = '#SCode#'
				ORDER BY S.Seq
			</cfquery>
			<tr>
				<td class="ball txtRep14Bold" style="padding:2px 4px;width:46%;">#SubjName#</td>
				<cfloop query="getOpt"><td class="btop bbottom bright txtRep11" align="center" style="padding:2px 4px;width:18%;">#OptName#</td></cfloop>
			</tr>
			<cfloop query="getDet">
				<tr>
					<td class="bleft bbottom bright txtRep11" style="padding:2px 4px;">#Description#</td>
					<cfloop query="getOpt"><td class="bbottom bright" align="center"><cfif OptCode EQ Grade><img src="#fileService.getFile(fileDir = "/keydoc/assessment", filename = "tick.png", includeHTTP = "https:")#" style="height:12pt;"></cfif></td></cfloop>
				</tr>
			</cfloop>
			<tr><td style="height:20px;"></td></tr>
		</cfloop>
	</table>
	</td>
	</tr>


	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
		<cfif getSubj.RecordCount GT 0>
			<tr style="background-color:##D3D3D3;">
				<td class="ball txtRep14Bold" style="padding:2px 4px;">Subject</td>
				<td class="btop bbottom bright txtRep11" align="center" style="padding:2px 4px;">Attainment</td>
				<td class="btop bbottom bright txtRep11" align="center" style="padding:2px 4px;">Effort</td>
				<td class="btop bbottom bright txtRep11" align="center" style="padding:2px 4px;">Teacher</td>
			</tr>
			<cfloop query="getSubj">
				<cfif Grade NEQ "" OR Effort NEQ "">
					<tr>
						<td class="bleft bbottom bright txtRep11Bold" style="padding:3px 4px;width:50%;">#SubjName#</td>
						<td class="bbottom bright txtRep11" align="center" style="padding:2px 4px;width:10%;">#Grade#</td>
						<td class="bbottom bright txtRep11" align="center" style="padding:2px 0px;width:20%;">#Effort#</td>
						<td class="bbottom bright txtRep11" align="left" style="padding:2px 4px;width:20%;">#T1Title#. #LEFT(T1FName, 1)# #T1LName#</td>
					</tr>
				</cfif>
			</cfloop>
		</cfif>
	</table>
	</td>
	</tr>

	<cfquery name="getComms" datasource="#dsn#">
		SELECT C.HeadingRep, S.Comment, C.TextType
		FROM ARCommSetup C
			LEFT JOIN ARCommStudent S ON S.CommSetupID = C.CommSetupID AND S.StudentID = #RecNo#
		WHERE C.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#year#">
			AND C.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#term#">
			AND C.StudYear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getList.AcYear#">
			AND C.Reference IN ('B','C') AND C.Type = 1 AND C.Status = 1 AND S.Comment <> ''
		ORDER BY C.Seq
	</cfquery>
	<cfquery name="getSubj" datasource="#dsn#">
		SELECT A.SCode, A.SubjName, SS.Comment, A.Page
		FROM vARSubjAcads A
			LEFT JOIN ARCommSetup CS ON CS.TermYear = A.TermYear AND CS.Term = A.Term AND CS.StudYear = A.AcYear AND CS.Type = 2 AND CS.Reference = 'A'
			LEFT JOIN ARAcadComm SS ON SS.CommSetupID = CS.CommSetupID AND SS.AcadID = A.AcadID
		WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.RepCard = 0 AND A.SType <> 'R' AND A.Page > 1 AND SS.Comment <> ''
		ORDER BY A.Seq
	</cfquery>
	<cfquery name="getComments2" dbtype="query">
		SELECT SubjName, Comment FROM getSubj
		WHERE Page = 2 
	</cfquery>
	<cfquery name="getComments3" dbtype="query">
		SELECT SubjName, Comment FROM getSubj
		WHERE Page = 3
	</cfquery>
	<cfquery name="getComments4" dbtype="query">
		SELECT SubjName, Comment FROM getSubj
		WHERE Page >= 4
	</cfquery>


	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
		
		<tr>
		<td>
		<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
			<tr><td style="height:20px;"></td></tr>
			<cfloop query="getComments2">
				<tr><td class="ball txtRep11Bold" style="padding:1px 5px;">#SubjName#</td></tr>
				<tr><td class="bleft bbottom bright txtRep10" style="padding:1px 5px;height:35px;vertical-align:top;line-height:11.5pt;">#Replace(Comment, Chr(13), "<br />", "All")#</td></tr>
				<tr><td style="height:10px;"></td></tr>
			</cfloop>
			<cfif getComments3.RecordCount EQ 0 AND getComments4.RecordCount EQ 0>
				<cfloop query="getComms">
					<cfif CurrentRow GT 1><tr><td style="height:10px;"></td></tr></cfif>
					<tr><td class="ball txtRep11Bold" style="padding:1px 5px;">#HeadingRep# <div style="float:right;padding-right:50px;" class="txtRep11Bold"><cfif Find('Head',HeadingRep)>#getCF.Title# #LEFT(getCF.FirstName, 1)# #getCF.LastName#<cfelseif Find('Class',HeadingRep)>#getList.Title[i]# #LEFT(getList.TFName[i], 1)# #getList.TLName[i]#</cfif></div></td></tr>
					<tr><td class="bleft bbottom bright txtRep10" style="padding:1px 5px;height:35px;vertical-align:top;line-height:11.5pt;">#Replace(Comment, Chr(13), "<br />", "All")#</td></tr>
				</cfloop>
			</cfif>
		</table>
		</td>
		</tr>
	</table>
	</td>
	</tr>





</table>
</td>
</tr>


<tr style="vertical-align:bottom;">
<td>
<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
	<tr>
		<td style="width:53%" align="right" class="btop"><img src="#fileService.getFile(fileDir = "/keydoc/assessment", filename = "EducoreServices.png", includeHTTP = "https:")#" style="height:0.8cm;"></td>
		<td style="width:47%;vertical-align:top;padding-left:30px;font:normal 6pt 'Arial';" align="left" class="btop">#getCF.RepData2#</td>
	</tr>
</table>
</td>
</tr>
</table>





<cfif getComments3.RecordCount GT 0>
<div class="pagebreak"></div>
<table cellpadding="0" cellspacing="0" align="center" style="width:18.7cm;height:28cm;">
<tr style="vertical-align:top;">
<td>
<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
		<cfloop query="getComments3">
			<tr><td class="ball txtRep11Bold" style="padding:1px 5px;">#SubjName#</td></tr>
			<tr><td class="bleft bbottom bright txtRep10" style="padding:1px 5px;height:35px;vertical-align:top;line-height:11.5pt;">#Replace(Comment, Chr(13), "<br />", "All")#</td></tr>
			<tr><td style="height:10px;"></td></tr>
		</cfloop>
		<cfif getComments4.RecordCount EQ 0>
			<cfloop query="getComms">
				<cfif CurrentRow GT 1><tr><td style="height:10px;"></td></tr></cfif>
				<tr><td class="ball txtRep11Bold" style="padding:1px 5px;">#HeadingRep# <div style="float:right;padding-right:50px;" class="txtRep11Bold"><cfif Find('Head',HeadingRep)>#getCF.Title# #LEFT(getCF.FirstName, 1)# #getCF.LastName#<cfelseif Find('Class',HeadingRep)>#getList.Title[i]# #LEFT(getList.TFName[i], 1)# #getList.TLName[i]#</cfif></div></td></tr>
				<tr><td class="bleft bbottom bright txtRep10" style="padding:1px 5px;height:35px;vertical-align:top;line-height:11.5pt;">#Replace(Comment, Chr(13), "<br />", "All")#</td></tr>
			</cfloop>
		</cfif>
	</table>
	</td>
	</tr>
</table>
</td>
</tr>


<tr style="vertical-align:bottom;">
<td>
<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
	<tr>
		<td style="width:53%" align="right" class="btop"><img src="#fileService.getFile(fileDir = "/keydoc/assessment", filename = "EducoreServices.png", includeHTTP = "https:")#" style="height:0.8cm;"></td>
		<td style="width:47%;vertical-align:top;padding-left:30px;font:normal 6pt 'Arial';" align="left" class="btop">#getCF.RepData2#</td>
	</tr>
</table>
</td>
</tr>
</table>
</cfif>





<cfif getComments4.RecordCount GT 0>
<div class="pagebreak"></div>
<table cellpadding="0" cellspacing="0" align="center" style="width:18.7cm;height:28cm;">
<tr style="vertical-align:top;">
<td>
<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
	<tr>
	<td>
	<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
		<cfloop query="getComments4">
			<tr><td class="ball txtRep11Bold" style="padding:1px 5px;">#SubjName#</td></tr>
			<tr><td class="bleft bbottom bright txtRep10" style="padding:1px 5px;height:35px;vertical-align:top;line-height:11.5pt;">#Replace(Comment, Chr(13), "<br />", "All")#</td></tr>
			<tr><td style="height:10px;"></td></tr>
		</cfloop>
		<cfloop query="getComms">
			<cfif CurrentRow GT 1><tr><td style="height:10px;"></td></tr></cfif>
			<tr><td class="ball txtRep11Bold" style="padding:1px 5px;">#HeadingRep# <div style="float:right;padding-right:50px;" class="txtRep11Bold"><cfif Find('Head',HeadingRep)>#getCF.Title# #LEFT(getCF.FirstName, 1)# #getCF.LastName#<cfelseif Find('Class',HeadingRep)>#getList.Title[i]# #LEFT(getList.TFName[i], 1)# #getList.TLName[i]#</cfif></div></td></tr>
			<tr><td class="bleft bbottom bright txtRep10" style="padding:1px 5px;height:35px;vertical-align:top;line-height:11.5pt;">#Replace(Comment, Chr(13), "<br />", "All")#</td></tr>
		</cfloop>
	</table>
	</td>
	</tr>
</table>
</td>
</tr>


<tr style="vertical-align:bottom;">
<td>
<table cellpadding="0" cellspacing="0" align="center" style="width:100%;">
	<tr>
		<td style="width:53%" align="right" class="btop"><img src="#fileService.getFile(fileDir = "/keydoc/assessment", filename = "EducoreServices.png", includeHTTP = "https:")#" style="height:0.8cm;"></td>
		<td style="width:47%;vertical-align:top;padding-left:30px;font:normal 6pt 'Arial';" align="left" class="btop">#getCF.RepData2#</td>
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