<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title></title>
</head>
<body>
<SCRIPT TYPE="text/javascript">
function Percent(str){
str=(str*100)/1024;
str=Math.round(str);
return(str);
}
document.writeln(
'<table border="0" summary="">'+
'	<tr>'+
'		<td>Analogue 1:</td>'+
'		<td>'+Percent(%01)+'%%</td>'+
'	</tr>'+
'	<tr>'+
'		<td>Analogue 2:</td>'+
'		<td>'+Percent(%02)+'%%</td>'+
'	</tr>'+
'	<tr>'+
'		<td>Analogue 3:</td>'+
'		<td>'+Percent(%03)+'%%</td>'+
'	</tr>'+
'	<tr>'+
'		<td>Analogue 4:</td>'+
'		<td>'+Percent(%04)+'%%</td>'+
'	</tr>'+
'</table>'
);
</SCRIPT>
<form action="Percent.cgi" method="get">
<input type=submit value="Refresh">                  
</form>
</body>
</html>