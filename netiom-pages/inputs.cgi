<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Netiom Inputs</title>
</head>
<body>
<SCRIPT TYPE="text/javascript">
function ChangeText(str){

var re=/Off/;
str=str.replace(re,"Clear");
re2=/On/;
str=str.replace(re2,"Alarm");
return(str);
}
document.writeln(
'<table border="0" align="centre" cellspacing="14" summary="">'+
'	<tr>'+
'		<td>Input 1 %41</td>'+	
'		<td>Input 2 %42</td>'+
'		<td>Input 3 '+ChangeText('%43')+'</td>'+
'		<td>Input 4 %44</td>'+
'	</tr>'+
'	<tr>'+
'		<td>Input 5 %45</td>'+
'		<td>Input 6 %46</td>'+
'		<td>Input 7 %47</td>'+
'		<td>Input 8 %48</td>'+
'	</tr>'+
'	<tr>'+
'		<td>Input 9 %49</td>'+
'		<td>Input 10 %50</td>'+
'		<td>Input 11 %51</td>'+
'		<td>Input 12 %52</td>'+
'	</tr>'+
'	<tr>'+
'		<td>Input 13 %53</td>'+
'		<td>Input 14 %54</td>'+
'		<td>Input 15 %55</td>'+
'		<td>Input 16 %56</td>'+
'	</tr>'+
'</table>');
</SCRIPT>
<form action="inputs.cgi" method="get">
<input type=submit value="Refresh">                  
</form>
</body>
</html>