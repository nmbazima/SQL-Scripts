<html>

<cfinclude template="/assessment/reportsec.cfm">



<cfparam name="ARSID" default="0">
<cfparam name="RecNo" default="0">
<cfparam name="term" default="0">
<cfparam name="year" default="#Year(Now())#">
<cfparam name="AsPDF" default="0">
<cfparam name="ReportFileName" default="">

<cfset MaxTerm = 3>
<cfset Numbers = [" 0 "," 1 "," 2 "," 3 "," 4 "," 5 "," 6 "," 7 "," 8 "," 9 "]>
<cfset Cletters = ["  A  ","  B  ","  C  ","  D  ","  E  ","  F  ","  G  ","  H  ","  I  ","  J  ","  K  ","  L  ","  M  ","  N  ","  O  ","  P  ","  Q  ","  R  ","  S  ","  T  ","  U  ","  V  ","  W  ","  X  ","  Y  ","  Z  "]>
<cfset Sletters = ["  a  ","  b  ","  c  ","  d  ","  e  ","  f  ","  g  ","  h  ","  i  ","  j  ","  k  ","  l  ","  m  ","  n  ","  o  ","  p  ","  q  ","  r  ","  s  ","  t  ","  u  ","  v  ","  w  ","  x  ","  y  ","  z  "] >
<cfquery name="getList" datasource="#dsn#">
	SELECT A.StudID, A.LastName, A.FirstName, A.TermYear, A.Term, A.AcYear, A.BirthDate, A.Photo,
		C.Class, T.FirstName AS TFName, T.LastName AS TLName, T.Title, T.TeacherID, T.T2Title, T.T2FName, T.T2LName, T.T1SignFile
	FROM vARSubjAcads A
		LEFT JOIN TTClassStud C ON C.TermYear = A.TermYear AND C.Term = A.Term
			AND C.AcYear = A.AcYear AND C.StudID = A.StudID
		LEFT JOIN vTTClasses T ON T.Class = C.Class AND T.ClYear = C.TermYear AND T.ClTerm = C.Term
	WHERE ARSID = <cfqueryparam cfsqltype="cf_sql_bigint" value="#ARSID#">
		<cfif RecNo NEQ 0>AND A.StudID = <cfqueryparam cfsqltype="cf_sql_integer" value="#RecNo#"></cfif>
	ORDER BY LastName, FirstName
</cfquery>


<cfif AsPDF>
	<cfset strWidth = "29cm">
	<cfset strSmallWidth = "13cm">
<cfelse>
	<cfset strWidth = "100%">
	<cfset strSmallWidth = "100%">
</cfif>

<cfsavecontent variable="myReport">
<cfoutput>
<cfloop index="i" from="1" to="#getList.RecordCount#">
<cfset RecNo = getList.StudID[i]>


<table cellpadding="0" cellspacing="0" style="width:100%; height:100%;" align="center">
 <tr valign="top">
	<td>

 <table cellpadding="0" cellspacing="0" width="100%" align="center">
  <tr align="center" class="txtRep14Bold">
    <td width="5%" class="ball" style="padding:2 0;">No.</td>
    <td width="22%" class="btop bright bbottom" style="padding:2 0;">Font Style</td>
    <td width="9%" class="btop bright bbottom" style="padding:2 0;">10pt</td>
    <td width="9%" class="btop bright bbottom" style="padding:2 0;">16pt</td>
    <td width="13%" class="btop bright bbottom" style="padding:2 0;">Bold</td>
    <td width="13%" class="btop bright bbottom" style="padding:2 0;">Italic</td>
    <td width="15%" class="btop bright bbottom" style="padding:2 0;">Underlined</td>
    <td width="13%" class="btop bright bbottom" style="padding:2 0;">All</td>
  </tr>




<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Aharoni;">1</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Aharoni;">Aharoni</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Aharoni;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Aharoni;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Aharoni;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Aharoni;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Aharoni;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Aharoni;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Aharoni;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>



  <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Aldhabi;">2</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Aldhabi;">Aldhabi</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Aldhabi;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Aldhabi;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Aldhabi;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Aldhabi;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Aldhabi;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Aldhabi;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Aldhabi;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>


<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Andalus;">3</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Andalus;">Andalus</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Andalus;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Andalus;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Andalus;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Andalus;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Andalus;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Andalus;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Andalus;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
</tr>





<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt AngsanaUPC;">4</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt AngsanaUPC;">AngsanaUPC</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt AngsanaUPC;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt AngsanaUPC;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt AngsanaUPC;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt AngsanaUPC;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt AngsanaUPC;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt AngsanaUPC;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt AngsanaUPC;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>


<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Angsana New;">5</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Angsana New;">Angsana New</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Angsana New;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Angsana New;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Angsana New;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Angsana New;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Angsana New;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Angsana New;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Angsana New;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Aparajita;">6</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Aparajita;">Aparajita</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Aparajita;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Aparajita;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Aparajita;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Aparajita;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Aparajita;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Aparajita;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Aparajita;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>


 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Arabic Typesetting;">7</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Arabic Typesetting;">Arabic Typesetting</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Arabic Typesetting;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Arabic Typesetting;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Arabic Typesetting;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Arabic Typesetting;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Arabic Typesetting;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Arabic Typesetting;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Arabic Typesetting;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

<tr align="center">
  <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Arial;">8</td>
  <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Arial;">Arial</td>
  <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Arial;">10pt</td>
  <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Arial;">16pt</td>
  <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Arial;">Bold</td>
  <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Arial;"><i>Italic</i></td>
  <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Arial;"><u>Underlined</u></td>
  <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Arial;"><u><i>Text</i></u></td>
</tr>
<tr>
  <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Arial;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
  </td>
</tr>

<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Arial Black;">9</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Arial Black;">Arial Black</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Arial Black;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Arial Black;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Arial Black;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Arial Black;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Arial Black;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Arial Black;"><u><i>Text</i></u></td>
</tr>
<tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Arial Black;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
</tr>


<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Bernard MT Condensed;">10</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Bernard MT Condensed;">Bernard MT Condensed</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Bernard MT Condensed;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Bernard MT Condensed;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Bernard MT Condensed;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Bernard MT Condensed;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Bernard MT Condensed;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Bernard MT Condensed;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Bernard MT Condensed;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Britannic Bold;">11</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Britannic Bold;">Britannic Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Britannic Bold;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Britannic Bold;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Britannic Bold;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Britannic Bold;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Britannic Bold;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Britannic Bold;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Britannic Bold;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
</tr>


        </table>
		</td>
	</tr>
</table>


<div class="pagebreak"></div>
<div style="height:5;"></div>

<table cellpadding="0" cellspacing="0" style="width:100%; height:100%;" align="center">
 <tr valign="top">
	<td>

<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="center">
   <td class="btop bleft bright bbottom" style="padding:1px;font:normal 12pt BrowalliaUPC;">12</td>
   <td class="btop bright bbottom" align="left" style="padding:1px;font:normal 12pt BrowalliaUPC;">BrowalliaUPC</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 10pt BrowalliaUPC;">10pt</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 16pt BrowalliaUPC;">16pt</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt BrowalliaUPC;">Bold</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt BrowalliaUPC;"><i>Italic</i></td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt BrowalliaUPC;"><u>Underlined</u></td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt BrowalliaUPC;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt BrowalliaUPC;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Browallia New;">13</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Browallia New;">Browallia New</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Browallia New;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Browallia New;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Browallia New;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Browallia New;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Browallia New;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Browallia New;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Browallia New;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 
 <tr align="center">
    <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Calibri;">14</td>
    <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Calibri;">Calibri</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Calibri;">10pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Calibri;">16pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Calibri;">Bold</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Calibri;"><i>Italic</i></td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Calibri;"><u>Underlined</u></td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Calibri;"><u><i>Text</i></u></td>
 </tr>
 <tr>
    <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Calibri;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
     Text: The Quick Brown Fox Jumps Over The Lazy Dog.
    </td>
 </tr>

 
 <tr align="center">
    <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Candara;">15</td>
    <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Candara;">Candara</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Candara;">10pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Candara;">16pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Candara;">Bold</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Candara;"><i>Italic</i></td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Candara;"><u>Underlined</u></td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Candara;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Candara;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
     Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
</tr>

<tr align="center">
    <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Comic Sans MS;">16</td>
    <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Comic Sans MS;">Comic Sans MS</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Comic Sans MS;">10pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Comic Sans MS;">16pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Comic Sans MS;">Bold</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Comic Sans MS;"><i>Italic</i></td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Comic Sans MS;"><u>Underlined</u></td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Comic Sans MS;"><u><i>Text</i></u></td>
 </tr>
 <tr>
    <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Comic Sans MS;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
      Text: The Quick Brown Fox Jumps Over The Lazy Dog.
    </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Consolas;">17</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Consolas;">Consolas</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Consolas;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Consolas;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Consolas;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Consolas;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Consolas;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Consolas;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Consolas;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Constantia;">18</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Constantia;">Constantia</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Constantia;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Constantia;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Constantia;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Constantia;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Constantia;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Constantia;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Constantia;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Corbel;">19</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Corbel;">Corbel</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Corbel;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Corbel;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Corbel;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Corbel;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Corbel;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Corbel;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Corbel;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt CordiaUPC;">20</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt CordiaUPC;">CordiaUPC</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt CordiaUPC;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt CordiaUPC;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt CordiaUPC;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt CordiaUPC;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt CordiaUPC;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt CordiaUPC;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt CordiaUPC;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Cordia New;">21</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Cordia New;">Cordia New</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Cordia New;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Cordia New;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Cordia New;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Cordia New;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Cordia New;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Cordia New;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Cordia New;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Courier New;">22</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Courier New;">Courier New</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Courier New;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Courier New;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Courier New;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Courier New;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Courier New;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Courier New;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Courier New;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 </table>
		</td>
	</tr>
</table>

<div class="pagebreak"></div>
<div style="height:5;"></div>

<table cellpadding="0" cellspacing="0" style="width:100%; height:100%;" align="center">
 <tr valign="top">
	<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
 
 <tr align="center">
   <td class="btop bleft bright bbottom" style="padding:1px;font:normal 12pt DaunPenh;">23</td>
   <td class="btop bright bbottom" align="left" style="padding:1px;font:normal 12pt DaunPenh;">DaunPenh</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 10pt DaunPenh;">10pt</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 16pt DaunPenh;">16pt</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt DaunPenh;">Bold</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt DaunPenh;"><i>Italic</i></td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt DaunPenh;"><u>Underlined</u></td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt DaunPenh;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt DaunPenh;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt David;">24</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt David;">David</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt David;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt David;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt David;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt David;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt David;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt David;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt David;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt DFKai-SB;">25</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt DFKai-SB;">DFKai-SB</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt DFKai-SB;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt DFKai-SB;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt DFKai-SB;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt DFKai-SB;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt DFKai-SB;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt DFKai-SB;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt DFKai-SB;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt DilleniaUPC;">26</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt DilleniaUPC;">DilleniaUPC</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt DilleniaUPC;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt DilleniaUPC;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt DilleniaUPC;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt DilleniaUPC;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt DilleniaUPC;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt DilleniaUPC;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt DilleniaUPC;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt DokChampa;">27</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt DokChampa;">DokChampa</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt DokChampa;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt DokChampa;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt DokChampa;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt DokChampa;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt DokChampa;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt DokChampa;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt DokChampa;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Ebrima;">28</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Ebrima;">Ebrima</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Ebrima;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Ebrima;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Ebrima;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Ebrima;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Ebrima;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Ebrima;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Ebrima;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Estrangelo Edessa;">29</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Estrangelo Edessa;">Estrangelo Edessa</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Estrangelo Edessa;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Estrangelo Edessa;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Estrangelo Edessa;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Estrangelo Edessa;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Estrangelo Edessa;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Estrangelo Edessa;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Estrangelo Edessa;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt EucrosiaUPC;">30</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt EucrosiaUPC;">EucrosiaUPC</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt EucrosiaUPC;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt EucrosiaUPC;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt EucrosiaUPC;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt EucrosiaUPC;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt EucrosiaUPC;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt EucrosiaUPC;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt EucrosiaUPC;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Euphemia;">31</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Euphemia;">Euphemia</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Euphemia;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Euphemia;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Euphemia;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Euphemia;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Euphemia;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Euphemia;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Euphemia;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>


<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt FangSong;">32</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt FangSong;">FangSong</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt FangSong;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt FangSong;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt FangSong;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt FangSong;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt FangSong;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt FangSong;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt FangSong;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Franklin Gothic Medium;">33</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Franklin Gothic Medium;">Franklin Gothic Medium</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Franklin Gothic Medium;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Franklin Gothic Medium;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Franklin Gothic Medium;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Franklin Gothic Medium;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Franklin Gothic Medium;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Franklin Gothic Medium;"><u><i>Text</i></u></td>
 </tr>
  <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Franklin Gothic Medium;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 </table>
		</td>
	</tr>
</table>


<div class="pagebreak"></div>
<div style="height:5;"></div>

<table cellpadding="0" cellspacing="0" style="width:100%; height:100%;" align="center">
 <tr valign="top">
	<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
<tr align="center">
   <td class="btop bleft bright bbottom" style="padding:1px;font:normal 12pt FreesiaUPC;">34</td>
   <td class="btop bright bbottom" align="left" style="padding:1px;font:normal 12pt FreesiaUPC;">FreesiaUPC</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 10pt FreesiaUPC;">10pt</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 16pt FreesiaUPC;">16pt</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt FreesiaUPC;">Bold</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt FreesiaUPC;"><i>Italic</i></td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt FreesiaUPC;"><u>Underlined</u></td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt FreesiaUPC;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt FreesiaUPC;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Gabriola;">35</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Gabriola;">Gabriola</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Gabriola;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Gabriola;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Gabriola;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Gabriola;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Gabriola;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Gabriola;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Gabriola;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Gadugi;">36</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Gadugi;">Gadugi</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Gadugi;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Gadugi;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Gadugi;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Gadugi;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Gadugi;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Gadugi;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Gadugi;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Gautami;">37</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Gautami;">Gautami</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Gautami;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Gautami;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Gautami;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Gautami;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Gautami;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Gautami;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Gautami;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
    <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Georgia;">38</td>
    <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Georgia;">Georgia</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Georgia;">10pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Georgia;">16pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Georgia;">Bold</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Georgia;"><i>Italic</i></td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Georgia;"><u>Underlined</u></td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Georgia;"><u><i>Text</i></u></td>
 </tr>
 <tr>
    <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Georgia;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
      Text: The Quick Brown Fox Jumps Over The Lazy Dog.
    </td>
 </tr>




<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Gisha;">39</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Gisha;">Gisha</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Gisha;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Gisha;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Gisha;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Gisha;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Gisha;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Gisha;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Gisha;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 
 <tr align="center">
    <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Helvetica;">40</td>
    <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Helvetica;">Helvetica</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Helvetica;">10pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Helvetica;">16pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Helvetica;">Bold</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Helvetica;"><i>Italic</i></td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Helvetica;"><u>Underlined</u></td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Helvetica;"><u><i>Text</i></u></td>
</tr>
<tr>
    <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Helvetica;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
      Text: The Quick Brown Fox Jumps Over The Lazy Dog.
    </td>
</tr>


 

 <tr align="center">
    <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Impact;">41</td>
    <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Impact;">Impact</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Impact;">10pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Impact;">16pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Impact;">Bold</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Impact;"><i>Italic</i></td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Impact;"><u>Underlined</u></td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Impact;"><u><i>Text</i></u></td>
 </tr>
 <tr>
    <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Impact;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
      Text: The Quick Brown Fox Jumps Over The Lazy Dog.
    </td>
</tr>


<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt IrisUPC;">42</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt IrisUPC;">IrisUPC</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt IrisUPC;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt IrisUPC;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt IrisUPC;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt IrisUPC;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt IrisUPC;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt IrisUPC;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt IrisUPC;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt JasmineUPC;">43</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt JasmineUPC;">JasmineUPC</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt JasmineUPC;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt JasmineUPC;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt JasmineUPC;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt JasmineUPC;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt JasmineUPC;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt JasmineUPC;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt JasmineUPC;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>


 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt KaiTi;">44</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt KaiTi;">KaiTi</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt KaiTi;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt KaiTi;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt KaiTi;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt KaiTi;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt KaiTi;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt KaiTi;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt KaiTi;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

</table>
		</td>
	</tr>
</table>


<div class="pagebreak"></div>
<div style="height:5;"></div>

<table cellpadding="0" cellspacing="0" style="width:100%; height:100%;" align="center">
 <tr valign="top">
	<td>
 <table cellpadding="0" cellspacing="0" width="100%" align="center">



 

 <tr align="center">
   <td class="btop bleft bright bbottom" style="padding:1px;font:normal 12pt Kalinga;">45</td>
   <td class="btop bright bbottom" align="left" style="padding:1px;font:normal 12pt Kalinga;">Kalinga</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 10pt Kalinga;">10pt</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 16pt Kalinga;">16pt</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt Kalinga;">Bold</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt Kalinga;"><i>Italic</i></td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt Kalinga;"><u>Underlined</u></td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt Kalinga;"><u><i>Text</i></u></td>
 </tr> 
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Kalinga;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Kartika;">46</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Kartika;">Kartika</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Kartika;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Kartika;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Kartika;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Kartika;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Kartika;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Kartika;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Kartika;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 

<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Khmer UI;">47</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Khmer UI;">Khmer UI</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Khmer UI;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Khmer UI;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Khmer UI;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Khmer UI;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Khmer UI;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Khmer UI;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Khmer UI;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt KodchiangUPC;">48</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt KodchiangUPC;">KodchiangUPC</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt KodchiangUPC;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt KodchiangUPC;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt KodchiangUPC;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt KodchiangUPC;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt KodchiangUPC;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt KodchiangUPC;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt KodchiangUPC;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Kokila;">49</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Kokila;">Kokila</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Kokila;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Kokila;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Kokila;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Kokila;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Kokila;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Kokila;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Kokila;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Lao UI;">50</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Lao UI;">Lao UI</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Lao UI;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Lao UI;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Lao UI;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Lao UI;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Lao UI;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Lao UI;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Lao UI;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Latha;">51</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Latha;">Latha</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Latha;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Latha;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Latha;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Latha;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Latha;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Latha;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Latha;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Leelawadee;">52</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Leelawadee;">Leelawadee</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Leelawadee;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Leelawadee;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Leelawadee;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Leelawadee;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Leelawadee;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Leelawadee;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Leelawadee;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Leelawadee UI;">53</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Leelawadee UI;">Leelawadee UI</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Leelawadee UI;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Leelawadee UI;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Leelawadee UI;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Leelawadee UI;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Leelawadee UI;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Leelawadee UI;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Leelawadee UI;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Levenim MT;">54</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Levenim MT;">Levenim MT</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Levenim MT;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Levenim MT;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Levenim MT;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Levenim MT;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Levenim MT;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Levenim MT;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Levenim MT;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt LilyUPC;">55</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt LilyUPC;">LilyUPC</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt LilyUPC;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt LilyUPC;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt LilyUPC;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt LilyUPC;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt LilyUPC;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt LilyUPC;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt LilyUPC;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 </table>
		</td>
	</tr>
</table>


<div class="pagebreak"></div>
<div style="height:5;"></div>

<table cellpadding="0" cellspacing="0" style="width:100%; height:100%;" align="center">
 <tr valign="top">
	<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">

 <tr align="center">
    <td class="btop bleft bright bbottom" style="padding:1px;font:normal 12pt Lucida Console;">56</td>
    <td class="btop bright bbottom" align="left" style="padding:1px;font:normal 12pt Lucida Console;">Lucida Console</td>
    <td class="btop bright bbottom" style="padding:1px 0px;font:normal 10pt Lucida Console;">10pt</td>
    <td class="btop bright bbottom" style="padding:1px 0px;font:normal 16pt Lucida Console;">16pt</td>
    <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt Lucida Console;">Bold</td>
    <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt Lucida Console;"><i>Italic</i></td>
    <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt Lucida Console;"><u>Underlined</u></td>
    <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt Lucida Console;"><u><i>Text</i></u></td>
 </tr>
 <tr>
    <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Lucida Console;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
      Text: The Quick Brown Fox Jumps Over The Lazy Dog.
    </td>
 </tr>

<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Lucida Console;">57</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Lucida Console;">Lucida Console</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Lucida Console;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Lucida Console;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Lucida Console;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Lucida Console;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Lucida Console;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Lucida Console;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Lucida Console;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>


<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Lucida Sans Unicode;">58</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Lucida Sans Unicode;">Lucida Sans Unicode</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Lucida Sans Unicode;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Lucida Sans Unicode;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Lucida Sans Unicode;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Lucida Sans Unicode;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Lucida Sans Unicode;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Lucida Sans Unicode;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Lucida Sans Unicode;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Malgun Gothic;">59</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Malgun Gothic;">Malgun Gothic</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Malgun Gothic;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Malgun Gothic;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Malgun Gothic;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Malgun Gothic;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Malgun Gothic;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Malgun Gothic;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Malgun Gothic;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 

 
 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Times New Roman;">60</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Times New Roman;">Marlett</td>
   <td class="bright bbottom"></td>
   <td class="bright bbottom"></td>
   <td class="bright bbottom"></td>
   <td class="bright bbottom"></td>
   <td class="bright bbottom"></td>
   <td class="bright bbottom"></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bbottom bright" style="padding:1px;height:1.5cm;" valign="top"> 
     <span style="font:normal 12pt Times New Roman;">Numbers: </span>
     <cfloop index="b" from="1" to="10">
     <span><b>#Numbers[b]#</b></span><span style="font:normal 12pt Marlett;">#Numbers[b]#</span>&nbsp;&nbsp; 
     </cfloop> <br/>
     <span style="font:normal 12pt Times New Roman;">Alphabets:</span><br/>
     <cfloop index="i" from="1" to="26">
     <span><b>#Sletters[i]#</b></span><span style="font:normal 12pt Marlett;">#Sletters[i]#</span>&nbsp;&nbsp;      
     </cfloop> 
    </td>
 </tr>

 
<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Mead Bold;">61</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Mead Bold;">Mead Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Mead Bold;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Mead Bold;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Mead Bold;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Mead Bold;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Mead Bold;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Mead Bold;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Mead Bold;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Microsoft Himalaya;">62</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Microsoft Himalaya;">Microsoft Himalaya</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Microsoft Himalaya;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Microsoft Himalaya;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft Himalaya;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft Himalaya;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft Himalaya;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft Himalaya;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Microsoft Himalaya;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Microsoft JhengHei;">63</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Microsoft JhengHei;">Microsoft JhengHei</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Microsoft JhengHei;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Microsoft JhengHei;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft JhengHei;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft JhengHei;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft JhengHei;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft JhengHei;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Microsoft JhengHei;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Microsoft JhengHei UI;">64</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Microsoft JhengHei UI;">Microsoft JhengHei UI</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Microsoft JhengHei UI;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Microsoft JhengHei UI;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft JhengHei UI;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft JhengHei UI;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft JhengHei UI;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft JhengHei UI;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Microsoft JhengHei UI;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 
 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Microsoft New Tai Lue;">65</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Microsoft New Tai Lue;">Microsoft New Tai Lue</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Microsoft New Tai Lue;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Microsoft New Tai Lue;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft New Tai Lue;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft New Tai Lue;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft New Tai Lue;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft New Tai Lue;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Microsoft New Tai Lue;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Microsoft PhagsPa;">66</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Microsoft PhagsPa;">Microsoft PhagsPa</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Microsoft PhagsPa;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Microsoft PhagsPa;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft PhagsPa;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft PhagsPa;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft PhagsPa;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft PhagsPa;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Microsoft PhagsPa;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 </table>
		</td>
	</tr>
</table>

 <div class="pagebreak"></div>
 <div style="height:5;"></div>
 
<table cellpadding="0" cellspacing="0" style="width:100%; height:100%;" align="center">
 <tr valign="top">
	<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">

<tr align="center">
   <td class="btop bleft bright bbottom" style="padding:1px;font:normal 12pt Microsoft Tai Le;">67</td>
   <td class="btop bright bbottom" align="left" style="padding:1px;font:normal 12pt Microsoft Tai Le;">Microsoft Tai Le</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 10pt Microsoft Tai Le;">10pt</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 16pt Microsoft Tai Le;">16pt</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft Tai Le;">Bold</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft Tai Le;"><i>Italic</i></td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft Tai Le;"><u>Underlined</u></td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft Tai Le;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Microsoft Tai Le;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>
 
 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Microsoft YaHei;">68</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Microsoft YaHei;">Microsoft YaHei</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Microsoft YaHei;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Microsoft YaHei;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft YaHei;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft YaHei;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft YaHei;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft YaHei;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Microsoft YaHei;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Microsoft YaHei UI;">69</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Microsoft YaHei UI;">Microsoft YaHei UI</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Microsoft YaHei UI;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Microsoft YaHei UI;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft YaHei UI;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft YaHei UI;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft YaHei UI;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft YaHei UI;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Microsoft YaHei UI;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Microsoft Yi Baiti;">70</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Microsoft Yi Baiti;">Microsoft Yi Baiti</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Microsoft Yi Baiti;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Microsoft Yi Baiti;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft Yi Baiti;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft Yi Baiti;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Microsoft Yi Baiti;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Microsoft Yi Baiti;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Microsoft Yi Baiti;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

  

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt MingLiU-ExtB;">71</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt MingLiU-ExtB;">MingLiU-ExtB</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt MingLiU-ExtB;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt MingLiU-ExtB;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt MingLiU-ExtB;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt MingLiU-ExtB;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt MingLiU-ExtB;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt MingLiU-ExtB;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt MingLiU-ExtB;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <table cellpadding="0" cellspacing="0" width="100%" align="center">
 <tr align="center">
    <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt monospace;">72</td>
    <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt monospace;">Monospace</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt monospace;">10pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt monospace;">16pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt monospace;">Bold</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt monospace;"><i>Italic</i></td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt monospace;"><u>Underlined</u></td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt monospace;"><u><i>Text</i></u></td>
 </tr>
 <tr>
    <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt monospace;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
        Text: The Quick Brown Fox Jumps Over The Lazy Dog.
    </td>
</tr>

 
 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt MS Gothic;">73</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt MS Gothic;">MS Gothic</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt MS Gothic;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt MS Gothic;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt MS Gothic;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt MS Gothic;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt MS Gothic;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt MS Gothic;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt MS Gothic;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>
 
 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt MS PGothic;">74</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt MS PGothic;">MS PGothic</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt MS PGothic;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt MS PGothic;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt MS PGothic;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt MS PGothic;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt MS PGothic;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt MS PGothic;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt MS PGothic;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>


 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt MV Boli;">75</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt MV Boli;">MV Boli</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt MV Boli;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt MV Boli;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt MV Boli;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt MV Boli;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt MV Boli;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt MV Boli;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt MV Boli;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Myanmar Text;">76</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Myanmar Text;">Myanmar Text</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Myanmar Text;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Myanmar Text;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Myanmar Text;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Myanmar Text;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Myanmar Text;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Myanmar Text;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Myanmar Text;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

  <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Nirmala UI;">77</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Nirmala UI;">Nirmala UI</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Nirmala UI;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Nirmala UI;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Nirmala UI;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Nirmala UI;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Nirmala UI;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Nirmala UI;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Nirmala UI;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>


 </table>
		</td>
	</tr>
</table>

 <div class="pagebreak"></div>
 <div style="height:5;"></div>

 <table cellpadding="0" cellspacing="0" style="width:100%; height:100%;" align="center">
 <tr valign="top">
	<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
 
 <tr align="center">
    <td class="btop bleft bright bbottom" style="padding:1px;font:normal 12pt Palatino Linotype;">78</td>
    <td class="btop bright bbottom" align="left" style="padding:1px;font:normal 12pt Palatino Linotype;">Palatino Linotype</td>
    <td class="btop bright bbottom" style="padding:1px 0px;font:normal 10pt Palatino Linotype;">10pt</td>
    <td class="btop bright bbottom" style="padding:1px 0px;font:normal 16pt Palatino Linotype;">16pt</td>
    <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt Palatino Linotype;">Bold</td>
    <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt Palatino Linotype;"><i>Italic</i></td>
    <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt Palatino Linotype;"><u>Underlined</u></td>
    <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt Palatino Linotype;"><u><i>Text</i></u></td>
 </tr>
 <tr>
    <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Palatino Linotype;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
      Text: The Quick Brown Fox Jumps Over The Lazy Dog.
    </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Plantagenet Cherokee;">79</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Plantagenet Cherokee;">Plantagenet Cherokee</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Plantagenet Cherokee;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Plantagenet Cherokee;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Plantagenet Cherokee;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Plantagenet Cherokee;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Plantagenet Cherokee;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Plantagenet Cherokee;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Plantagenet Cherokee;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>


 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Rockwell Extra Bold;">80</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Rockwell Extra Bold;">Rockwell Extra Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Rockwell Extra Bold;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Rockwell Extra Bold;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Rockwell Extra Bold;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Rockwell Extra Bold;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Rockwell Extra Bold;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Rockwell Extra Bold;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Rockwell Extra Bold;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>



 <tr align="center">
    <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt sans-serif;">81</td>
    <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt sans-serif;">Sans-serif</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt sans-serif;">10pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt sans-serif;">16pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt sans-serif;">Bold</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt sans-serif;"><i>Italic</i></td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt sans-serif;"><u>Underlined</u></td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt sans-serif;"><u><i>Text</i></u></td>
 </tr>
 <tr>
    <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt sans-serif;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
        Text: The Quick Brown Fox Jumps Over The Lazy Dog.
    </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Script MT Bold;">82</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Script MT Bold;">Script MT Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Script MT Bold;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Script MT Bold;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Script MT Bold;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Script MT Bold;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Script MT Bold;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Script MT Bold;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Script MT Bold;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Segoe Print;">83</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Segoe Print;">Segoe Print</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Segoe Print;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Segoe Print;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Segoe Print;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Segoe Print;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Segoe Print;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Segoe Print;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Segoe Print;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Segoe Script;">84</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Segoe Script;">Segoe Script</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Segoe Script;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Segoe Script;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Segoe Script;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Segoe Script;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Segoe Script;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Segoe Script;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Segoe Script;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Segoe UI;">85</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Segoe UI;">Segoe UI</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Segoe UI;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Segoe UI;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Segoe UI;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Segoe UI;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Segoe UI;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Segoe UI;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Segoe UI;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Segoe UI Emoji;">86</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Segoe UI Emoji;">Segoe UI Emoji</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Segoe UI Emoji;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Segoe UI Emoji;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Segoe UI Emoji;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Segoe UI Emoji;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Segoe UI Emoji;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Segoe UI Emoji;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Segoe UI Emoji;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 
 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Segoe UI Symbol;">87</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Segoe UI Symbol;">Segoe UI Symbol</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Segoe UI Symbol;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Segoe UI Symbol;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Segoe UI Symbol;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Segoe UI Symbol;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Segoe UI Symbol;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Segoe UI Symbol;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Segoe UI Symbol;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt SimSun;">88</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt SimSun;">SimSun</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt SimSun;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt SimSun;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt SimSun;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt SimSun;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt SimSun;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt SimSun;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt SimSun;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>


 </table>
		</td>
	</tr>
</table>

<div class="pagebreak"></div>
<div style="height:3;"></div>

<table cellpadding="0" cellspacing="0" style="width:100%; height:100%;" align="center">
 <tr valign="top">
	<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">
 

 <tr align="center">
   <td class="btop bleft bright bbottom" style="padding:1px;font:normal 12pt SimSun-ExtB;">89</td>
   <td class="btop bright bbottom" align="left" style="padding:1px;font:normal 12pt SimSun-ExtB;">SimSun-ExtB</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 10pt SimSun-ExtB;">10pt</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 16pt SimSun-ExtB;">16pt</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt SimSun-ExtB;">Bold</td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt SimSun-ExtB;"><i>Italic</i></td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:normal 12pt SimSun-ExtB;"><u>Underlined</u></td>
   <td class="btop bright bbottom" style="padding:1px 0px;font:Bold 12pt SimSun-ExtB;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt SimSun-ExtB;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Sylfaen;">90</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Sylfaen;">Sylfaen</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Sylfaen;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Sylfaen;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Sylfaen;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Sylfaen;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Sylfaen;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Sylfaen;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Sylfaen;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Times New Roman;">91</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Times New Roman;">Symbol</td>
   <td class="bright bbottom"> </td>
   <td class="bright bbottom"> </td>
   <td class="bright bbottom"> </td>
   <td class="bright bbottom"> </td>
   <td class="bright bbottom"> </td>
   <td class="bright bbottom"> </td>
 </tr>
 <tr>
  <td colspan="8" class="bleft bbottom bright" style="padding:1px;height:1.5cm;" valign="top"> 
     <span style="font:normal 12pt Times New Roman;">Numbers: </span>
     <span style="font:normal 12pt Symbol;">0  1  2  3  4  5  6  7  8  9</span> <br/>
     <span style="font:normal 12pt Times New Roman;">Alphabets:</span><br/>
     <cfloop index="i" from="1" to="26">
     <span><b>#Sletters[i]#</b></span><span style="font:normal 12pt Symbol;">#Sletters[i]#</span>&nbsp;&nbsp;      
     </cfloop> 
     <br/>
     <span style="font:normal 12pt Times New Roman;">ALPHABETS:</span><br/>
     <cfloop index="i" from="1" to="26">
     <span><b>#Cletters[i]#</b></span><span style="font:normal 12pt Symbol;">#Cletters[i]#</span>&nbsp;&nbsp;      
     </cfloop> 
  </td>
 </tr>

<tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Tahoma;">92</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Tahoma;">Tahoma</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Tahoma;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Tahoma;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Tahoma;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Tahoma;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Tahoma;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Tahoma;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Tahoma;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
    <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Times New Roman;">93</td>
    <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Times New Roman;">Times New Roman</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Times New Roman;">10pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Times New Roman;">16pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Times New Roman;">Bold</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Times New Roman;"><i>Italic</i></td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Times New Roman;"><u>Underlined</u></td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Times New Roman;"><u><i>Text</i></u></td>
 </tr>
 <tr>
    <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Times New Roman;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
      Text: The Quick Brown Fox Jumps Over The Lazy Dog.
    </td>
 </tr>


 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Trebuchet MS;">94</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Trebuchet MS;">Trebuchet MS</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Trebuchet MS;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Trebuchet MS;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Trebuchet MS;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Trebuchet MS;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Trebuchet MS;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Trebuchet MS;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Trebuchet MS;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Vani;">95</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Vani;">Vani</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Vani;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Vani;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Vani;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Vani;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Vani;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Vani;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Vani;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
    <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Verdana;">96</td>
    <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Verdana;">Verdana</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Verdana;">10pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Verdana;">16pt</td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Verdana;">Bold</td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Verdana;"><i>Italic</i></td>
    <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Verdana;"><u>Underlined</u></td>
    <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Verdana;"><u><i>Text</i></u></td>
 </tr>
 <tr>
    <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Verdana;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
      Text: The Quick Brown Fox Jumps Over The Lazy Dog.
    </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Verdana Pro;">97</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Verdana Pro;">Verdana Pro</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Verdana Pro;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Verdana Pro;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Verdana Pro;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Verdana Pro;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Verdana Pro;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Verdana Pro;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Verdana Pro;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Vivaldi;">98</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Vivaldi;">Vivaldi</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Vivaldi;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Vivaldi;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Vivaldi;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Vivaldi;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Vivaldi;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Vivaldi;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Vivaldi;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>



 </table>
		</td>
	</tr>
</table>


<div class="pagebreak"></div>

<table cellpadding="0" cellspacing="0" style="width:100%;height:100%" align="center">
 <tr valign="top">
	<td>
<table cellpadding="0" cellspacing="0" width="100%" align="center">

 <tr align="center">
   <td class="btop bleft bright bbottom" style="padding:1px;font:normal 12pt Times New Roman;">99</td>
   <td class="btop bright bbottom" align="left" style="padding:1px;font:normal 12pt Times New Roman;">Webdings</td>
   <td class="btop bright bbottom"></td>
   <td class="btop bright bbottom"></td>
   <td class="btop bright bbottom"></td>
   <td class="btop bright bbottom"></td>
   <td class="btop bright bbottom"></td>
   <td class="btop bright bbottom"></td>
 </tr>
 <tr>
  <td colspan="8" class="bleft bbottom bright" style="padding:1px;height:1.5cm;" valign="top"> 
     <span style="font:normal 12pt Times New Roman;">Numbers: </span>
     <cfloop index="b" from="1" to="10">
     <span><b>#Numbers[b]#</b></span><span style="font:normal 12pt Webdings;">#Numbers[b]# </span>&nbsp;&nbsp;
     </cfloop> <br/>
     <span style="font:normal 12pt Times New Roman;">Alphabets:</span><br/>
     <cfloop index="i" from="1" to="26">
     <span><b>#Sletters[i]#</b></span><span style="font:normal 12pt Webdings;">#Sletters[i]#</span>&nbsp;&nbsp;       
     </cfloop> 
     <br/>
     <span style="font:normal 12pt Times New Roman;">ALPHABETS:</span><br/>
     <cfloop index="i" from="1" to="26">
     <span><b>#Cletters[i]#</b></span><span style="font:normal 12pt Webdings;">#Cletters[i]#</span>&nbsp;&nbsp;       
     </cfloop> 
   </td>
</tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Times New Roman;">100</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Times New Roman;">Wingdings</td>
   <td class="bright bbottom"></td>
   <td class="bright bbottom"></td>
   <td class="bright bbottom"></td>
   <td class="bright bbottom"></td>
   <td class="bright bbottom"></td>
   <td class="bright bbottom"></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bbottom bright" style="padding:1px;height:1.5cm;" valign="top"> 
     <span style="font:normal 12pt Times New Roman;">Numbers: </span>
     <cfloop index="b" from="1" to="10">
     <span><b>#Numbers[b]#</b></span><span style="font:normal 12pt Wingdings;">#Numbers[b]# </span>&nbsp;&nbsp; 
     </cfloop> <br/>
     <span style="font:normal 12pt Times New Roman;">Alphabets:</span><br/>
     <cfloop index="i" from="1" to="26">
     <span><b>#Sletters[i]#</b></span><span style="font:normal 12pt Wingdings;">#Sletters[i]#</span>&nbsp;&nbsp;      
     </cfloop> 
     <br/>
     <span style="font:normal 12pt Times New Roman;">ALPHABETS:</span><br/>
     <cfloop index="i" from="1" to="26">
     <span><b>#Cletters[i]#</b></span><span style="font:normal 12pt Wingdings;">#Cletters[i]#</span>&nbsp;&nbsp;      
     </cfloop> 
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Yu Gothic;">101</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Yu Gothic;">Yu Gothic</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Yu Gothic;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Yu Gothic;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Yu Gothic;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Yu Gothic;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Yu Gothic;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Yu Gothic;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Yu Gothic;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Helvetica Neue LT;">102</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Helvetica Neue LT;">Helvetica Neue LT</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Helvetica Neue LT;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Helvetica Neue LT;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Helvetica Neue LT;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Helvetica Neue LT;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Helvetica Neue LT;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Helvetica Neue LT;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Helvetica Neue LT;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

 <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font:normal 12pt Brush Script MT;">103</td>
   <td class="bright bbottom" align="left" style="padding:1px;font:normal 12pt Brush Script MT;">Brush MT</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 10pt Brush Script MT;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 16pt Brush Script MT;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Brush Script MT;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Brush Script MT;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font:normal 12pt Brush Script MT;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font:Bold 12pt Brush Script MT;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font:normal 12pt Brush Script MT;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

  <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font-size:12pt;font-family:'Please write me a song', sans-serif;">104</td>
   <td class="bright bbottom" align="left" style="padding:1px;font-size:12pt;font-family:'Please write me a song', sans-serif;">'Please write me a song'</td>
   <td class="bright bbottom" style="padding:1px 0px;font-size:12pt;font-family:'Please write me a song', sans-serif;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font-size:12pt;font-family:'Please write me a song', sans-serif;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font-size:12pt;font-family:'Please write me a song', sans-serif;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font-size:12pt;font-family:'Please write me a song', sans-serif;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font-size:12pt;font-family:'Please write me a song', sans-serif;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font-size:12pt;font-family:'Please write me a song', sans-serif;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font-size:12pt;font-family:'Please write me a song', sans-serif;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>

  <tr align="center">
   <td class="bleft bright bbottom" style="padding:1px;font-size:12pt;font-family:Snell Roundhand, cursive;">105</td>
   <td class="bright bbottom" align="left" style="padding:1px;font-size:12pt;font-family:Snell Roundhand, cursive;">Snell Roundhand, cursive</td>
   <td class="bright bbottom" style="padding:1px 0px;font-size:12pt;font-family:Snell Roundhand, cursive;">10pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font-size:12pt;font-family:Snell Roundhand, cursive;">16pt</td>
   <td class="bright bbottom" style="padding:1px 0px;font-size:12pt;font-family:Snell Roundhand, cursive;">Bold</td>
   <td class="bright bbottom" style="padding:1px 0px;font-size:12pt;font-family:Snell Roundhand, cursive;"><i>Italic</i></td>
   <td class="bright bbottom" style="padding:1px 0px;font-size:12pt;font-family:Snell Roundhand, cursive;"><u>Underlined</u></td>
   <td class="bright bbottom" style="padding:1px 0px;font-size:12pt;font-family:Snell Roundhand, cursive;"><u><i>Text</i></u></td>
 </tr>
 <tr>
   <td colspan="8" class="bleft bright bbottom" style="padding:1px;height:1.5cm;font-size:12pt;font-family:Snell Roundhand, cursive;" valign="top">Numbers: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9<br/>
    Text: The Quick Brown Fox Jumps Over The Lazy Dog.
   </td>
 </tr>
</table>

 </td>
	</tr>
</table>

</cfloop> <!--- Students --->
</cfoutput>
</cfsavecontent>


<cfif AsPDF EQ 0>

<head>
<InvalidTag http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Report Card</title>
<link rel="stylesheet" href="<cfoutput>#varSiteHome#</cfoutput>css/stylesheet.css" type="text/css">
<style type="text/css">
.F1{font-family:normal 12pt Wingdings!important}
.F2{font-family:normal 12pt Webdings!important}
.F3{font-family:normal 12pt Marlett!important}
.F4{font-family:normal 12pt Symbol!important}
.F5{font-family:normal 12pt Arial !important}


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

<cfdocument format="PDF" pagetype="a4" orientation="portrait" scale="100" unit="cm" marginbottom="0.5" margintop="0.5" marginleft="1" marginright="1" localurl="yes" fontembed="yes" fontdirectory="/superfonts/" name="MyPDFFile">

<head>
<InvalidTag http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Report Card</title>
<link rel="stylesheet" href="<cfoutput>#varSiteHome#</cfoutput>css/stylesheet.css" type="text/css">
<style type="text/css">

.F1{font-family:normal 12pt Wingdings!important}
.F2{font-family:normal 12pt Webdings!important}
.F3{font-family:normal 12pt Marlett!important}
.F4{font-family:normal 12pt Symbol!important}
.F5{font-family:normal 12pt Arial !important}


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
