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
        C.Class, T.FirstName AS TFName, T.LastName AS TLName, T.Title, T.TeacherID, T.T1SignFile, G.Height, G.Weight, A.Age, AV.AvgAge
    
        FROM vARSubjAcads A
        LEFT JOIN TTClassStud C ON C.TermYear = A.TermYear AND C.Term = A.Term
        AND C.AcYear = A.AcYear AND C.StudID = A.StudID
        LEFT JOIN vTTClasses T ON T.Class = C.Class AND T.ClYear = C.TermYear AND T.ClTerm = C.Term
        LEFT JOIN vMedicalInfo G ON G.StudentID = A.StudID
        LEFT JOIN (
        SELECT C2.Class, AVG(DateDiff(m, A2.BirthDate, D.EndDate))AS AvgAge
        FROM vARSubjAcads A2
        INNER JOIN TermDates D ON D.termYear = A2.TermYear AND D.Term = A2.Term
        LEFT JOIN TTClassStud C2 ON C2.TermYear = A2.TermYear AND C2.Term = A2.Term
        AND C2.AcYear = A2.AcYear AND C2.StudID = A2.StudID
        WHERE ARSID = #ARSID#
        GROUP BY C2.Class
        ) AS AV ON AV.Class = C.Class
        WHERE ARSID = #ARSID#<cfif RecNo NEQ 0> AND A.StudID = #RecNo#</cfif>
        ORDER BY LastName, FirstName
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
    
    <cfquery name="getStudAtt" datasource="#dsn#">
        SELECT SUM(Absent) AS Absent, SUM(Present) AS Present
        FROM vATDStudAttTerm
        WHERE StudentID = #RecNo# AND TermYear = #year# AND Term = #term#
    </cfquery>
    
    <cfquery name="getTermDays" datasource="#dsn#">
        SELECT dbo.fnTermDays (#year#, #term#) AS TermDays
    </cfquery>
    
    <cfquery name="getComms" datasource="#dsn#">
        SELECT C.Seq, C.HeadingRep, C.Heading, S.Comment, C.CommPerson
        FROM ARCommSetup C
        LEFT JOIN ARCommStudent S ON S.CommSetupID = C.CommSetupID AND S.StudentID = #RecNo#
        WHERE C.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#year#">
        AND C.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#term#">
        AND C.StudYear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getList.AcYear#">
        AND C.Reference IN ('B','C','D') AND C.Type = 1
        ORDER BY C.Reference ASC
    </cfquery>
    
    <cfset StudGrade = "One,Two,Three,Four,Five,Six">
    
    <table cellpadding="0" cellspacing="0" style="width:100%; height:27cm" align="center">
    <tr valign="top">
    <td>
    <table cellpadding="0" cellspacing="0" width="100%" align="center">
    
    <tr>
    <td>
    <table cellpadding="0" cellspacing="0" width="100%" align="center">
    <tr align="center" class="txtRep14Bold">
    <td width="30%" rowspan="2" valign="top"><img src="#fileService.getFile(fileDir = "/keydoc/images", filename = "Trident_Prep_Kalumbila.png", includeHTTP = "https:")#" style="height:5.5cm;"/></td>
    <td width="40%" style="color:##004B23;padding-top:1cm;">End of Term Report<br/>#year#</td>
    <td width="30%" rowspan="2" class="watermark"><cfif getList.Photo[i] NEQ "" AND fileService.checkFileExist(fileDir  = "/keydoc/stphotos", filename = "#getList.Photo[i]#")>
    <img src="#fileService.getFile(fileDir = "/keydoc/stphotos", filename = "#getList.Photo[i]#", includeHTTP = "https:")#" style="border:5pt solid white;height:4.6cm;width:3.2cm;position:relative;"></cfif></td>
    </tr>
    
    <tr align="center" class="txtRep12Bold">
    <td style="color:##004B23;padding-bottom:2cm;">#getList.FirstName[i]# #getList.LastName[i]#<br/>Year #ListGetAt(StudGrade,#ListFirst(Replace(getList.AcYear[i], "Yr", ""), "_")#)#</td>
    </tr>
    </table>
    </td>
    </tr>
    
    <tr>
    <td style="height:10px;"></td>
    </tr>
    
    <cfquery name="getSubjSum" datasource="#dsn#">
        SELECT A1.SumVal
        FROM vARSubjAcads A
        LEFT JOIN ARCommSetup C1 ON C1.TermYear = A.TermYear AND C1.Term = A.Term AND C1.StudYear = A.AcYear AND C1.Type = 52 AND C1.Reference = 'B'
        LEFT JOIN ARAcadComm A1 ON A1.CommSetupID = C1.CommSetupID AND A1.AcadID = A.AcadID
        WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.SCode = 'ENG'
    </cfquery>
    
    <tr>
    <td>
    <table cellpadding="0" cellspacing="0" width="90%" align="center">
    <cfif term EQ 1 OR  getSubjSum.sumVal EQ "">
    <tr>
    <td width="33%"></td>
    <td width="34%"></td>
    <td width="33%"></td>
    </tr>
    <cfelse>
    <tr>
    <td width="22%"></td>
    <td width="28%"></td>
    <td width="22%"></td>
    <td width="28%"></td>
    </tr>
    </cfif>
    
    <tr align="center" class="txtRep10Bold" style="background-color:##ECF8F3;">
    <td style="padding:5px 0px;" class="ball">Student Age</td>
    <td class="btop bright bbottom">Year Group Average Age</td>
    <cfif term NEQ 1><cfif getSubjSum.sumVal NEQ ""><td class="btop bright bbottom">Reading Age</td></cfif></cfif>
    <td class="btop bright bbottom">Days Absent</td>
    </tr>
    
    <tr align="center" class="txtRep10">
    <td class="bleft bright bbottom" style="padding:5px 0px;">#ListFirst(getList.Age[i], "-")#y #ListLast(getList.Age[i], "-")-0#m</td>
    <td class="bright bbottom">#getList.AvgAge[i] \ 12#y #getList.AvgAge[i] MOD 12#m</td>
    <cfif term NEQ 1><cfif getSubjSum.sumVal NEQ ""><td class="bright bbottom">#getSubjSum.Sumval#</td></cfif></cfif>
    <td class="bright bbottom">#NumberFormat(getStudAtt.Absent)#</td>
    </tr>
    </table>
    </td>
    </tr>
    
    <tr>
    <td style="height:10px;"></td>
    </tr>
    
    <tr align="center" class="txtRep8">
    <td><u><span class="txtRep12Bold">Summary of Attainment</span></u></td>
    </tr>
    
    <tr align="left" class="txtRep9">
    <td>#getCF.RepData3#</td>
    </tr>
    
    <tr>
    <td style="height:10px;"></td>
    </tr>
    
    
    <cfquery name="getSubj" datasource="#dsn#">
        SELECT A.SubjName, A.SCode, A.T1Title, A.T1FName, A.T1LName, A.TopNum, A.IsCore, A.Seq
        FROM (
        SELECT A.SCode, A.SubjName, A.T1Title, A.T1FName, A.T1LName, A.SSID, C.IsCore, C.TopNum, A.Seq
        FROM vARSubjAcads A
        INNER JOIN SubjCore C ON C.TermYear = A.TermYear AND C.Term = A.Term AND C.AcYear = A.AcYear
        INNER JOIN SubjCoreList L ON L.SubjCoreID = C.SubjCoreID AND L.SSID = A.SSID
        WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.RepCard = 0 AND A.SType <> 'R' AND A.Page <> 0
        ) AS A
        WHERE A.IsCore = 1
        ORDER BY A.Seq
    </cfquery>
    
    <tr>
    <td>
    <table cellpadding="0" cellspacing="0" width="100%" align="center">
    <tr align="center" class="txtRep11Bold" style="background-color:##ECF8F3;">
    <td rowspan="2" width="36%" style="padding:2px 0px;" class="ball">Subject</td>
    <td rowspan="2" width="25%" class="btop bright bbottom">Teacher</td>
    <td colspan="3" class="btop bright bbottom">Term</td>
    </tr>
    
    <tr align="center" class="txtRep11Bold" style="background-color:##ECF8F3;">
    <td width="13%" class="bright bbottom" style="padding:2px 0px;">One</td>
    <td width="13%" class="bright bbottom">Two</td>
    <td width="13%" class="bright bbottom">Three</td>
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
    <cfset tData['Class'] = getList.Class[i]>
    <cfset tData['SubjName'] = SubjName>
    <cfset tData['CurrentRow'] = CurrentRow>
    <cfset tData['T1Title'] = T1Title>
    <cfset tData['T1FName'] = T1FName>
    <cfset tData['T1LName'] = T1LName>
    <cfset tData['MaxTerm'] = MaxTerm>
    
    <cfthread name="#tName#" action="run" tData="#tData#" dsn="#dsn#">
    
    <cfset THREAD.SubjName = ATTRIBUTES.tData.SubjName>
    <cfset THREAD.SCode = ATTRIBUTES.tData.SCode>
    <cfset THREAD.CurrentRow = ATTRIBUTES.tData.CurrentRow>
    <cfset THREAD.T1Title = ATTRIBUTES.tData.T1Title>
    <cfset THREAD.T1FName = ATTRIBUTES.tData.T1FName>
    <cfset THREAD.T1LName = ATTRIBUTES.tData.T1LName>
    
    <cfquery name="THREAD.getDet" datasource="#ATTRIBUTES.dsn#">
        SELECT Nbr, A1.Sumval, CASE WHEN A.IsHeader = 1 THEN C.Mark ELSE A.Mark END AS Mark,
        CASE WHEN A.IsHeader = 1 THEN C.Grade ELSE A.Grade END AS Grade
    
        FROM UTLNumbers N
        LEFT JOIN vARSubjAcads A ON A.Term = N.Nbr AND A.TermYear = #ATTRIBUTES.tData.year# AND A.Term <= #ATTRIBUTES.tData.term# AND A.StudID = #RecNo# AND A.SCode = N'#ATTRIBUTES.tData.SCode#'
    
        LEFT JOIN (
        SELECT PSSID, ROUND(SUM(ROUND(A.Mark, 2) * A.SubjWeight) / SUM(CASE WHEN A.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 2) AS Mark, (
        SELECT TOP 1 Grade FROM StudYearGrade G
        WHERE G.MinPercent <= ROUND(SUM(ROUND(A.Mark, 2) * A.SubjWeight) / SUM(CASE WHEN A.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 2)
        AND G.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
        AND G.Term <= <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
        AND G.StudYear = '#ATTRIBUTES.tData.AcYear#'
        ORDER BY G.MinPercent DESC
        ) AS Grade
        FROM vARSubjAcads A
        WHERE A.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
        AND A.Term <= <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
        AND A.StudID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.tData.RecNo#">
        AND A.PSSID IS NOT NULL
        GROUP BY PSSID
        ) AS C ON C.PSSID = A.SSID
    
        LEFT JOIN ARCommSetup C1 ON C1.TermYear = A.TermYear AND C1.Term = A.Term AND C1.StudYear = A.AcYear AND C1.Type = 52 AND C1.Reference = 'A'
        LEFT JOIN ARAcadComm A1 ON A1.CommSetupID = C1.CommSetupID AND A1.AcadID = A.AcadID
                                   
        WHERE N.Nbr <= #ATTRIBUTES.tData.MaxTerm#
        ORDER BY N.Nbr
    </cfquery>
    
    <cfquery name="THREAD.getGradeAvg" datasource="#ATTRIBUTES.dsn#">
        SELECT Nbr, CASE WHEN A.IsHeader = 1 THEN C.GradeAvgMark ELSE S.GradeAvgMark END AS GradeAvgMark,
        CASE WHEN A.IsHeader = 1 THEN C.GradeAvgGrade ELSE S.GradeAvgGrade END AS GradeAvgGrade
    
        FROM UTLNumbers N
        LEFT JOIN vARSubjAcads A ON A.Term = N.Nbr AND A.TermYear = #ATTRIBUTES.tData.year# AND A.Term = #ATTRIBUTES.tData.term# AND A.StudID = #ATTRIBUTES.tData.RecNo# AND A.SCode = N'#ATTRIBUTES.tData.SCode#'
        LEFT JOIN vARSubjects S ON S.ARSID = A.ARSID
        LEFT JOIN (
        SELECT PSSID, ROUND(SUM(ROUND(S.GradeAvgMark, 0) * A.SubjWeight) / SUM(CASE WHEN S.GradeAvgMark IS NULL THEN NULL ELSE A.SubjWeight END), 0) AS GradeAvgMark, (
        SELECT TOP 1 Grade FROM StudYearGrade G
        WHERE G.MinPercent <= ROUND(SUM(ROUND(S.GradeAvgMark, 0) * A.SubjWeight) / SUM(CASE WHEN S.GradeAvgMark IS NULL THEN NULL ELSE A.SubjWeight END), 0)
        AND G.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
        AND G.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
        AND G.StudYear = '#ATTRIBUTES.tData.AcYear#'
        ORDER BY G.MinPercent DESC
        ) AS GradeAvgGrade
    
        FROM vARSubjAcads A
        LEFT JOIN vARSubjects S ON S.ARSID = A.ARSID
        WHERE A.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
        AND A.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
        AND A.StudID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.tData.RecNo#">
        AND A.PSSID IS NOT NULL
        GROUP BY PSSID
        ) AS C ON C.PSSID = A.SSID
    
        WHERE N.Nbr = #term#
        ORDER BY Nbr
    </cfquery>
    
    
    </cfthread>
    </cfloop>
    
    <cfif listLen(listThreadName)>
    <cfthread action="join" name="#listThreadName#" />
    <cfloop list="#listThreadName#" item="t">
    <cfif structKeyExists(cfthread, t)>
    <cfset threadResult = cfthread[t]>
    
    <cfif threadResult.SCode NEQ getSubj.SCode[threadResult.CurrentRow-1]>
    <tr align="center" class="txtRep11">
    <td style="padding:2px 5px;" class="bleft bright bbottom" align="left">#threadResult.SubjName#</td>
    <td class="bright bbottom" style="padding:2px 5px;" align="left"><i>#ucFirst(threadResult.T1Title, true, true)#<cfif threadResult.T1Title NEQ "">.</cfif> #ucFirst(threadResult.T1LName, true, true)#</i></td>
    <td class="bright bbottom"><cfif threadResult.getDet.Mark[1] NEQ "">#threadResult.getDet.Grade[1]#</cfif></td>
    <td class="bright bbottom"><cfif term GTE 2 AND threadResult.getDet.Mark[2] NEQ "">#threadResult.getDet.Grade[2]#</cfif></td>
    <td class="bright bbottom"><cfif term EQ 3 AND threadResult.getDet.Mark[3] NEQ "">#threadResult.getDet.Grade[3]#</cfif></td>
    </tr>
    </cfif>
    
    </cfif>
    </cfloop>
    </cfif>
    </table>
    </td>
    </tr>
    
    <tr>
    <td style="height:10px;"></td>
    </tr>
    
    <cfset Numbers = "1,2,3,4,5,6,7,8,9,10,11,12,13,14">
    
    <cfquery name="getSubj" datasource="#dsn#">
        SELECT A.SubjName, A.SCode, A.T1Title, A.T1FName, A.T1LName, A.SubjComms, A.Sumval
        FROM (
        SELECT A.SCode, A.SubjName, A.T1Title, A.T1FName, A.T1LName, A.SSID, C.IsCore, C.TopNum, A.Seq, SS.Comment AS SubjComms, A1.Sumval
        FROM vARSubjAcads A
        INNER JOIN SubjCore C ON C.TermYear = A.TermYear AND C.Term = A.Term AND C.AcYear = A.AcYear
        INNER JOIN SubjCoreList L ON L.SubjCoreID = C.SubjCoreID AND L.SSID = A.SSID
        LEFT JOIN ARCommSetup CS ON CS.TermYear = A.TermYear AND CS.Term = A.Term AND CS.StudYear = A.AcYear AND CS.Type = 2 AND CS.Reference = 'A'
        LEFT JOIN ARAcadComm SS ON SS.CommSetupID = CS.CommSetupID AND SS.AcadID = A.AcadID
        LEFT JOIN ARCommSetup C1 ON C1.TermYear = A.TermYear AND C1.Term = A.Term AND C1.StudYear = A.AcYear AND C1.Type = 52 AND C1.Reference = 'A'
        LEFT JOIN ARAcadComm A1 ON A1.CommSetupID = C1.CommSetupID AND A1.AcadID = A.AcadID
        WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.SType <> 'R' AND A.RepCard = 0 AND A.Page = 1
        ) AS A
        WHERE A.IsCore = 1
        ORDER BY A.Seq
    </cfquery>
    
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
    <cfset tData['Sumval'] = Sumval>
    <cfset tData['SubjComms'] = SubjComms>
    
    <cfthread name="#tName#" action="run" tData="#tData#" dsn="#dsn#">
    
    <cfset THREAD.SubjName = ATTRIBUTES.tData.SubjName>
    <cfset THREAD.SCode = ATTRIBUTES.tData.SCode>
    <cfset THREAD.CurrentRow = ATTRIBUTES.tData.CurrentRow>
    <cfset THREAD.T1Title = ATTRIBUTES.tData.T1Title>
    <cfset THREAD.T1FName = ATTRIBUTES.tData.T1FName>
    <cfset THREAD.T1LName = ATTRIBUTES.tData.T1LName>
    <cfset THREAD.Sumval = ATTRIBUTES.tData.Sumval>
    <cfset THREAD.SubjComms = ATTRIBUTES.tData.SubjComms>
    
    <cfquery name="THREAD.getDet" datasource="#ATTRIBUTES.dsn#">
        SELECT Nbr, CASE WHEN A.IsHeader = 1 THEN C.Mark ELSE A.Mark END AS Mark,
        CASE WHEN A.IsHeader = 1 THEN C.Grade ELSE A.Grade END AS Grade
    
        FROM UTLNumbers N
        LEFT JOIN vARSubjAcads A ON A.Term = N.Nbr AND A.TermYear = #ATTRIBUTES.tData.year# AND A.Term = #ATTRIBUTES.tData.term# AND A.StudID = #ATTRIBUTES.tData.RecNo# AND A.SCode = N'#ATTRIBUTES.tData.SCode#'
    
        LEFT JOIN (
        SELECT PSSID, ROUND(SUM(ROUND(A.Mark, 0) * A.SubjWeight) / SUM(CASE WHEN A.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 0) AS Mark, (
        SELECT TOP 1 Grade FROM StudYearGrade G
        WHERE G.MinPercent <= ROUND(SUM(ROUND(A.Mark, 2) * A.SubjWeight) / SUM(CASE WHEN A.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 2)
        AND G.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
        AND G.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
        AND G.StudYear = '#ATTRIBUTES.tData.AcYear#'
        ORDER BY G.MinPercent DESC
        ) AS Grade
        FROM vARSubjAcads A
    
        WHERE A.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
        AND A.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
        AND A.StudID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.tData.RecNo#">
        AND A.PSSID IS NOT NULL
        GROUP BY PSSID
        ) AS C ON C.PSSID = A.SSID
        WHERE N.Nbr = #ATTRIBUTES.tData.term#
        ORDER BY Nbr
    </cfquery>
    
    <cfquery name="THREAD.getDet2" datasource="#ATTRIBUTES.dsn#">
        SELECT C0.Title, ((D.Mark / C0.OutOf) * 100) AS Mark, (
        SELECT TOP 1 Grade FROM StudYearGrade G
        WHERE G.MinPercent <= ((D.Mark / C0.OutOf) * 100) 
        AND G.TermYear = #ATTRIBUTES.tData.year# 
        AND G.Term = #ATTRIBUTES.tData.term# 
        AND G.StudYear = '#ATTRIBUTES.tData.AcYear#' 
        ORDER BY G.MinPercent DESC) AS Grade2
        FROM vARSubjAcads A  
        LEFT JOIN ARAssCol C1 ON C1.ARSID = A.ARSID AND C1.Lvl = 1 AND C1.ColHeading = 'Strands'
        LEFT JOIN ARAssCol C0 ON C0.ARAssColPID = C1.ARAssColID
        LEFT JOIN ARAssColData D ON D.ARAssColID = C0.ARAssColID AND D.AcadID = A.AcadID 
        WHERE A.TermYear = #ATTRIBUTES.tData.year# AND A.Term = #ATTRIBUTES.tData.term# AND A.StudID = #ATTRIBUTES.tData.RecNo# AND A.SCode = N'#ATTRIBUTES.tData.SCode#' AND C0.ColHeading <> '' AND D.Mark > 0
        ORDER BY C0.Seq
    </cfquery>
    
    <cfquery name="THREAD.getGrades" datasource="#ATTRIBUTES.dsn#">
        SELECT * FROM StudYearGrade
        WHERE TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
        AND Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
        AND StudYear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.tData.AcYear#">
        ORDER BY MinPercent DESC
    </cfquery>
    
    <cfquery name="THREAD.getOpt" datasource="#ATTRIBUTES.dsn#">
        SELECT A.SetName, B.OptCode, B.OptName, B.OptDescript, B.OptDefinition
        FROM SSTSet A
        LEFT JOIN SSTSetOption B ON B.SetID = A.SetID
        WHERE A.SetName = 'Effort Trident Y3-Y6'
        ORDER BY B.Seq
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
    
    <cfif threadResult.CurrentRow EQ 1>
    <tr align="center" class="txtRep8">
    <td colspan="2"><u><span class="txtRep12Bold">Details of Attainment</span></u></td>
    </tr>
    
    <tr>
    <td colspan="2" style="height:10px;"></td>
    </tr>
    </cfif>
    
    <tr align="left" class="txtRep12Bold" style="background-color:##ECF8F3;">
    <td width="50%" style="padding:2px 5px;" class="bleft btop bbottom">#threadResult.SubjName#</td>
    <td width="50%" style="padding:2px 5px;" class="txtRep11 btop bright bbottom" align="right"><i>#ucFirst(threadResult.T1Title, true, true)# #ucFirst(threadResult.T1FName, true, true)# #ucFirst(threadResult.T1LName, true, true)#</i></td>
    </tr>
    
    <tr align="left" class="txtRep11Bold" style="color:##004B23;">
    <td style="padding:2px 5px;" class="bleft bright bbottom">Overall Effort</td>
    <td align="center" class="bright bbottom"><cfloop query="threadResult.getOpt"><cfif OptCode EQ threadResult.Sumval>#OptName#</cfif></cfloop></td>
    </tr>
    
    <tr align="left" class="txtRep11Bold">
    <td style="padding:2px 5px;" class="bleft bright bbottom">Overall Attainment</td>
    <td align="center" class="bright bbottom"><cfif threadResult.getDet.Mark NEQ ""><cfloop query="threadResult.getGrades"><cfif Grade EQ threadResult.getDet.Grade><b>#GradeDet#</b></cfif></cfloop></cfif></td>
    </tr>
    </cfif>
    
    <cfloop query="threadResult.getDet2">
    <tr align="left" class="txtRep11">
    <td style="padding:2px 5px;" class="bleft bright bbottom">#Title#</td>
    <td align="center" class="bright bbottom"><cfloop query="threadResult.getGrades"><cfif Grade EQ threadResult.getDet2.Grade2>#GradeDet#</cfif></cfloop></td>
    </tr>
    </cfloop>
    
    <cfif threadResult.SCode NEQ getSubj.SCode[threadResult.CurrentRow+1] AND threadResult.SubjComms NEQ "">
    <tr align="left" class="txtRep11Bold" style="background-color:##ECF8F3;">
    <td colspan="2" class="bleft bright bbottom" style="padding:2px 5px;">Teacher Comment</td>
    </tr>
    
    <tr align="left" class="txtRep11" valign="top">
    <td colspan="2" class="bleft bright bbottom" style="padding:2px 5px;height:2cm;">#Replace(threadResult.SubjComms, Chr(13), "<br />", "All")#</td>
    </tr>
    </cfif>
    
    </table>
    </td>
    </tr>
    
    <tr>
    <td style="height:20px;"></td>
    </tr>
    
    </cfif>
    </cfloop>
    </cfif>
    
    
    <cfquery name="getSubj" datasource="#dsn#">
        SELECT A.SubjName, A.SCode, A.T1Title, A.T1FName, A.T1LName, A.SubjComms, A.Sumval
        FROM (
        SELECT A.SCode, A.SubjName, A.T1Title, A.T1FName, A.T1LName, A.SSID, C.IsCore, C.TopNum, A.Seq, SS.Comment AS SubjComms, A1.Sumval
        FROM vARSubjAcads A
        INNER JOIN SubjCore C ON C.TermYear = A.TermYear AND C.Term = A.Term AND C.AcYear = A.AcYear
        INNER JOIN SubjCoreList L ON L.SubjCoreID = C.SubjCoreID AND L.SSID = A.SSID
        LEFT JOIN ARCommSetup CS ON CS.TermYear = A.TermYear AND CS.Term = A.Term AND CS.StudYear = A.AcYear AND CS.Type = 2 AND CS.Reference = 'A'
        LEFT JOIN ARAcadComm SS ON SS.CommSetupID = CS.CommSetupID AND SS.AcadID = A.AcadID
        LEFT JOIN ARCommSetup C1 ON C1.TermYear = A.TermYear AND C1.Term = A.Term AND C1.StudYear = A.AcYear AND C1.Type = 52 AND C1.Reference = 'A'
        LEFT JOIN ARAcadComm A1 ON A1.CommSetupID = C1.CommSetupID AND A1.AcadID = A.AcadID
        WHERE A.TermYear = #year# AND A.Term = #term# AND A.StudID = #RecNo# AND A.SType <> 'R' AND A.RepCard = 0 AND A.Page = 1
        ) AS A
        WHERE A.IsCore = 0
        ORDER BY A.Seq
    </cfquery>
    
    <tr>
    <td>
    <table cellpadding="0" cellspacing="0" width="100%" align="center" class="print-friendly">
    <tr align="center" class="txtRep11Bold" style="background-color:##ECF8F3;">
    <td width="25%" style="padding:2px 5px;" class="ball" align="left">Specialist Subjects</td>
    <td width="25%" class="btop bright bbottom">Teacher</td>
    <td width="25%" class="btop bright bbottom">Effort</td>
    <td width="25%" class="btop bright bbottom">Attainment</td>
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
    
    <cfthread name="#tName#" action="run" tData="#tData#" dsn="#dsn#">
    
    <cfset THREAD.SubjName = ATTRIBUTES.tData.SubjName>
    <cfset THREAD.SCode = ATTRIBUTES.tData.SCode>
    <cfset THREAD.CurrentRow = ATTRIBUTES.tData.CurrentRow>
    <cfset THREAD.T1Title = ATTRIBUTES.tData.T1Title>
    <cfset THREAD.T1FName = ATTRIBUTES.tData.T1FName>
    <cfset THREAD.T1LName = ATTRIBUTES.tData.T1LName>
    
    <cfquery name="THREAD.getDet" datasource="#ATTRIBUTES.dsn#">
        SELECT Nbr, A1.Sumval, CASE WHEN A.IsHeader = 1 THEN C.Mark ELSE A.Mark END AS Mark,
        CASE WHEN A.IsHeader = 1 THEN C.Grade ELSE A.Grade END AS Grade
    
        FROM UTLNumbers N
        LEFT JOIN vARSubjAcads A ON A.Term = N.Nbr AND A.TermYear = #ATTRIBUTES.tData.year# AND A.Term = #ATTRIBUTES.tData.term# AND A.StudID = #RecNo# AND A.SCode = N'#ATTRIBUTES.tData.SCode#'
    
        LEFT JOIN (
        SELECT PSSID, ROUND(SUM(ROUND(A.Mark, 2) * A.SubjWeight) / SUM(CASE WHEN A.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 2) AS Mark, (
        SELECT TOP 1 Grade FROM StudYearGrade G
        WHERE G.MinPercent <= ROUND(SUM(ROUND(A.Mark, 2) * A.SubjWeight) / SUM(CASE WHEN A.Mark IS NULL THEN NULL ELSE A.SubjWeight END), 2)
        AND G.TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
        AND G.Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
        AND G.StudYear = '#ATTRIBUTES.tData.AcYear#'
        ORDER BY G.MinPercent DESC
        ) AS Grade
    
        FROM vARSubjAcads A
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
    
    <cfquery name="THREAD.getGrades" datasource="#ATTRIBUTES.dsn#">
        SELECT * FROM StudYearGrade
        WHERE TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.year#">
        AND Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#ATTRIBUTES.tData.term#">
        AND StudYear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.tData.AcYear#">
        ORDER BY MinPercent DESC
    </cfquery>
    
    <cfquery name="THREAD.getOpt" datasource="#ATTRIBUTES.dsn#">
        SELECT A.SetName, B.OptCode, B.OptName, B.OptDescript, B.OptDefinition
        FROM SSTSet A
        LEFT JOIN SSTSetOption B ON B.SetID = A.SetID
        WHERE A.SetName = 'Effort Trident Y3-Y6'
        ORDER BY B.Seq
    </cfquery>
    
    </cfthread>
    </cfloop>
    
    <cfif listLen(listThreadName)>
    <cfthread action="join" name="#listThreadName#" />
    <cfloop list="#listThreadName#" item="t">
    <cfif structKeyExists(cfthread, t)>
    <cfset threadResult = cfthread[t]>
    
    <cfif threadResult.SCode NEQ getSubj.SCode[threadResult.CurrentRow-1]>
    <tr align="center" class="txtRep10">
    <td style="padding:2px 5px;" class="bleft bright bbottom" align="left"><b>#threadResult.SubjName#</b></td>
    <td class="bright bbottom" style="padding:2px 5px;"><i>#ucFirst(threadResult.T1Title, true, true)#<cfif threadResult.T1Title NEQ "">.</cfif> #LEFT(threadResult.T1FName, 1)# #ucFirst(threadResult.T1LName, true, true)#</i></td>
    <td class="bright bbottom"><cfloop query="threadResult.getOpt"><cfif OptCode EQ threadResult.getDet.Sumval>#OptName#</cfif></cfloop></td>
    <td class="bright bbottom"><cfif threadResult.getDet.Mark NEQ ""><cfloop query="threadResult.getGrades"><cfif Grade EQ threadResult.getDet.Grade>#GradeDet#</cfif></cfloop></cfif></td>
    </tr>
    </cfif>
    
    </cfif>
    </cfloop>
    </cfif>
    </table>
    </td>
    </tr>
    
    <cfif getComms.Comment[2] NEQ "" OR getComms.Comment[1] NEQ "" OR getComms.Comment[3] NEQ "">
    <tr>
    <td style="height:20px;"></td>
    </tr>
    
    <tr align="center" class="txtRep8">
    <td><u><span class="txtRep12Bold">General Comments</span></u></td>
    </tr>
    </cfif>
    
    <cfif getComms.Comment[2] NEQ "">
    <tr>
    <td>
    <table cellpadding="0" cellspacing="0" width="100%" align="center" class="print-friendly">
    <tr>
    <td colspan="2" style="height:20px;"></td>
    </tr>
    
    <tr align="left" class="txtRep11" style="background-color:##ECF8F3;">
    <td style="padding:2px 5px;" class="bleft btop bbottom"><b>#getComms.HeadingRep[2]#</b></td>
    <td class="btop bright bbottom" style="padding:2px 5px;" align="right"><i>#ucFirst(getList.Title[i], true, true)#<cfif getList.Title[i] NEQ "">.</cfif> #LEFT(getList.TFName[i], 1)# #ucFirst(getList.TLName[i], true, true)#</i></td>
    </tr>
    <tr align="left" class="txtRep10" valign="top">
    <td colspan="2" class="bleft bright bbottom" style="padding:2px 5px;height:2cm;">#Replace(getComms.Comment[2], Chr(13), "<br />", "All")#</td>
    </tr>
    </table>
    </td>
    </tr>
    </cfif>
    
    <cfif getComms.Comment[1] NEQ "">
    <tr>
    <td>
    <table cellpadding="0" cellspacing="0" width="100%" align="center" class="print-friendly">
    <tr>
    <td colspan="2" style="height:20px;"></td>
    </tr>
    
    <tr align="left" class="txtRep11" style="background-color:##ECF8F3;">
    <td style="padding:2px 5px;" class="bleft btop bbottom"><b>#getComms.HeadingRep[1]#</b></td>
    <td class="btop bright bbottom" style="padding:2px 5px;" align="right"><i>#ucFirst(getList.Title[i], true, true)#<cfif getList.Title[i] NEQ "">.</cfif> #LEFT(getList.TFName[i], 1)# #ucFirst(getList.TLName[i], true, true)#</i></td>
    </tr>
    <tr align="left" class="txtRep10" valign="top">
    <td colspan="2" class="bleft bright bbottom" style="padding:2px 5px;height:2cm;">#Replace(getComms.Comment[1], Chr(13), "<br />", "All")#</td>
    </tr>
    </table>
    </td>
    </tr>
    </cfif>
    
    <cfif getComms.Comment[3] NEQ "">
    <tr>
    <td>
    <table cellpadding="0" cellspacing="0" width="100%" align="center" class="print-friendly">
    <tr>
    <td colspan="2" style="height:20px;"></td>
    </tr>
    
    <tr align="left" class="txtRep11" style="background-color:##ECF8F3;">
    <td style="padding:2px 5px;" class="bleft btop bbottom"><b>#getComms.HeadingRep[3]#</b></td>
    <td class="btop bright bbottom" style="padding:2px 5px;" align="right"><i>#ucFirst(getCF.Title, true, true)#<cfif getCF.Title NEQ "">.</cfif> #LEFT(getCF.FirstName, 1)# #ucFirst(getCF.LastName, true, true)#</i></td>
    </tr>
    <tr align="left" class="txtRep10" valign="top">
    <td colspan="2" class="bleft bright bbottom" style="padding:2px 5px;height:2cm;">#Replace(getComms.Comment[3], Chr(13), "<br />", "All")#</td>
    </tr>
    </table>
    </td>
    </tr>
    </cfif>
    
    <tr>
    <td style="height:20px;"></td>
    </tr>
    
    <cfquery name="getGrades" datasource="#dsn#">
        SELECT * FROM StudYearGrade
        WHERE TermYear = <cfqueryparam cfsqltype="cf_sql_smallint" value="#year#">
        AND Term = <cfqueryparam cfsqltype="cf_sql_smallint" value="#term#">
        AND StudYear = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getList.AcYear[i]#">
        ORDER BY MinPercent ASC
    </cfquery>
    
    <tr>
    <td>
    <table cellpadding="0" cellspacing="0" width="100%" align="center" class="print-friendly">
    <tr align="center" class="txtRep8">
    <td colspan="4"><u><span class="txtRep12Bold">Descriptors</span></u></td>
    </tr>
    
    <tr>
    <td style="height:10px;"></td>
    </tr>
    
    <tr align="left" class="txtRep12Bold">
    <td colspan="4">Attainment</td>
    </tr>
    
    <tr align="center" class="txtRep11Bold" style="background-color:##ECF8F3;">
    <td width="10%" class="ball" style="height:1.2cm;">Score</td>
    <td width="10%" class="btop bright bbottom">Range</td>
    <td width="15%" style="padding:2px 0px;" class="btop bright bbottom">Performance<br/>Band</td>
    <td width="65%" class="btop bright bbottom">General Descriptors</td>
    </tr>
    
    <cfloop query="getGrades">
    <tr align="center" class="txtRep10">
    <td class="bleft bright bbottom">#Grade#</td>
    <td class="bright bbottom">#NumberFormat(MinPercent)#-#NumberFormat(MaxPercent)#</td>
    <td class="bright bbottom">#GradeDet#</td>
    <td style="padding:2px 5px;" class="bright bbottom" align="left">#GradeDesc#</td>
    </tr>
    </cfloop>
    </table>
    </td>
    </tr>
    
    <tr>
    <td>
    <table cellpadding="0" cellspacing="0" width="100%" align="center" class="print-friendly">
    <tr>
    <td colspan="2" style="height:20px;"></td>
    </tr>
    
    <tr align="left" class="txtRep12Bold">
    <td colspan="2">Effort</td>
    </tr>
    
    <tr align="center" class="txtRep11Bold" style="background-color:##ECF8F3;">
    <td width="35%" class="ball" style="height:1.2cm;">Effort</td>
    <td width="65%" class="btop bright bbottom">Descriptors</td>
    </tr>
    
    <cfquery name="getOpt" datasource="#dsn#">
        SELECT A.SetName, B.OptCode, B.OptName, B.OptDescript, B.OptDefinition
        FROM SSTSet A
        LEFT JOIN SSTSetOption B ON B.SetID = A.SetID
        WHERE A.SetName = 'Effort Trident Y3-Y6'
        ORDER BY B.Seq
    </cfquery>
    
    <cfloop query="getOpt">
    <tr align="center" class="txtRep10">
    <td class="bleft bright bbottom" style="padding:2px 5px;">#OptName#</td>
    <td class="bright bbottom">#OptDefinition#</td>
    </tr>
    </cfloop>
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
    <InvalidTag http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
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
    
    <cfdocument format="PDF" pagetype="a4" orientation="portrait" scale="100" unit="cm" marginbottom="1" margintop="1" 
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
    <cfelse>
    <cffile action="write" output="#MyPDFFile#" file="#ReportFileName#">
    </cfif>
    </cfif>
    </html>  